<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="space-y-5" id="um-root">

  <!-- ── Header row ── -->
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
    <div>
      <h2 class="text-lg font-bold text-foreground">User Management</h2>
      <p class="text-sm text-muted-foreground mt-0.5">
        Manage accounts, roles, and activity.
        <span id="um-total-label" class="font-medium text-foreground"></span>
      </p>
    </div>

    <!-- Search -->
    <div class="um-search-wrap">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
           aria-hidden="true">
        <circle cx="11" cy="11" r="8"/>
        <path d="m21 21-4.3-4.3"/>
      </svg>
      <input id="um-search" type="search" class="um-search-input" placeholder="Search users" autocomplete="off"/>
    </div>
  </div>

  <!-- ── Table card ── -->
  <div class="bg-card rounded-xl shadow-sm">
    <div class="um-table-wrapper">
      <table class="um-table" id="um-table">
        <thead>
        <tr>
          <th>User</th>
          <th>Email</th>
          <th>Role</th>
          <th>Joined</th>
          <th></th>
        </tr>
        </thead>
        <tbody id="um-tbody">
        <!-- Skeleton rows while loading -->
        <c:forEach begin="1" end="10">
          <tr>
            <td>
              <div class="flex items-center gap-3">
                <div class="um-skeleton w-9 h-9 rounded-full"></div>
                <div class="um-skeleton h-3.5 w-28 rounded"></div>
              </div>
            </td>
            <td>
              <div class="um-skeleton h-3 w-40 rounded"></div>
            </td>
            <td>
              <div class="um-skeleton h-5 w-16 rounded-full"></div>
            </td>
            <td>
              <div class="um-skeleton h-3 w-20 rounded"></div>
            </td>
            <td>
              <div class="um-skeleton h-7 w-20 rounded-lg"></div>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- Error state (hidden by default) -->
    <div id="um-error" class="um-empty-state hidden">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10"/>
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <p class="font-medium">Failed to load users</p>
      <p class="text-xs">Please refresh the page or try again.</p>
    </div>

    <!-- Empty search state (hidden by default) -->
    <div id="um-no-results" class="um-empty-state hidden">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
           stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"/>
        <path d="m21 21-4.3-4.3"/>
      </svg>
      <p class="font-medium">No users match your search</p>
      <p class="text-xs">Try a different name or email.</p>
    </div>

    <!-- Pagination footer -->
    <div id="um-pagination" class="flex items-center justify-between gap-4 px-4 py-3 border-t border-border hidden">
      <p id="um-page-info" class="text-xs text-muted-foreground"></p>
      <div class="flex items-center gap-1.5" id="um-page-btns"></div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════
USER DETAIL MODAL
════════════════════════════════════════════ -->
<div id="um-modal-backdrop" role="dialog" aria-modal="true" aria-labelledby="um-modal-title">
  <div id="um-modal-panel">

    <!-- Modal header -->
    <div class="flex items-center justify-between px-5 py-4 border-b border-border shrink-0">
      <h3 id="um-modal-title" class="text-base font-bold text-foreground">User Details</h3>
      <button id="um-modal-close"
              class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-muted transition-colors text-muted-foreground hover:text-foreground cursor-pointer"
              aria-label="Close">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M18 6 6 18"/>
          <path d="m6 6 12 12"/>
        </svg>
      </button>
    </div>

    <!-- Modal body (scrollable) -->
    <div id="um-modal-body" class="px-5 py-5 space-y-5">

      <!-- User hero -->
      <div class="flex items-center gap-4">
        <div id="um-modal-avatar-wrap"></div>
        <div class="min-w-0">
          <p id="um-modal-name" class="text-base font-bold text-foreground truncate"></p>
          <p id="um-modal-email" class="text-sm text-muted-foreground truncate"></p>
          <div id="um-modal-role-wrap" class="mt-1.5"></div>
        </div>
      </div>

      <!-- Stats row -->
      <div class="flex gap-3">
        <div class="um-stat-card">
          <span class="stat-label">Total Orders</span>
          <span id="um-modal-orders" class="stat-value">—</span>
        </div>
        <div class="um-stat-card">
          <span class="stat-label">Total Spent</span>
          <span id="um-modal-spent" class="stat-value">—</span>
        </div>
        <div class="um-stat-card">
          <span class="stat-label">Member Since</span>
          <span id="um-modal-joined" class="stat-value text-base!"></span>
        </div>
      </div>

      <!-- Grant admin toggle -->
      <div class="um-toggle-wrap">
        <label class="um-toggle" id="um-toggle-label">
          <input type="checkbox" id="um-admin-toggle"/>
          <span class="um-toggle-slider"></span>
        </label>
        <div class="min-w-0">
          <p class="text-sm font-semibold text-foreground">Grant Admin Access</p>
          <p class="text-xs text-muted-foreground mt-0.5">Admin users can manage products, orders, and other users.</p>
        </div>
        <span id="um-toggle-spinner" class="ml-auto shrink-0 hidden">
                    <svg class="animate-spin w-4 h-4 text-muted-foreground" viewBox="0 0 24 24" fill="none">
                        <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" opacity=".25"/>
                        <path d="M12 2a10 10 0 0 1 10 10" stroke="currentColor" stroke-width="3"
                              stroke-linecap="round"/>
                    </svg>
                </span>
      </div>

      <!-- Order history -->
      <div>
        <p class="text-xs font-semibold uppercase tracking-wider text-muted-foreground mb-2">Recent Orders</p>
        <div id="um-modal-orders-list" class="space-y-0">
          <!-- populated by JS -->
          <div class="um-empty-state py-6 text-xs">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M16 10a4 4 0 0 1-8 0"/>
              <path d="M3.103 6.034h17.794"/>
              <path d="M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z"/>
            </svg>
            <p>No orders yet</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal footer -->
    <div class="px-5 py-4 border-t border-border shrink-0 flex justify-end">
      <button id="um-modal-close-btn"
              class="inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-border bg-transparent font-semibold text-sm text-muted-foreground hover:text-foreground hover:border-foreground/30 transition-colors cursor-pointer">
        Close
      </button>
    </div>
  </div>
</div>
