package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class CartItemId implements Serializable {
    private static final long serialVersionUID = 514418106954792554L;
    @NotNull
    @Column(name = "cart_id", nullable = false)
    private Long cartId;

    @NotNull
    @Column(name = "book_id", nullable = false)
    private Long bookId;

    public Long getCartId() {
        return cartId;
    }

    public void setCartId(Long cartId) {
        this.cartId = cartId;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CartItemId entity = (CartItemId) o;
        return Objects.equals(this.cartId, entity.cartId) &&
                Objects.equals(this.bookId, entity.bookId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cartId, bookId);
    }
}