package com.iti.jets.controller.admin;

import com.iti.jets.model.dto.response.OrderDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserOrderHistoryDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.extra.EmailService;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.OrderService;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.util.PathStorage;
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
    OrderService orderService;
    EmailService emailService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        userService = ServiceFactory.getInstance().getUserService();
        orderService = ServiceFactory.getInstance().getOrderService();
        emailService = ServiceFactory.getInstance().getEmailService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getParameter("getUsers") != null && req.getParameter("getUsers").equalsIgnoreCase("true")) {
            int pageNumber = (req.getParameter("page") != null)
                    ? Integer.parseInt(req.getParameter("page"))
                    : 1;

            int pageSize = (req.getParameter("size") != null)
                    ? Integer.parseInt(req.getParameter("size"))
                    : 10;

            resp.setContentType("application/json");
            resp.getWriter().write(loadAllUsers(pageNumber, pageSize).build().toString());
        } else if (req.getParameter("fetchUser") != null && req.getParameter("fetchUser").equalsIgnoreCase("true")) {

            String userIdParam = req.getParameter("userId");
            if (userIdParam == null || userIdParam.isBlank()) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
                return;
            }

            try {
                Long userId = Long.parseLong(userIdParam);
                resp.setContentType("application/json");
                resp.getWriter().write(fetchUser(userId).build().toString());
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
            }
        } else if (req.getParameter("toggleRole") != null && req.getParameter("toggleRole").equalsIgnoreCase("true")) {
            String userIdParam = req.getParameter("userId");
            if (userIdParam == null || userIdParam.isBlank()) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
                return;
            }

            try {
                Long userId = Long.parseLong(userIdParam);
                resp.setContentType("application/json");
                resp.getWriter().write(toggleUserRole(userId).build().toString());
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
            }
        } else if (req.getParameter("cancelOrder") != null && req.getParameter("cancelOrder").equalsIgnoreCase("true")) {
            String orderIdParam = req.getParameter("orderId");
            if (orderIdParam == null || orderIdParam.isBlank()) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
                return;
            }

            try {
                Long orderId = Long.parseLong(orderIdParam);
                resp.setContentType("application/json");
                resp.getWriter().write(cancelOrder(orderId).build().toString());
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }

    // Helpers
    private JsonObjectBuilder loadAllUsers(int pageNumber, int pageSize) {
        List<UserDTO> users = userService.findAll(pageNumber, pageSize);

        JsonArrayBuilder jsonArray = Json.createArrayBuilder();

        for (UserDTO user : users) {
            jsonArray.add(
                    Json.createObjectBuilder()
                            .add("id", user.getId())
                            .add("username", user.getUsername())
                            .add("email", user.getEmail())
                            .add("role", user.getRole().toString())
                            .add("avatarUrl", (user.getProfilePicUrl() == null) ? "null" : user.getProfilePicUrl())

            );
        }

        long totalUsers = userService.count();

        return Json.createObjectBuilder()
                .add("users", jsonArray)
                .add("totalCount", totalUsers);
    }

    private JsonObjectBuilder fetchUser(Long userId) {
        BaseResponse<UserOrderHistoryDTO> res = orderService.loadOrderHistory(userId);

        if (res.isFailure()) {
            return Json.createObjectBuilder()
                    .add("success", false)
                    .add("error", res.getMessage());
        }

        UserOrderHistoryDTO orders = res.getData();
        JsonArrayBuilder jsonArray = Json.createArrayBuilder();

        for (OrderDTO order : orders.getRecentOrders()) {
            jsonArray.add(
                    Json.createObjectBuilder()
                            .add("id", order.getOrderId())
                            .add("orderCode", order.getOrderCode())
                            .add("status", order.getOrderStatus().toString())
                            .add("createdAt", order.getCreatedAt().toString())
                            .add("total", order.getTotalPrice())
            );
        }

        return Json.createObjectBuilder()
                .add("success", true)
                .add("totalOrders", orders.getTotalOrders())
                .add("totalSpent", orders.getTotalSpent())
                .add("recentOrders", jsonArray);
    }

    private JsonObjectBuilder toggleUserRole(Long userId) {
        boolean res = userService.toggleRole(userId);

        // Send Email
        UserDTO user = userService.findById(userId);
        if(res && user.getEmailNotifications()){
            emailService.sendToggleRoleMail(user);
        }
        return Json.createObjectBuilder()
                .add("success", res);
    }

    private JsonObjectBuilder cancelOrder(Long orderId) {
        BaseResponse<Void> res = orderService.cancelOrder(orderId);

        // Send Email
        UserDTO user = orderService.getOwnedUser(orderId);
        if(res.isSuccess() && user.getEmailNotifications()){
            emailService.sendCancelOrder(user, orderId);
        }

        return Json.createObjectBuilder()
                .add("success", res.isSuccess())
                .add("message", res.getMessage());
    }
}
