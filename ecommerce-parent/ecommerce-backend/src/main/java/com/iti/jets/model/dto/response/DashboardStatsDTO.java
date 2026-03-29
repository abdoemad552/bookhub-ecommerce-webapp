package com.iti.jets.model.dto.response;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class DashboardStatsDTO {
    private BigDecimal totalRevenue;
    private long ordersCount;
    private long booksCount;
    private List<TopCategoryDTO> topCategories;
    private UserRoleStatsDTO userRoleStats;
    private InventoryStatusDTO inventoryStats;
}
