package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "user_interests")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class UserInterest {

    @EmbeddedId
    @Builder.Default
    private UserInterestId id = new UserInterestId();

    @MapsId("userId")
    @OnDelete(action = OnDeleteAction.CASCADE)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    @EqualsAndHashCode.Include
    private User user;

    @MapsId("categoryId")
    @OnDelete(action = OnDeleteAction.CASCADE)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    @EqualsAndHashCode.Include
    private Category category;

    public UserInterest(User user, Category category) {
        this.user = user;
        this.category = category;
        this.id = new UserInterestId();
    }
}