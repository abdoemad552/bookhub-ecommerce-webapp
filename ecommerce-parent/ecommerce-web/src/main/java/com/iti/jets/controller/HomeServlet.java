package com.iti.jets.controller;

import com.iti.jets.mock.dto.UserDto;
import com.iti.jets.util.PathStorage;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        HttpSession session = req.getSession();
//        UserDto userDto = new UserDto();
//        userDto.setFirstName("Abdo");
//        userDto.setLastName("Emad");
//        userDto.setEmail("abdoemad552@gmail.com");
//        session.setAttribute("user", userDto);
        req.getRequestDispatcher(PathStorage.HOME_PAGE).forward(req, resp);
    }
}
