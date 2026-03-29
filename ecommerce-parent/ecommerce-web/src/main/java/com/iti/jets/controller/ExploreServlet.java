package com.iti.jets.controller;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.PageResponseDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserInterestsDTO;
import com.iti.jets.model.entity.Book;
import com.iti.jets.mock.dto.BookCardDto;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.service.interfaces.CategoryService;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.util.PathStorage;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.json.bind.JsonbConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {

    private static final int DEFAULT_MIN_PRICE = 0;
    private static final int DEFAULT_MAX_PRICE = 999999;
    private static final int DEFAULT_PAGE_SIZE = 12;

    private BookService bookService;
    private CategoryService categoryService;
    private UserService userService;
    private Jsonb jsonb;

    @Override
    public void init() {
        bookService = ServiceFactory.getInstance().getBookService();
        categoryService = ServiceFactory.getInstance().getCategoryService();
        userService = ServiceFactory.getInstance().getUserService();

        JsonbConfig config = new JsonbConfig();
        config.withFormatting(true);
        jsonb = JsonbBuilder.create(config);
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        int       page        = parsePositiveInteger(request.getParameter("page"), 1);
        int       size        = parsePositiveInteger(request.getParameter("size"), DEFAULT_PAGE_SIZE);
        String    query       = normalizeText(request.getParameter("query"));
        Set<Long> categoryIds = parseCategoryIds(request.getParameterValues("category"));
        int       maxPrice    = parsePositiveInteger(request.getParameter("maxPrice"), DEFAULT_MAX_PRICE);
        int       minPrice    = parsePositiveInteger(request.getParameter("minPrice"), DEFAULT_MIN_PRICE);
        String    sort        = normalizeSortCriteria(request.getParameter("sort"));
        boolean   includeInterests = Boolean.parseBoolean(request.getParameter("includeInterests"));

        mergeUserInterests(request, includeInterests, categoryIds);

        System.out.println(request.getParameter("page"));
        System.out.println(request.getParameter("size"));
        System.out.println(request.getParameter("query"));
        System.out.println(Arrays.toString(request.getParameterValues("category")));
        System.out.println(request.getParameter("minPrice"));
        System.out.println(request.getParameter("maxPrice"));
        System.out.println(request.getParameter("sort"));
        System.out.println(request.getParameter("includeInterests"));

        BookFilterDTO filter = BookFilterDTO.builder()
            .searchQuery(query)
            .categoryIds(categoryIds)
            .minPrice(minPrice)
            .maxPrice(maxPrice)
            .sortCriteria(sort)
            .includeInterests(includeInterests)
            .build();

        PageResponseDTO<BookCardDTO> booksPage = bookService.findAllBookCard(page, size, filter);

        request.setAttribute("pagination", booksPage);

        request.setAttribute("query", query);
        request.setAttribute("categoryIds", categoryIds);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("sort", sort);
        request.setAttribute("includeInterests", includeInterests);

        request.getRequestDispatcher(PathStorage.EXPLORE_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        int       page        = parsePositiveInteger(request.getParameter("page"), 1);
        int       size        = parsePositiveInteger(request.getParameter("size"), DEFAULT_PAGE_SIZE);
        String    query       = normalizeText(request.getParameter("query"));
        Set<Long> categoryIds = parseCategoryIds(request.getParameterValues("category"));
        int       maxPrice    = parsePositiveInteger(request.getParameter("maxPrice"), DEFAULT_MAX_PRICE);
        int       minPrice    = parsePositiveInteger(request.getParameter("minPrice"), DEFAULT_MIN_PRICE);
        String    sort        = normalizeSortCriteria(request.getParameter("sort"));
        boolean   includeInterests = Boolean.parseBoolean(request.getParameter("includeInterests"));

        mergeUserInterests(request, includeInterests, categoryIds);

        System.out.println(request.getParameter("page"));
        System.out.println(request.getParameter("size"));
        System.out.println(request.getParameter("query"));
        System.out.println(Arrays.toString(request.getParameterValues("category")));
        System.out.println(request.getParameter("minPrice"));
        System.out.println(request.getParameter("maxPrice"));
        System.out.println(request.getParameter("sort"));
        System.out.println(request.getParameter("includeInterests"));

        BookFilterDTO filter = BookFilterDTO.builder()
            .searchQuery(query)
            .categoryIds(categoryIds)
            .minPrice(minPrice)
            .maxPrice(maxPrice)
            .sortCriteria(sort)
            .includeInterests(includeInterests)
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

    private Set<Long> parseCategoryIds(String[] strCategoryIds) {
        Set<Long> categoryIds = new HashSet<>();
        if (strCategoryIds != null) {
            for (String strCategoryId : strCategoryIds) {
                try {
                    categoryIds.add(Long.parseLong(strCategoryId));
                } catch (NumberFormatException ignored) {
                }
            }
        }
        return categoryIds;
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

    public void mergeUserInterests(
        HttpServletRequest request,
        boolean includeInterests,
        Set<Long> categoryIds
    ) {
        HttpSession session = request.getSession(false);
        if (
            session != null &&
            session.getAttribute("user") != null &&
            includeInterests
        ) {
            UserDTO user = (UserDTO) session.getAttribute("user");
            UserInterestsDTO userInterests
                = userService.loadUserInterests(user.getId());

            System.out.println(userInterests);
            if (userInterests != null) {
                categoryIds.addAll(userInterests.getInterests()
                    .stream()
                    .map(interest -> interest.getId())
                    .collect(Collectors.toSet())
                );
            }
        }
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
