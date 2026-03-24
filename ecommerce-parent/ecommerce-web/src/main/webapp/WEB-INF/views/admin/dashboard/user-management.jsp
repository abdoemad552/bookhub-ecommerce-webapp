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
          <th>Actions</th>
        </tr>
        </thead>
        <tbody id="um-tbody">
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

<!--USER DETAIL MODAL -->
<div id="um-modal-backdrop" role="dialog" aria-modal="true" aria-labelledby="um-modal-title">
  <div id="um-modal-panel">

    <!-- ── Hero banner (avatar + name + email + role) ── -->
    <div class="um-modal-hero shrink-0">
      <!-- Close button -->
      <button id="um-modal-close" class="um-modal-hero-close" aria-label="Close">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M18 6 6 18"/>
          <path d="m6 6 12 12"/>
        </svg>
      </button>

      <div class="flex items-center gap-4">
        <div id="um-modal-avatar-wrap" class="um-modal-avatar-ring"></div>
        <div class="min-w-0 flex-1">
          <p id="um-modal-name" class="text-lg font-bold text-foreground truncate leading-tight"></p>
          <p id="um-modal-email" class="text-sm text-muted-foreground truncate mt-0.5"></p>
          <div id="um-modal-role-wrap" class="mt-2"></div>
        </div>
      </div>

      <!-- Stats strip inside hero -->
      <div class="um-stats-strip">
        <div class="um-stat-pill">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M16 10a4 4 0 0 1-8 0"/>
            <path d="M3.103 6.034h17.794"/>
            <path d="M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z"/>
          </svg>
          <div>
            <span class="um-stat-pill-label">Total Orders</span>
            <span id="um-modal-orders" class="um-stat-pill-value">—</span>
          </div>
        </div>
        <div class="um-stat-divider"></div>
        <div class="um-stat-pill">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" x2="12" y1="2" y2="22"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
          </svg>
          <div>
            <span class="um-stat-pill-label">Total Spent</span>
            <span id="um-modal-spent" class="um-stat-pill-value">—</span>
          </div>
        </div>
      </div>
    </div>

    <!-- ── Scrollable body ── -->
    <div id="um-modal-body">

      <!-- Recent Orders section -->
      <div class="px-5 pt-5 pb-1">
        <div class="flex items-center justify-between mb-3">
          <p class="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Recent Orders</p>
        </div>
        <div id="um-modal-orders-list">
          <!-- Populated by JS — loading state shown initially via populateModalBase -->
        </div>
      </div>

    </div>

    <!-- ── Footer: Grant / Revoke + Close ── -->
    <div class="um-modal-footer shrink-0">
      <button id="um-role-action-btn" class="um-footer-role-btn" data-user-id="" data-is-admin="false">
        <span id="um-role-btn-spinner" class="hidden">
          <svg class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" opacity=".25"/>
            <path d="M12 2a10 10 0 0 1 10 10" stroke="currentColor" stroke-width="3" stroke-linecap="round"/>
          </svg>
        </span>
        <span id="um-role-btn-icon">
          <!-- icon swapped by JS -->
        </span>
        <span id="um-role-btn-text">Grant Admin</span>
      </button>
    </div>

  </div>
</div>
