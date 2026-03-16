package com.iti.jets.controller.auth;

import com.iti.jets.model.dto.request.LoginRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.util.CookieHandler;
import com.iti.jets.util.PathStorage;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(LoginServlet.class);

    private AuthService authService;

    @Override
    public void init() {
        authService = ServiceFactory.getInstance().getAuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        var session = request.getSession(false);
        if(session != null){
            // Already logged-in user
            if (session.getAttribute("user") != null) {
                response.sendRedirect(PathStorage.HOME_SERVLET);
                return;
            }

            // Flash success message form signup page
            String flash = (String) session.getAttribute("flash_success");
            String username = (String) session.getAttribute("flash_username");
            if (flash != null) {
                request.setAttribute("flash_success", flash);
                request.setAttribute("flash_username", username);

                session.removeAttribute("flash_success");
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

        if (isSuccess) {
            LOGGER.info("New user log in: {}", loginRequest.getUsernameOrEmail());

            UserDTO loggedInUser = result.getData();

            // Invalidate any old session first to prevent session fixation
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null){
                oldSession.invalidate();
            }
            // Create session for this user (valid 30 minutes)
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(60 * 30);
            session.setAttribute("user", loggedInUser);

            // Create cookie for this user (Valid 30 days)
            boolean rememberMe = request.getParameter("rememberMe") != null;
            if(rememberMe){
                Cookie cookie = new Cookie(CookieHandler.COOKIE_NAME, String.valueOf(loggedInUser.getId()));
                cookie.setPath(request.getContextPath());
                cookie.setMaxAge(60 * 60 * 24 * 30);
                cookie.setSecure(request.isSecure());
                response.addCookie(cookie);
                response.addCookie(cookie);

                LOGGER.info("Remember-me cookie set for user: {}", loggedInUser.getUsername());
            }else{
                // Clear any old remember-me cookie
                CookieHandler.clearCookie(response, CookieHandler.COOKIE_NAME, request.getContextPath());
            }
            // TODO:Send Email to the user
        }

        // Send AJAX response to JS
        JsonObject json = Json.createObjectBuilder()
                .add("success", isSuccess)
                .add("message", result.getMessage())
                .build();

        response.getWriter().write(json.toString());
    }

    private LoginRequestDTO buildLoginRequest(HttpServletRequest req) {
        return LoginRequestDTO.builder()
                .usernameOrEmail(req.getParameter("usernameOrEmail"))
                .password(req.getParameter("password"))
                .build();
    }
}