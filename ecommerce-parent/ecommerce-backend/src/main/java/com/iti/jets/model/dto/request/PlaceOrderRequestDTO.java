package com.iti.jets.model.dto.request;

import com.iti.jets.model.dto.response.OrderItemDTO;
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
public class PlaceOrderRequestDTO {

    private long userId;
    private LocalDateTime createdAt;
    private OrderStatus status;
    private double totalPrice;
    private Set<OrderItemDTO> items;

    // Shipping address
    private Government government;
    private AddressType addressType;
    private String city;
    private String street;
    private String buildingNo;
    private String description;
}
