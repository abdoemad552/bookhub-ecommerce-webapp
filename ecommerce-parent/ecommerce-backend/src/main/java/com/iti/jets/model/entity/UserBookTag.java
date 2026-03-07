package com.iti.jets.model.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "user_book_tags", schema = "book_hub")
public class UserBookTag {
    @EmbeddedId
    private UserBookTagId id;

    @MapsId("userTagId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_tag_id", nullable = false)
    private UserTag userTag;

    @MapsId("bookId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    public UserBookTagId getId() {
        return id;
    }

    public void setId(UserBookTagId id) {
        this.id = id;
    }

    public UserTag getUserTag() {
        return userTag;
    }

    public void setUserTag(UserTag userTag) {
        this.userTag = userTag;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

}