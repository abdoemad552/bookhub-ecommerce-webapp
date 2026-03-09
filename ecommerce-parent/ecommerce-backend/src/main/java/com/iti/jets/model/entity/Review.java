package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.LocalDateTime;

@Entity
@Table(name = "reviews", indexes = {
        @Index(name = "idx_reviews_book", columnList = "book_id"),
        @Index(name = "idx_reviews_book_created_at", columnList = "book_id, created_at")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Review {

    @EmbeddedId
    @EqualsAndHashCode.Include
    private ReviewId id;

    @MapsId("userId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @MapsId("bookId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "book_id", nullable = false)
    private Book book;

    @Column(name = "rating")
    private Integer rating = 1;

    @Lob
    @Column(name = "comment")
    private String comment;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // Special constructor
    public Review(User user, Book book, Integer rating, String comment, LocalDateTime createdAt) {
        this.user = user;
        this.book = book;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.id = new ReviewId(user.getId(), book.getId());
    }

    // Special setters
    public void setRating(Integer rating) {
        if(rating != null){
            if(rating >= 1 && rating <= 5){
                this.rating = rating;
            }
        }
    }

    @Override
    public String toString() {
        return "Review{" +
                "id=" + id +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}