package com.iti.jets.service.interfaces;

import com.iti.jets.model.entity.Review;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface ReviewService extends BaseService<Review, Long> {

    List<Review> findAllByBookId(Integer bookId);
}
