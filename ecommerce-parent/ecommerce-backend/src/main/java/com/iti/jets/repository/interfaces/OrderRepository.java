package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Order;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.List;

public interface OrderRepository extends BaseRepository<Order, Long> {
    List<Order> findAllByUserId(Long userId);

}
