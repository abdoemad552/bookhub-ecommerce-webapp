package com.iti.jets.controller.checkout;

import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CartService;
import jakarta.json.Json;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;

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

        if (result.isSuccess()) {
            CartDTO cartDto = result.getData();
            // TODO: Add all details of items too
            JsonObjectBuilder jsonObject = Json.createObjectBuilder()
                    .add("subtotal", cartDto.getTotalPrice())
                    .add("shipping", cartDto.getShippingPrice());

            resp.getWriter().write(jsonObject.build().toString());
        }
    }

    /**
     * POST request from JS to place new order
     * for the current user
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        resp.setContentType("application/json");
//        resp.setCharacterEncoding("UTF-8");
//
//        var session = req.getSession(false);
//        if (session == null || session.getAttribute("user") == null) {
//            return;
//        }
//        UserDTO currentUser = (UserDTO) session.getAttribute("user");
//
//        AddressRequestDTO addressRequestDto = buildRequestDto(req);
//        BaseResponse<Void> result = userService.saveNewUserAddress(currentUser.getId(), addressRequestDto);
//
//        JsonObjectBuilder jsonObject = Json.createObjectBuilder()
//                .add("success", result.isSuccess())
//                .add("message", result.getMessage());
//
//        resp.getWriter().write(jsonObject.build().toString());
    }

    private AddressRequestDTO buildRequestDto(HttpServletRequest req) {
        return AddressRequestDTO.builder()
                .addressType(AddressType.valueOf(req.getParameter("addressType")))
                .government(Government.valueOf(req.getParameter("government")))
                .city(req.getParameter("city"))
                .street(req.getParameter("street"))
                .buildingNo(req.getParameter("buildingNo"))
                .description(req.getParameter("description"))
                .build();
    }
}
