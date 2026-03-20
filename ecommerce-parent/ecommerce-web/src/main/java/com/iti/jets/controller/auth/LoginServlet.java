package com.iti.jets.controller.auth;

import com.iti.jets.model.dto.request.LoginRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.extra.EmailService;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.service.interfaces.CartService;
import com.iti.jets.util.CookieHandler;
import com.iti.jets.util.PathStorage;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(LoginServlet.class);

    private AuthService authService;
    private EmailService emailService;
    private CartService cartService;

    @Override
    public void init() {
        authService = ServiceFactory.getInstance().getAuthService();
        emailService = ServiceFactory.getInstance().getEmailService();
        cartService = ServiceFactory.getInstance().getCartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var session = request.getSession(false);
        if (session != null) {
            // Already logged-in user
            if (session.getAttribute("user") != null) {
                response.sendRedirect(PathStorage.HOME_SERVLET);
                return;
            }

            // Flash message from signup, admin and checkout page
            String flash = (String) session.getAttribute("flash_message");
            if (flash != null) {
                request.setAttribute("flash_message", flash);
                session.removeAttribute("flash_message");
            }
            // Flash username from signup page
            String username = (String) session.getAttribute("flash_username");
            if (username != null) {
                request.setAttribute("flash_username", username);
                session.removeAttribute("flash_username");
            }
        }
        request.getRequestDispatcher(PathStorage.LOGIN_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LoginRequestDTO loginRequest = buildLoginRequest(request);
        BaseResponse<UserDTO> result = authService.login(loginRequest);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        boolean isSuccess = result.isSuccess();
        boolean redirectToHome = true;

        if (isSuccess) {
            LOGGER.info("New user log in: {}", loginRequest.getUsernameOrEmail());

            UserDTO loggedInUser = result.getData();

            Object sessionCartObj = null;
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                sessionCartObj = oldSession.getAttribute("sessionCart");

                // Check if this user login normally or comes form checkout page
                redirectToHome = oldSession.getAttribute("comes_from_checkout") == null;

                // Invalidate any old session first to prevent session fixation
                oldSession.invalidate();
            }

            if (sessionCartObj != null) {
                @SuppressWarnings("unchecked")
                Map<Integer, Integer> sessionCart = (Map<Integer, Integer>) sessionCartObj;

                System.out.println("Merging session cart: " + sessionCart);

                for (Map.Entry<Integer, Integer> entry : sessionCart.entrySet()) {
                    Integer bookId = entry.getKey();
                    Integer quantity = entry.getValue();

                    cartService.addToCart(Math.toIntExact(loggedInUser.getId()), bookId, quantity);
                }
            }

            // Create session for this user (valid 30 minutes)
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(60 * 30);
            session.setAttribute("user", loggedInUser);

            // Create cookie for this user (Valid 30 days)
            boolean rememberMe = request.getParameter("rememberMe") != null;
            if (rememberMe) {
                Cookie cookie = new Cookie(CookieHandler.COOKIE_NAME, String.valueOf(loggedInUser.getId()));
                cookie.setPath(request.getContextPath());
                cookie.setMaxAge(60 * 60 * 24 * 30);
                cookie.setSecure(request.isSecure());
                response.addCookie(cookie);

                LOGGER.info("Remember-me cookie set for user: {}", loggedInUser.getUsername());
            } else {
                // Clear any old remember-me cookie
                CookieHandler.clearCookie(response, CookieHandler.COOKIE_NAME, request.getContextPath());
            }

            // Send Confirmation Email to the user in a background thread
            if (loggedInUser.getEmailNotifications()) {
                CompletableFuture.runAsync(() ->
                    emailService.sendLoginNotification(loggedInUser)
                );
            }

            mergeSessionCart(request, Math.toIntExact(loggedInUser.getId()));
        }

        // Send AJAX response to JS
        JsonObject json = Json.createObjectBuilder()
                .add("success", isSuccess)
                .add("message", result.getMessage())
                .add("redirectToHome", redirectToHome)
                .build();

        response.getWriter().write(json.toString());
    }

    private void mergeSessionCart(HttpServletRequest request, int userId) {
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> sessionCart = (Map<Integer, Integer>)
            request.getSession().getAttribute("sessionCart");

        System.out.println("Merging session cart: " + sessionCart);
        if (sessionCart == null || sessionCart.isEmpty()) {
            return;
        }

        for (Map.Entry<Integer, Integer> entry : sessionCart.entrySet()) {
            Integer bookId = entry.getKey();
            Integer quantity = entry.getValue();

            cartService.addToCart(userId, bookId, quantity);
        }

        // Clear session cart after merge
        request.getSession().removeAttribute("sessionCart");
    }

    private LoginRequestDTO buildLoginRequest(HttpServletRequest req) {
        return LoginRequestDTO.builder()
                .usernameOrEmail(req.getParameter("usernameOrEmail"))
                .password(req.getParameter("password"))
                .build();
    }
}