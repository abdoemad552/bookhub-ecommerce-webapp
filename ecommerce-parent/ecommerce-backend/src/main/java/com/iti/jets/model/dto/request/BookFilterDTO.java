package com.iti.jets.model.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookFilterDTO {
    private String category;
    private double minPrice;
    private double maxPrice;
    private String searchQuery;
}
