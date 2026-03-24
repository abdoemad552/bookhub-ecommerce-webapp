package com.iti.jets.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class BookCardDTO {
    private String title;
    private List<AuthorDTO> authors;
    private double averageRating;
    // At most 255 characters...
    private String description;
    private double price;
    private int stockQuantity;
    // TODO: Tags...
}
