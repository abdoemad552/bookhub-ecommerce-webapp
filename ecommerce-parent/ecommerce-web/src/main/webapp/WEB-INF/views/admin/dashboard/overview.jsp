<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="space-y-6">
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-6">
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4 sm:p-6 relative overflow-hidden group hover:shadow-lg transition-all duration-300">
            <div class="absolute top-0 right-0 w-24 h-24 bg-linear-to-br from-emerald-500 to-teal-600 opacity-10 rounded-full -translate-y-1/2 translate-x-1/2 group-hover:scale-150 transition-transform duration-500"></div>
            <div class="relative">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-9 h-9 sm:w-12 sm:h-12 rounded-xl bg-linear-to-br from-emerald-500 to-teal-600 flex items-center justify-center shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-dollar-sign w-4 h-4 sm:w-6 sm:h-6 text-white" aria-hidden="true">
                            <line x1="12" x2="12" y1="2" y2="22"></line>
                            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                        </svg>
                    </div>
                </div>
                <p id="total-revenue-stat" class="text-xl sm:text-3xl font-bold text-foreground mb-0.5">${requestScope.dashboardStats.totalRevenue}</p>
                <p class="text-xs sm:text-sm text-muted-foreground">Total Revenue</p>
            </div>
        </div>
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4 sm:p-6 relative overflow-hidden group hover:shadow-lg transition-all duration-300">
            <div class="absolute top-0 right-0 w-24 h-24 bg-linear-to-br from-blue-500 to-indigo-600 opacity-10 rounded-full -translate-y-1/2 translate-x-1/2 group-hover:scale-150 transition-transform duration-500"></div>
            <div class="relative">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-9 h-9 sm:w-12 sm:h-12 rounded-xl bg-linear-to-br from-blue-500 to-indigo-600 flex items-center justify-center shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-bag w-4 h-4 sm:w-6 sm:h-6 text-white" aria-hidden="true">
                            <path d="M16 10a4 4 0 0 1-8 0"></path>
                            <path d="M3.103 6.034h17.794"></path>
                            <path d="M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z"></path>
                        </svg>
                    </div>
                </div>
                <p id="orders-count-stat" class="text-xl sm:text-3xl font-bold text-foreground mb-0.5">${requestScope.dashboardStats.ordersCount}</p>
                <p class="text-xs sm:text-sm text-muted-foreground">Total Orders</p>
            </div>
        </div>
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4 sm:p-6 relative overflow-hidden group hover:shadow-lg transition-all duration-300">
            <div class="absolute top-0 right-0 w-24 h-24 bg-linear-to-br from-violet-500 to-purple-600 opacity-10 rounded-full -translate-y-1/2 translate-x-1/2 group-hover:scale-150 transition-transform duration-500"></div>
            <div class="relative">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-9 h-9 sm:w-12 sm:h-12 rounded-xl bg-linear-to-br from-violet-500 to-purple-600 flex items-center justify-center shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-users w-4 h-4 sm:w-6 sm:h-6 text-white" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                            <path d="M16 3.128a4 4 0 0 1 0 7.744"></path>
                            <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                        </svg>
                    </div>
                </div>
                <p class="text-xl sm:text-3xl font-bold text-foreground mb-0.5">${requestScope.activeUsersCount}</p>
                <p class="text-xs sm:text-sm text-muted-foreground">Active Users</p>
            </div>
        </div>
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4 sm:p-6 relative overflow-hidden group hover:shadow-lg transition-all duration-300">
            <div class="absolute top-0 right-0 w-24 h-24 bg-linear-to-br from-amber-500 to-orange-600 opacity-10 rounded-full -translate-y-1/2 translate-x-1/2 group-hover:scale-150 transition-transform duration-500"></div>
            <div class="relative">
                <div class="flex items-center justify-between mb-3">
                    <div class="w-9 h-9 sm:w-12 sm:h-12 rounded-xl bg-linear-to-br from-amber-500 to-orange-600 flex items-center justify-center shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-package w-4 h-4 sm:w-6 sm:h-6 text-white" aria-hidden="true">
                            <path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"></path>
                            <path d="M12 22V12"></path>
                            <polyline points="3.29 7 12 12 20.71 7"></polyline>
                            <path d="m7.5 4.27 9 5.15"></path>
                        </svg>
                    </div>
                </div>
                <p id="products-count-stat" class="text-xl sm:text-3xl font-bold text-foreground mb-0.5">${requestScope.dashboardStats.booksCount}</p>
                <p class="text-xs sm:text-sm text-muted-foreground">Products</p>
            </div>
        </div>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-3 rounded-xl border shadow-sm p-4 sm:p-6">
            <h3 class="text-sm font-semibold text-muted-foreground mb-4">Top Categories</h3>
            <div id="top-categories-container" class="space-y-3">
                <c:forEach begin="0" end="2" var="i">
                    <div>
                        <div class="flex items-center justify-between text-sm mb-1">
                            <span class="text-foreground">${requestScope.dashboardStats.topCategories[i].categoryName}</span>
                            <span class="text-muted-foreground">${requestScope.dashboardStats.topCategories[i].percentage}%</span>
                        </div>
                        <div class="h-2 bg-muted rounded-full overflow-hidden">
                            <div class="h-full ${i eq 0 ? 'bg-blue-500' : i eq 1 ? 'bg-emerald-500' : 'bg-violet-500'} bg-blue-500 rounded-full" style="width:${requestScope.dashboardStats.topCategories[i].percentage}%"></div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-3 rounded-xl border shadow-sm p-4 sm:p-6">
            <h3 class="text-sm font-semibold text-muted-foreground mb-4">User Roles</h3>
            <div class="flex items-center justify-center gap-8">
                <div class="text-center">
                    <div class="w-14 h-14 rounded-full bg-linear-to-br from-violet-500 to-purple-600 flex items-center justify-center mx-auto mb-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shield w-7 h-7 text-white" aria-hidden="true">
                            <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"></path>
                        </svg>
                    </div>
                    <p id="admin-count" class="text-2xl font-bold text-foreground">${requestScope.dashboardStats.userRoleStats.adminCount}</p>
                    <p class="text-xs text-muted-foreground">Admins</p>
                </div>
                <div class="text-center">
                    <div class="w-14 h-14 rounded-full bg-linear-to-br from-blue-500 to-indigo-600 flex items-center justify-center mx-auto mb-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-users w-7 h-7 text-white" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                            <path d="M16 3.128a4 4 0 0 1 0 7.744"></path>
                            <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <p id="user-count" class="text-2xl font-bold text-foreground">${requestScope.dashboardStats.userRoleStats.userCount}</p>
                    <p class="text-xs text-muted-foreground">Users</p>
                </div>
            </div>
        </div>
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-3 rounded-xl border shadow-sm p-4 sm:p-6 sm:col-span-2 lg:col-span-1">
            <h3 class="text-sm font-semibold text-muted-foreground mb-4">Inventory Status</h3>
            <div class="space-y-3">
                <div class="flex items-center justify-between">
                    <span class="text-sm text-foreground">In Stock</span>
                    <span id="in-stock" class="px-2 py-1 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">${requestScope.dashboardStats.inventoryStats.inStock} items</span>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-sm text-foreground">Low Stock</span>
                    <span id="low-stock" class="px-2 py-1 rounded-full text-xs font-medium bg-amber-500/10 text-amber-600">${requestScope.dashboardStats.inventoryStats.lowStock} items</span>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-sm text-foreground">Out of Stock</span>
                    <span id="out-of-stock" class="px-2 py-1 rounded-full text-xs font-medium bg-red-500/10 text-red-600">${requestScope.dashboardStats.inventoryStats.outOfStock} items</span>
                </div>
            </div>
        </div>
    </div>
</div>
