package com.iti.jets.service.interfaces;

import com.iti.jets.model.dto.request.PlaceOrderRequestDTO;
import com.iti.jets.model.dto.response.OrderDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserOrderHistoryDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.entity.Order;
import com.iti.jets.model.enums.OrderStatus;

import java.util.List;

public interface OrderService {

    BaseResponse<String> placeOrder(PlaceOrderRequestDTO request);

    BaseResponse<OrderDTO> loadOrderDetails(Long orderId);

    OrderStatus getOrderStatus(Long orderId);

    OrderStatus getOrderStatus(Order order);

    BaseResponse<Void> cancelOrder(Long orderId);

    BaseResponse<Void> cancelOrder(Order order);

    boolean isOrderOwnedByUser(Long orderId, Long userId);

    BaseResponse<UserOrderHistoryDTO> loadOrderHistory(Long userId);

    UserDTO getOwnedUser(Long orderId);

    List<OrderDTO> findAllByUserId(Long userId);
}
