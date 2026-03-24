import {getContextPath} from "../../util.js";
import {state} from "./user-management.js";

// DOM helpers
export const $ = (sel, ctx = document) => {
    if (typeof sel !== "string") {
        console.error("Invalid selector:", sel);
        return null;
    }
    return ctx.querySelector(sel);
};

// Avatar
export function buildAvatar(user, size = 36) {
    if (user.avatarUrl && user.avatarUrl !== "null") {
        return `<img src="${getContextPath()}/${user.avatarUrl}" 
                     alt="${escHtml(user.username)}"
                     class="um-avatar"
                     width="${size}" height="${size}">`;
    }

    return `<div 
                style="width:${size}px; height:${size}px;" 
                class="rounded-full bg-primary/20 flex items-center justify-center border-2 border-primary">
              <svg xmlns="http://www.w3.org/2000/svg"
                   style="width:${size * 0.55}px; height:${size * 0.55}px;"
                   viewBox="0 0 24 24"
                   fill="none" stroke="currentColor" stroke-width="2"
                   stroke-linecap="round" stroke-linejoin="round"
                   class="lucide lucide-user text-primary"
                   aria-hidden="true">
                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
            </div>`;
}

export function roleBadge(role) {
    const isAdmin = role?.toLowerCase() !== "user";
    const cls = isAdmin ? "role-admin" : "role-user";
    const icon = isAdmin
        ? `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="width:9px;height:9px">
               <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
           </svg>`
        : `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="width:9px;height:9px">
               <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
               <circle cx="12" cy="7" r="4"/>
           </svg>`;
    return `<span class="um-role-badge ${cls}">${icon}${escHtml(role ?? "User")}</span>`;
}

export function escHtml(str) {
    return String(str ?? "")
        .replace(/&/g, "&amp;").replace(/</g, "&lt;")
        .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

export function fmtMoney(amount) {
    if (amount == null) return "—";

    return new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "EGP"
    }).format(amount);
}

// Modal helpers
export function openModal() {
    const backdrop = $("#um-modal-backdrop");
    backdrop?.classList.add("is-open");
    document.body.style.overflow = "hidden";
}

export function closeModal() {
    const backdrop = $("#um-modal-backdrop");
    backdrop?.classList.remove("is-open");
    document.body.style.overflow = "";
    state.activeUserId = null;
}

// Populate modal with basic user data
export function populateModalBase(user) {
    // Avatar
    const avatarWrap = $("#um-modal-avatar-wrap");
    if (avatarWrap) avatarWrap.innerHTML = buildAvatar(user, 62);

    // Text fields
    const setTxt = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.textContent = val ?? "—";
    };
    setTxt("um-modal-name", user.username);
    setTxt("um-modal-email", user.email);

    // Role badge
    const roleWrap = $("#um-modal-role-wrap");
    if (roleWrap) roleWrap.innerHTML = roleBadge(user.role);

    // Grant / Revoke footer button
    const isAdmin = user.role?.toLowerCase() !== "user";
    updateRoleActionBtn(user.id, isAdmin);

    // Reset stats
    setTxt("um-modal-orders", "…");
    setTxt("um-modal-spent", "…");

    // Hide count badge while loading
    const badge = document.getElementById("um-orders-count-badge");
    if (badge) badge.classList.add("hidden");

    // Reset orders list to loading state
    const ordersList = $("#um-modal-orders-list");
    if (ordersList) {
        ordersList.innerHTML = `
            <div class="um-empty-state py-6 text-xs">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                     style="width:28px;height:28px">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 6v6l4 2"/>
                </svg>
                <p>Loading orders…</p>
            </div>`;
    }
}

// Sync the footer Grant/Revoke button appearance
export function updateRoleActionBtn(userId, isAdmin) {
    const btn = document.getElementById("um-role-action-btn");
    if (!btn) return;

    btn.dataset.userId = userId;
    btn.dataset.isAdmin = isAdmin ? "true" : "false";

    const iconEl = document.getElementById("um-role-btn-icon");
    const textEl = document.getElementById("um-role-btn-text");

    if (isAdmin) {
        btn.className = "um-footer-role-btn revoke";
        if (iconEl) iconEl.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <line x1="17" y1="8" x2="23" y2="14"/>
                <line x1="23" y1="8" x2="17" y2="14"/>
            </svg>`;
        if (textEl) textEl.textContent = "Revoke Admin";
    } else {
        btn.className = "um-footer-role-btn grant";
        if (iconEl) iconEl.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
            </svg>`;
        if (textEl) textEl.textContent = "Grant Admin";
    }
}

// Render table rows
export function renderRows(users) {
    const tbody = $("#um-tbody");
    const noResults = $("#um-no-results");
    if (!tbody) return;

    if (!users.length) {
        tbody.innerHTML = "";
        noResults?.classList.remove("hidden");
        return;
    }

    noResults?.classList.add("hidden");

    tbody.innerHTML = users.map(user => `
        <tr>
            <td>
                <div class="flex items-center gap-3">
                    ${buildAvatar(user)}
                    <span class="font-medium text-foreground">${escHtml(user.username)}</span>
                </div>
            </td>
            <td class="text-muted-foreground">${escHtml(user.email)}</td>
            <td>${roleBadge(user.role)}</td>
            <td>
                <button class="um-action-btn" data-user-id="${user.id}" aria-label="View ${escHtml(user.username)}">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                        <circle cx="12" cy="12" r="3"/>
                    </svg>
                    View
                </button>
            </td>
        </tr>
    `).join("");
}

// Pagination
export function renderPagination() {
    const pagination = $("#um-pagination");
    const pageInfo = $("#um-page-info");
    const btnsWrap = $("#um-page-btns");
    if (!pagination) return;

    if (state.totalPages <= 1) {
        pagination.classList.add("hidden");
        return;
    }

    pagination.classList.remove("hidden");

    // "Page 1 of 3" with bold numbers
    if (pageInfo) {
        pageInfo.innerHTML = `Page <strong>${state.currentPage}</strong> of <strong>${state.totalPages}</strong>`;
    }

    const pages = buildPageRange(state.currentPage, state.totalPages);
    if (!btnsWrap) return;

    btnsWrap.innerHTML = `
        <button class="um-page-btn" data-page="prev"
                ${state.currentPage === 1 ? "disabled" : ""} aria-label="Previous page">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="m15 18-6-6 6-6"/>
            </svg>
        </button>
        ${pages.map(p => p === "…"
        ? `<span class="text-xs text-muted-foreground px-1">…</span>`
        : `<button class="um-page-btn ${p === state.currentPage ? "active" : ""}"
                       data-page="${p}">${p}</button>`
    ).join("")}
        <button class="um-page-btn" data-page="next"
                ${state.currentPage === state.totalPages ? "disabled" : ""} aria-label="Next page">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="m9 18 6-6-6-6"/>
            </svg>
        </button>
    `;
}

export function buildPageRange(current, total) {
    if (total <= 7) return Array.from({length: total}, (_, i) => i + 1);
    const pages = new Set([1, total, current, current - 1, current + 1].filter(p => p >= 1 && p <= total));
    const sorted = [...pages].sort((a, b) => a - b);
    const result = [];
    for (let i = 0; i < sorted.length; i++) {
        if (i > 0 && sorted[i] - sorted[i - 1] > 1) result.push("…");
        result.push(sorted[i]);
    }
    return result;
}

// Render order cards
export function buildOrderCard(order) {
    const statusMap = {
        "delivered": "status-delivered",
        "processing": "status-processing",
        "cancelled": "status-cancelled",
    };

    const statusKey = order.status?.toLowerCase() ?? "";
    const statusClass = statusMap[statusKey] ?? "status-processing";
    const statusLabel = order.status
        ? order.status.charAt(0) + order.status.slice(1).toLowerCase()
        : "Processing";
    const orderUrl = `${getContextPath()}/order-confirmation?orderId=${order.id}`;
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

// Toast
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

export function dismissToast(toast) {
    toast.classList.remove("um-toast-show");
    toast.classList.add("um-toast-hide");
    toast.addEventListener("transitionend", () => toast.remove(), {once: true});
}

// Confirm dialog
export function showConfirm(orderCode) {
    return new Promise(resolve => {
        const backdrop = document.getElementById("um-confirm-backdrop");
        const desc     = document.getElementById("um-confirm-desc");
        const yesBtn   = document.getElementById("um-confirm-yes");
        const noBtn    = document.getElementById("um-confirm-no");
        if (!backdrop || !yesBtn || !noBtn) { resolve(false); return; }

        if (desc) {
            desc.textContent = orderCode
                ? `Are you sure you want to cancel order ${orderCode}? This action cannot be undone.`
                : "This will permanently cancel the order. This action cannot be undone.";
        }

        backdrop.classList.add("is-open");

        function cleanup(result) {
            backdrop.classList.remove("is-open");
            yesBtn.removeEventListener("click", onYes);
            noBtn.removeEventListener("click",  onNo);
            backdrop.removeEventListener("click", onBackdrop);
            resolve(result);
        }

        const onYes      = () => cleanup(true);
        const onNo       = () => cleanup(false);
        const onBackdrop = e => { if (e.target === backdrop) cleanup(false); };

        yesBtn.addEventListener("click",   onYes,      {once: true});
        noBtn.addEventListener("click",    onNo,       {once: true});
        backdrop.addEventListener("click", onBackdrop);
    });
}