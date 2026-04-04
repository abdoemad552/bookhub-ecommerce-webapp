package com.iti.jets.controller.admin;

import com.iti.jets.model.dto.response.DashboardStatsDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.service.interfaces.StatsService;
import com.iti.jets.util.ActiveUserStore;
import com.iti.jets.util.PathStorage;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/dashboard/control")
public class DashboardControlServlet extends HttpServlet {

    private StatsService statsService;
    private BookService bookService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        statsService = ServiceFactory.getInstance().getStatsService();
        bookService = ServiceFactory.getInstance().getBookService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {

        String tab = request.getParameter("tab");

        if (tab == null || tab.equalsIgnoreCase("overview")) {
            DashboardStatsDTO dashboardStats = statsService.getDashboardStats();

            // Get current active users count
            request.setAttribute("activeUsersCount", ActiveUserStore.count());

            if (request.getParameter("json") != null) {
                response.setContentType("application/json");
                response.getWriter().write(dashboardStatsJson(dashboardStats));
            } else {
                request.setAttribute("dashboardStats", dashboardStats);
                request.getRequestDispatcher(PathStorage.ADMIN_DASHBOARD_PAGE_OVERVIEW)
                    .forward(request, response);
            }
        } else if (tab.equalsIgnoreCase("products")) {
            request.getRequestDispatcher(PathStorage.ADMIN_DASHBOARD_PAGE_PRODUCTS)
                .forward(request, response);
        }else{
            request.getRequestDispatcher(PathStorage.ADMIN_DASHBOARD_PAGE_USER_MANAGEMENT)
                    .forward(request, response);
        }
    }

    private String dashboardStatsJson(DashboardStatsDTO dashboardStats) {
        JsonArrayBuilder topCategoriesArrayBuilder = Json.createArrayBuilder();
        for (var topCategory : dashboardStats.getTopCategories()) {
            topCategoriesArrayBuilder.add(
                Json.createObjectBuilder()
                    .add("name", topCategory.getCategoryName())
                    .add("percentage", topCategory.getPercentage())
            );
        }

        return Json.createObjectBuilder()
            .add("totalRevenue", dashboardStats.getTotalRevenue())
            .add("ordersCount", dashboardStats.getOrdersCount())
            .add("booksCount", dashboardStats.getBooksCount())
            .add("topCategories", topCategoriesArrayBuilder.build())
            .add("userRoleStats", Json.createObjectBuilder()
                .add("adminCount", dashboardStats.getUserRoleStats().getAdminCount())
                .add("userCount", dashboardStats.getUserRoleStats().getUserCount())
            )
            .add("inventoryStats", Json.createObjectBuilder()
                .add("inStock", dashboardStats.getInventoryStats().getInStock())
                .add("lowStock", dashboardStats.getInventoryStats().getLowStock())
                .add("outOfStock", dashboardStats.getInventoryStats().getOutOfStock())
            )
            .build()
            .toString();
    }
}
