import {getContextPath} from "../../util.js";

import {
    $, openModal,
    closeModal, populateModalBase
} from "./user-management-util.js";

import {
    loadPage,fetchUserDetails, handleAdminToggle
} from "./user-management-server.js"

// Module state
export const state = {
    currentPage: 0,
    totalUsers: 0,
    totalPages: 0,
    activeUserId: null,
    destroyed: false
};

// Event delegation
function bindEvents() {
    document.addEventListener("click", e => {
        if (state.destroyed) return;

        // View button → open modal
        const actionBtn = e.target.closest(".um-action-btn");
        if (actionBtn) {
            const userId = actionBtn.dataset.userId;
            // Find user in current rendered rows via data attribute
            state.activeUserId = userId;
            // Build a minimal user object from the row cells to populate immediately
            const row = actionBtn.closest("tr");
            const user = extractUserFromRow(row, userId);
            populateModalBase(user);
            openModal();
            fetchUserDetails(userId);
            return;
        }

        // Close modal
        if (e.target.closest("#um-modal-close") || e.target.closest("#um-modal-close-btn")) {
            closeModal();
            return;
        }

        // Click backdrop to close
        if (e.target.id === "um-modal-backdrop") {
            closeModal();
            return;
        }

        // Pagination
        const pageBtn = e.target.closest(".um-page-btn");
        if (pageBtn) {
            const p = pageBtn.dataset.page;
            if (p === "prev" && state.currentPage > 1) loadPage(state.currentPage - 1);
            else if (p === "next" && state.currentPage < state.totalPages) loadPage(state.currentPage + 1);
            else if (!isNaN(+p)) loadPage(+p);
        }
    });

    // Keyboard close
    document.addEventListener("keydown", e => {
        if (!state.destroyed && e.key === "Escape") closeModal();
    });

    // Role action button (Grant / Revoke Admin)
    const roleActionBtn = document.getElementById("um-role-action-btn");
    if (roleActionBtn) {
        roleActionBtn.addEventListener("click", () => {
            const userId  = roleActionBtn.dataset.userId;
            const isAdmin = roleActionBtn.dataset.isAdmin === "true";
            // isAdmin === currently admin → clicking means REVOKE; else GRANT
            handleAdminToggle(userId, !isAdmin);
        });
    }
}

// Extract a minimal user object from a rendered table row
function extractUserFromRow(row, userId) {
    if (!row) return {id: userId, username: "", email: "", role: null, avatarUrl: "null"};
    const nameEl = row.querySelector(".font-medium.text-foreground");
    const emailEl = row.querySelector(".text-muted-foreground");
    const dateEl = row.querySelector(".text-muted-foreground.text-xs");
    const avatarImg = row.querySelector(".um-avatar");
    const avatarFallback = row.querySelector(".um-avatar-fallback");

    return {
        id: userId,
        username: nameEl?.textContent?.trim() ?? "",
        email: emailEl?.textContent?.trim() ?? "",
        role: row.querySelector(".um-role-badge")?.textContent?.trim() ?? null,
        avatarUrl: avatarImg ? avatarImg.src.replace(getContextPath() + "/", "") : "null",
        _fallbackColor: avatarFallback?.dataset?.color ?? null,
        _fallbackLetter: avatarFallback?.textContent?.trim() ?? null,
    };
}

// Init visibility helpers
function initVisibility() {
    $("#um-error")?.classList.add("hidden");
    $("#um-no-results")?.classList.add("hidden");
    $("#um-pagination")?.classList.add("hidden");
}

// Public lifecycle
export function initUserManagement() {
    console.log("User Management Init");
    state.destroyed = false;

    const $mainContent = $("#main-content");
    if (!$mainContent) return;

    fetch(`${getContextPath()}/admin/dashboard/control?tab=user-management`)
        .then(r => r.text())
        .then(html => {
            if (state.destroyed) return;
            $mainContent.innerHTML = html;

            // Inject CSS if not already loaded
            if (!document.getElementById("um-css")) {
                const link = document.createElement("link");
                link.id = "um-css";
                link.rel = "stylesheet";
                link.href = `${getContextPath()}/assets/css/user-management.css`;
                document.head.appendChild(link);
            }

            initVisibility();
            bindEvents();
            loadPage(1);
        })
        .catch(err => console.error("User Management load error:", err));
}

export function destroyUserManagement() {
    state.destroyed = true;
    closeModal();

    // Reset all state for a fresh mount next time
    state.currentPage = 1;
    state.totalUsers = 0;
    state.totalPages = 0;
    state.activeUserId = null;
}