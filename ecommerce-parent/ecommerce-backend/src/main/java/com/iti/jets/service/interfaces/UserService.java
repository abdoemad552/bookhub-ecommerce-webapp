package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.service.generic.BaseService;

public interface UserService extends BaseService<UserDTO, Long> {

    boolean existsByUserName(String username);

    boolean existsByEmail(String email);
}
