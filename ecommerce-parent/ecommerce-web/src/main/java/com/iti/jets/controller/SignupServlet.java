package com.iti.jets.controller;

import com.iti.jets.model.dto.request.RegisterRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletConfig;
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
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class SignupServlet extends HttpServlet {

//    private static final Logger LOGGER = LoggerFactory.getLogger(SignupServlet.class);
//
//    private AuthService authService;
//
//    @Override
//    public void init(ServletConfig config) throws ServletException {
//        authService = ServiceFactory.getInstance().getAuthService();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        req.getRequestDispatcher(PathStorage.SING_UP_PAGE).forward(req, resp);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//
//        BaseResponse<UserDTO> userDto = authService.register(buildRegisterRequest(req));
//
//        if(userDto.isSuccess()){
//
//            resp.sendRedirect(PathStorage.LOGIN_SERVLET);
//        }
//    }
//
//    private RegisterRequestDTO buildRegisterRequest(HttpServletRequest req) {
//        return RegisterRequestDTO.builder()
//                .username(req.getParameter("username"))
//                .email(req.getParameter("email"))
//                .password(req.getParameter("password"))
//                .confirmPassword(req.getParameter("confirmPassword"))
//                .firstName(req.getParameter("firstName"))
//                .lastName(req.getParameter("lastName"))
//                .birthDate(parseBirthDate(req.getParameter("birthDate")))
//                .job(null)
//                .creditLimit(parseCreditLimit(req.getParameter("creditCardLimit")))
//                .categoryIds(null)
//                .build();
//    }
//
//    private LocalDate parseBirthDate(String birthDateParam) {
//        if (birthDateParam == null || birthDateParam.trim().isEmpty()) {
//            return null;
//        }
//        try {
//            return LocalDate.parse(birthDateParam);
//        } catch (DateTimeParseException e) {
//            LOGGER.warn("Invalid birth date format: {}", birthDateParam);
//            return null;
//        }
//    }
//
//    private BigDecimal parseCreditLimit(String creditLimitParam) {
//        if (creditLimitParam == null || creditLimitParam.trim().isEmpty()) {
//            return BigDecimal.ZERO;
//        }
//        try {
//            BigDecimal value = new BigDecimal(creditLimitParam);
//            return value.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : value;
//        } catch (NumberFormatException e) {
//            LOGGER.warn("Invalid credit limit format: {}", creditLimitParam);
//            return BigDecimal.ZERO;
//        }
//    }

    private static final Logger LOGGER =
            LoggerFactory.getLogger(SignupServlet.class);
    private AuthService authService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        authService = ServiceFactory.getInstance().getAuthService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(PathStorage.SING_UP_PAGE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RegisterRequestDTO request = extractRequest(req);
        BaseResponse<UserDTO> result = authService.register(request);

        if (result.isFailure()) {
            // Re-display form with error + preserve fields
            req.setAttribute("error", result.getMessage());
            req.setAttribute("formData", request);
            req.getRequestDispatcher(PathStorage.SING_UP_PAGE)
                    .forward(req, resp);
            return;
        }

        // Flash success message to login page
        req.getSession().setAttribute(
                "successMessage",
                "Account created! Please log in."
        );
        LOGGER.info("New user registered: {}", request.getUsername());
        resp.sendRedirect(PathStorage.LOGIN_SERVLET);

    }

    private RegisterRequestDTO extractRequest(HttpServletRequest req) {
        String creditStr = req.getParameter("creditCardLimit");
        BigDecimal credit = BigDecimal.ZERO;
        try {
            if (creditStr != null && !creditStr.isBlank())
                credit = new BigDecimal(creditStr);
        } catch (NumberFormatException ignored) {}

        String birthStr = req.getParameter("birthDate");
        LocalDate birthDate = null;
        try {
            if (birthStr != null && !birthStr.isBlank())
                birthDate = LocalDate.parse(birthStr);
        } catch (DateTimeParseException ignored) {}

        String categoryIdsParam = req.getParameter("categoryIds");
        Set<Long> categoryIds = new HashSet<>();
        if (categoryIdsParam != null && !categoryIdsParam.isBlank()) {
            for (String id : categoryIdsParam.split(",")) {
                try { categoryIds.add(Long.parseLong(id.trim())); }
                catch (NumberFormatException ignored) {}
            }
        }

        return RegisterRequestDTO.builder()
                .username(req.getParameter("username"))
                .email(req.getParameter("email"))
                .password(req.getParameter("password"))
                .confirmPassword(req.getParameter("confirmPassword"))
                .firstName(req.getParameter("firstName"))
                .lastName(req.getParameter("lastName"))
                .birthDate(birthDate)
                .job(req.getParameter("job"))
                .creditLimit(credit)
                .categoryIds(categoryIds)
                .build();
    }

}
