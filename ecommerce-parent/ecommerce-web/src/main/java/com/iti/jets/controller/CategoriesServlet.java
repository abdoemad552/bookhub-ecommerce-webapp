package com.iti.jets.controller;

import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CategoryService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/categories")
public class CategoriesServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(CategoriesServlet.class);

    private CategoryService categoryService;

    @Override
    public void init() {
        categoryService = ServiceFactory.getInstance().getCategoryService();
    }

    /**
     * GET /categories
     * Returns all categories as a JSON array: [{id, name}, ...]
     * Used by the signup step-3 category picker.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "public, max-age=3600"); // categories rarely change

        List<CategoryDTO> categories = categoryService.findAll();

        PrintWriter out = resp.getWriter();
        out.print('[');
        for (int i = 0; i < categories.size(); i++) {
            CategoryDTO c = categories.get(i);
            out.print("{\"id\":");
            out.print(c.getId());
            out.print(",\"name\":\"");
            out.print(escapeJson(c.getName()));
            out.print("\"}");
            if (i < categories.size() - 1) out.print(',');
        }
        out.print(']');
    }

    // Minimal JSON string escaper — avoids pulling in a library
    private String escapeJson(String s) {
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}