package com.iti.jets.controller;

import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CategoryService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/categories/all")
public class AllCategoriesServlet extends HttpServlet {

    private CategoryService categoryService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        categoryService = ServiceFactory.getInstance().getCategoryService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        List<CategoryDTO> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
    }
}
