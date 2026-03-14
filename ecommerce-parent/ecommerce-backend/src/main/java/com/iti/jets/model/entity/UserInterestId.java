package com.iti.jets.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serial;
import java.io.Serializable;

@Embeddable
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class UserInterestId implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Column(name="user_id")
    private Long userId;

    @Column(name = "category_id")
    private Long categoryId;

    @Override
    public String toString() {
        return "UserInterestId{" +
                "userId=" + userId +
                ", categoryId=" + categoryId +
                '}';
    }
}
