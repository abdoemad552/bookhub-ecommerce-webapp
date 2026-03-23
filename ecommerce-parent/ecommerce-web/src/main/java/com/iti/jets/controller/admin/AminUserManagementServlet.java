package com.iti.jets.controller.admin;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.UserService;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard/userManagement")
public class AminUserManagementServlet extends HttpServlet {

    UserService userService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        userService = ServiceFactory.getInstance().getUserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if(req.getParameter("getUsers").equalsIgnoreCase("true")){
            resp.setContentType("application/json");
            resp.getWriter().write(loadAllUsers().build().toString());
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }

    // Helpers
    private JsonObjectBuilder loadAllUsers(){
        List<UserDTO> users = userService.findAll(1, 10);

        JsonArrayBuilder jsonArray = Json.createArrayBuilder();

        for(UserDTO user : users){
            jsonArray.add(
              Json.createObjectBuilder()
                      .add("id", user.getId())
                      .add("username", user.getUsername())
                      .add("email", user.getEmail())
                      .add("role", user.getRole().toString())
                      .add("avatarUrl", (user.getProfilePicUrl() == null) ? "null"  : user.getProfilePicUrl())

            );
        }

        return Json.createObjectBuilder()
                .add("users", jsonArray);
    }
}
