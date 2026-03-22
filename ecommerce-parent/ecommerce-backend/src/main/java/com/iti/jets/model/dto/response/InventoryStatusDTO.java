package com.iti.jets.model.dto.response;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class InventoryStatusDTO {
    private long inStock;
    private long lowStock;
    private long outOfStock;
}
