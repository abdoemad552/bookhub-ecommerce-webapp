package com.iti.jets.model.dto.response;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class OrderItemDTO {

    private long bookId;
    private String bookTittle;
    private String imageUrl;
    private int quantity;
    private double currentPrice;
}
