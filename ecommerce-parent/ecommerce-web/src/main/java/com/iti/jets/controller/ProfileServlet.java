package com.iti.jets.controller;

import com.iti.jets.controller.admin.AdminBooksServlet;
import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.request.ImageUploadRequest;
import com.iti.jets.model.dto.request.UpdatePersonalInfoRequestDTO;
import com.iti.jets.model.dto.response.CategoryDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserInterestsDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
import com.iti.jets.model.enums.ImageCategory;
import com.iti.jets.service.extra.ImageService;
import com.iti.jets.service.interfaces.CategoryService;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.OrderService;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.service.interfaces.WishlistService;
import com.iti.jets.util.PathStorage;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.Set;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB — spool to disk above this
    maxFileSize       = 5 * 1024 * 1024,   // 5 MB max per file
    maxRequestSize    = 6 * 1024 * 1024    // 6 MB max total request
)
public class ProfileServlet extends HttpServlet {

    private UserService userService;
    private OrderService orderService;
    private WishlistService wishlistService;
    private CategoryService categoryService;
    private ImageService imageService;
    private Jsonb jsonb;

    private static final Logger LOGGER = LoggerFactory.getLogger(ProfileServlet.class);


    @Override
    public void init() {
        userService = ServiceFactory.getInstance().getUserService();
        orderService = ServiceFactory.getInstance().getOrderService();
        wishlistService = ServiceFactory.getInstance().getWishlistService();
        categoryService = ServiceFactory.getInstance().getCategoryService();
        imageService = ServiceFactory.getInstance().getImageService();
        jsonb = JsonbBuilder.create();
    }

    @Override
    public void destroy() {
        try { if (jsonb != null) jsonb.close(); }
        catch (Exception ignored) {}
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDTO currentUser = requireAuthenticatedUser(req, resp);
        if (currentUser == null) {
            return;
        }

        consumeFlashMessages(req);
        applyRequestedTab(req);
        populateProfileData(req, currentUser);
        req.getRequestDispatcher(PathStorage.PROFILE_PAGE).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        UserDTO currentUser = requireAuthenticatedUser(req, resp);
        if (currentUser == null) {
            return;
        }

        String formAction = req.getParameter("formAction");

        try {
            if ("credit-settings".equals(formAction)) {
                handleUserResponse(
                        req,
                        userService.updateBalance(
                                currentUser.getId(),
                                parseCreditLimit(req.getParameter("creditLimit"))
                        ),
                        "credit-manage-info"
                );
            } else if ("save-address".equals(formAction)) {
                handleVoidResponse(
                        req,
                        userService.saveNewUserAddress(currentUser.getId(), buildAddressRequest(req)),
                        "addresses-info"
                );
            } else if ("delete-address".equals(formAction)) {
                handleVoidResponse(
                        req,
                        userService.deleteUserAddress(currentUser.getId(), parseAddressId(req.getParameter("addressId"))),
                        "addresses-info"
                );
            } else if ("remove-wishlist".equals(formAction)) {
                handleWishlistRemoval(
                        req,
                        currentUser,
                        parseWishlistBookId(req.getParameter("bookId"))
                );
            } else {
                UpdatePersonalInfoRequestDTO updateRequest = buildUpdateRequest(req);
                handleUserResponse(
                        req,
                        userService.updateUser(currentUser.getId(), updateRequest),
                        "profile-info"
                );
            }
        } catch (DateTimeParseException e) {
            req.getSession().setAttribute("profile_error_message", "Birth date is invalid");
            req.getSession().setAttribute("profile_active_tab", "profile-info");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("profile_error_message", "Credit limit or address id is invalid");
            req.getSession().setAttribute("profile_active_tab", resolveActiveTab(formAction));
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("profile_error_message", e.getMessage() == null || e.getMessage().isBlank()
                    ? "Submitted data is invalid"
                    : e.getMessage());
            req.getSession().setAttribute("profile_active_tab", resolveInvalidDataTab(formAction));
        }

        resp.sendRedirect(PathStorage.PROFILE_SERVLET);
    }

    @Override
    protected void doPut(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {

        Part imagePart = request.getPart("image");

        long userId;
        try {
            userId = parseLongParam(request, "userId", "User ID");
        } catch (NumberFormatException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
            return;
        }

        System.out.println(userId + " " + imagePart.getSubmittedFileName());

        HttpSession session = request.getSession(false);

        UserDTO user;
        if (session != null) {
            user = (UserDTO) session.getAttribute("user");
            if (user == null || !user.getId().equals(userId)) {
                writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "You are unauthorized to do this action");
                return;
            }
        } else {
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                "You are unauthorized to do this action");
            return;
        }

        String newProfilePicUrl;
        String oldProfilePicUrl = user.getProfilePicUrl();
        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                ImageUploadRequest uploadRequest = new ImageUploadRequest(
                    imagePart.getInputStream(),
                    imagePart.getContentType(),
                    imagePart.getSize(),
                    ImageCategory.PROFILE
                );

                newProfilePicUrl = imageService.uploadImage(uploadRequest);
                userService.updateProfilePicUrl(userId, newProfilePicUrl);
                user.setProfilePicUrl(newProfilePicUrl);
                session.setAttribute("user", user);
            } catch (Exception e) {
                System.out.println(e.getMessage());
                LOGGER.warn("Profile picture upload failed for user {}, saved without cover", userId);
                writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update the image");
                return;
            }
        } else {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Image must be provided");
            return;
        }

        try {
            System.out.println("Deleting: " + oldProfilePicUrl);
            imageService.removeImage(oldProfilePicUrl.replace("images/", "/"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Couldn't delete the old user profile picture");
        }

        writeJson(response, HttpServletResponse.SC_OK, Map.of("profilePicUrl", newProfilePicUrl));
    }

    private void writeJson(HttpServletResponse response, int status, Object body)
        throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        jsonb.toJson(body, response.getWriter());
    }

    private void writeError(HttpServletResponse resp, int status, String message)
        throws IOException {
        writeJson(resp, status, new AdminBooksServlet.ErrorResponse(message));
    }

    private long parseLongParam(HttpServletRequest request, String name, String label) {
        String val = request.getParameter(name);
        if (val == null || val.isBlank())
            throw new IllegalArgumentException(label + " is required");
        try { return Long.parseLong(val.trim()); }
        catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a whole number");
        }
    }

    private void populateProfileData(HttpServletRequest req, UserDTO currentUser) {
        UserAddressesDTO userAddresses = userService.loadUserAddresses(currentUser.getId());
        UserInterestsDTO userInterests = userService.loadUserInterests(currentUser.getId());
        List<CategoryDTO> availableCategories = categoryService.findAll()
                .stream()
                .sorted(Comparator.comparing(
                        category -> category.getName() == null ? "" : category.getName(),
                        String.CASE_INSENSITIVE_ORDER
                ))
                .toList();
        Map<Long, Boolean> interestSelections = new HashMap<>();
        if (userInterests != null && userInterests.getInterests() != null) {
            userInterests.getInterests().forEach(interest -> interestSelections.put(interest.getId(), Boolean.TRUE));
        }

        req.setAttribute("profileUser", currentUser);
        req.setAttribute("profileAddresses", userAddresses);
        req.setAttribute("profileInterests", userInterests);
        req.setAttribute("profileAvailableCategories", availableCategories);
        req.setAttribute("profileInterestSelections", interestSelections);
        req.setAttribute("profileOrders", orderService.findAllByUserId(currentUser.getId()));
        req.setAttribute("profileWishlistBooks", wishlistService.findWishlistBooks(currentUser.getId()));
        req.setAttribute("addressTypes", AddressType.values());
        req.setAttribute("governments", Government.values());
    }

    private void consumeFlashMessages(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return;
        }

        String successMessage = (String) session.getAttribute("profile_success_message");
        if (successMessage != null) {
            req.setAttribute("profile_success_message", successMessage);
            session.removeAttribute("profile_success_message");
        }

        String errorMessage = (String) session.getAttribute("profile_error_message");
        if (errorMessage != null) {
            req.setAttribute("profile_error_message", errorMessage);
            session.removeAttribute("profile_error_message");
        }

        String activeTab = (String) session.getAttribute("profile_active_tab");
        if (activeTab != null) {
            req.setAttribute("profile_active_tab", activeTab);
            session.removeAttribute("profile_active_tab");
        }
    }

    private void applyRequestedTab(HttpServletRequest req) {
        String requestedTab = req.getParameter("tab");
        if (requestedTab == null || requestedTab.isBlank()) {
            return;
        }

        switch (requestedTab) {
            case "profile-info":
            case "orders-info":
            case "addresses-info":
            case "credit-manage-info":
            case "wishlist-info":
                req.setAttribute("profile_active_tab", requestedTab);
                break;
            default:
                break;
        }
    }

    private UserDTO requireAuthenticatedUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            HttpSession flashSession = req.getSession(true);
            flashSession.setAttribute("flash_message", "Please login first to access your profile.");
            resp.sendRedirect(PathStorage.LOGIN_SERVLET);
            return null;
        }

        return (UserDTO) session.getAttribute("user");
    }

    private UpdatePersonalInfoRequestDTO buildUpdateRequest(HttpServletRequest req) {
        String birthDateValue = req.getParameter("birthDate");

        return UpdatePersonalInfoRequestDTO.builder()
                .firstName(req.getParameter("firstName"))
                .lastName(req.getParameter("lastName"))
                .job(req.getParameter("job"))
                .birthDate((birthDateValue == null || birthDateValue.isBlank()) ? null : LocalDate.parse(birthDateValue))
                .emailNotifications(req.getParameter("emailNotifications") != null)
                .currentPassword(req.getParameter("currentPassword"))
                .newPassword(req.getParameter("newPassword"))
                .confirmNewPassword(req.getParameter("confirmNewPassword"))
                .interestIds(extractInterestIds(req.getParameterValues("interestIds")))
                .build();
    }

    private BigDecimal parseCreditLimit(String creditLimitValue) {
        if (creditLimitValue == null || creditLimitValue.isBlank()) {
            return null;
        }

        return new BigDecimal(creditLimitValue.trim());
    }

    private Long parseAddressId(String addressIdValue) {
        if (addressIdValue == null || addressIdValue.isBlank()) {
            throw new NumberFormatException("Address id is missing");
        }

        return Long.parseLong(addressIdValue.trim());
    }

    private Integer parseWishlistBookId(String bookIdValue) {
        if (bookIdValue == null || bookIdValue.isBlank()) {
            throw new NumberFormatException("Wishlist book id is missing");
        }

        return Integer.parseInt(bookIdValue.trim());
    }

    private Set<Long> extractInterestIds(String[] interestIdValues) {
        if (interestIdValues == null || interestIdValues.length == 0) {
            return Set.of();
        }

        Set<Long> interestIds = new LinkedHashSet<>();
        for (String interestIdValue : interestIdValues) {
            if (interestIdValue == null || interestIdValue.isBlank()) {
                continue;
            }

            interestIds.add(Long.parseLong(interestIdValue.trim()));
        }

        return interestIds;
    }

    private AddressRequestDTO buildAddressRequest(HttpServletRequest req) {
        return AddressRequestDTO.builder()
                .addressType(AddressType.valueOf(req.getParameter("addressType")))
                .government(Government.valueOf(req.getParameter("government")))
                .city(req.getParameter("city"))
                .street(req.getParameter("street"))
                .buildingNo(req.getParameter("buildingNo"))
                .description(req.getParameter("description"))
                .build();
    }

    private void handleUserResponse(HttpServletRequest req, BaseResponse<UserDTO> result, String activeTab) {
        HttpSession session = req.getSession();
        session.setAttribute("profile_active_tab", activeTab);

        if (result.isSuccess()) {
            session.setAttribute("user", result.getData());
            session.setAttribute("profile_success_message", result.getMessage());
        } else {
            session.setAttribute("profile_error_message", result.getMessage());
        }
    }

    private void handleVoidResponse(HttpServletRequest req, BaseResponse<Void> result, String activeTab) {
        HttpSession session = req.getSession();
        session.setAttribute("profile_active_tab", activeTab);

        if (result.isSuccess()) {
            session.setAttribute("profile_success_message", result.getMessage());
        } else {
            session.setAttribute("profile_error_message", result.getMessage());
        }
    }

    private void handleWishlistRemoval(HttpServletRequest req, UserDTO currentUser, Integer bookId) {
        HttpSession session = req.getSession();
        session.setAttribute("profile_active_tab", "wishlist-info");

        boolean removed = wishlistService.removeFromWishlist(Math.toIntExact(currentUser.getId()), bookId);
        if (removed) {
            session.setAttribute("profile_success_message", "Book removed from wishlist successfully.");
        } else {
            session.setAttribute("profile_error_message", "Unable to remove this book from your wishlist.");
        }
    }

    private String resolveActiveTab(String formAction) {
        if ("save-address".equals(formAction) || "delete-address".equals(formAction)) {
            return "addresses-info";
        }
        if ("remove-wishlist".equals(formAction)) {
            return "wishlist-info";
        }
        if ("credit-settings".equals(formAction)) {
            return "credit-manage-info";
        }
        return "profile-info";
    }

    private String resolveInvalidDataTab(String formAction) {
        if ("save-address".equals(formAction) || "delete-address".equals(formAction)) {
            return "addresses-info";
        }
        return "profile-info";
    }
}
