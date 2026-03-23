package com.iti.jets.service.implementation;

import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.repository.interfaces.WishlistRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.WishlistService;

import java.util.List;

public class WishlistServiceImpl extends ContextHandler implements WishlistService {

    private final WishlistRepository wishlistRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;

    public WishlistServiceImpl(WishlistRepository wishlistRepository,
                               UserRepository userRepository,
                               BookRepository bookRepository) {
        this.wishlistRepository = wishlistRepository;
        this.userRepository = userRepository;
        this.bookRepository = bookRepository;
    }


    @Override
    public boolean addToWishlist(Integer userId, Integer bookId) {
        WishlistId wishlistId = buildWishlistId(userId, bookId);

        if (wishlistId == null) {
            return false;
        }

        return executeInContext(() -> {
            if (wishlistRepository.existsById(wishlistId)) {
                return true;
            }

            var userOpt = userRepository.findById(Long.valueOf(userId));
            var bookOpt = bookRepository.findById(Long.valueOf(bookId));

            if (userOpt.isEmpty() || bookOpt.isEmpty()) {
                return false;
            }

            Wishlist wishlist = Wishlist.builder()
                    .id(wishlistId)
                    .user(userOpt.get())
                    .book(bookOpt.get())
                    .build();

            wishlistRepository.save(wishlist);
            return true;
        });
    }

    @Override
    public boolean removeFromWishlist(Integer userId, Integer bookId) {
        WishlistId wishlistId = buildWishlistId(userId, bookId);

        if (wishlistId == null) {
            return false;
        }

        return executeInContext(() -> {
            if (!wishlistRepository.existsById(wishlistId)) {
                return false;
            }

            wishlistRepository.deleteById(wishlistId);
            return true;
        });
    }

    @Override
    public boolean isInWishlist(Integer userId, Integer bookId) {
        WishlistId wishlistId = buildWishlistId(userId, bookId);

        if (wishlistId == null) {
            return false;
        }

        return executeInContext(() -> wishlistRepository.existsById(wishlistId));
    }

    private WishlistId buildWishlistId(Integer userId, Integer bookId) {
        if (userId == null || bookId == null) {
            return null;
        }

        return WishlistId.builder()
                .userId(Long.valueOf(userId))
                .bookId(Long.valueOf(bookId))
                .build();
    }
}
