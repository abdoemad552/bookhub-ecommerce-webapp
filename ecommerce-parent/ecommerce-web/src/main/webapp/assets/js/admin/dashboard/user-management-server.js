import {getContextPath} from "../../util.js";

import {
    $, roleBadge, escHtml, fmtMoney,
    renderPagination, renderRows, updateRoleActionBtn
} from "./user-management-util.js";

import {state} from "./user-management.js";

// Constants
const PAGE_SIZE = 10;
const USER_MANAGEMENT_URL = `${getContextPath()}/admin/dashboard/userManagement`;

// ─── Toast ────────────────────────────────────────────────────────────────────
export function showToast(message, type = "success") {
    const container = document.getElementById("um-toast-container");
    if (!container) return;

    const toast = document.createElement("div");
    toast.className = `um-toast um-toast-${type}`;

    const icon = type === "success"
        ? `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>`
        : `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>`;

    toast.innerHTML = `
        <span class="um-toast-icon">${icon}</span>
        <span class="um-toast-msg">${escHtml(message)}</span>
        <button class="um-toast-close" aria-label="Dismiss">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
        </button>`;

    toast.querySelector(".um-toast-close").addEventListener("click", () => dismissToast(toast));
    container.appendChild(toast);

    // Trigger enter animation on next frame
    requestAnimationFrame(() => toast.classList.add("um-toast-show"));

    // Auto-dismiss after 4s
    setTimeout(() => dismissToast(toast), 4000);
}

function dismissToast(toast) {
    toast.classList.remove("um-toast-show");
    toast.classList.add("um-toast-hide");
    toast.addEventListener("transitionend", () => toast.remove(), {once: true});
}

// ─── Load a page from server ──────────────────────────────────────────────────
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
        state.totalUsers = data.totalCount ?? users.length;
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

// ─── Build order card HTML ─────────────────────────────────────────────────────
function buildOrderCard(order) {
    const statusMap = {
        "delivered":  "status-delivered",
        "processing": "status-processing",
        "cancelled":  "status-cancelled",
    };

    const statusKey   = order.status?.toLowerCase() ?? "";
    const statusClass = statusMap[statusKey] ?? "status-processing";
    const statusLabel = order.status
        ? order.status.charAt(0) + order.status.slice(1).toLowerCase()
        : "Processing";
    const orderUrl  = `${getContextPath()}/order-confirmation?orderId=${order.id}`;
    const dateLabel = order.createdAt
        ? new Date(order.createdAt).toLocaleDateString("en-US", {year: "numeric", month: "short", day: "numeric"})
        : null;

    const isCancellable = statusKey !== "cancelled" && statusKey !== "delivered";

    return `
        <div class="um-order-card-wrap" data-order-id="${order.id}">
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
            </a>
            ${isCancellable ? `
            <button class="um-cancel-order-btn" data-order-id="${order.id}"
                    aria-label="Cancel order ${escHtml(order.orderCode ?? String(order.id))}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="m15 9-6 6"/><path d="m9 9 6 6"/>
                </svg>
                Cancel
            </button>` : ""}
        </div>`;
}

// ─── Fetch user details + order history ──────────────────────────────────────
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

        ordersList.innerHTML = data.recentOrders.map(buildOrderCard).join("");

    } catch (err) {
        console.error("Failed to load user details:", err);
        const ordersList = $("#um-modal-orders-list");
        if (ordersList) {
            ordersList.innerHTML = `<p class="text-xs text-red-500 py-3 text-center">Could not load order history.</p>`;
        }
    }
}

// ─── Cancel order ─────────────────────────────────────────────────────────────
export async function cancelOrder(orderId, btn) {
    // Prevent double-click
    if (btn.disabled) return;
    btn.disabled = true;

    // ── Optimistic UI: immediately flip the card to "Cancelled" ──
    const wrap       = btn.closest(".um-order-card-wrap");
    const statusEl   = wrap?.querySelector(".um-order-status");
    const prevClass  = statusEl ? [...statusEl.classList].find(c => c.startsWith("status-")) : null;
    const prevText   = statusEl?.textContent ?? "";

    if (statusEl) {
        statusEl.className = "um-order-status status-cancelled";
        statusEl.textContent = "Cancelled";
    }
    // Hide the cancel button immediately (optimistic)
    btn.classList.add("um-cancel-order-btn--hiding");

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
            throw new Error(data.message ?? "Server rejected cancellation");
        }

        // ── Confirmed: remove button from DOM ──
        btn.remove();
        showToast("Order cancelled successfully.", "success");

        // Refresh stats (totalSpent may have changed)
        if (state.activeUserId) {
            const setTxt = (id, val) => {
                const el = document.getElementById(id);
                if (el) el.textContent = val ?? "—";
            };
            if (data.totalSpent != null) setTxt("um-modal-spent", fmtMoney(data.totalSpent));
        }

    } catch (err) {
        console.error("Cancel order error:", err);

        // ── Rollback optimistic update ──
        if (statusEl && prevClass) {
            statusEl.className = `um-order-status ${prevClass}`;
            statusEl.textContent = prevText;
        }
        btn.classList.remove("um-cancel-order-btn--hiding");
        btn.disabled = false;

        showToast("Failed to cancel order. Please try again.", "error");
    }
}

// ─── Grant / revoke admin ─────────────────────────────────────────────────────
export async function handleAdminToggle(userId, makeAdmin) {
    const btn     = document.getElementById("um-role-action-btn");
    const spinner = document.getElementById("um-role-btn-spinner");
    const icon    = document.getElementById("um-role-btn-icon");

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
