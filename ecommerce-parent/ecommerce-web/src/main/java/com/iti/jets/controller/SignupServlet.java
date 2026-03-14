package com.iti.jets.controller;

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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class SignupServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(SignupServlet.class);

    private AuthService authService;

    @Override
    public void init() {
        authService = ServiceFactory.getInstance().getAuthService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Redirect already-logged-in users to home page
        if (req.getSession(false) != null
                && req.getSession(false).getAttribute("user") != null) {

            resp.sendRedirect(PathStorage.HOME_SERVLET);
            return;
        }
        req.getRequestDispatcher(PathStorage.SING_UP_PAGE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RegisterRequestDTO registerRequestDTO = buildRegisterRequest(req);
        BaseResponse<UserDTO> result = authService.register(registerRequestDTO);

        if (result.isFailure()) {
            // Preserve what the user typed so they don't retype everything
            req.setAttribute("error", result.getMessage());
            req.setAttribute("formData", registerRequestDTO);
            req.getRequestDispatcher(PathStorage.SING_UP_PAGE).forward(req, resp);
            return;
        }

        // Flash success message consumed by login page
        req.getSession().setAttribute("successMessage", "Account created! Please sign in.");
        LOGGER.info("New user registered: {}", registerRequestDTO.getUsername());
        resp.sendRedirect(PathStorage.LOGIN_SERVLET);
    }

    private RegisterRequestDTO buildRegisterRequest(HttpServletRequest req) {
        return RegisterRequestDTO.builder()
                .username(req.getParameter("username"))
                .email(req.getParameter("email"))
                .password(req.getParameter("password"))
                .confirmPassword(req.getParameter("confirmPassword"))
                .firstName(req.getParameter("firstName"))
                .lastName(req.getParameter("lastName"))
                .birthDate(parseBirthDate(req.getParameter("birthDate")))
                .job(req.getParameter("job"))
                .creditLimit(parseCreditLimit(req.getParameter("creditCardLimit")))
                .categoryIds(null)
                .build();
    }

    private LocalDate parseBirthDate(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            LOGGER.warn("Invalid birth date format: {}", value);
            return null;
        }
    }

    private BigDecimal parseCreditLimit(String value) {
        if (value == null || value.isBlank()) return BigDecimal.ZERO;
        try {
            BigDecimal v = new BigDecimal(value);
            return v.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : v;
        } catch (NumberFormatException e) {
            LOGGER.warn("Invalid credit limit: {}", value);
            return BigDecimal.ZERO;
        }
    }
}