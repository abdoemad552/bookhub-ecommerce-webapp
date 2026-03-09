package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "user_tags", indexes = {
        @Index(name = "idx_user_tags_user", columnList = "user_id")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class UserTag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    @EqualsAndHashCode.Include
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Lob
    @Column(name = "description")
    private String description;

    @OneToMany(mappedBy = "userTag", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<UserBookTag> books = new HashSet<>();

    public void addBook(UserBookTag ubt) {
        if (ubt != null) {
            books.add(ubt);
            ubt.setUserTag(this);
        }
    }

    public void removeBook(UserBookTag ubt) {
        if (ubt != null) {
            books.remove(ubt);
            ubt.setUserTag(null);
        }
    }

    public void addBook(Book book) {
        if (book != null) {
            UserBookTag userBookTag = new UserBookTag();
            userBookTag.setBook(book);
            userBookTag.setUserTag(this);
            books.add(userBookTag);
        }
    }

    public void removeBook(Book book) {
        if (book != null) {
            books.removeIf(ubt -> ubt.getBook().equals(book));
        }
    }

    @Override
    public String toString() {
        return "UserTag{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}