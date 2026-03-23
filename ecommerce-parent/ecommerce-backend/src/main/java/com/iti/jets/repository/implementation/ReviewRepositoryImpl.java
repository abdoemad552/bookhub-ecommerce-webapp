package com.iti.jets.repository.implementation;

import com.iti.jets.model.entity.Review;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.ReviewRepository;

import java.util.List;
import java.util.Optional;

public class ReviewRepositoryImpl extends BaseRepositoryImpl<Review, Long> implements ReviewRepository {

    @Override
    public List<Review> findAllByBookId(Integer bookId, Integer pageNumber, Integer pageSize) {
        return executeReadOnly(em -> {
            int safePageNumber = Math.max(pageNumber, 1);
            int safePageSize = Math.max(pageSize, 1);

            return em.createQuery(
                            "SELECT r FROM Review r " +
                                    "JOIN FETCH r.user " +
                                    "WHERE r.book.id = :bookId " +
                                    "ORDER BY r.createdAt DESC",
                            getEntityClass()
                    )
                    .setParameter("bookId", Long.valueOf(bookId))
                    .setFirstResult((safePageNumber - 1) * safePageSize)
                    .setMaxResults(safePageSize)
                    .getResultList();
        });
    }

    @Override
    public Optional<Review> findByUserIdAndBookId(Integer userId, Integer bookId) {
        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT r FROM Review r " +
                                        "JOIN FETCH r.user " +
                                        "WHERE r.user.id = :userId AND r.book.id = :bookId",
                                getEntityClass()
                        )
                        .setParameter("userId", Long.valueOf(userId))
                        .setParameter("bookId", Long.valueOf(bookId))
                        .getResultStream()
                        .findFirst()
        );
    }
}
