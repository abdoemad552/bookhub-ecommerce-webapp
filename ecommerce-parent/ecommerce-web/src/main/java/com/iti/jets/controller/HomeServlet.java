package com.iti.jets.controller;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var session = request.getSession(false);

        if(session != null && session.getAttribute("user") != null){
            UserDTO user = (UserDTO) session.getAttribute("user");
            if(user.getRole() == UserRole.ADMIN){
                response.sendRedirect(PathStorage.ADMIN_DASHBOARD_SERVLET);
                return;
            }
        }

        request.getRequestDispatcher(PathStorage.HOME_PAGE).forward(request, response);
    }
}
