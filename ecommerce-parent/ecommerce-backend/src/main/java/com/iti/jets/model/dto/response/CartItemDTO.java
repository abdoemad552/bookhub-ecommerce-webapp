package com.iti.jets.model.dto.response;

import lombok.*;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CartItemDTO {
    private long bookId;
    private int quantity;
    private String bookTitle;
    private String bookCoverUrl;
    private List<AuthorDTO> authors;
    private double price;
    private int amount;
}
