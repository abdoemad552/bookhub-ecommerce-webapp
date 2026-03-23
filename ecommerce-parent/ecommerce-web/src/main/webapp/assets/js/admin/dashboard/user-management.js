import {getContextPath} from "../../util.js";


// ─── Constants ─────────────────────────────────────────────────────────────
const PAGE_SIZE = 10;
const AVATAR_COLORS = 10; // cycles 0–9 (matches CSS data-color attribute)
const USER_MANAGEMENT_URL = `${getContextPath()}/admin/dashboard/userManagement`;

// ─── Module state ──────────────────────────────────────────────────────────
let allUsers = [];   // full list returned by the server
let filtered = [];   // after search filter
let currentPage = 1;
let activeUserId = null; // user currently shown in modal
let searchTimer = null;
let destroyed = false;

// ─── DOM helpers ───────────────────────────────────────────────────────────
const $ = (sel, ctx = document) => {
    if (typeof sel !== "string") {
        console.error("Invalid selector:", sel);
        return null;
    }
    return ctx.querySelector(sel);
};

// ─── Avatar ─────────────────────────────────────────────────────────────────
function buildAvatar(user, size = 36) {
    if (user.avatarUrl !== "null") {
        return `<img src="${getContextPath()}/${user.avatarUrl}" alt="${escHtml(user.username)}"
                     class="um-avatar" width="${size}" height="${size}"
                     onerror="this.replaceWith(buildFallbackAvatar('${escHtml(user.username)}', ${user.id}))">`;
    }
    const letter = (user.username || "?")[0].toUpperCase();
    const color = user.id % AVATAR_COLORS;
    return `<div class="um-avatar-fallback" data-color="${color}" style="width:${size}px;height:${size}px">${letter}</div>`;
}

function roleBadge(role) {
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

function escHtml(str) {
    return String(str ?? "")
        .replace(/&/g, "&amp;").replace(/</g, "&lt;")
        .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function fmtDate(iso) {
    if (!iso) return "—";
    return new Date(iso).toLocaleDateString("en-US", {year: "numeric", month: "short", day: "numeric"});
}

function fmtMoney(amount) {
    if (amount == null) return "—";
    return new Intl.NumberFormat("en-US", {style: "currency", currency: "USD"}).format(amount);
}

// ─── Render table rows ───────────────────────────────────────────────────────
function renderRows() {
    const tbody = $("#um-tbody");
    const noResults = $("#um-no-results");
    const pagination = $("#um-pagination");

    if (!tbody) return;

    if (filtered.length === 0) {
        tbody.innerHTML = "";
        noResults?.classList.remove("hidden");
        pagination?.classList.add("hidden");
        return;
    }

    noResults?.classList.add("hidden");

    const start = (currentPage - 1) * PAGE_SIZE;
    const page = filtered.slice(start, start + PAGE_SIZE);

    tbody.innerHTML = page.map(user => `
        <tr>
            <td>
                <div class="flex items-center gap-3">
                    ${buildAvatar(user)}
                    <span class="font-medium text-foreground">${escHtml(user.username)}</span>
                </div>
            </td>
            <td class="text-muted-foreground">${escHtml(user.email)}</td>
            <td>${roleBadge(user.role)}</td>
            <td class="text-muted-foreground text-xs">${fmtDate(user.createdAt)}</td>
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

    renderPagination();
}

// ─── Pagination ───────────────────────────────────────────────────────────────
function renderPagination() {
    const pagination = $("#um-pagination");
    const pageInfo = $("#um-page-info");
    const btnsWrap = $("#um-page-btns");

    if (!pagination) return;

    const totalPages = Math.ceil(filtered.length / PAGE_SIZE);

    if (totalPages <= 1) {
        pagination.classList.add("hidden");
        return;
    }

    pagination.classList.remove("hidden");

    const start = (currentPage - 1) * PAGE_SIZE + 1;
    const end = Math.min(currentPage * PAGE_SIZE, filtered.length);
    if (pageInfo) pageInfo.textContent = `${start}–${end} of ${filtered.length} users`;

    // Build page numbers (always show first, last, current ±1 and ellipsis)
    const pages = buildPageRange(currentPage, totalPages);
    if (!btnsWrap) return;

    btnsWrap.innerHTML = `
        <button class="um-page-btn" data-page="prev" ${currentPage === 1 ? "disabled" : ""} aria-label="Previous page">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="m15 18-6-6 6-6"/>
            </svg>
        </button>
        ${pages.map(p => p === "…"
        ? `<span class="text-xs text-muted-foreground px-1">…</span>`
        : `<button class="um-page-btn ${p === currentPage ? "active" : ""}" data-page="${p}">${p}</button>`
    ).join("")}
        <button class="um-page-btn" data-page="next" ${currentPage === totalPages ? "disabled" : ""} aria-label="Next page">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="m9 18 6-6-6-6"/>
            </svg>
        </button>
    `;
}

function buildPageRange(current, total) {
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

// ─── Search filter ────────────────────────────────────────────────────────────
function applySearch(query) {
    const q = query.trim().toLowerCase();
    filtered = q
        ? allUsers.filter(u =>
            u.username?.toLowerCase().includes(q) ||
            u.email?.toLowerCase().includes(q))
        : [...allUsers];
    currentPage = 1;
    renderRows();

    // Update count label
    const label = $("#um-total-label");
    if (label) label.textContent = `(${filtered.length} users)`;
}

// ─── Modal helpers ────────────────────────────────────────────────────────────
function openModal() {
    const backdrop = $("#um-modal-backdrop");
    backdrop?.classList.add("is-open");
    document.body.style.overflow = "hidden";
}

function closeModal() {
    const backdrop = $("#um-modal-backdrop");
    backdrop?.classList.remove("is-open");
    document.body.style.overflow = "";
    activeUserId = null;
}

// ─── Populate modal with basic user data (from the already-loaded list) ──────
function populateModalBase(user) {
    // Avatar
    const avatarWrap = $("#um-modal-avatar-wrap");
    if (avatarWrap) avatarWrap.innerHTML = buildAvatar(user, 52);

    // Text fields
    const setTxt = (id, val) => {
        const el = document.getElementById(id);
        if (el) el.textContent = val ?? "—";
    };
    setTxt("um-modal-name", user.username);
    setTxt("um-modal-email", user.email);
    setTxt("um-modal-joined", fmtDate(user.createdAt));

    // Role badge
    const roleWrap = $("#um-modal-role-wrap");
    if (roleWrap) roleWrap.innerHTML = roleBadge(user.role);

    // Admin toggle
    const toggle = document.getElementById("um-admin-toggle");
    if (toggle) {
        toggle.checked = user.role?.toLowerCase() === "admin";
        toggle.dataset.userId = user.id;
    }

    // Reset stats
    setTxt("um-modal-orders", "…");
    setTxt("um-modal-spent", "…");

    // Reset orders list
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

// ─── Fetch user details + order history ──────────────────────────────────────
async function fetchUserDetails(userId) {
    try {
        const res = await fetch(
            `${getContextPath()}/admin/dashboard/control?tab=user-management&action=details&userId=${userId}`,
            {
                method: 'GET',
                cache: 'no-store',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
            }
        );
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const data = await res.json();

        if (activeUserId !== userId) return; // user switched modals

        const setTxt = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.textContent = val ?? "—";
        };
        setTxt("um-modal-orders", data.totalOrders ?? 0);
        setTxt("um-modal-spent", fmtMoney(data.totalSpent));

        // Render order rows
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

        ordersList.innerHTML = data.recentOrders.map(order => {
            const statusClass = {
                "delivered": "status-delivered",
                "processing": "status-processing",
                "cancelled": "status-cancelled"
            }[order.status?.toLowerCase()] ?? "status-processing";

            return `
                <div class="um-order-row">
                    <span class="text-foreground font-medium truncate">#${escHtml(String(order.id))}</span>
                    <span class="um-order-status ${statusClass}">${escHtml(order.status ?? "Processing")}</span>
                    <span class="text-muted-foreground text-right">${fmtMoney(order.total)}</span>
                </div>`;
        }).join("");
    } catch (err) {
        console.error('Failed to load user details:', err);
        const ordersList = $("#um-modal-orders-list");
        if (ordersList) {
            ordersList.innerHTML = `<p class="text-xs text-red-500 py-3 text-center">Could not load order history.</p>`;
        }
    }
}

// ─── Grant / revoke admin ─────────────────────────────────────────────────────
async function handleAdminToggle(toggle) {
    const userId = toggle.dataset.userId;
    const isAdmin = toggle.checked;
    const spinner = $("#um-toggle-spinner");

    if (spinner) spinner.classList.remove("hidden");
    toggle.disabled = true;

    try {
        const res = await fetch(
            `${getContextPath()}/admin/dashboard/control?tab=user-management&action=setRole`,
            {
                method: 'POST',
                cache: 'no-store',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({userId, role: isAdmin ? 'ADMIN' : 'USER'}),
            }
        );
        if (!res.ok) throw new Error('HTTP ' + res.status);
        await res.json();

        // Update local data
        const user = allUsers.find(u => String(u.id) === String(userId));
        if (user) {
            user.role = isAdmin ? 'ADMIN' : 'USER';
            // Refresh role badge in modal
            const roleWrap = $("#um-modal-role-wrap");
            if (roleWrap) roleWrap.innerHTML = roleBadge(user.role);
            // Refresh role badge in table row
            renderRows();
        }
    } catch (err) {
        console.error('Failed to update user role:', err);
        // Revert toggle on error
        toggle.checked = !isAdmin;
    } finally {
        toggle.disabled = false;
        if (spinner) spinner.classList.add("hidden");
    }
}

// ─── Event delegation ─────────────────────────────────────────────────────────
function bindEvents() {
    // View button → open modal
    document.addEventListener("click", e => {
        if (destroyed) return;

        const actionBtn = e.target.closest(".um-action-btn");
        if (actionBtn) {
            const userId = actionBtn.dataset.userId;
            const user = allUsers.find(u => String(u.id) === String(userId));
            if (!user) return;
            activeUserId = userId;
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
            const totalPages = Math.ceil(filtered.length / PAGE_SIZE);
            if (p === "prev" && currentPage > 1) currentPage--;
            else if (p === "next" && currentPage < totalPages) currentPage++;
            else if (!isNaN(+p)) currentPage = +p;
            renderRows();
        }
    });

    // Keyboard close
    document.addEventListener("keydown", e => {
        if (!destroyed && e.key === "Escape") closeModal();
    });

    // Search with debounce
    const searchInput = $("#um-search");
    if (searchInput) {
        searchInput.addEventListener("input", e => {
            clearTimeout(searchTimer);
            searchTimer = setTimeout(() => applySearch(e.target.value), 250);
        });
    }

    // Admin toggle
    const adminToggle = document.getElementById("um-admin-toggle");
    if (adminToggle) {
        adminToggle.addEventListener("change", () => handleAdminToggle(adminToggle));
    }
}

// Load users from server
async function loadUsers() {
    try {
        const res = await fetch(USER_MANAGEMENT_URL+'?getUsers=true', {
                method: 'GET',
                cache: 'no-store',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
            }
        );
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const data = await res.json();

        if (destroyed) return;
        allUsers = data.users ?? data ?? [];
        filtered = [...allUsers];

        // Update total label
        const label = $("#um-total-label");
        if (label) label.textContent = `(${allUsers.length} users)`;

        renderRows();
    } catch (err) {
        console.error('Failed to load users:', err);
        if (destroyed) return;
        const tbody = $("#um-tbody");
        if (tbody) tbody.innerHTML = "";
        $("#um-error")?.classList.remove("hidden");
    }
}

// Public lifecycle
export function initUserManagement() {
    console.log("User Management Init");
    destroyed = false;

    const $mainContent = $("#main-content");
    if (!$mainContent) return;

    fetch(`${getContextPath()}/admin/dashboard/control?tab=user-management`)
        .then(r => r.text())
        .then(html => {
            if (destroyed) return;
            $mainContent.innerHTML = html;

            // Inject CSS if not already loaded
            if (!document.getElementById("um-css")) {
                const link = document.createElement("link");
                link.id = "um-css";
                link.rel = "stylesheet";
                link.href = `${getContextPath()}/assets/css/user-management.css`;
                document.head.appendChild(link);
            }

            initVisibility(); // ✅ add this
            bindEvents();
            loadUsers();
        })
        .catch(err => console.error("User Management load error:", err));
}

function initVisibility() {
    $("#um-error")?.classList.add("hidden");
    $("#um-no-results")?.classList.add("hidden");
}

export function destroyUserManagement() {
    destroyed = true;
    closeModal();
    clearTimeout(searchTimer);
    // Reset state for fresh mount next time
    allUsers = [];
    filtered = [];
    currentPage = 1;
    activeUserId = null;
}