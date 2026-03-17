package com.iti.jets.service.implementation;

import com.iti.jets.model.entity.Cart;
import com.iti.jets.repository.interfaces.CartRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.CartService;

import java.util.List;

public class CartServiceImpl extends ContextHandler implements CartService {

    private final CartRepository cartRepository;

    public CartServiceImpl(CartRepository cartRepository) {
        this.cartRepository = cartRepository;
    }

    @Override
    public Cart findById(Long id) {
        return executeInContext(() -> cartRepository.findById(id).orElse(null));
    }

    @Override
    public Cart findByUserId(Integer userId) {
        if (userId == null) {
            return null;
        }

        return executeInContext(() -> cartRepository.findByUserId(userId).orElse(null));
    }

    @Override
    public int getItemsCount(Integer userId) {
        return executeInContext(() -> cartRepository.getItemsCount(userId));
    }

    @Override
    public boolean addToCart(Integer userId, Integer bookId) {
        return executeInContext(() -> cartRepository.addToCart(userId, bookId,1));
    }

    @Override
    public boolean addToCart(Integer userId, Integer bookId, Integer quantity) {
        return executeInContext(() -> cartRepository.addToCart(userId, bookId, quantity));
    }

    @Override
    public boolean removeFromCart(Integer userId, Integer bookId) {
        return executeInContext(() -> cartRepository.removeFromCart(userId, bookId,1));
    }

    @Override
    public boolean removeFromCart(Integer userId, Integer bookId, Integer quantity) {
        return executeInContext(() -> cartRepository.removeFromCart(userId, bookId, quantity));
    }
}
