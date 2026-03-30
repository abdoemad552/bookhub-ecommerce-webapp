package com.iti.jets.service.implementation;

import com.iti.jets.model.dto.response.DashboardStatsDTO;
import com.iti.jets.model.dto.response.InventoryStatusDTO;
import com.iti.jets.model.dto.response.UserRoleStatsDTO;
import com.iti.jets.repository.interfaces.StatsRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("StatsServiceImpl Tests")
class StatsServiceImplTest {

    @Mock
    private StatsRepository statsRepository;

    @InjectMocks
    private StatsServiceImpl statsService;

    @BeforeEach
    void setUp() {
        // default stubs for all getDashboardStats calls
        when(statsRepository.getTotalRevenue()).thenReturn(new BigDecimal("15000.00"));
        when(statsRepository.getOrdersCount()).thenReturn(120L);
        when(statsRepository.getBooksCount()).thenReturn(350L);
        when(statsRepository.getTopCategories()).thenReturn(List.of());
        when(statsRepository.getUserRoleStats()).thenReturn(new UserRoleStatsDTO(2, 5));
        when(statsRepository.getInventoryStats()).thenReturn(new InventoryStatusDTO(15, 2, 5));
    }

    @Test
    @DisplayName("getDashboardStats returns non-null DTO")
    void getDashboardStats_returnsNonNull() {
        DashboardStatsDTO result = statsService.getDashboardStats();

        assertNotNull(result);
    }

    @Test
    @DisplayName("getDashboardStats calls all repository methods exactly once")
    void getDashboardStats_callsAllRepositoryMethods() {
        statsService.getDashboardStats();

        verify(statsRepository).getTotalRevenue();
        verify(statsRepository).getOrdersCount();
        verify(statsRepository).getBooksCount();
        verify(statsRepository).getTopCategories();
        verify(statsRepository).getUserRoleStats();
        verify(statsRepository).getInventoryStats();
    }

    @Test
    @DisplayName("getDashboardStats populates totalRevenue from repository")
    void getDashboardStats_totalRevenue_isCorrect() {
        DashboardStatsDTO result = statsService.getDashboardStats();

        assertEquals(new BigDecimal("15000.00"), result.getTotalRevenue());
    }

    @Test
    @DisplayName("getDashboardStats populates ordersCount from repository")
    void getDashboardStats_ordersCount_isCorrect() {
        DashboardStatsDTO result = statsService.getDashboardStats();

        assertEquals(120L, result.getOrdersCount());
    }

    @Test
    @DisplayName("getDashboardStats populates booksCount from repository")
    void getDashboardStats_booksCount_isCorrect() {
        DashboardStatsDTO result = statsService.getDashboardStats();

        assertEquals(350L, result.getBooksCount());
    }

    @Test
    @DisplayName("getDashboardStats works correctly when repository returns zeros")
    void getDashboardStats_worksWithZeroValues() {
        when(statsRepository.getTotalRevenue()).thenReturn(BigDecimal.ZERO);
        when(statsRepository.getOrdersCount()).thenReturn(0L);
        when(statsRepository.getBooksCount()).thenReturn(0L);

        DashboardStatsDTO result = statsService.getDashboardStats();

        assertNotNull(result);
        assertEquals(BigDecimal.ZERO, result.getTotalRevenue());
        assertEquals(0L, result.getOrdersCount());
        assertEquals(0L, result.getBooksCount());
    }

    @Test
    @DisplayName("getDashboardStats is called multiple times independently")
    void getDashboardStats_isIdempotent() {
        statsService.getDashboardStats();
        statsService.getDashboardStats();

        verify(statsRepository, times(2)).getTotalRevenue();
        verify(statsRepository, times(2)).getOrdersCount();
    }
}
