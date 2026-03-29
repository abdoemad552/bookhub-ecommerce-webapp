package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.response.DashboardStatsDTO;
import com.iti.jets.repository.interfaces.StatsRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.StatsService;

public class StatsServiceImpl extends ContextHandler implements StatsService {

    private final StatsRepository statsRepository;

    public StatsServiceImpl(StatsRepository statsRepository) {
        this.statsRepository = statsRepository;
    }

    @Override
    public DashboardStatsDTO getDashboardStats() {
        return executeInContext(() -> new DashboardStatsDTO(
            statsRepository.getTotalRevenue(),
            statsRepository.getOrdersCount(),
            statsRepository.getBooksCount(),
            statsRepository.getTopCategories(),
            statsRepository.getUserRoleStats(),
            statsRepository.getInventoryStats()
        ));
    }
}
