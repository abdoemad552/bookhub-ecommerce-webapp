package com.iti.jets.model.dto.response;

import lombok.*;

import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CartDTO {
    private double totalPrice;
    private double shippingPrice;
    private Set<CartItemDTO> items;
}
