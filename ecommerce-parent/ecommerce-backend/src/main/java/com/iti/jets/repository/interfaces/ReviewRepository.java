package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Review;
import com.iti.jets.repository.generic.BaseRepository;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface ReviewRepository extends BaseRepository<Review, Long> {

    List<Review> findAllByBookId(Integer bookId);
}
