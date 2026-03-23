package com.iti.jets.filter;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class UserRefreshFilter implements Filter {

    private UserService userService;

    @Override
    public void init(FilterConfig filterConfig) {
        userService = ServiceFactory.getInstance().getUserService();
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {

            UserDTO sessionUser = (UserDTO) session.getAttribute("user");

            // reload from DB
            UserDTO freshUser = userService.findById(sessionUser.getId());

            if (freshUser != null) {
                session.setAttribute("user", freshUser);
            }
        }

        chain.doFilter(req, res);
    }
}
