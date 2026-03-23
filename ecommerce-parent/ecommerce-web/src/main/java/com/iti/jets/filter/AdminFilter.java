package com.iti.jets.filter;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            req.getSession().setAttribute("flash_message", "Please Login first");
            resp.sendRedirect(req.getContextPath() + "/" + PathStorage.LOGIN_SERVLET);
            return;
        }

        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user.getRole() != UserRole.ADMIN) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.getRequestDispatcher(PathStorage.FORBIDDEN_PAGE).forward(req, resp);
            return;
        }
        chain.doFilter(request, response);
    }
}
