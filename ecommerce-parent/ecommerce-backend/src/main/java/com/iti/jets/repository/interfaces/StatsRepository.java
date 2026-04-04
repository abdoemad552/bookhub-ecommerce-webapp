package com.iti.jets.repository.interfaces;

import com.iti.jets.model.dto.response.InventoryStatusDTO;
import com.iti.jets.model.dto.response.TopCategoryDTO;
import com.iti.jets.model.dto.response.UserRoleStatsDTO;

import java.math.BigDecimal;
import java.util.List;

public interface StatsRepository {

    BigDecimal getTotalRevenue();

    long getOrdersCount();

    long getBooksCount();

    List<TopCategoryDTO> getTopCategories();

    UserRoleStatsDTO getUserRoleStats();

    InventoryStatusDTO getInventoryStats();
}
