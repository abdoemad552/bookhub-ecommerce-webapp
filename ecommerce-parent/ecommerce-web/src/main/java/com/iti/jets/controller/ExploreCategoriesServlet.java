package com.iti.jets.controller;

import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CategoryService;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/explore/categories")
public class ExploreCategoriesServlet extends HttpServlet {

    private CategoryService categoryService;
    private Jsonb jsonb;

    @Override
    public void init() {
        this.categoryService = ServiceFactory.getInstance().getCategoryService();
        this.jsonb = JsonbBuilder.create();
    }

    @Override
    public void destroy() {
        try { if (jsonb != null) jsonb.close(); }
        catch (Exception ignored) {}
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        if (request.getParameter("json") != null) {
            response.setContentType("application/json");
            List<CategoryDTO> categories = categoryService.findAll();
            System.out.println(categories);
            writeJson(response, HttpServletResponse.SC_OK, categories);
        }
    }

    private void writeJson(HttpServletResponse response, int status, Object body)
        throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        jsonb.toJson(body, response.getWriter());
    }

    private void writeError(HttpServletResponse resp, int status, String message)
        throws IOException {
        writeJson(resp, status, new ErrorResponse(message));
    }

    public static class ErrorResponse {
        public final String error;
        public ErrorResponse(String error) { this.error = error; }
    }
}
