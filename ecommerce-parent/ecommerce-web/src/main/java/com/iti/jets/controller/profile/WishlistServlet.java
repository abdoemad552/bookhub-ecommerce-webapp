package com.iti.jets.controller.profile;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.WishlistService;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private WishlistService wishlistService;

    @Override
    public void init() {
        wishlistService = ServiceFactory.getInstance().getWishlistService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserDTO user = getSessionUser(request);

        if (user == null) {
            writeJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, false, "You need to sign in first.", false);
            return;
        }

        Integer bookId = parseInteger(request.getParameter("bookId"));

        if (bookId == null) {
            writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, false, "Book id is required.", false);
            return;
        }

        int userId = Math.toIntExact(user.getId());
        boolean success = wishlistService.addToWishlist(userId, bookId);

        writeJsonResponse(
                response,
                success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST,
                success,
                success ? "Book added to wishlist successfully." : "Unable to add this book to your wishlist.",
                success
        );
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserDTO user = getSessionUser(request);

        if (user == null) {
            writeJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, false, "You need to sign in first.", false);
            return;
        }

        Integer bookId = parseInteger(request.getParameter("bookId"));

        if (bookId == null) {
            writeJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, false, "Book id is required.", false);
            return;
        }

        int userId = Math.toIntExact(user.getId());
        boolean success = wishlistService.removeFromWishlist(userId, bookId);
        boolean inWishlist = success && wishlistService.isInWishlist(userId, bookId);

        writeJsonResponse(
                response,
                success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST,
                success,
                success ? "Book removed from wishlist successfully." : "Unable to update your wishlist.",
                inWishlist
        );
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
                                   boolean inWishlist) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject json = Json.createObjectBuilder()
                .add("success", success)
                .add("message", message)
                .add("inWishlist", inWishlist)
                .build();

        response.getWriter().write(json.toString());
    }
}
