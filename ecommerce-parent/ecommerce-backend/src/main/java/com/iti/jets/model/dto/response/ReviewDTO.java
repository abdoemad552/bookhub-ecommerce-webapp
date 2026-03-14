package com.iti.jets.model.dto.response;

import java.time.LocalDateTime;

public class ReviewDTO {
    private long id;

    private long userId;
    private String userFullName;
    private String userProfilePicUrl;

    private String comment;
    private double averageRating;
    private LocalDateTime createdAt;
}
