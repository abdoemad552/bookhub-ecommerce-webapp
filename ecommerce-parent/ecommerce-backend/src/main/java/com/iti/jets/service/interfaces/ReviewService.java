package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.ReviewRequestDTO;
import com.iti.jets.model.dto.response.ReviewDTO;
import com.iti.jets.service.generic.BaseService;

import java.util.List;

public interface ReviewService extends BaseService<ReviewDTO, Long> {

    List<ReviewDTO> getBookReviews(Integer bookId, Integer pageNumber, Integer pageSize);

    ReviewDTO getUserBookReview(Integer userId, Integer bookId);

    ReviewDTO submitReview(ReviewRequestDTO request);

    boolean deleteReview(Integer userId, Integer bookId);
}
