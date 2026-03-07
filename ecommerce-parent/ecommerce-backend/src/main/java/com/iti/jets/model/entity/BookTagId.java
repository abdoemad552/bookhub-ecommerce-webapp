package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class BookTagId implements Serializable {
    private static final long serialVersionUID = -6559745374664924204L;
    @NotNull
    @Column(name = "book_id", nullable = false)
    private Long bookId;

    @NotNull
    @Column(name = "tag_id", nullable = false)
    private Long tagId;

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Long getTagId() {
        return tagId;
    }

    public void setTagId(Long tagId) {
        this.tagId = tagId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BookTagId entity = (BookTagId) o;
        return Objects.equals(this.bookId, entity.bookId) &&
                Objects.equals(this.tagId, entity.tagId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(bookId, tagId);
    }
}