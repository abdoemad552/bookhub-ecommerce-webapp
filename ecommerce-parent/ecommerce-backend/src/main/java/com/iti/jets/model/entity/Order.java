package com.iti.jets.model.entity;

import com.iti.jets.model.enums.OrderStatus;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "orders", indexes = {
        @Index(name = "idx_orders_user", columnList = "user_id")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    @EqualsAndHashCode.Include
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "total_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalPrice;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    private OrderStatus status = OrderStatus.PENDING;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<OrderItem> items = new HashSet<>();

    // Synchronization methods
    public void addItem(OrderItem item) {
        if (item != null) {
            items.add(item);
            item.setOrder(this);
        }
    }

    public void removeItem(OrderItem item) {
        if (item != null) {
            items.remove(item);
            item.setOrder(null);
        }
    }

    public void addBook(Book book, int quantity) {
        if (book == null) return;

        OrderItem item = new OrderItem();
        item.setOrder(this);
        item.setBook(book);
        item.setQuantity(quantity);

        this.addItem(item);
    }

    public void removeBook(Book book) {
        if (book == null) return;

        items.removeIf(item -> {
            boolean match = item.getBook().equals(book);
            if (match) {
                item.setOrder(null);
            }
            return match;
        });
    }

    // Special setters
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = (totalPrice == null || totalPrice.compareTo(BigDecimal.ZERO) < 0)
                ? BigDecimal.ZERO
                : totalPrice;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", totalPrice=" + totalPrice +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}