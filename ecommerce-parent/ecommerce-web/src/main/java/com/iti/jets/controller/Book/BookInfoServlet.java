package com.iti.jets.controller.Book;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.ReviewDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.service.interfaces.ReviewService;
import com.iti.jets.service.interfaces.WishlistService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet("/books/*")
public class BookInfoServlet extends HttpServlet {

    private static final int REVIEWS_PAGE_SIZE = 4;
    private static final int RELATED_BOOKS_COUNT = 4;

    private BookService bookService;
    private ReviewService reviewService;
    private WishlistService wishlistService;

    @Override
    public void init() {
        ServiceFactory serviceFactory = ServiceFactory.getInstance();
        bookService = serviceFactory.getBookService();
        reviewService = serviceFactory.getReviewService();
        wishlistService = serviceFactory.getWishlistService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long bookId = parseBookId(request.getPathInfo());

        if (bookId == null) {
            forwardToNotFound(request, response);
            return;
        }

        Book book = bookService.findById(bookId);

        if (book == null) {
            forwardToNotFound(request, response);
            return;
        }

        List<ReviewDTO> reviews = reviewService.getBookReviews(Math.toIntExact(bookId), 1, REVIEWS_PAGE_SIZE);
        UserDTO user = getSessionUser(request);
        boolean isInWishlist = user != null && wishlistService.isInWishlist(Math.toIntExact(user.getId()), Math.toIntExact(bookId));
        ReviewDTO userReview = user == null ? null : reviewService.getUserBookReview(Math.toIntExact(user.getId()), Math.toIntExact(bookId));

        System.out.println(book.getImageUrl());
        request.setAttribute("book", book);
        double averageRating = book.getAverageRating() == null ? 0.0 : book.getAverageRating();
        request.setAttribute("bookAverageRating", (int) Math.floor(averageRating));
        request.setAttribute("bookAverageRatingValue", String.format(Locale.US, "%.1f", averageRating));
        request.setAttribute("bookReviewCount", book.getRatingCount() == null ? reviews.size() : book.getRatingCount());
        request.setAttribute("bookFormatLabel", book.getBookType() == null ? "" : book.getBookType().getPrettyName());
        request.setAttribute("reviews", reviews);
        request.setAttribute("reviewsPageSize", REVIEWS_PAGE_SIZE);
        request.setAttribute("canLoadMoreReviews", reviews.size() >= REVIEWS_PAGE_SIZE);
        request.setAttribute("isInWishlist", isInWishlist);
        request.setAttribute("userReview", userReview);
        request.setAttribute("relatedBooks", findRelatedBooks(book));

        request.getRequestDispatcher(PathStorage.BOOK_INFO_PAGE).forward(request, response);
    }

    private UserDTO getSessionUser(HttpServletRequest request) {
        Object user = request.getSession(false) == null ? null : request.getSession(false).getAttribute("user");
        return user instanceof UserDTO ? (UserDTO) user : null;
    }

    private Long parseBookId(String pathInfo) {
        if (pathInfo == null || pathInfo.isBlank() || "/".equals(pathInfo)) {
            return null;
        }

        String[] parts = pathInfo.split("/");
        String rawId = parts.length > 1 ? parts[1] : parts[0];

        try {
            return Long.parseLong(rawId);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private List<BookCardDTO> findRelatedBooks(Book currentBook) {
        Map<Long, BookCardDTO> relatedBooks = new LinkedHashMap<>();
        String currentCategory = currentBook.getCategory() == null ? null : currentBook.getCategory().getName();

        if (currentCategory != null && !currentCategory.isBlank()) {
            BookFilterDTO filter = BookFilterDTO.builder()
                    .categoryIds(Set.of(currentBook.getCategory().getId()))
                    .sortCriteria("featured")
                    .build();

            bookService.findAll(1, RELATED_BOOKS_COUNT + 4, filter).stream()
                    .filter(book -> !book.getId().equals(currentBook.getId()))
                    .map(BookCardDTO::from)
                    .forEach(book -> relatedBooks.putIfAbsent(book.getId(), book));
        }

        if (relatedBooks.size() < RELATED_BOOKS_COUNT) {
            bookService.findAllFeatured().stream()
                    .filter(book -> !book.getId().equals(currentBook.getId()))
                    .map(BookCardDTO::from)
                    .forEach(book -> relatedBooks.putIfAbsent(book.getId(), book));
        }

        return relatedBooks.values()
                .stream()
                .limit(RELATED_BOOKS_COUNT)
                .toList();
    }

    private void forwardToNotFound(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        request.getRequestDispatcher(PathStorage.BOOK_NOT_FOUND_PAGE).forward(request, response);
    }
}
