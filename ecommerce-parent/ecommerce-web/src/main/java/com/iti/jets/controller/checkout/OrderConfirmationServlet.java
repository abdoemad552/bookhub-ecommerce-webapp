package com.iti.jets.controller.checkout;

import com.iti.jets.model.dto.response.OrderDTO;
import com.iti.jets.model.dto.response.OrderItemDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.OrderService;
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
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/order-confirmation")
public class OrderConfirmationServlet extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        orderService = ServiceFactory.getInstance().getOrderService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            HttpSession flashSession = req.getSession(true);
            flashSession.setAttribute("flash_message", "Please login first, before proceed to checkout!");
            flashSession.setAttribute("comes_from_checkout", "true");

            resp.sendRedirect(PathStorage.LOGIN_SERVLET);
            return;
        }

        // Validate parameter (orderId)
        String orderIdParam = req.getParameter("orderId");

        if (orderIdParam == null || orderIdParam.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
            return;
        }

        try {
            Long orderId = Long.parseLong(orderIdParam);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            req.getRequestDispatcher(PathStorage.NOT_FOUND_PAGE).forward(req, resp);
            return;
        }

        // Validate ownership
        Long orderId = Long.parseLong(orderIdParam);

        UserDTO user = (UserDTO) session.getAttribute("user");

        if (!orderService.isOrderOwnedByUser(orderId, user.getId())) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.getRequestDispatcher(PathStorage.FORBIDDEN_PAGE).forward(req, resp);
            return;
        }

        req.getRequestDispatcher(PathStorage.ORDER_CONFIRMATION).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Load all data needed for the current user
        BaseResponse<OrderDTO> result = orderService.loadOrderDetails(Long.parseLong(req.getParameter("orderId")));

        JsonObjectBuilder jsonObject = Json.createObjectBuilder();
        JsonArrayBuilder jsonArray = Json.createArrayBuilder();

        if (result.isSuccess()) {
            OrderDTO orderDto = result.getData();

            for (OrderItemDTO item : orderDto.getItems()) {
                jsonArray.add(
                        Json.createObjectBuilder()
                                .add("bookId", item.getBookId())
                                .add("title", item.getBookTittle())
                                .add("imageUrl", (item.getImageUrl() != null) ? item.getImageUrl() : "Not Found")
                                .add("quantity", item.getQuantity())
                                .add("price", item.getCurrentPrice())
                );
            }

            jsonObject
                    .add("orderId", orderDto.getOrderId())
                    .add("orderCode", orderDto.getOrderCode())
                    .add("status", orderDto.getOrderStatus().toString())
                    .add("subtotal", orderDto.getTotalPrice())
                    .add("shipping", orderDto.getShippingPrice())
                    .add("items", jsonArray)
                    .add("shippingAddress", orderDto.getShippingAddress());


        } else {
            jsonObject
                    .add("error", result.getMessage());
        }
        resp.getWriter().write(jsonObject.build().toString());
    }
}
