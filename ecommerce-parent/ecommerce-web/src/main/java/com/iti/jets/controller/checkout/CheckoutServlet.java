package com.iti.jets.controller.checkout;

import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if the user does not log in
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            HttpSession flashSession = req.getSession(true);
            flashSession.setAttribute("flash_message", "Please login first, before proceed to checkout!");
            flashSession.setAttribute("comes_from_checkout", "true");

            resp.sendRedirect(PathStorage.LOGIN_SERVLET);
            return;
        }

        req.getRequestDispatcher(PathStorage.CHECKOUT_PAGE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
