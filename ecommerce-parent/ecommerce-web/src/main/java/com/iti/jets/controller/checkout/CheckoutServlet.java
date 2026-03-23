package com.iti.jets.controller.checkout;

import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.CartItemDTO;
import com.iti.jets.model.dto.response.OrderItemDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
import com.iti.jets.model.enums.OrderStatus;
import com.iti.jets.service.extra.EmailService;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CartService;
import com.iti.jets.service.interfaces.OrderService;
import com.iti.jets.util.PathStorage;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(CheckoutServlet.class);
    private CartService cartService;
    private OrderService orderService;
    private EmailService emailService;

    @Override
    public void init() {
        cartService = ServiceFactory.getInstance().getCartService();
        orderService = ServiceFactory.getInstance().getOrderService();
        emailService = ServiceFactory.getInstance().getEmailService();
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if the user does not log in
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            HttpSession flashSession = req.getSession(true);
            flashSession.setAttribute("flash_message", "Please login first, before proceed to checkout!");
            flashSession.setAttribute("comes_from_checkout", "true");

            resp.sendRedirect(PathStorage.LOGIN_SERVLET);
            return;
        }

        req.setAttribute("governments", Government.values());
        req.setAttribute("addressType", AddressType.values());
        req.getRequestDispatcher(PathStorage.CHECKOUT_PAGE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Load all data needed for the current user
        var session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return;
        }

        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        PlaceOrderRequestDTO placeOrderRequestDTO = buildPlaceOrderRequestDto(currentUser.getId(), req);
        BaseResponse<String> result = orderService.placeOrder(placeOrderRequestDTO);

        JsonObjectBuilder jsonObject = Json.createObjectBuilder();
        if (result.isSuccess()) {
            String id = result.getData().substring(result.getData().lastIndexOf("-") + 1);

            jsonObject
                    .add("success", true)
                    .add("orderId", id);

            // Send Confirmation Email to the user in a background thread
            if (currentUser.getEmailNotifications()) {
                assert placeOrderRequestDTO != null;
                emailService.sendPlaceOrderNotification(currentUser, result.getData(), placeOrderRequestDTO.getTotalPrice());
            }

        } else {
            jsonObject
                    .add("success", false)
                    .add("message", result.getMessage());
        }
        resp.getWriter().write(jsonObject.build().toString());
    }

    private PlaceOrderRequestDTO buildPlaceOrderRequestDto(Long userId, HttpServletRequest req) {
        BaseResponse<CartDTO> result = cartService.loadOrderSummary(userId);

        if (result.isFailure()) {
            return null;
        }

        CartDTO cart = result.getData();
        Set<OrderItemDTO> orderItems = new HashSet<>();

        for (var cartItem : cart.getItems()) {
            orderItems.add(OrderItemDTO.builder()
                    .bookId(cartItem.getBookId())
                    .quantity(cartItem.getQuantity())
                    .currentPrice(cartItem.getPrice())
                    .build());
        }

        return PlaceOrderRequestDTO.builder()
                .userId(userId)
                .createdAt(LocalDateTime.now())
                .status(OrderStatus.PROCESSING)
                .totalPrice(cart.getTotalPrice())
                .items(orderItems)
                .government(Government.valueOf(req.getParameter("government").toUpperCase()))
                .addressType(AddressType.valueOf(req.getParameter("addressType").toUpperCase()))
                .city(req.getParameter("city"))
                .street(req.getParameter("street"))
                .buildingNo(req.getParameter("buildingNo"))
                .description(req.getParameter("description"))
                .build();
    }
}