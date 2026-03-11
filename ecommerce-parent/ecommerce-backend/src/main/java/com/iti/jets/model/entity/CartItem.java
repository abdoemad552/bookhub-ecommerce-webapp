package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "cart_items",
        indexes = {
                @Index(name = "idx_cart_items_cart", columnList = "cart_id"),
                @Index(name = "idx_cart_items_book", columnList = "book_id")
        },
        uniqueConstraints = {
                @UniqueConstraint(name = "uq_cart_items", columnNames = {"book_id", "cart_id"})
        }
)
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class CartItem {

    @Id
    @EqualsAndHashCode.Include
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "cart_id", nullable = false)
    private Cart cart;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Column(name = "quantity", nullable = false)
    private Integer quantity;

    // Special setters
    public void setQuantity(Integer quantity) {
        this.quantity = (quantity == null || quantity <= 0) ? 1 : quantity;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", quantity=" + quantity +
                '}';
    }
}