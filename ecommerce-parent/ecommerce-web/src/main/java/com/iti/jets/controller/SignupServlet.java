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
import jakarta.servlet.http.HttpSession;
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(PathStorage.SING_UP_PAGE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RegisterRequestDTO registerRequestDTO = buildRegisterRequest(req);
        System.out.println(registerRequestDTO);
        BaseResponse<UserDTO> userDTOResponse = authService.register(registerRequestDTO);

        System.out.println(userDTOResponse);
        if (userDTOResponse.isFailure()) {
            req.setAttribute("error", userDTOResponse.getMessage());
            req.getRequestDispatcher(PathStorage.SING_UP_PAGE).forward(req, resp);
            return;
        }

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
                .job(null)
                .creditLimit(parseCreditLimit(req.getParameter("creditCardLimit")))
                .categoryIds(null)
                .build();
    }

    private LocalDate parseBirthDate(String birthDateParam) {
        if (birthDateParam == null || birthDateParam.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(birthDateParam);
        } catch (DateTimeParseException e) {
            LOGGER.warn("Invalid birth date format: {}", birthDateParam);
            return null;
        }
    }

    private BigDecimal parseCreditLimit(String creditLimitParam) {
        if (creditLimitParam == null || creditLimitParam.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            BigDecimal value = new BigDecimal(creditLimitParam);
            return value.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : value;
        } catch (NumberFormatException e) {
            LOGGER.warn("Invalid credit limit format: {}", creditLimitParam);
            return BigDecimal.ZERO;
        }
    }
}
