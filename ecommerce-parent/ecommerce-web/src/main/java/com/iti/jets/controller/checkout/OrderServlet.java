package com.iti.jets.controller.checkout;

import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.CartItemDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CartService;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(OrderServlet.class);
    private CartService cartService;

    @Override
    public void init() {
        cartService = ServiceFactory.getInstance().getCartService();
    }

    /**
     * GET /order details for a specific user
     * Returns order summary for a user as a JSON object.
     * Used by the checkout step-2 payment part.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        // Load all data needed for the current user
        var session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return;
        }

        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        BaseResponse<CartDTO> result = cartService.loadOrderSummary(currentUser.getId());

        JsonObjectBuilder jsonObject = Json.createObjectBuilder();
        JsonArrayBuilder jsonArray = Json.createArrayBuilder();

        if (result.isSuccess()) {
            CartDTO cartDto = result.getData();

            for (CartItemDTO item : cartDto.getItems()) {
                jsonArray.add(
                        Json.createObjectBuilder()
                                .add("bookId", item.getBookId())
                                .add("title", item.getBookTitle())
                                .add("quantity", item.getQuantity())
                                .add("price", item.getPrice())
                );
            }

            jsonObject
                    .add("subtotal", cartDto.getTotalPrice())
                    .add("shipping", cartDto.getShippingPrice())
                    .add("limit", currentUser.getCreditLimit())
                    .add("items", jsonArray);

        } else {
            jsonObject
                    .add("error", result.getMessage());
        }
        resp.getWriter().write(jsonObject.build().toString());
    }
}