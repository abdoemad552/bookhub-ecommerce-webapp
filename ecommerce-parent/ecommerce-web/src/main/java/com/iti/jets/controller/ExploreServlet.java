package com.iti.jets.controller;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.mock.dto.BookCardDto;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {

    private static final int BOOKS_PAGE_SIZE = 9;
    private static final int DEFAULT_MAX_PRICE = 1000;

    private BookService bookService;

    @Override
    public void init() {
        bookService = ServiceFactory.getInstance().getBookService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        int pageNumber = parsePositiveInteger(request.getParameter("page"), 1);
        String selectedCategory = normalizeCategory(request.getParameter("category"));
        String searchQuery = normalizeText(request.getParameter("query"));
        int maxPrice = parsePositiveInteger(request.getParameter("maxPrice"), DEFAULT_MAX_PRICE);
        String sortCriteria = normalizeSortCriteria(request.getParameter("sort"));

        BookFilterDTO filter = BookFilterDTO.builder()
                .category(selectedCategory)
                .maxPrice(maxPrice)
                .searchQuery(searchQuery)
                .sortCriteria(sortCriteria)
                .build();

        List<BookCardDto> books = bookService.findAll(pageNumber, BOOKS_PAGE_SIZE, filter)
                .stream()
                .map(this::toBookCardDto)
                .toList();

        boolean hasNextPage = !bookService.findAll(pageNumber + 1, BOOKS_PAGE_SIZE, filter).isEmpty();

        request.setAttribute("books", books);
        request.setAttribute("bookCardVariant", "grid");
        request.setAttribute("booksResultCount", books.size());
        request.setAttribute("currentPageNumber", pageNumber);
        request.setAttribute("hasPreviousPage", pageNumber > 1);
        request.setAttribute("hasNextPage", hasNextPage);
        request.setAttribute("selectedCategory", selectedCategory == null ? "All Books" : selectedCategory);
        request.setAttribute("selectedCategoryParam", selectedCategory == null ? "" : selectedCategory);
        request.setAttribute("selectedCategoryValue", selectedCategory == null ? "all" : toSlug(selectedCategory));
        request.setAttribute("selectedSearchQuery", searchQuery == null ? "" : searchQuery);
        request.setAttribute("selectedMaxPrice", maxPrice);
        request.setAttribute("selectedSortCriteria", sortCriteria);

        request.getRequestDispatcher(PathStorage.EXPLORE_PAGE).forward(request, response);
    }

    private int parsePositiveInteger(String rawValue, int fallback) {
        try {
            int parsedValue = Integer.parseInt(rawValue);
            return parsedValue > 0 ? parsedValue : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private String normalizeCategory(String rawCategory) {
        String normalizedCategory = normalizeText(rawCategory);

        if (normalizedCategory == null) {
            return null;
        }

        return "all".equalsIgnoreCase(normalizedCategory) || "all books".equalsIgnoreCase(normalizedCategory)
                ? null
                : normalizedCategory;
    }

    private String normalizeText(String rawValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return null;
        }

        return rawValue.trim();
    }

    private String normalizeSortCriteria(String rawSortCriteria) {
        String normalizedSortCriteria = normalizeText(rawSortCriteria);

        if (normalizedSortCriteria == null) {
            return "featured";
        }

        return switch (normalizedSortCriteria.trim().toLowerCase(Locale.ROOT)) {
            case "price-low-to-high", "price-high-to-low", "rating" -> normalizedSortCriteria.trim().toLowerCase(Locale.ROOT);
            default -> "featured";
        };
    }

    private String toSlug(String value) {
        return value.toLowerCase(Locale.ROOT).replace(' ', '-');
    }

    private BookCardDto toBookCardDto(Book book) {
        String authorNames = book.getBookAuthors()
                .stream()
                .map(bookAuthor -> bookAuthor.getAuthor().getName())
                .collect(Collectors.joining(", "));

        return new BookCardDto(
                Math.toIntExact(book.getId()),
                book.getTitle(),
                authorNames,
                book.getDescription(),
                book.getAverageRating() == null ? 0 : Math.round(book.getAverageRating()),
                book.getPrice() == null ? 0 : book.getPrice().doubleValue(),
                book.getImageUrl(),
                book.getStockQuantity() == null ? 0 : book.getStockQuantity()
        );
    }
}
