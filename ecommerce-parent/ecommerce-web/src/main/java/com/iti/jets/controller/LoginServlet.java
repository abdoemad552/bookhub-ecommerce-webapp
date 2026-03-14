package com.iti.jets.controller;

import com.iti.jets.model.dto.request.LoginRequestDTO;
import com.iti.jets.model.dto.request.RegisterRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        if (request.getSession(false) != null
                && request.getSession(false).getAttribute("user") != null) {
            response.sendRedirect(PathStorage.HOME_SERVLET);
        }

        request.getRequestDispatcher(PathStorage.LOGIN_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        LoginRequestDTO loginRequest = buildLoginRequest(request);

        BaseResponse<UserDTO> userDTOResponse = authService.login(loginRequest);

        if (userDTOResponse.isFailure()) {
            request.setAttribute("error", userDTOResponse.getMessage());
            request.getRequestDispatcher(PathStorage.LOGIN_PAGE).forward(request, response);
        }

        // TODO: How to handle remember me?
        String rememberMe = request.getParameter("rememberMe");

        UserDTO user = userDTOResponse.getData();
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        response.sendRedirect(PathStorage.HOME_SERVLET);
    }

    private LoginRequestDTO buildLoginRequest(HttpServletRequest req) {
        return LoginRequestDTO.builder()
            .usernameOrEmail(req.getParameter("usernameOrEmail"))
            .password(req.getParameter("password"))
            .emailNotifications(req.getParameter("emailNotifications") != null)
            .build();
    }
}
