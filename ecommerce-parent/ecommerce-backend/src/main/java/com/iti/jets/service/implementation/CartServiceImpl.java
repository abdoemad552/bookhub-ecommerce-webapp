package com.iti.jets.service.implementation;

import com.iti.jets.mapper.CartMapper;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CartRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.CartService;

import java.util.List;
import java.util.Optional;

public class CartServiceImpl extends ContextHandler implements CartService {

    private final CartRepository cartRepository;
    private final BookRepository bookRepository;
    private final CartMapper cartMapper;

    public CartServiceImpl(CartRepository cartRepository, BookRepository bookRepository, CartMapper cartMapper) {
        this.cartRepository = cartRepository;
        this.cartMapper = cartMapper;
        this.bookRepository = bookRepository;
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
    public CartItem createTransientCartItem(Integer bookId, Integer amount) {
        return executeInContext(() -> {
            CartItem cartItem = new CartItem();
            Book book = bookRepository.findById(Long.valueOf(bookId)).orElse(null);
            cartItem.setBook(book);
            cartItem.setQuantity(amount);
            return cartItem;
        });
    }

    @Override
    public boolean addToCart(Integer userId, Integer bookId) {
        return executeInContext(() -> cartRepository.addToCart(userId, bookId));
    }

    @Override
    public boolean addToCart(Integer userId, Integer bookId, Integer quantity) {
        return executeInContext(() -> cartRepository.addToCart(userId, bookId, quantity));
    }

    @Override
    public boolean removeFromCart(Integer userId, Integer bookId) {
        return executeInContext(() -> cartRepository.removeFromCart(userId, bookId));
    }

    @Override
    public boolean removeFromCart(Integer userId, Integer bookId, Integer quantity) {
        return executeInContext(() -> cartRepository.removeFromCart(userId, bookId, quantity));
    }

    @Override
    public BaseResponse<CartDTO> loadOrderSummary(Long userId) {
        return executeInContext(() -> {
            Optional<Cart> cartOpt = cartRepository.findByUserId(userId.intValue());
            if(cartOpt.isEmpty()){
                return ResponseFactory.failure("Invalid user");
            }
            return ResponseFactory.success("Order Summary Loaded",
                    cartMapper.toDTO(cartOpt.get()));
        });
    }
}
