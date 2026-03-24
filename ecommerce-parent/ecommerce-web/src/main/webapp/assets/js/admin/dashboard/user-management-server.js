import {getContextPath} from "../../util.js";

import {
    $, roleBadge, escHtml, fmtMoney,
    renderPagination, renderRows, updateRoleActionBtn
} from "./user-management-util.js";

import {state} from "./user-management.js";

// Constants
const PAGE_SIZE = 10;
const USER_MANAGEMENT_URL = `${getContextPath()}/admin/dashboard/userManagement`;

// Load a page from server
export async function loadPage(page = 1) {
    state.currentPage = page;

    $("#um-error")?.classList.add("hidden");
    $("#um-no-results")?.classList.add("hidden");
    $("#um-pagination")?.classList.add("hidden");

    try {
        const params = new URLSearchParams({
            getUsers: "true",
            page: page,
            size: PAGE_SIZE,
        });

        const res = await fetch(`${USER_MANAGEMENT_URL}?${params}`, {
            method: "GET",
            cache: "no-store",
            headers: {"X-Requested-With": "XMLHttpRequest"},
        });
        if (!res.ok) throw new Error("HTTP " + res.status);

        const data = await res.json();
        if (state.destroyed) return;

        // Expected response shape: { users: [...], totalCount: 123 }
        const users = data.users ?? data ?? [];
        state.totalUsers = data.totalCount ?? users.length;
        state.totalPages = Math.ceil(state.totalUsers / PAGE_SIZE);

        // Update total label
        const label = $("#um-total-label");
        if (label) label.textContent = `(${state.totalUsers} users)`;

        renderRows(users);
        renderPagination();

    } catch (err) {
        console.error("Failed to load users:", err);
        if (state.destroyed) return;
        const tbody = $("#um-tbody");
        if (tbody) tbody.innerHTML = "";
        $("#um-error")?.classList.remove("hidden");
    }
}

// Fetch user details + order history
export async function fetchUserDetails(userId) {
    try {
        const params = new URLSearchParams({
            fetchUser: "true",
            userId: userId,
        });

        const res = await fetch(`${USER_MANAGEMENT_URL}?${params}`, {
            method: "GET",
            cache: "no-store",
            headers: {"X-Requested-With": "XMLHttpRequest"},
        });
        if (!res.ok) throw new Error("HTTP " + res.status);
        const data = await res.json();

        if (state.activeUserId !== userId) return; // user switched modals

        const setTxt = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.textContent = val ?? "—";
        };
        setTxt("um-modal-orders", data.totalOrders ?? 0);
        setTxt("um-modal-spent", fmtMoney(data.totalSpent));

        // Orders count badge
        const badge = document.getElementById("um-orders-count-badge");
        if (badge && data.totalOrders > 0) {
            badge.textContent = data.totalOrders;
            badge.classList.remove("hidden");
        }

        // Render order cards
        const ordersList = $("#um-modal-orders-list");
        if (!ordersList) return;

        if (!data.recentOrders?.length) {
            ordersList.innerHTML = `
                <div class="um-empty-state py-5 text-xs">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                         style="width:26px;height:26px">
                        <path d="M16 10a4 4 0 0 1-8 0"/>
                        <path d="M3.103 6.034h17.794"/>
                        <path d="M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z"/>
                    </svg>
                    <p>No orders yet</p>
                </div>`;
            return;
        }

        const statusMap = {
            "delivered": "status-delivered",
            "processing": "status-processing",
            "cancelled": "status-cancelled",
        };

        ordersList.innerHTML = data.recentOrders.map(order => {
            const statusKey = order.status?.toLowerCase() ?? "";
            const statusClass = statusMap[statusKey] ?? "status-processing";
            const statusLabel = order.status
                ? order.status.charAt(0) + order.status.slice(1).toLowerCase()
                : "Processing";
            const orderUrl = `${getContextPath()}/order-confirmation?orderId=${order.id}`;
            const dateLabel = order.createdAt
                ? new Date(order.createdAt).toLocaleDateString("en-US", {
                    year: "numeric",
                    month: "short",
                    day: "numeric"
                })
                : null;

            return `
                <a href="${orderUrl}" class="um-order-card" aria-label="View order ${escHtml(order.orderCode ?? String(order.id))}">
                    <div class="um-order-card-left">
                        <div class="um-order-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M16 10a4 4 0 0 1-8 0"/>
                                <path d="M3.103 6.034h17.794"/>
                                <path d="M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z"/>
                            </svg>
                        </div>
                        <div>
                            <span class="um-order-code">${escHtml(order.orderCode ?? "#" + order.id)}</span>
                            <span class="um-order-meta">
                                <span class="um-order-status ${statusClass}">${escHtml(statusLabel)}</span>
                                ${dateLabel ? `<span class="um-order-date">${escHtml(dateLabel)}</span>` : ""}
                            </span>
                        </div>
                    </div>
                    <div class="um-order-card-right">
                        <span class="um-order-total">${fmtMoney(order.total)}</span>
                        <span class="um-order-arrow">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="m9 18 6-6-6-6"/>
                            </svg>
                        </span>
                    </div>
                </a>`;
        }).join("");

    } catch (err) {
        console.error("Failed to load user details:", err);
        const ordersList = $("#um-modal-orders-list");
        if (ordersList) {
            ordersList.innerHTML = `<p class="text-xs text-red-500 py-3 text-center">Could not load order history.</p>`;
        }
    }
}

// Grant / revoke admin
export async function handleAdminToggle(userId, makeAdmin) {
    const btn = document.getElementById("um-role-action-btn");
    const spinner = document.getElementById("um-role-btn-spinner");
    const icon = document.getElementById("um-role-btn-icon");

    if (btn) btn.disabled = true;
    if (spinner) spinner.classList.remove("hidden");
    if (icon) icon.classList.add("hidden");

    try {
        const params = new URLSearchParams({
            toggleRole: "true",
            userId: userId,
        });

        const res = await fetch(`${USER_MANAGEMENT_URL}?${params}`, {
            method: "GET",
            cache: "no-store",
            headers: {"X-Requested-With": "XMLHttpRequest"},
        });
        if (!res.ok) throw new Error("HTTP " + res.status);
        await res.json();

        // Flip button state
        updateRoleActionBtn(userId, makeAdmin);

        // Refresh role badge in modal header
        const roleWrap = $("#um-modal-role-wrap");
        if (roleWrap) roleWrap.innerHTML = roleBadge(makeAdmin ? "ADMIN" : "USER");

        // Re-fetch current page so table row reflects the change
        await loadPage(state.currentPage);

    } catch (err) {
        console.error("Failed to update user role:", err);
    } finally {
        if (btn) btn.disabled = false;
        if (spinner) spinner.classList.add("hidden");
        if (icon) icon.classList.remove("hidden");
    }
}

export async function cancelOrder(orderId) {
    hideAlert();

    try {
        const res = await fetch(
            `/ecommerce/admin/dashboard/userManagement?cancelOrder=true&orderId=${orderId}`,
            {
                method: "GET",
                cache: "no-store",
                headers: {"X-Requested-With": "XMLHttpRequest"},
            }
        );

        const data = await res.json();

        if (!res.success || data.error) {
            alert(data.message || "Failed to cancel order");
        }

    } catch (err) {
        console.error("Cancel order error:", err);
        alert("Something went wrong. Please try again.");
    }
}
