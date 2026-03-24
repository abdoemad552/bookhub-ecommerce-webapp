package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.List;
import java.util.Optional;

public interface WishlistRepository extends BaseRepository<Wishlist, WishlistId> {

    Optional<Wishlist> findByUserIdAndBookId(Integer userId, Integer bookId);

    boolean existsByUserIdAndBookId(Integer userId, Integer bookId);

    List<Wishlist> findAllByUserId(Long userId);
}
