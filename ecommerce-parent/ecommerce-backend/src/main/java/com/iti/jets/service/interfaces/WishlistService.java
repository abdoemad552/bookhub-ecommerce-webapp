package com.iti.jets.service.interfaces;

import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.service.generic.BaseService;

public interface WishlistService extends BaseService<Wishlist, WishlistId> {

    boolean addToWishlist(Integer userId, Integer bookId);

    boolean removeFromWishlist(Integer userId, Integer bookId);

    boolean isInWishlist(Integer userId, Integer bookId);
}
