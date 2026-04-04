package com.iti.jets.model.dto.response;

import lombok.*;

import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CartItemDTO {

    private long bookId;
    private String bookTitle;
    private int quantity;
    private double price;
}
