package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "carts", indexes = {
        @Index(name = "idx_cart_user", columnList = "user_id")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    @EqualsAndHashCode.Include
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<CartItem> items = new HashSet<>();

    // Synchronization methods
    public void addItem(CartItem item) {
        if (item != null) {
            CartItem existing = items.stream()
                    .filter(ci -> ci.getBook().getId().equals(item.getBook().getId()))
                    .findFirst()
                    .orElse(null);

            if (existing != null) {
                existing.setQuantity(existing.getQuantity() + item.getQuantity());
            } else {
                items.add(item);
                item.setCart(this);
            }
        }
    }

    public void addItem(Book book, int quantity) {
        CartItem existing = items.stream()
                .filter(ci -> ci.getBook().equals(book))
                .findFirst()
                .orElse(null);

        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            CartItem item = new CartItem();
            item.setCart(this);
            item.setBook(book);
            item.setQuantity(quantity);
            items.add(item);
        }
    }

    public void removeItem(CartItem item) {
        if (item != null) {
            items.remove(item);
            item.setCart(null);
        }
    }

    public void removeItem(Book book) {
        items.removeIf(item -> item.getBook().equals(book));
    }

    @Override
    public String toString() {
        return "Cart{" +
                "id=" + id +
                ", items=" + items +
                '}';
    }
}