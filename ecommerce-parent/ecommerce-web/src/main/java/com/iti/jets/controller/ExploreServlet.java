package com.iti.jets.controller;

import com.iti.jets.model.dto.request.BookFilterDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserInterestsDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.service.interfaces.CategoryService;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.Comparator;
import java.util.stream.Collectors;

@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {

    private static final int BOOKS_PAGE_SIZE = 9;
    private static final int DEFAULT_MAX_PRICE = 1000;
    private static final String MY_INTERESTS_FILTER = "my-interests";

    private BookService bookService;
    private CategoryService categoryService;
    private UserService userService;

    @Override
    public void init() {
        bookService = ServiceFactory.getInstance().getBookService();
        categoryService = ServiceFactory.getInstance().getCategoryService();
        userService = ServiceFactory.getInstance().getUserService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        int pageNumber = parsePositiveInteger(request.getParameter("page"), 1);
        List<CategoryDTO> availableCategories = categoryService.findAll()
                .stream()
                .sorted(Comparator.comparing(
                        category -> category.getName() == null ? "" : category.getName(),
                        String.CASE_INSENSITIVE_ORDER
                ))
                .toList();
        UserInterestsDTO userInterests = loadCurrentUserInterests(request.getSession(false));
        List<CategoryDTO> interestCategories = extractSortedInterestCategories(userInterests);

        String requestedCategory = normalizeCategory(request.getParameter("category"));
        boolean myInterestsSelected = MY_INTERESTS_FILTER.equalsIgnoreCase(requestedCategory);
        String selectedCategory = myInterestsSelected
                ? MY_INTERESTS_FILTER
                : canonicalizeCategoryName(requestedCategory, availableCategories);
        String searchQuery = normalizeText(request.getParameter("query"));
        int maxPrice = parsePositiveInteger(request.getParameter("maxPrice"), DEFAULT_MAX_PRICE);
        String sortCriteria = normalizeSortCriteria(request.getParameter("sort"));
        Set<String> interestCategoryNames = interestCategories.stream()
                .map(CategoryDTO::getName)
                .filter(categoryName -> categoryName != null && !categoryName.isBlank())
                .collect(Collectors.toCollection(java.util.LinkedHashSet::new));

        BookFilterDTO filter = BookFilterDTO.builder()
                .category(selectedCategory)
                .categories(myInterestsSelected ? interestCategoryNames : Set.of())
                .maxPrice(maxPrice)
                .searchQuery(searchQuery)
                .sortCriteria(sortCriteria)
                .build();

        boolean canFilterByInterests = !interestCategoryNames.isEmpty();
        boolean emptyInterestSelection = myInterestsSelected && !canFilterByInterests;

        List<BookCardDTO> books = emptyInterestSelection
                ? List.of()
                : bookService.findAllCards(pageNumber, BOOKS_PAGE_SIZE, filter);

        boolean hasNextPage = !emptyInterestSelection
                && !bookService.findAllCards(pageNumber + 1, BOOKS_PAGE_SIZE, filter).isEmpty();

        request.setAttribute("books", books);
        request.setAttribute("bookCardVariant", "grid");
        request.setAttribute("booksResultCount", books.size());
        request.setAttribute("currentPageNumber", pageNumber);
        request.setAttribute("hasPreviousPage", pageNumber > 1);
        request.setAttribute("hasNextPage", hasNextPage);
        request.setAttribute("selectedCategory", resolveSelectedCategoryLabel(selectedCategory));
        request.setAttribute("selectedCategoryParam", selectedCategory == null ? "" : selectedCategory);
        request.setAttribute("selectedCategoryValue", selectedCategory == null ? "all" : selectedCategory);
        request.setAttribute("selectedSearchQuery", searchQuery == null ? "" : searchQuery);
        request.setAttribute("selectedMaxPrice", maxPrice);
        request.setAttribute("selectedSortCriteria", sortCriteria);
        request.setAttribute("exploreCategories", availableCategories);
        request.setAttribute("exploreHasInterestFilter", canFilterByInterests);

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

    private UserInterestsDTO loadCurrentUserInterests(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object currentUserObject = session.getAttribute("user");
        if (!(currentUserObject instanceof UserDTO currentUser) || currentUser.getId() == null) {
            return null;
        }

        return userService.loadUserInterests(currentUser.getId());
    }

    private List<CategoryDTO> extractSortedInterestCategories(UserInterestsDTO userInterests) {
        if (userInterests == null || userInterests.getInterests() == null || userInterests.getInterests().isEmpty()) {
            return List.of();
        }

        return userInterests.getInterests().stream()
                .sorted(Comparator.comparing(
                        category -> category.getName() == null ? "" : category.getName(),
                        String.CASE_INSENSITIVE_ORDER
                ))
                .toList();
    }

    private String canonicalizeCategoryName(String requestedCategory, List<CategoryDTO> availableCategories) {
        if (requestedCategory == null || requestedCategory.isBlank()) {
            return null;
        }

        return availableCategories.stream()
                .map(CategoryDTO::getName)
                .filter(categoryName -> categoryName != null && categoryName.equalsIgnoreCase(requestedCategory))
                .findFirst()
                .orElse(requestedCategory);
    }

    private String resolveSelectedCategoryLabel(String selectedCategory) {
        if (selectedCategory == null) {
            return "All Books";
        }
        if (MY_INTERESTS_FILTER.equalsIgnoreCase(selectedCategory)) {
            return "My Interests";
        }
        return selectedCategory;
    }
}
