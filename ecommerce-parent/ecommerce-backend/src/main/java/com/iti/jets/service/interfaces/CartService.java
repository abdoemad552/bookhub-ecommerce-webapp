package com.iti.jets.service.interfaces;

import com.iti.jets.model.entity.Cart;
import com.iti.jets.service.generic.BaseService;

public interface CartService extends BaseService<Cart, Long> {

    int getItemsCount();

    boolean addToCart(Integer userId, Integer bookId);

    boolean addToCart(Integer userId, Integer bookId, Integer quantity);

    boolean removeFromCart(Integer userId, Integer bookId);

    boolean removeFromCart(Integer userId, Integer bookId, Integer quantity);
}
