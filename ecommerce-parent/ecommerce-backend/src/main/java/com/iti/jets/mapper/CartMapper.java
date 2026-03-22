package com.iti.jets.mapper;

import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.CartItemDTO;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class CartMapper {

    private static final CartMapper INSTANCE = new CartMapper();

    private CartMapper() {
    }

    public static CartMapper getInstance() {
        return INSTANCE;
    }

    public CartItemDTO toDTO(CartItem cartItem){
        return CartItemDTO.builder()
                .bookId(cartItem.getBook().getId())
                .bookTitle(cartItem.getBook().getTitle())
                .price(cartItem.getBook().getPrice().doubleValue())
                .quantity(cartItem.getQuantity())
                .build();
    }

    public CartDTO toDTO(Cart cart) {

        Set<CartItemDTO> cartItems = cart.getItems().stream()
                .map(this::toDTO)
                .collect(Collectors.toSet());

        return CartDTO.builder()
                .shippingPrice(0)
                .totalPrice(cart.getTotalPrice())
                .items(cartItems)
                .build();
    }
}
