package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "user_interest")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class UserInterest {

    @EmbeddedId
    private UserInterestId id;

    @MapsId("userId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @MapsId("categoryId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    // Special constructor
    public UserInterest(Category category, User user) {
        this.category = category;
        this.user = user;
        this.id = new UserInterestId(user.getId(), category.getId());
    }
}
