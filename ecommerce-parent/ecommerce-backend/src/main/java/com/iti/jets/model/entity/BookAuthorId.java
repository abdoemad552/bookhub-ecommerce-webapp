package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serial;
import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class BookAuthorId implements Serializable {

    @Serial
    private static final long serialVersionUID = 7928548887450048385L;

    @Column(name = "book_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long bookId;

    @Column(name = "author_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long authorId;

    @Override
    public String toString() {
        return "BookAuthorId{" +
                "bookId=" + bookId +
                ", authorId=" + authorId +
                '}';
    }
}