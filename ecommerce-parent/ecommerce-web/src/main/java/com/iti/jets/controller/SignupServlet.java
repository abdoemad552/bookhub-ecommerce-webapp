package com.iti.jets.controller;

import com.iti.jets.model.dto.request.RegisterRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.util.ParsingHelper;
import com.iti.jets.util.PathStorage;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

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

        boolean isSuccess = result.isSuccess();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject json = Json.createObjectBuilder()
                .add("success", isSuccess)
                .add("message", result.getMessage())
                .build();

        resp.getWriter().write(json.toString());

        if (isSuccess) {
            LOGGER.info("New user registered: {}", registerRequestDTO.getUsername());
        }
    }

    private RegisterRequestDTO buildRegisterRequest(HttpServletRequest req) {
        return RegisterRequestDTO.builder()
                .username(req.getParameter("username"))
                .email(req.getParameter("email"))
                .password(req.getParameter("password"))
                .confirmPassword(req.getParameter("confirmPassword"))
                .firstName(req.getParameter("firstName"))
                .lastName(req.getParameter("lastName"))
                .birthDate(ParsingHelper.parseDate(req.getParameter("birthDate")))
                .job(req.getParameter("job"))
                .creditLimit(ParsingHelper.parseBigDecimal(req.getParameter("creditCardLimit")))
                .categoryIds(null)
                .build();
    }
}