package com.iti.jets.model.dto.response;

import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
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
public class OrderDTO {

    private Long orderId;
    private Long userId;
    private String orderCode;
    private LocalDateTime createdAt;
    private OrderStatus orderStatus;
    private double totalPrice;
    private double shippingPrice;
    Set<OrderItemDTO> items;

    // Shipping Address
    private String shippingAddress;
}
