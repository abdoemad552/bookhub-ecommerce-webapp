package com.iti.jets.repository.implementation;

import com.iti.jets.model.entity.Order;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.OrderRepository;

import java.util.List;

public class OrderRepositoryImpl extends BaseRepositoryImpl<Order, Long> implements OrderRepository {

    public OrderRepositoryImpl() {
        super();
    }

    @Override
    public List<Order> findAllByUserId(Long userId) {
        if (userId == null) {
            return List.of();
        }

        return executeReadOnly(em ->
                em.createQuery(
                                "SELECT DISTINCT o FROM Order o " +
                                        "LEFT JOIN FETCH o.user " +
                                        "LEFT JOIN FETCH o.items i " +
                                        "LEFT JOIN FETCH i.book " +
                                        "WHERE o.user.id = :userId " +
                                        "ORDER BY o.createdAt DESC",
                                getEntityClass()
                        )
                        .setParameter("userId", userId)
                        .getResultList()
        );
    }
}
