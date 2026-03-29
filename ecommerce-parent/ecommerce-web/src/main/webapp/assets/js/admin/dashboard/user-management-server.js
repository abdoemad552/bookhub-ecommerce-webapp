import {getContextPath} from "../../util.js";

import {
    $, roleBadge, fmtMoney,
    renderPagination, renderRows,
    updateRoleActionBtn, showToast,
    buildOrderCard, showConfirm
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

        const users = data.users ?? data ?? [];
        state.totalUsers = data.totalCount - 1 ?? users.length - 1;
        state.totalPages = Math.ceil(state.totalUsers / PAGE_SIZE);

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

        if (state.activeUserId !== userId) return;

        const setTxt = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.textContent = val ?? "—";
        };
        setTxt("um-modal-orders", data.totalOrders ?? 0);
        setTxt("um-modal-spent", fmtMoney(data.totalSpent));

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

        ordersList.innerHTML = [...data.recentOrders]
            .sort((a, b) => {
                const idOf = o => parseInt((o.orderCode ?? "").split("-").pop(), 10) || o.id;
                return idOf(b) - idOf(a);
            })
            .map(buildOrderCard).join("");

    } catch (err) {
        console.error("Failed to load user details:", err);
        const ordersList = $("#um-modal-orders-list");
        if (ordersList) {
            ordersList.innerHTML = `<p class="text-xs text-red-500 py-3 text-center">Could not load order history.</p>`;
        }
    }
}

// Cancel order
export async function cancelOrder(orderId, btn) {
    if (btn.disabled) return;
    btn.disabled = true;

    // Read order code for the confirm message before disabling the button
    const wrap      = btn.closest(".um-order-card-wrap");
    const orderCode = wrap?.querySelector(".um-order-code")?.textContent?.trim() ?? null;

    const confirmed = await showConfirm(orderCode);
    if (!confirmed) {
        btn.disabled = false;
        return;
    }

    let statusEl;
    let prevClass;
    let prevText;

    try {
        const res = await fetch(
            `${USER_MANAGEMENT_URL}?cancelOrder=true&orderId=${orderId}`,
            {
                method: "GET",
                cache: "no-store",
                headers: {"X-Requested-With": "XMLHttpRequest"},
            }
        );
        if (!res.ok) throw new Error("HTTP " + res.status);
        const data = await res.json();

        if (data.error || data.success === false) {
            showToast(data.message ?? "Server rejected cancellation", "error");
            btn.disabled = false;
            return;
        }

        // Hide the cancel button immediately
        btn.classList.add("um-cancel-order-btn--hiding");

        // Flip the status badge to "Cancelled"
        statusEl  = wrap?.querySelector(".um-order-status");
        prevClass = statusEl ? [...statusEl.classList].find(c => c.startsWith("status-")) : null;
        prevText  = statusEl?.textContent ?? "";

        if (statusEl) {
            statusEl.className   = "um-order-status status-cancelled";
            statusEl.textContent = "Cancelled";
        }

        btn.remove();
        showToast("Order cancelled successfully.", "success");

        // Decrement totalSpent immediately using the order's displayed amount
        const totalEl  = wrap?.querySelector(".um-order-total");
        const spentEl  = document.getElementById("um-modal-spent");
        if (totalEl && spentEl) {
            const orderAmount  = parseFloat(totalEl.textContent.replace(/[^0-9.]/g, "")) || 0;
            const currentSpent = parseFloat(spentEl.textContent.replace(/[^0-9.]/g, "")) || 0;
            spentEl.textContent = fmtMoney(Math.max(0, currentSpent - orderAmount));
        }

    } catch (err) {
        console.error("Cancel order error:", err);

        // Rollback
        if (statusEl && prevClass) {
            statusEl.className   = `um-order-status ${prevClass}`;
            statusEl.textContent = prevText;
        }
        btn.classList.remove("um-cancel-order-btn--hiding");
        btn.disabled = false;

        showToast("Failed to cancel order. Please try again.", "error");
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

        updateRoleActionBtn(userId, makeAdmin);

        const roleWrap = $("#um-modal-role-wrap");
        if (roleWrap) roleWrap.innerHTML = roleBadge(makeAdmin ? "ADMIN" : "USER");

        showToast(
            makeAdmin ? "Admin access granted." : "Admin access revoked.",
            "success"
        );

        await loadPage(state.currentPage);

    } catch (err) {
        console.error("Failed to update user role:", err);
        showToast("Failed to update role. Please try again.", "error");
    } finally {
        if (btn) btn.disabled = false;
        if (spinner) spinner.classList.add("hidden");
        if (icon) icon.classList.remove("hidden");
    }
}