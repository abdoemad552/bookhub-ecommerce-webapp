package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface WishlistService extends BaseService<Wishlist, WishlistId> {

    boolean addToWishlist(Integer userId, Integer bookId);

    boolean removeFromWishlist(Integer userId, Integer bookId);

    boolean isInWishlist(Integer userId, Integer bookId);

    List<BookCardDTO> findWishlistBooks(Long userId);
}
