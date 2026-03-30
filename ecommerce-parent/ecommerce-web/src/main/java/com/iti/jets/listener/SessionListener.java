package com.iti.jets.listener;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.util.ActiveUserStore;
import jakarta.servlet.http.*;

public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {

        UserDTO user = (UserDTO) se.getSession().getAttribute("user");

        if (user != null) {
            ActiveUserStore.removeSession(user.getId(), se.getSession().getId());
        }
    }
}
