package com.iti.jets.controller;

import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() {
        authService = ServiceFactory.getInstance().getAuthService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        request.getRequestDispatcher(PathStorage.LOGIN_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
    }
}
