package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serial;
import java.io.Serializable;

@Embeddable
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class CartItemId implements Serializable {

    @Serial
    private static final long serialVersionUID = 514418106954792554L;

    @Column(name = "cart_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long cartId;

    @Column(name = "book_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long bookId;

    @Override
    public String toString() {
        return "CartItemId{" +
                "cartId=" + cartId +
                ", bookId=" + bookId +
                '}';
    }
}