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
public class BookTagId implements Serializable {

    @Serial
    private static final long serialVersionUID = -6559745374664924204L;

    @Column(name = "book_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long bookId;

    @Column(name = "tag_id", nullable = false)
    @EqualsAndHashCode.Include
    private Long tagId;

    @Override
    public String toString() {
        return "BookTagId{" +
                "bookId=" + bookId +
                ", tagId=" + tagId +
                '}';
    }
}