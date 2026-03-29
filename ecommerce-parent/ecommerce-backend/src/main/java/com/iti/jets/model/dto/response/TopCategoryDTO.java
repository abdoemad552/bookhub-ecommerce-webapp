package com.iti.jets.model.dto.response;

import lombok.*;

import java.math.BigDecimal;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TopCategoryDTO {
    private String categoryName;
    private BigDecimal percentage;
}
