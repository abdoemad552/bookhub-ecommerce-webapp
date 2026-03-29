package com.iti.jets.controller;

import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/authors/*")
public class AuthorInfoServlet extends HttpServlet {

    private ServiceFactory serviceFactory;

    @Override
    public void init() throws ServletException {
        serviceFactory = ServiceFactory.getInstance();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        String strAuthorId = pathInfo.split("/")[1];

        Long authorId;
        try {
            authorId = Long.parseLong(strAuthorId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                pathInfo + " doesn't map to actual author");
            return;
        }

        System.out.println(authorId);
        request.setAttribute("authorId", authorId);

        request.getRequestDispatcher(PathStorage.AUTHOR_INFO_PAGE).forward(request, response);
    }
}
