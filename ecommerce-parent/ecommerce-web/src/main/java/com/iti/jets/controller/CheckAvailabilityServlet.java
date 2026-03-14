package com.iti.jets.controller;

import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.UserService;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/checkAvailability")
public class CheckAvailabilityServlet extends HttpServlet {

    UserService userService;

    @Override
    public void init() {
        userService = ServiceFactory.getInstance().getUserService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");

        boolean available = true;
        if (username != null) {
            available = !userService.existsByUserName(username);
        } else if (email != null) {
            available = !userService.existsByEmail(email);
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject json = Json.createObjectBuilder()
                .add("available", available)
                .build();

        resp.getWriter().write(json.toString());
    }
}