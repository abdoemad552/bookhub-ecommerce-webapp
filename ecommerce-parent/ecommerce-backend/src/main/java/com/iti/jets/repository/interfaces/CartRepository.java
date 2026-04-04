package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Cart;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.Optional;

public interface CartRepository extends BaseRepository<Cart, Long> {

    int getItemsCount(Integer userId);

    Optional<Cart> findByUserId(Integer userId);

    boolean addToCart(Integer userId, Integer bookId);

    boolean addToCart(Integer userId, Integer bookId, Integer quantity);

    boolean removeFromCart(Integer userId, Integer bookId);

    boolean removeFromCart(Integer userId, Integer bookId, Integer quantity);

    void deleteByUserId(Long userId);
}
