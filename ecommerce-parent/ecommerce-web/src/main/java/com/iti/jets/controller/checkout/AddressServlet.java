package com.iti.jets.controller.checkout;

import com.iti.jets.model.dto.response.AddressDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.UserService;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(AddressServlet.class);
    private UserService userService;

    @Override
    public void init() {
        userService = ServiceFactory.getInstance().getUserService();
    }

    /**
     * GET /addresses for a specific user
     * Returns all addresses per user as a JSON array: [{id, type, city, ...}, ...]
     * Used by the checkout step-1 address picker.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
//        resp.setHeader("Cache-Control", "public, max-age=3600");

        // Load all data needed for the current user (like addresses)
        var session = req.getSession(false);
        if(session == null || session.getAttribute("user") == null){
            return;
        }

        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        UserAddressesDTO userAddressesDto = userService.loadUserAddresses(currentUser.getId());


        JsonArrayBuilder jsonArray = Json.createArrayBuilder();
        for (AddressDTO a : userAddressesDto.getAddresses()) {
            jsonArray.add(Json.createObjectBuilder()
                    .add("id", a.getId())
                    .add("addressType", a.getAddressType().getPrettyName())
                    .add("government", a.getGovernment().getPrettyName())
                    .add("city", a.getCity())
                    .add("street", a.getStreet())
                    .add("buildingNo", a.getBuildingNo())
                    .add("description", a.getDescription())
            );
        }

        PrintWriter out = resp.getWriter();
        out.write(jsonArray.build().toString());
    }
}
