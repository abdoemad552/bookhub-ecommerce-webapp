package com.iti.jets.controller.admin;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Not logged in
        if (session == null || session.getAttribute("user") == null) {
            req.getSession().setAttribute("flash_message", "Please Login first");
            resp.sendRedirect(req.getContextPath() + "/" + PathStorage.LOGIN_SERVLET);
            return;
        }

        var user = (UserDTO) session.getAttribute("user");
        if (user.getRole() != UserRole.ADMIN) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        req.getRequestDispatcher(PathStorage.ADMIN_DASHBOARD_PAGE).forward(req, resp);
    }
}
