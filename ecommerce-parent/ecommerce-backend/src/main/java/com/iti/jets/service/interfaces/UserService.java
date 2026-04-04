package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserInterestsDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.service.generic.BaseService;
import com.iti.jets.model.dto.request.UpdatePersonalInfoRequestDTO;


import java.math.BigDecimal;

public interface UserService extends BaseService<UserDTO, Long> {

    boolean existsByUserName(String username);

    boolean existsByEmail(String email);

    UserDTO findByUsername(String username);

    UserAddressesDTO loadUserAddresses(Long id);

    UserInterestsDTO loadUserInterests(Long id);

    BaseResponse<Void> saveNewUserAddress(Long userId, AddressRequestDTO addressRequestDto);

    boolean toggleRole(Long userId);

    BaseResponse<UserDTO> updateUser(Long userId, UpdatePersonalInfoRequestDTO userInfoRequestDto);

    BaseResponse<UserDTO> updateBalance(Long userId, BigDecimal newBalance);

    BaseResponse<Void> deleteUserAddress(Long userId, Long addressId);

    void updateProfilePicUrl(Long userId, String profilePicUrl);
}
