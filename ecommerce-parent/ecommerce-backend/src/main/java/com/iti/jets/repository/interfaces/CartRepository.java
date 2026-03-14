package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Cart;
import com.iti.jets.repository.generic.BaseRepository;

public interface CartRepository extends BaseRepository<Cart, Long> {

    int getItemsCount();

    boolean addToCart(Integer userId, Integer bookId);

    boolean addToCart(Integer userId, Integer bookId, Integer quantity);

    boolean removeFromCart(Integer userId, Integer bookId);

    boolean removeFromCart(Integer userId, Integer bookId, Integer quantity);
}
