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
public class WishlistId implements Serializable {

    @Serial
    private static final long serialVersionUID = 5039353313556203786L;

    @Column(name = "user_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long userId;

    @Column(name = "book_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long bookId;

    @Override
    public String toString() {
        return "WishlistId{" +
                "userId=" + userId +
                ", bookId=" + bookId +
                '}';
    }
}