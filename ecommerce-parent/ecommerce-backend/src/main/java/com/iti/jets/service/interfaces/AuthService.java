package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.LoginRequestDTO;
import com.iti.jets.model.dto.request.RegisterRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;

public interface AuthService {

    BaseResponse<UserDTO> login(LoginRequestDTO request);

    BaseResponse<UserDTO> register(RegisterRequestDTO request);
}