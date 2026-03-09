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
public class OrderItemId implements Serializable {

    @Serial
    private static final long serialVersionUID = -8015659842891949674L;

    @Column(name = "order_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long orderId;

    @Column(name = "book_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long bookId;

    @Override
    public String toString() {
        return "OrderItemId{" +
                "orderId=" + orderId +
                ", bookId=" + bookId +
                '}';
    }
}