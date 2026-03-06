package com.iti.jets.controller;

import com.iti.jets.mock.dto.BookCardDto;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class FeaturedBooksServlet extends HttpServlet {

    public void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        response.setContentType("text/html");
        
        List<BookCardDto> books = List.of(
            new BookCardDto("Book1", "Author1", 4, 1000, ""),
            new BookCardDto("Book2", "Author2", 3, 1500, ""),
            new BookCardDto("Book3", "Author3", 5, 1000, ""),
            new BookCardDto("Book4", "Author4", 1, 1000, "")
        );
        
        request.setAttribute("books", books);
        request.getRequestDispatcher(PathStorage.BOOK_CARD).forward(request, response);
    }
}
