package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class UserBookTagId implements Serializable {
    private static final long serialVersionUID = 2027961110595616895L;
    @NotNull
    @Column(name = "user_tag_id", nullable = false)
    private Long userTagId;

    @NotNull
    @Column(name = "book_id", nullable = false)
    private Long bookId;

    public Long getUserTagId() {
        return userTagId;
    }

    public void setUserTagId(Long userTagId) {
        this.userTagId = userTagId;
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
        UserBookTagId entity = (UserBookTagId) o;
        return Objects.equals(this.userTagId, entity.userTagId) &&
                Objects.equals(this.bookId, entity.bookId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userTagId, bookId);
    }
}