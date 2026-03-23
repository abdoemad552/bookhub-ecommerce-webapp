package com.iti.jets.controller;

import com.iti.jets.model.entity.Book;
import com.iti.jets.mock.dto.BookCardDto;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class FeaturedBooksServlet extends HttpServlet {

    private BookService bookService;

    @Override
    public void init() {
        bookService = ServiceFactory.getInstance().getBookService();
    }

    public void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        response.setContentType("text/html");

        List<BookCardDto> books = bookService.findAllFeatured()
                .stream()
                .map(this::toBookCardDto)
                .toList();

        request.setAttribute("books", books);
        request.setAttribute("bookCardVariant", "carousel");
        request.getRequestDispatcher(PathStorage.BOOK_CARD).forward(request, response);
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
