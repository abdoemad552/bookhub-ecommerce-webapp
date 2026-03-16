package com.iti.jets.controller.auth;

import com.iti.jets.util.CookieHandler;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session != null){
            session.invalidate();
        }

        CookieHandler.clearCookie(response, CookieHandler.COOKIE_NAME, request.getContextPath());

        response.sendRedirect(PathStorage.HOME_SERVLET);
    }
}