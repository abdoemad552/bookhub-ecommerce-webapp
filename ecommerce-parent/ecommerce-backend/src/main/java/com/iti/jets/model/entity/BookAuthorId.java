package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class BookAuthorId implements Serializable {
    private static final long serialVersionUID = 7928548887450048385L;
    @NotNull
    @Column(name = "book_id", nullable = false)
    private Long bookId;

    @NotNull
    @Column(name = "author_id", nullable = false)
    private Long authorId;

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BookAuthorId entity = (BookAuthorId) o;
        return Objects.equals(this.bookId, entity.bookId) &&
                Objects.equals(this.authorId, entity.authorId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(bookId, authorId);
    }
}