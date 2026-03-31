package com.iti.jets.controller.helpers;

import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

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

        List<BookCardDTO> books = bookService.findAllFeatured()
                .stream()
                .map(BookCardDTO::from)
                .toList();

        request.setAttribute("books", books);
        request.setAttribute("bookCardVariant", "carousel");
        request.getRequestDispatcher(PathStorage.BOOK_CARD).forward(request, response);
    }
}
