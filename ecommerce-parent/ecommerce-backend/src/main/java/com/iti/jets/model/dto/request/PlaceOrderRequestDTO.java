package com.iti.jets.model.dto.request;

import com.iti.jets.model.dto.response.OrderItemDTO;
import com.iti.jets.model.enums.OrderStatus;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PlaceOrderRequestDTO {

    private long userId;
    private LocalDateTime createdAt;
    private OrderStatus status;
    private double totalPrice;
    private Set<OrderItemDTO> items;
}
