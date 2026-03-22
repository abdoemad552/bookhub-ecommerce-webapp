package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;

public interface OrderService {

    BaseResponse<String> placeOrder(PlaceOrderRequestDTO request);
}
