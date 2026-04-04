<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="overview-grid">

    <%-- ══════════════════════════════════════════════════════
         ROW 1 — 4 KPI Stat Cards
    ══════════════════════════════════════════════════════ --%>
    <div class="overview-row overview-row--stats">

        <%-- Revenue --%>
        <div data-slot="card" class="stat-card stat-card--emerald">
            <div class="stat-card__orb"></div>
            <div class="stat-card__icon-wrap">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <line x1="12" x2="12" y1="2" y2="22"/>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                </svg>
            </div>
            <div class="stat-card__body">
                <p id="total-revenue-stat" class="stat-card__value">${requestScope.dashboardStats.totalRevenue}</p>
                <p class="stat-card__label">Total Revenue</p>
            </div>
        </div>

        <%-- Orders --%>
        <div data-slot="card" class="stat-card stat-card--blue">
            <div class="stat-card__orb"></div>
            <div class="stat-card__icon-wrap">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                    <path d="M3.103 6.034h17.794"/>
                    <path d="M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z"/>
                </svg>
            </div>
            <div class="stat-card__body">
                <p id="orders-count-stat" class="stat-card__value">${requestScope.dashboardStats.ordersCount}</p>
                <p class="stat-card__label">Total Orders</p>
            </div>
        </div>

        <%-- Active Users --%>
        <div data-slot="card" class="stat-card stat-card--violet">
            <div class="stat-card__orb"></div>
            <div class="stat-card__icon-wrap">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                    <path d="M16 3.128a4 4 0 0 1 0 7.744"/>
                    <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
                    <circle cx="9" cy="7" r="4"/>
                </svg>
            </div>
            <div class="stat-card__body">
                <p class="stat-card__value">${requestScope.activeUsersCount}</p>
                <p class="stat-card__label">Active Users</p>
            </div>
        </div>

        <%-- Products --%>
        <div data-slot="card" class="stat-card stat-card--amber">
            <div class="stat-card__orb"></div>
            <div class="stat-card__icon-wrap">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"/>
                    <path d="M12 22V12"/>
                    <polyline points="3.29 7 12 12 20.71 7"/>
                    <path d="m7.5 4.27 9 5.15"/>
                </svg>
            </div>
            <div class="stat-card__body">
                <p id="products-count-stat" class="stat-card__value">${requestScope.dashboardStats.booksCount}</p>
                <p class="stat-card__label">Products</p>
            </div>
        </div>

    </div><%-- /ROW 1 --%>


    <%-- ══════════════════════════════════════════════════════
         ROW 2 — Top Categories (wide) + User Roles (narrow)
    ══════════════════════════════════════════════════════ --%>
    <div class="overview-row overview-row--mid">

        <%-- Top Categories --%>
        <div data-slot="card" class="panel panel--categories">
            <div class="panel__header">
                <span class="panel__dot panel__dot--blue"></span>
                <h3 class="panel__title">Top Categories</h3>
            </div>
            <div id="top-categories-container" class="categories-list">
                <c:forEach begin="0" end="2" var="i">
                    <div class="category-row">
                        <div class="category-row__meta">
                            <span class="category-row__name">${requestScope.dashboardStats.topCategories[i].categoryName}</span>
                            <span class="category-row__pct">${requestScope.dashboardStats.topCategories[i].percentage}%</span>
                        </div>
                        <div class="category-row__track">
                            <div class="category-row__fill ${i eq 0 ? 'fill--blue' : i eq 1 ? 'fill--emerald' : 'fill--violet'}"
                                 style="width:${requestScope.dashboardStats.topCategories[i].percentage}%"></div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <%-- User Roles --%>
        <div data-slot="card" class="panel panel--roles">
            <div class="panel__header">
                <span class="panel__dot panel__dot--violet"></span>
                <h3 class="panel__title">User Roles</h3>
            </div>
            <div class="roles-grid">
                <div class="role-item">
                    <div class="role-item__icon role-item__icon--violet">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
                        </svg>
                    </div>
                    <p id="admin-count" class="role-item__count">${requestScope.dashboardStats.userRoleStats.adminCount}</p>
                    <p class="role-item__label">Admins</p>
                </div>
                <div class="role-divider"></div>
                <div class="role-item">
                    <div class="role-item__icon role-item__icon--blue">
                        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                            <path d="M16 3.128a4 4 0 0 1 0 7.744"/>
                            <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
                            <circle cx="9" cy="7" r="4"/>
                        </svg>
                    </div>
                    <p id="user-count" class="role-item__count">${requestScope.dashboardStats.userRoleStats.userCount}</p>
                    <p class="role-item__label">Users</p>
                </div>
            </div>
        </div>

    </div><%-- /ROW 2 --%>


    <%-- ══════════════════════════════════════════════════════
         ROW 3 — Inventory Status (full width, horizontal)
    ══════════════════════════════════════════════════════ --%>
    <div data-slot="card" class="panel panel--inventory">
        <div class="panel__header">
            <span class="panel__dot panel__dot--amber"></span>
            <h3 class="panel__title">Inventory Status</h3>
        </div>
        <div class="inventory-row">
            <div class="inv-item">
                <div class="inv-item__indicator inv-item__indicator--emerald"></div>
                <div class="inv-item__body">
                    <span class="inv-item__label">In Stock</span>
                    <span id="in-stock" class="inv-item__badge inv-item__badge--emerald">${requestScope.dashboardStats.inventoryStats.inStock} items</span>
                </div>
            </div>
            <div class="inv-separator"></div>
            <div class="inv-item">
                <div class="inv-item__indicator inv-item__indicator--amber"></div>
                <div class="inv-item__body">
                    <span class="inv-item__label">Low Stock</span>
                    <span id="low-stock" class="inv-item__badge inv-item__badge--amber">${requestScope.dashboardStats.inventoryStats.lowStock} items</span>
                </div>
            </div>
            <div class="inv-separator"></div>
            <div class="inv-item">
                <div class="inv-item__indicator inv-item__indicator--red"></div>
                <div class="inv-item__body">
                    <span class="inv-item__label">Out of Stock</span>
                    <span id="out-of-stock" class="inv-item__badge inv-item__badge--red">${requestScope.dashboardStats.inventoryStats.outOfStock} items</span>
                </div>
            </div>
        </div>
    </div><%-- /ROW 3 --%>

</div><%-- /overview-grid --%>