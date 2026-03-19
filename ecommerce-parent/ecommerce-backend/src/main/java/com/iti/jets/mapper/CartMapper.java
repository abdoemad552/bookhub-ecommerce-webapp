package com.iti.jets.mapper;

import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.CartItemDTO;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;

import java.util.List;

public class CartMapper {

    private static final CartMapper INSTANCE = new CartMapper();

    private CartMapper() {
    }

    public static CartMapper getInstance() {
        return INSTANCE;
    }

    public CartDTO toDTO(Cart cart) {

        return CartDTO.builder()
                .shippingPrice(0)
                .totalPrice(cart.getTotalPrice())
                .build();
    }
}
