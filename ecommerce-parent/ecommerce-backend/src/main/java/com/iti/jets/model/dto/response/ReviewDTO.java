package com.iti.jets.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ReviewDTO {
    private Long id;

    private Long userId;
    private String userFullName;
    private String userProfilePicUrl;

    private String comment;
    private Integer rating;
    private LocalDateTime createdAt;
}
