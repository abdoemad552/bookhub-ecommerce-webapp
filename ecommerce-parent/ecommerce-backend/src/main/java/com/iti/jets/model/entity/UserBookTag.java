package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "user_book_tags", indexes = {
        @Index(name = "idx_user_book_tags_user_tag", columnList = "user_tag_id"),
        @Index(name = "idx_user_book_tags_book", columnList = "book_id")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class UserBookTag {

    @EmbeddedId
    @EqualsAndHashCode.Include
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
}