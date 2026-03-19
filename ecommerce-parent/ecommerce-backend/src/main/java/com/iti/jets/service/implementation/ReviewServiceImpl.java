package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.request.ReviewRequestDTO;
import com.iti.jets.model.dto.response.ReviewDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.entity.Review;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.ReviewRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.ReviewService;

import java.util.List;
import java.util.Optional;

public class ReviewServiceImpl extends ContextHandler implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;

    public ReviewServiceImpl(ReviewRepository reviewRepository,
                             UserRepository userRepository,
                             BookRepository bookRepository) {
        this.reviewRepository = reviewRepository;
        this.userRepository = userRepository;
        this.bookRepository = bookRepository;
    }

    @Override
    public ReviewDTO findById(Long id) {
        return executeInContext(() -> reviewRepository.findById(id).map(this::toDTO).orElse(null));
    }

    @Override
    public void delete(Long id) {
        if (id == null) {
            return;
        }

        executeInContext(() -> {
            Optional<Review> reviewOpt = reviewRepository.findById(id);

            if (reviewOpt.isEmpty()) {
                return;
            }

            Review review = reviewOpt.get();
            reviewRepository.deleteById(id);
            removeReviewFromBook(review.getBook(), review.getRating());
        });
    }

    @Override
    public long count() {
        return executeInContext(() -> reviewRepository.count());
    }

    @Override
    public boolean existsById(Long id) {
        return executeInContext(() -> reviewRepository.existsById(id));
    }


    @Override
    public List<ReviewDTO> getBookReviews(Integer bookId, Integer pageNumber, Integer pageSize) {
        return executeInContext(() -> reviewRepository.findAllByBookId(bookId, pageNumber, pageSize).stream().map(this::toDTO).toList());
    }

    @Override
    public ReviewDTO getUserBookReview(Integer userId, Integer bookId) {
        if (userId == null || bookId == null) {
            return null;
        }

        return executeInContext(() -> reviewRepository.findByUserIdAndBookId(userId, bookId).map(this::toDTO).orElse(null));
    }

    @Override
    public ReviewDTO submitReview(ReviewRequestDTO request) {
        if (request == null || request.getUserId() == null || request.getBookId() == null || request.getRating() == null) {
            return null;
        }

        if (request.getRating() < 1 || request.getRating() > 5) {
            return null;
        }

        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(Long.valueOf(request.getUserId()));
            Optional<Book> bookOpt = bookRepository.findById(Long.valueOf(request.getBookId()));

            if (userOpt.isEmpty() || bookOpt.isEmpty()) {
                return null;
            }

            Optional<Review> existingReview = reviewRepository.findByUserIdAndBookId(request.getUserId(), request.getBookId());

            if (existingReview.isPresent()) {
                return null;
            }

            Review review = Review.builder()
                    .user(userOpt.get())
                    .book(bookOpt.get())
                    .build();

            review.setRating(request.getRating());
            review.setComment(request.getComment() == null ? null : request.getComment().trim());

            Review savedReview = reviewRepository.save(review);

            addReviewToBook(bookOpt.get(), request.getRating());
            return toDTO(savedReview);
        });
    }

    @Override
    public boolean deleteReview(Integer userId, Integer bookId) {
        if (userId == null || bookId == null) {
            return false;
        }

        return executeInContext(() -> {
            Optional<Review> reviewOpt = reviewRepository.findByUserIdAndBookId(userId, bookId);

            if (reviewOpt.isEmpty()) {
                return false;
            }

            Review review = reviewOpt.get();
            reviewRepository.delete(review);
            removeReviewFromBook(review.getBook(), review.getRating());
            return true;
        });
    }

    private void addReviewToBook(Book book, Integer newRating) {
        int currentRatingCount = book.getRatingCount() == null ? 0 : book.getRatingCount();
        double currentAverageRating = book.getAverageRating() == null ? 0.0 : book.getAverageRating();
        int updatedRatingCount = currentRatingCount + 1;
        double updatedAverageRating = ((currentAverageRating * currentRatingCount) + newRating) / updatedRatingCount;

        book.setRatingCount(updatedRatingCount);
        book.setAverageRating(updatedAverageRating);
        bookRepository.update(book);
    }

    private void removeReviewFromBook(Book book, Integer removedRating) {
        int currentRatingCount = book.getRatingCount() == null ? 0 : book.getRatingCount();
        double currentAverageRating = book.getAverageRating() == null ? 0.0 : book.getAverageRating();

        if (currentRatingCount <= 1) {
            book.setAverageRating(0.0);
            book.setRatingCount(0);
        } else {
            int updatedRatingCount = currentRatingCount - 1;
            double updatedAverageRating = ((currentAverageRating * currentRatingCount) - removedRating) / updatedRatingCount;

            book.setAverageRating(updatedAverageRating);
            book.setRatingCount(updatedRatingCount);
        }

        bookRepository.update(book);
    }

    private ReviewDTO toDTO(Review review) {
        if (review == null) {
            return null;
        }

        User user = review.getUser();
        String firstName = user.getFirstName() == null ? "" : user.getFirstName().trim();
        String lastName = user.getLastName() == null ? "" : user.getLastName().trim();
        String fullName = (firstName + " " + lastName).trim();

        if (fullName.isBlank()) {
            fullName = user.getUsername();
        }

        return ReviewDTO.builder()
                .id(review.getId())
                .userId(user.getId())
                .userFullName(fullName)
                .userProfilePicUrl(user.getProfilePicUrl())
                .comment(review.getComment())
                .rating(review.getRating())
                .createdAt(review.getCreatedAt())
                .build();
    }
}
