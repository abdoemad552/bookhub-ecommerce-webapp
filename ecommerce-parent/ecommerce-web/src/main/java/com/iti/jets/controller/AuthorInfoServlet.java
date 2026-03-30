package com.iti.jets.controller;

import com.iti.jets.model.dto.response.AuthorDTO;
import com.iti.jets.model.dto.response.AuthorStatsDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthorService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/authors/*")
public class AuthorInfoServlet extends HttpServlet {

    private AuthorService authorService;

    @Override
    public void init() throws ServletException {
        authorService = ServiceFactory.getInstance().getAuthorService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        String strAuthorId = pathInfo.split("/")[1];

        long authorId;
        try {
            authorId = Long.parseLong(strAuthorId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                pathInfo + " is malformed path");
            return;
        }

        AuthorDTO author = authorService.findById(authorId);

        if (author == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                pathInfo + " does not map to a actual author");
            return;
        }

        AuthorStatsDTO authorStats = authorService.getAuthorStats(authorId);

        System.out.println(author);
        request.setAttribute("author", author);
        request.setAttribute("authorStats", authorStats);

        request.getRequestDispatcher(PathStorage.AUTHOR_INFO_PAGE).forward(request, response);
    }
}
