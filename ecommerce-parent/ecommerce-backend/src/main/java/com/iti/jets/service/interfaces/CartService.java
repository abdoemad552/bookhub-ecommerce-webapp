package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;
import com.iti.jets.service.generic.BaseService;

public interface CartService extends BaseService<Cart, Long> {

    Cart findByUserId(Integer userId);

    int getItemsCount(Integer userId);

    CartItem createTransientCartItem(Integer bookId, Integer amount);

    boolean addToCart(Integer userId, Integer bookId);

    boolean addToCart(Integer userId, Integer bookId, Integer quantity);

    boolean removeFromCart(Integer userId, Integer bookId);

    boolean removeFromCart(Integer userId, Integer bookId, Integer quantity);

    BaseResponse<CartDTO> loadOrderSummary(Long userId);
}
