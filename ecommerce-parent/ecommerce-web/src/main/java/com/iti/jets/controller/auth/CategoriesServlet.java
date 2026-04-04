package com.iti.jets.controller.auth;

import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CategoryService;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
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

        // Render only 8 categories in user interests UI
        List<CategoryDTO> categories = categoryService.findAll(1, 8);

        JsonArrayBuilder jsonArray = Json.createArrayBuilder();
        for (CategoryDTO c : categories) {
            jsonArray.add(Json.createObjectBuilder()
                    .add("id", c.getId())
                    .add("name", c.getName())
            );
        }

        PrintWriter out = resp.getWriter();
        out.write(jsonArray.build().toString());
    }
}