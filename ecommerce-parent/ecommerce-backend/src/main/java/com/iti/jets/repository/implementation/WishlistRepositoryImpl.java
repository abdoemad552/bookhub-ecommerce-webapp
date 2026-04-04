package com.iti.jets.repository.implementation;

import com.iti.jets.model.entity.Wishlist;
import com.iti.jets.model.entity.WishlistId;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.WishlistRepository;

import java.util.List;
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

    @Override
    public List<Wishlist> findAllByUserId(Long userId) {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT DISTINCT w FROM Wishlist w " +
                                        "JOIN FETCH w.book b " +
                                        "LEFT JOIN FETCH b.bookAuthors ba " +
                                        "LEFT JOIN FETCH ba.author " +
                                        "WHERE w.user.id = :userId " +
                                        "ORDER BY b.title",
                                getEntityClass()
                        )
                        .setParameter("userId", userId)
                        .getResultList()
        );
    }
}
