package com.iti.jets.model.dto.response;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TopCategoryDTO {
    private String categoryName;
    private double percentage;
}
