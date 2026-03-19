package com.iti.jets.controller;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.entity.Cart;
import com.iti.jets.model.entity.CartItem;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.CartService;
import com.iti.jets.util.PathStorage;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Comparator;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() {
        cartService = ServiceFactory.getInstance().getCartService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        if (request.getParameter("count") != null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            UserDTO user = getSessionUser(request);
            int count = user == null ? 0 : cartService.getItemsCount(Math.toIntExact(user.getId()));

            JsonObject json = Json.createObjectBuilder()
                    .add("count", count)
                    .build();

            response.getWriter().write(json.toString());
            return;
        }

        UserDTO user = getSessionUser(request);
        Cart cart = user == null ? null : cartService.findByUserId(Math.toIntExact(user.getId()));
        List<CartItem> cartItems = cart == null
                ? List.of()
                : cart.getItems().stream()
                .sorted(Comparator.comparing(item -> item.getBook().getTitle(), String.CASE_INSENSITIVE_ORDER))
                .toList();

        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartItemsCount", user == null ? 0 : cartService.getItemsCount(Math.toIntExact(user.getId())));
        request.setAttribute("cartTotalPrice", cart == null ? 0.0 : cart.getTotalPrice());
        request.setAttribute("isCartEmpty", cartItems.isEmpty());

        request.getRequestDispatcher(PathStorage.CART_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserDTO user = getSessionUser(request);

        if (user == null) {
            writeJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, false, "You need to sign in first.", 0, null, null);
            return;
        }

        Integer bookId = parseInteger(request.getParameter("bookId"));
        Integer amount = parseInteger(request.getParameter("amount"));

        if (bookId == null) {
            writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, false, "Book id is required.", 0, null, null);
            return;
        }

        int userId = Math.toIntExact(user.getId());
        boolean success = amount == null
                ? cartService.addToCart(userId, bookId)
                : cartService.addToCart(userId, bookId, amount);

        Cart cart = cartService.findByUserId(userId);
        int count = cartService.getItemsCount(userId);
        Integer itemQuantity = resolveCartItemQuantity(cart, bookId);
        String message = success ? "Book added to cart successfully." : "Unable to add this book to the cart.";

        writeJsonResponse(
                response,
                success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST,
                success,
                message,
                count,
                cart,
                itemQuantity
        );
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserDTO user = getSessionUser(request);

        if (user == null) {
            writeJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, false, "You need to sign in first.", 0, null, null);
            return;
        }

        Integer bookId = parseInteger(request.getParameter("bookId"));
        Integer amount = parseInteger(request.getParameter("amount"));

        if (bookId == null) {
            writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, false, "Book id is required.", 0, null, null);
            return;
        }

        int userId = Math.toIntExact(user.getId());
        boolean success = amount == null
                ? cartService.removeFromCart(userId, bookId)
                : cartService.removeFromCart(userId, bookId, amount);

        Cart cart = cartService.findByUserId(userId);
        int count = cartService.getItemsCount(userId);
        Integer itemQuantity = resolveCartItemQuantity(cart, bookId);
        String message = success
                ? ((itemQuantity == null || itemQuantity == 0) ? "Book removed from cart successfully." : "Cart updated successfully.")
                : "Unable to update the cart.";

        writeJsonResponse(
                response,
                success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST,
                success,
                message,
                count,
                cart,
                itemQuantity
        );
    }

    private Integer resolveCartItemQuantity(Cart cart, Integer bookId) {
        if (cart == null || bookId == null) {
            return 0;
        }

        return cart.getItems()
                .stream()
                .filter(item -> item.getBook().getId().equals(Long.valueOf(bookId)))
                .map(CartItem::getQuantity)
                .findFirst()
                .orElse(0);
    }

    private UserDTO getSessionUser(HttpServletRequest request) {
        Object user = request.getSession(false) == null ? null : request.getSession(false).getAttribute("user");
        return user instanceof UserDTO ? (UserDTO) user : null;
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void writeJsonResponse(HttpServletResponse response,
                                   int statusCode,
                                   boolean success,
                                   String message,
                                   int count,
                                   Cart cart,
                                   Integer itemQuantity) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObjectBuilder jsonBuilder = Json.createObjectBuilder()
                .add("success", success)
                .add("message", message)
                .add("count", count)
                .add("totalPrice", cart == null ? 0.0 : cart.getTotalPrice())
                .add("itemQuantity", itemQuantity == null ? 0 : itemQuantity);

        JsonObject json = jsonBuilder.build();
        response.getWriter().write(json.toString());
    }
}
