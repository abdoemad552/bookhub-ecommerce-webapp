package com.iti.jets.controller.helpers;

import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CategoryService;
import jakarta.json.Json;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/addCategory")
public class AddCategoryServlet extends HttpServlet {

    private CategoryService categoryService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        categoryService = ServiceFactory.getInstance().getCategoryService();
    }

    @Override
    protected void doPost(
        HttpServletRequest req,
        HttpServletResponse resp
    ) throws ServletException, IOException {
        String name = req.getParameter("category");

        BaseResponse<Void> res = categoryService.addCategory(name);

        JsonObjectBuilder jsonObjectBuilder = Json.createObjectBuilder();
        if(res.isSuccess()){
            jsonObjectBuilder.add("success", "true");
            resp.getWriter().write(jsonObjectBuilder.build().toString());
        }else{
            resp.setStatus(HttpServletResponse.SC_CONFLICT);
            jsonObjectBuilder.add("error", res.getMessage());
            resp.getWriter().write(jsonObjectBuilder.build().toString());
        }
    }
}
