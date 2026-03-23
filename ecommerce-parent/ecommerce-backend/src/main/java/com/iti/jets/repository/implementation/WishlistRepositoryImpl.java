package com.iti.jets.repository.implementation;

import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.WishlistRepository;

import java.util.Optional;

public class WishlistRepositoryImpl extends BaseRepositoryImpl<Wishlist, WishlistId> implements WishlistRepository {

    @Override
    public Optional<Wishlist> findByUserIdAndBookId(Integer userId, Integer bookId) {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT w FROM Wishlist w WHERE w.user.id = :userId AND w.book.id = :bookId",
                                getEntityClass()
                        )
                        .setParameter("userId", Long.valueOf(userId))
                        .setParameter("bookId", Long.valueOf(bookId))
                        .getResultStream()
                        .findFirst()
        );
    }

    @Override
    public boolean existsByUserIdAndBookId(Integer userId, Integer bookId) {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT COUNT(w) FROM Wishlist w WHERE w.user.id = :userId AND w.book.id = :bookId",
                                Long.class
                        )
                        .setParameter("userId", Long.valueOf(userId))
                        .setParameter("bookId", Long.valueOf(bookId))
                        .getSingleResult() > 0
        );
    }
}
