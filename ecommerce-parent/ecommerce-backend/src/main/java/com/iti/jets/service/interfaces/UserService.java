package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.generic.BaseService;

public interface UserService extends BaseService<UserDTO, Long> {

    boolean existsByUserName(String username);

    boolean existsByEmail(String email);

    UserDTO findByUsername(String username);

    UserAddressesDTO loadUserAddresses(Long id);

    BaseResponse<Void> saveNewUserAddress(Long userId, AddressRequestDTO addressRequestDto);

    boolean toggleRole(Long userId);
}
