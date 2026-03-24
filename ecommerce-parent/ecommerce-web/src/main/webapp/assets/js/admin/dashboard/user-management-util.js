import {getContextPath} from "../../util.js";
import {state} from "./user-management.js";

// Constant
const AVATAR_COLORS = 10;

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
    const isAdmin = role?.toLowerCase() === "admin";
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

export function fmtDate(iso) {
    if (!iso) return "—";
    return new Date(iso).toLocaleDateString("en-US", {year: "numeric", month: "short", day: "numeric"});
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
    const isAdmin = user.role?.toLowerCase() === "admin";
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