package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.Review;
import com.iti.jets.repository.generic.BaseRepository;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends BaseRepository<Review, Long> {

    List<Review> findAllByBookId(Integer bookId, Integer pageNumber, Integer pageSize);

    Optional<Review> findByUserIdAndBookId(Integer userId, Integer bookId);
}
