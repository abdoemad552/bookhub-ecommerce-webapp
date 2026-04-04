package com.iti.jets.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Builder
public class AuthorStatsDTO {
    private final long totalBooks;
    private final double averageRating;
    private final long totalReviews;
}
