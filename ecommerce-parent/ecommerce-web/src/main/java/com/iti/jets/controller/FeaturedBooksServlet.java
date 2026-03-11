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
            new BookCardDto("Book1", "Author1", "about two or three lines and then the text should ots.", 4, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book2", "Author2", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 3, 1500, "https://blog-cdn.reedsy.com/directories/gallery/281/large_840e5e5eba909420719c977e31888e1a.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/311/large_96abdb14e9e413f1f2ac2a8bd734c0c1.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book3", "Author3", "Under the stars I want a description part. This part should be about two or three lines and then the text should be clipped with dots.", 5, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg"),
            new BookCardDto("Book4", "Author4", "Under the stars the text should be clipped with dots.", 1, 1000, "https://blog-cdn.reedsy.com/directories/gallery/248/large_65b0ae90317f7596d6f95bfdd6131398.jpg")
        );
        
        request.setAttribute("books", books);
        request.getRequestDispatcher(PathStorage.BOOK_CARD).forward(request, response);
    }
}
