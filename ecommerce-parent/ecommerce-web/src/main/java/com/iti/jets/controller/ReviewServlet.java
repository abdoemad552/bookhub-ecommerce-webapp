package com.iti.jets.controller;

import com.iti.jets.model.dto.request.ReviewRequestDTO;
import com.iti.jets.model.dto.response.ReviewDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.service.interfaces.ReviewService;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/reviews")
public class ReviewServlet extends HttpServlet {

    private BookService bookService;
    private ReviewService reviewService;

    @Override
    public void init() {
        ServiceFactory serviceFactory = ServiceFactory.getInstance();
        bookService = serviceFactory.getBookService();
        reviewService = serviceFactory.getReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer bookId = parseInteger(request.getParameter("bookId"));
        Integer pageNumber = parseInteger(request.getParameter("pageNumber"));
        Integer pageSize = parseInteger(request.getParameter("pageSize"));

        if (bookId == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "Book id is required.")
                            .build()
            );
            return;
        }

        List<ReviewDTO> reviews = reviewService.getBookReviews(
                bookId,
                pageNumber == null ? 1 : pageNumber,
                pageSize == null ? 4 : pageSize
        );

        JsonArrayBuilder reviewsJson = Json.createArrayBuilder();
        reviews.forEach(review -> reviewsJson.add(toReviewJson(review)));

        JsonObject json = Json.createObjectBuilder()
                .add("success", true)
                .add("reviews", reviewsJson)
                .build();

        writeJsonResponse(response, HttpServletResponse.SC_OK, json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserDTO user = getSessionUser(request);

        if (user == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_UNAUTHORIZED,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "You need to sign in first.")
                            .build()
            );
            return;
        }

        Integer bookId = parseInteger(request.getParameter("bookId"));
        Integer rating = parseInteger(request.getParameter("rating"));
        String comment = request.getParameter("comment");
        int userId = Math.toIntExact(user.getId());

        if (bookId == null || rating == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "Book id and rating are required.")
                            .build()
            );
            return;
        }

        if (reviewService.getUserBookReview(userId, bookId) != null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_CONFLICT,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "You already submitted a review for this book.")
                            .build()
            );
            return;
        }

        ReviewDTO review = reviewService.submitReview(
                ReviewRequestDTO.builder()
                        .userId(userId)
                        .bookId(bookId)
                        .rating(rating)
                        .comment(comment)
                        .build()
        );

        if (review == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "Unable to submit your review.")
                            .build()
            );
            return;
        }

        Book book = bookService.findById(Long.valueOf(bookId));

        JsonObject json = Json.createObjectBuilder()
                .add("success", true)
                .add("message", "Review submitted successfully.")
                .add("review", toReviewJson(review))
                .add("ratingSummary", toRatingSummaryJson(book))
                .build();

        writeJsonResponse(response, HttpServletResponse.SC_OK, json);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserDTO user = getSessionUser(request);

        if (user == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_UNAUTHORIZED,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "You need to sign in first.")
                            .build()
            );
            return;
        }

        Integer bookId = parseInteger(request.getParameter("bookId"));
        int userId = Math.toIntExact(user.getId());

        if (bookId == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "Book id is required.")
                            .build()
            );
            return;
        }

        ReviewDTO userReview = reviewService.getUserBookReview(userId, bookId);

        if (userReview == null) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_NOT_FOUND,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "No review found for this book.")
                            .build()
            );
            return;
        }

        boolean deleted = reviewService.deleteReview(userId, bookId);

        if (!deleted) {
            writeJsonResponse(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    Json.createObjectBuilder()
                            .add("success", false)
                            .add("message", "Unable to delete your review.")
                            .build()
            );
            return;
        }

        Book book = bookService.findById(Long.valueOf(bookId));

        JsonObject json = Json.createObjectBuilder()
                .add("success", true)
                .add("message", "Review deleted successfully.")
                .add("deletedReviewId", userReview.getId() == null ? 0 : userReview.getId())
                .add("ratingSummary", toRatingSummaryJson(book))
                .build();

        writeJsonResponse(response, HttpServletResponse.SC_OK, json);
    }

    private UserDTO getSessionUser(HttpServletRequest request) {
        Object user = request.getSession(false) == null ? null : request.getSession(false).getAttribute("user");
        return user instanceof UserDTO ? (UserDTO) user : null;
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private JsonObject toReviewJson(ReviewDTO review) {
        JsonObjectBuilder builder = Json.createObjectBuilder()
                .add("id", review.getId() == null ? 0 : review.getId())
                .add("userId", review.getUserId() == null ? 0 : review.getUserId())
                .add("userFullName", review.getUserFullName() == null ? "" : review.getUserFullName())
                .add("userProfilePicUrl", review.getUserProfilePicUrl() == null ? "" : review.getUserProfilePicUrl())
                .add("comment", review.getComment() == null ? "" : review.getComment())
                .add("rating", review.getRating() == null ? 0 : review.getRating());

        if (review.getCreatedAt() != null) {
            builder.add("createdAt", review.getCreatedAt().toString());
        } else {
            builder.add("createdAt", "");
        }

        return builder.build();
    }

    private JsonObject toRatingSummaryJson(Book book) {
        double averageRating = book == null || book.getAverageRating() == null ? 0.0 : book.getAverageRating();
        int ratingCount = book == null || book.getRatingCount() == null ? 0 : book.getRatingCount();

        return Json.createObjectBuilder()
                .add("averageRating", averageRating)
                .add("ratingCount", ratingCount)
                .build();
    }

    private void writeJsonResponse(HttpServletResponse response, int statusCode, JsonObject payload) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(payload.toString());
    }
}
