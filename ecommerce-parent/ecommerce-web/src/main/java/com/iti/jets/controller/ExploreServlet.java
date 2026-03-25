package com.iti.jets.controller;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.PageResponseDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.mock.dto.BookCardDto;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.util.PathStorage;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.json.bind.JsonbConfig;
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

    private static final int DEFAULT_MIN_PRICE = 0;
    private static final int DEFAULT_MAX_PRICE = 999999;
    private static final int DEFAULT_PAGE_SIZE = 12;

    private BookService bookService;
    private Jsonb jsonb;

    @Override
    public void init() {
        bookService = ServiceFactory.getInstance().getBookService();

        JsonbConfig config = new JsonbConfig();
        config.withFormatting(true);
        jsonb = JsonbBuilder.create(config);
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        int     page       = parsePositiveInteger(request.getParameter("page"), 1);
        int     size       = parsePositiveInteger(request.getParameter("size"), DEFAULT_PAGE_SIZE);
        String  query      = normalizeText(request.getParameter("query"));
        String  category   = normalizeCategory(request.getParameter("category"));
        int     maxPrice   = parsePositiveInteger(request.getParameter("maxPrice"), DEFAULT_MAX_PRICE);
        int     minPrice   = parsePositiveInteger(request.getParameter("minPrice"), DEFAULT_MIN_PRICE);
        String  sort       = normalizeSortCriteria(request.getParameter("sort"));

        System.out.println(request.getParameter("page"));
        System.out.println(request.getParameter("size"));
        System.out.println(request.getParameter("query"));
        System.out.println(request.getParameter("category"));
        System.out.println(request.getParameter("minPrice"));
        System.out.println(request.getParameter("maxPrice"));
        System.out.println(request.getParameter("sort"));

        BookFilterDTO filter = BookFilterDTO.builder()
            .searchQuery(query)
            .category(category)
            .minPrice(minPrice)
            .maxPrice(maxPrice)
            .sortCriteria(sort)
            .build();

        PageResponseDTO<BookCardDTO> booksPage = bookService.findAllBookCard(page, size, filter);

        request.setAttribute("pagination", booksPage);

        request.setAttribute("query", query);
        request.setAttribute("category", category);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher(PathStorage.EXPLORE_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        int     page       = parsePositiveInteger(request.getParameter("page"), 1);
        int     size       = parsePositiveInteger(request.getParameter("size"), DEFAULT_PAGE_SIZE);
        String  query      = normalizeText(request.getParameter("query"));
        String  category   = normalizeCategory(request.getParameter("category"));
        int     maxPrice   = parsePositiveInteger(request.getParameter("maxPrice"), DEFAULT_MAX_PRICE);
        int     minPrice   = parsePositiveInteger(request.getParameter("minPrice"), DEFAULT_MIN_PRICE);
        String  sort       = normalizeSortCriteria(request.getParameter("sort"));

        System.out.println(request.getParameter("page"));
        System.out.println(request.getParameter("size"));
        System.out.println(request.getParameter("query"));
        System.out.println(request.getParameter("category"));
        System.out.println(request.getParameter("minPrice"));
        System.out.println(request.getParameter("maxPrice"));
        System.out.println(request.getParameter("sort"));

        BookFilterDTO filter = BookFilterDTO.builder()
            .searchQuery(query)
            .category(category)
            .minPrice(minPrice)
            .maxPrice(maxPrice)
            .sortCriteria(sort)
            .build();

        PageResponseDTO<BookCardDTO> booksPage = bookService.findAllBookCard(page, size, filter);

        System.out.println(jsonb.toJson(booksPage));
        request.setAttribute("pagination", booksPage);

        request.getRequestDispatcher(PathStorage.EXPLORE_BOOKS_CONTAINER).forward(request, response);
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

        return "all".equalsIgnoreCase(normalizedCategory) ? null : normalizedCategory;
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
