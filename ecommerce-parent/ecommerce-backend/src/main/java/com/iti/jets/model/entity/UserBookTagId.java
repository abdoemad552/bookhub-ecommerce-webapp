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
public class UserBookTagId implements Serializable {

    @Serial
    private static final long serialVersionUID = 2027961110595616895L;

    @Column(name = "user_tag_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long userTagId;

    @Column(name = "book_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long bookId;

    @Override
    public String toString() {
        return "UserBookTagId{" +
                "userTagId=" + userTagId +
                ", bookId=" + bookId +
                '}';
    }
}