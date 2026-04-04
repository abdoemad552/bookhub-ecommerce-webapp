package com.iti.jets.controller.admin;

import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/updateBookData")
public class UpdateBookData extends HttpServlet {

    BookService bookService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        bookService = ServiceFactory.getInstance().getBookService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String newPrice = req.getParameter("newPrice");
        String newStock = req.getParameter("newStock");
        String bookIdStr = req.getParameter("bookId");

        if (newPrice != null && newStock != null && bookIdStr != null){
            Long bookId = Long.parseLong(bookIdStr);
            bookService.updateBookData(bookId, newPrice, newStock);
        }
    }
}
