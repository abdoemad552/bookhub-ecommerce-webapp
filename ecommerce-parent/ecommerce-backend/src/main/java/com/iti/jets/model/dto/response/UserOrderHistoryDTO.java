package com.iti.jets.model.dto.response;

import lombok.*;

import java.util.Set;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserOrderHistoryDTO {

    private int totalOrders;
    private double totalSpent;
    Set<OrderDTO> recentOrders;

}
