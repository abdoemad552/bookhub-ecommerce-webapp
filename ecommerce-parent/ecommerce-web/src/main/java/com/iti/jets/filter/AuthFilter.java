package com.iti.jets.filter;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.util.CookieHandler;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AuthFilter implements Filter {

    private UserService userService;

    @Override
    public void init(FilterConfig filterConfig) {
        userService = ServiceFactory.getInstance().getUserService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);

        // If no logged-in user in session -> check on the cookie
        if (session == null || session.getAttribute("user") == null) {
            String savedUserId = CookieHandler.getCookieValue(req, CookieHandler.COOKIE_NAME);

            if (savedUserId != null && !savedUserId.isBlank()) {
                UserDTO user = userService.findById(Long.parseLong(savedUserId));

                if (user != null) {
                    HttpSession newSession = req.getSession(true);
                    newSession.setMaxInactiveInterval(60 * 30);
                    newSession.setAttribute("user", user);
                }
            }
        }
        chain.doFilter(request, response);
    }
}