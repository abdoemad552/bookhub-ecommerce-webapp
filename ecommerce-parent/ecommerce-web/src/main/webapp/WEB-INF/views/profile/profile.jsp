<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html lang="en">
<head>
  <meta charSet="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
  <meta name="description" content="Manage your BookHub profile, orders, addresses, credit, and account security."/>
  <meta name="generator" content="BookHub"/>
  <title>BookHub - My Profile</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/bookhub-favicon.svg">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-payment-review.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">

  <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
  <script type="module" src="${pageContext.request.contextPath}/assets/js/profile/profile.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
  <jsp:include page="../common/header.jsp"/>

  <main class="max-w-6xl mx-auto px-4 sm:px-6 py-8 profile-layout"
        data-active-tab="${empty requestScope.profile_active_tab ? 'profile-info' : requestScope.profile_active_tab}">

    <%-- ── Alerts ── --%>
    <c:if test="${not empty requestScope.profile_success_message}">
      <div class="profile-alert profile-alert-success mb-5">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="shrink-0">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <polyline points="22 4 12 14.01 9 11.01"/>
        </svg>
        <span>${requestScope.profile_success_message}</span>
      </div>
    </c:if>
    <c:if test="${not empty requestScope.profile_error_message}">
      <div class="profile-alert profile-alert-error mb-5">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" class="shrink-0">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <span>${requestScope.profile_error_message}</span>
      </div>
    </c:if>

    <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">

      <%-- ════════════════════════
           SIDEBAR
      ════════════════════════ --%>
      <div class="lg:col-span-1">
        <div class="profile-sidebar-card bg-card text-card-foreground flex flex-col gap-4 rounded-2xl border shadow-sm p-5 sticky top-24">

          <%-- User identity --%>
          <div class="flex items-center gap-3 pb-4 border-b border-border">
            <div class="flex flex-col items-center justify-center w-full gap-3">
              <div class="profile-avatar-wrap">
                <div class="profile-avatar">
                  <button type="button"
                          data-upload-profile
                          data-user-id="${sessionScope.user.id}"
                          aria-label="Change profile image for ${sessionScope.user.username}"
                          class="group relative w-full h-full rounded overflow-hidden shrink-0 flex items-center justify-center text-muted-foreground cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    <c:choose>
                      <c:when test="${sessionScope.user.profilePicUrl != null}">
                        <img src="${pageContext.request.contextPath}/${sessionScope.user.profilePicUrl}"
                             alt="Cover of ${sessionScope.user.username}" loading="lazy"
                             class="w-full h-full object-cover rounded-full">
                      </c:when>
                      <c:otherwise>
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="1.6"
                             stroke-linecap="round" stroke-linejoin="round" class="text-primary">
                          <circle cx="12" cy="8" r="4"/>
                          <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
                        </svg>
                      </c:otherwise>
                    </c:choose>
                    <!-- hover overlay -->
                    <span class="absolute inset-0 bg-black/50 flex items-center justify-center text-white opacity-0 group-hover:opacity-100 transition-opacity duration-150 pointer-events-none rounded-full"
                          aria-hidden="true">
                                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                       fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                       stroke-linejoin="round" aria-hidden="true">
                                      <path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3z"/>
                                      <circle cx="12" cy="13" r="3"/>
                                  </svg>
                              </span>
                  </button>
                </div>
              </div>
              <div class="min-w-0 flex-1 ">
                <c:choose>
                  <c:when test="${not empty requestScope.profileUser.firstName or not empty requestScope.profileUser.lastName}">
                    <p class="profile-user-name text-foreground truncate">
                        ${requestScope.profileUser.firstName} ${requestScope.profileUser.lastName}
                    </p>
                  </c:when>
                  <c:otherwise>
                    <p class="profile-user-name text-foreground truncate">
                        ${requestScope.profileUser.username}
                    </p>
                  </c:otherwise>
                </c:choose>
                <p class="profile-user-email text-muted-foreground truncate text-center">${requestScope.profileUser.username}</p>
              </div>
            </div>
          </div>

          <%-- Quick stats --%>
          <div class="profile-stat-row">
            <div class="profile-stat-pill">
              <span class="profile-stat-value">${fn:length(requestScope.profileOrders)}</span>
              <span class="profile-stat-label">Orders</span>
            </div>
            <div class="profile-stat-pill">
              <span class="profile-stat-value">${fn:length(requestScope.profileWishlistBooks)}</span>
              <span class="profile-stat-label">Saved</span>
            </div>
            <div class="profile-stat-pill">
              <span class="profile-stat-value">${fn:length(requestScope.profileAddresses.addresses)}</span>
              <span class="profile-stat-label">Addrs</span>
            </div>
          </div>

          <%-- Nav — JS adds/removes .tab-active and bg-primary/text-background --%>
          <nav class="flex flex-col gap-0.5">
            <button type="button" data-tab="profile-info" class="profile-tab">
              <svg class="tab-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="8" r="4"/>
                <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
              </svg>
              Profile
            </button>
            <button type="button" data-tab="interests-info" class="profile-tab">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" stroke-width="2" fill="currentColor"
                   class="bi bi-filter" viewBox="0 0 16 16">
                <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5"/>
              </svg>
              Interests
            </button>
            <button type="button" data-tab="orders-info" class="profile-tab">
              <svg class="tab-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                <line x1="3" y1="6" x2="21" y2="6"/>
                <path d="M16 10a4 4 0 0 1-8 0"/>
              </svg>
              Orders
            </button>
            <button type="button" data-tab="wishlist-info" class="profile-tab">
              <svg class="tab-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
              </svg>
              Wishlist
            </button>
            <button type="button" data-tab="addresses-info" class="profile-tab">
              <svg class="tab-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                <circle cx="12" cy="10" r="3"/>
              </svg>
              Addresses
            </button>
            <button type="button" data-tab="credit-manage-info" class="profile-tab">
              <svg class="tab-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
                <line x1="1" y1="10" x2="23" y2="10"/>
              </svg>
              Credit
            </button>
          </nav>
        </div>
      </div>

      <%-- ════════════════════════
           MAIN PANELS
      ════════════════════════ --%>
      <div class="lg:col-span-3">

        <%-- ── Unified Form (wraps Profile Info + Interests panels) ── --%>
        <form id="profile-update-form" action="${pageContext.request.contextPath}/profile" method="post" novalidate>
          <input type="hidden" id="formActionField" name="formAction" value="update-profile"/>

          <%-- ── Profile Info ── --%>
          <div id="profile-info"
               class="profile-panel bg-card text-card-foreground rounded-2xl border shadow-sm p-6 lg:p-7">
            <div class="panel-header">
              <div>
                <h2 class="text-foreground">Profile Information</h2>
                <p class="text-muted-foreground">Update your personal details and account settings.</p>
              </div>
            </div>

            <div class="profile-form-section">

              <div class="profile-form-row cols-2">
                <div class="profile-field stagger-1 animate-slide-up">
                  <label class="profile-label">First Name</label>
                  <input type="text" name="firstName" id="firstName" class="profile-input input-modern"
                         value="${requestScope.profileUser.firstName}"/>
                </div>
                <div class="profile-field stagger-2 animate-slide-up">
                  <label class="profile-label">Last Name</label>
                  <input type="text" name="lastName" id="lastName" class="profile-input input-modern"
                         value="${requestScope.profileUser.lastName}"/>
                </div>
              </div>

              <div class="profile-form-row cols-2">
                <div class="profile-field stagger-3 animate-slide-up">
                  <label class="profile-label">Username</label>
                  <input type="text" class="profile-input" value="${requestScope.profileUser.username}" readonly/>
                </div>
                <div class="profile-field stagger-4 animate-slide-up">
                  <label class="profile-label">Email Address</label>
                  <input type="email" class="profile-input" value="${requestScope.profileUser.email}" readonly/>
                </div>
              </div>

              <div class="profile-form-row cols-2">
                <div class="profile-field stagger-5 animate-slide-up">
                  <label class="profile-label">Job Title</label>
                  <input type="text" name="job" class="profile-input input-modern"
                         value="${requestScope.profileUser.job}" placeholder="e.g. Software Engineer"/>
                </div>
                <div class="profile-field stagger-6 animate-slide-up">
                  <label class="profile-label">Birth Date</label>
                  <input type="date" name="birthDate" class="profile-input input-modern"
                         value="${requestScope.profileUser.birthDate}"/>
                </div>
              </div>

              <%-- Email notifications toggle --%>
              <label class="profile-toggle-row animate-slide-up stagger-1">
                <div class="profile-toggle-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                       fill="none" stroke="currentColor" stroke-width="2"
                       stroke-linecap="round" stroke-linejoin="round" class="text-primary">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                    <polyline points="22,6 12,13 2,6"/>
                  </svg>
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-semibold text-foreground">Email Notifications</p>
                  <p class="text-xs text-muted-foreground mt-0.5">Allow BookHub to send account and order emails.</p>
                </div>
                <div class="toggle-wrap shrink-0">
                  <input type="checkbox" name="emailNotifications"
                         <c:if test="${requestScope.profileUser.emailNotifications}">checked</c:if>/>
                  <span class="toggle-track"></span>
                </div>
              </label>

              <div class="profile-section-divider"><span>Security</span></div>

              <%-- Change password --%>
              <div class="profile-section-card animate-slide-up stagger-2">
                <div class="mb-4">
                  <h3 class="text-foreground">Change Password</h3>
                  <p class="text-xs text-muted-foreground mt-1">
                    Leave blank if you don't want to change. New passwords must be at least 8 characters.
                  </p>
                </div>
                <div class="profile-form-row cols-3">
                  <div class="profile-field">
                    <label class="profile-label">Current Password</label>
                    <input id="currentPassword" type="password" name="currentPassword"
                           autocomplete="current-password" class="profile-input input-modern"/>
                  </div>
                  <div class="profile-field">
                    <label class="profile-label">New Password</label>
                    <input id="newPassword" type="password" name="newPassword"
                           autocomplete="new-password" class="profile-input input-modern"/>
                  </div>
                  <div class="profile-field">
                    <label class="profile-label">Confirm New Password</label>
                    <input id="confirmNewPassword" type="password" name="confirmNewPassword"
                           autocomplete="new-password" class="profile-input input-modern"/>
                  </div>
                </div>
                <p id="password-validation-message" class="mt-3 text-muted-foreground text-sm"></p>
              </div>

              <div class="flex justify-end pt-1">
                <button type="submit" class="profile-save-btn"
                        onclick="document.getElementById('formActionField').value='update-profile'">
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                       fill="none" stroke="currentColor" stroke-width="2.5"
                       stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                    <polyline points="17 21 17 13 7 13 7 21"/>
                    <polyline points="7 3 7 8 15 8"/>
                  </svg>
                  Save Changes
                </button>
              </div>
            </div>
          </div>

          <%-- ── Interests ── --%>
          <div id="interests-info"
               class="profile-panel hidden bg-card text-card-foreground rounded-2xl border shadow-sm p-6 lg:p-7">
            <div>

              <div class="interests-panel-header-row">
                <div>
                  <h2 class="text-foreground" style="font-size:1.3rem;font-weight:700;letter-spacing:-0.025em;margin:0">
                    My Interests</h2>
                  <p class="text-muted-foreground" style="margin-top:4px;font-size:0.8rem">
                    Choose categories BookHub remembers for your account.
                  </p>
                </div>
                <div id="profile-selected-interests-count"
                     class="inline-flex items-center border border-primary/20 bg-primary/10 text-primary">
                  0 selected
                </div>
              </div>

              <div id="profile-selected-interests" class="interests-selected-banner"></div>

              <c:choose>
                <c:when test="${empty requestScope.profileAvailableCategories}">
                  <div class="profile-empty-state">
                    <div class="profile-empty-icon">
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                           fill="none" stroke="currentColor" stroke-width="1.8"
                           stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                      </svg>
                    </div>
                    <p class="text-sm text-muted-foreground">No categories available right now.</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-2.5">
                    <c:forEach items="${requestScope.profileAvailableCategories}" var="category">
                      <label data-interest-option
                             class="interest-option-card flex items-start gap-3 bg-card cursor-pointer">
                        <input type="checkbox"
                               name="interestIds"
                               value="${category.id}"
                               data-interest-name="${category.name}"
                               class="checkbox-modern profile-interest-checkbox mt-0.5 h-4 w-4 rounded border-border text-primary focus:ring-primary shrink-0"
                               <c:if test="${requestScope.profileInterestSelections[category.id]}">checked</c:if>/>
                        <div class="min-w-0">
                          <p class="text-sm font-semibold text-foreground">${category.name}</p>
                          <c:if test="${not empty category.description}">
                            <p class="mt-0.5 text-xs text-muted-foreground line-clamp-2">${category.description}</p>
                          </c:if>
                        </div>
                      </label>
                    </c:forEach>
                  </div>
                </c:otherwise>
              </c:choose>

              <div class="flex justify-end mt-5">
                <button type="submit" class="profile-save-btn"
                        onclick="document.getElementById('formActionField').value='update-interests'">
                  <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                       fill="none" stroke="currentColor" stroke-width="2.5"
                       stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                    <polyline points="17 21 17 13 7 13 7 21"/>
                    <polyline points="7 3 7 8 15 8"/>
                  </svg>
                  Save Interests
                </button>
              </div>
            </div>
          </div>
        </form>
        <%-- end unified profile-update-form --%>

        <%-- ── Orders ── --%>
        <div id="orders-info"
             class="profile-panel hidden bg-card text-card-foreground rounded-2xl border shadow-sm p-6 lg:p-7">
          <div class="panel-header">
            <div>
              <h2 class="text-foreground">Order History</h2>
              <p class="text-muted-foreground">All your past and current orders in one place.</p>
            </div>
          </div>
          <c:choose>
            <c:when test="${empty requestScope.profileOrders}">
              <div class="profile-empty-state">
                <div class="profile-empty-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24"
                       fill="none" stroke="currentColor" stroke-width="1.8"
                       stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground">
                    <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                  </svg>
                </div>
                <p class="text-sm font-semibold text-foreground">No orders yet</p>
                <p class="text-sm text-muted-foreground">Your orders will appear here once you place one.</p>
              </div>
            </c:when>
            <c:otherwise>
              <div class="flex flex-col gap-3">
                <c:forEach items="${requestScope.profileOrders}" var="order">
                  <a href="${pageContext.request.contextPath}/order-confirmation?orderId=${order.orderId}"
                     class="order-card">
                    <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                      <div class="flex flex-col gap-1.5">
                        <p class="font-bold text-foreground text-sm tracking-tight">${order.orderCode}</p>
                        <p class="text-xs text-muted-foreground">${order.createdAt}</p>
                        <c:choose>
                          <c:when test="${order.orderStatus.prettyName eq 'Delivered'}">
                            <span class="order-status-badge status-delivered">${order.orderStatus.prettyName}</span>
                          </c:when>
                          <c:when test="${order.orderStatus.prettyName eq 'Canceled'}">
                            <span class="order-status-badge status-canceled">${order.orderStatus.prettyName}</span>
                          </c:when>
                          <c:otherwise>
                            <span class="order-status-badge status-pending">${order.orderStatus.prettyName}</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                      <div class="flex items-center gap-3">
                        <p class="text-lg font-bold text-foreground tracking-tight">${order.totalPrice} EGP</p>
                        <div class="order-card-arrow text-foreground">
                          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                               viewBox="0 0 24 24" fill="none" stroke="currentColor"
                               stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m9 18 6-6-6-6"/>
                          </svg>
                        </div>
                      </div>
                    </div>
                  </a>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <%-- ── Wishlist ── --%>
        <div id="wishlist-info"
             class="profile-panel hidden bg-card text-card-foreground rounded-2xl border shadow-sm p-6 lg:p-7">
          <div class="panel-header">
            <div>
              <h2 class="text-foreground">Wishlist</h2>
              <p class="text-muted-foreground">Your saved books appear here.</p>
            </div>
          </div>
          <c:choose>
            <c:when test="${empty requestScope.profileWishlistBooks}">
              <div class="profile-empty-state">
                <div class="profile-empty-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24"
                       fill="none" stroke="currentColor" stroke-width="1.8"
                       stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                  </svg>
                </div>
                <p class="text-sm font-semibold text-foreground">Your wishlist is empty</p>
                <p class="text-sm text-muted-foreground">Browse books and save the ones you love.</p>
              </div>
            </c:when>
            <c:otherwise>
              <%-- ★ Fixed: semantic BEM elements instead of ad-hoc utility mix ★ --%>
              <div class="grid grid-cols-1 xl:grid-cols-2 gap-4">
                <c:forEach items="${requestScope.profileWishlistBooks}" var="book">
                  <div onclick="if(event.target.closest('[data-remove-wishlist-button]'))return; window.location.href='${pageContext.request.contextPath}/books/${book.id}'"
                       class="wishlist-card bg-card border shadow-sm cursor-pointer">

                      <%-- Cover --%>
                    <div class="wishlist-card-cover">
                      <c:choose>
                        <c:when test="${not empty book.coverPicUrl}">
                          <img src="${book.coverPicUrl}" alt="${book.title}"/>
                        </c:when>
                        <c:otherwise>
                          <div class="wishlist-cover-placeholder">
                            <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28"
                                 viewBox="0 0 24 24" fill="none" stroke="#b39d95"
                                 stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                              <path d="M12 7v14"/>
                              <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"/>
                            </svg>
                          </div>
                        </c:otherwise>
                      </c:choose>
                    </div>

                      <%-- Body --%>
                    <div class="wishlist-card-body select-none">
                      <div class="flex items-start justify-between gap-2">
                        <p class="wishlist-card-title">${book.title}</p>
                        <c:if test="${book.stockQuantity le 0}">
                          <span class="oos-badge shrink-0">
                            <svg class="oos-icon" width="13" height="13" viewBox="0 0 13 13" fill="none"
                                 xmlns="http://www.w3.org/2000/svg">
                              <circle cx="6.5" cy="6.5" r="5.5" stroke="currentColor" stroke-width="1.5"/>
                              <line x1="3.5" y1="3.5" x2="9.5" y2="9.5" stroke="currentColor" stroke-width="1.5"
                                    stroke-linecap="round"/>
                            </svg>
                          </span>
                        </c:if>
                      </div>

                      <p class="wishlist-card-authors">
                        <c:forEach items="${book.authors}" var="author" varStatus="status">
                          ${author.name}<c:if test="${not status.last}">, </c:if>
                        </c:forEach>
                      </p>

                      <div class="wishlist-card-stars">
                        <c:forEach begin="1" end="${book.averageRating}">
                          <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                               viewBox="0 0 24 24" fill="currentColor" class="text-accent">
                            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"/>
                          </svg>
                        </c:forEach>
                        <c:forEach begin="1" end="${5 - book.averageRating}">
                          <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                               viewBox="0 0 24 24" fill="none" stroke="currentColor"
                               stroke-width="2" class="text-accent">
                            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"/>
                          </svg>
                        </c:forEach>
                      </div>

                      <p class="wishlist-card-desc">${book.description}</p>

                      <div class="wishlist-card-footer">
                        <span class="wishlist-card-price">${book.price} EGP</span>
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                          <input type="hidden" name="formAction" value="remove-wishlist"/>
                          <input type="hidden" name="bookId" value="${book.id}"/>
                          <button type="submit" data-remove-wishlist-button class="profile-danger-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                 stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                              <polyline points="3 6 5 6 21 6"/>
                              <path d="M19 6l-1 14H6L5 6"/>
                              <path d="M10 11v6"/>
                              <path d="M14 11v6"/>
                              <path d="M9 6V4h6v2"/>
                            </svg>
                            Remove
                          </button>
                        </form>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <%-- ── Addresses ── --%>
        <div id="addresses-info"
             class="profile-panel hidden bg-card text-card-foreground rounded-2xl border shadow-sm p-6 lg:p-7">
          <div class="panel-header">
            <div>
              <h2 class="text-foreground">Saved Addresses</h2>
              <p class="text-muted-foreground">Add a new address, or overwrite an existing one by picking the same
                type.</p>
            </div>
          </div>

          <div class="grid grid-cols-1 xl:grid-cols-[1fr_1.15fr] gap-6">
            <form action="${pageContext.request.contextPath}/profile" method="post"
                  class="profile-section-card flex flex-col gap-4">
              <input type="hidden" name="formAction" value="save-address"/>
              <p class="text-sm font-bold text-foreground">New Address</p>

              <div class="profile-form-row cols-2">
                <div class="profile-field">
                  <label class="profile-label">Address Type</label>
                  <select name="addressType" class="profile-select" required>
                    <c:forEach items="${requestScope.addressTypes}" var="addressType">
                      <option value="${addressType}">${addressType.prettyName}</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="profile-field">
                  <label class="profile-label">Government</label>
                  <select name="government" class="profile-select" required>
                    <c:forEach items="${requestScope.governments}" var="government">
                      <option value="${government}">${government.prettyName}</option>
                    </c:forEach>
                  </select>
                </div>
              </div>

              <div class="profile-form-row cols-2">
                <div class="profile-field">
                  <label class="profile-label">City</label>
                  <input type="text" name="city" class="profile-input input-modern" required/>
                </div>
                <div class="profile-field">
                  <label class="profile-label">Building No.</label>
                  <input type="text" name="buildingNo" class="profile-input input-modern" required/>
                </div>
              </div>

              <div class="profile-field">
                <label class="profile-label">Street</label>
                <input type="text" name="street" class="profile-input input-modern" required/>
              </div>

              <div class="profile-field">
                <label class="profile-label">Description
                  <span class="normal-case text-xs font-normal text-muted-foreground">(optional)</span>
                </label>
                <textarea name="description" rows="2" class="profile-textarea"></textarea>
              </div>

              <button type="submit" class="profile-save-btn ">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round">
                  <line x1="12" y1="5" x2="12" y2="19"/>
                  <line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                Save Address
              </button>
            </form>

            <div class="flex flex-col gap-3">
              <c:choose>
                <c:when test="${empty requestScope.profileAddresses or empty requestScope.profileAddresses.addresses}">
                  <div class="profile-empty-state">
                    <div class="profile-empty-icon">
                      <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24"
                           fill="none" stroke="currentColor" stroke-width="1.8"
                           stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                        <circle cx="12" cy="10" r="3"/>
                      </svg>
                    </div>
                    <p class="text-sm font-semibold text-foreground">No saved addresses</p>
                    <p class="text-sm text-muted-foreground">Add one using the form.</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <c:forEach items="${requestScope.profileAddresses.addresses}" var="address">
                    <div class="address-card">
                      <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                        <div class="flex flex-col gap-1.5">
                          <span class="address-type-badge">${address.addressType.prettyName}</span>
                          <p class="text-sm font-semibold text-foreground">${address.street},
                            Building ${address.buildingNo}</p>
                          <p class="text-xs text-muted-foreground">${address.city}, ${address.government.prettyName}</p>
                          <c:if test="${not empty address.description}">
                            <p class="text-xs text-muted-foreground">${address.description}</p>
                          </c:if>
                        </div>
                        <form action="${pageContext.request.contextPath}/profile" method="post" class="shrink-0">
                          <input type="hidden" name="formAction" value="delete-address"/>
                          <input type="hidden" name="addressId" value="${address.id}"/>
                          <button type="submit" class="profile-danger-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                 stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                              <polyline points="3 6 5 6 21 6"/>
                              <path d="M19 6l-1 14H6L5 6"/>
                              <path d="M10 11v6"/>
                              <path d="M14 11v6"/>
                              <path d="M9 6V4h6v2"/>
                            </svg>
                            Delete
                          </button>
                        </form>
                      </div>
                    </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <%-- ── Credit Management ── --%>
        <div id="credit-manage-info"
             class="profile-panel hidden bg-card text-card-foreground rounded-2xl border shadow-sm p-6 lg:p-7">
          <div class="panel-header">
            <div>
              <h2 class="text-foreground">Credit Management</h2>
              <p class="text-muted-foreground">Manage your available account balance.</p>
            </div>
          </div>

          <%-- Visual credit card — uses pay-card CSS from order-payment-review.css ★ --%>
          <div class="pay-card-scene">
            <div class="pay-card">
              <%-- Shine layer --%>
              <div class="pay-card__shine" aria-hidden="true"></div>

              <%-- Top row: SVG chip + brand --%>
              <div style="display:flex;align-items:center;justify-content:space-between;">
                <div class="pay-card__chip" aria-hidden="true">
                  <svg viewBox="0 0 36 28" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="1" y="1" width="34" height="26" rx="4"
                          stroke="rgba(0,0,0,.25)" stroke-width="1.5"
                          fill="url(#profileChipGold)"/>
                    <line x1="13" y1="1" x2="13" y2="27" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                    <line x1="23" y1="1" x2="23" y2="27" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                    <line x1="1" y1="10" x2="35" y2="10" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                    <line x1="1" y1="18" x2="35" y2="18" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                    <defs>
                      <linearGradient id="profileChipGold" x1="0" y1="0" x2="1" y2="1">
                        <stop offset="0%" stop-color="#e8c97a"/>
                        <stop offset="50%" stop-color="#f5e09a"/>
                        <stop offset="100%" stop-color="#c8a84b"/>
                      </linearGradient>
                    </defs>
                  </svg>
                </div>
                <div class="pay-card__network">
                  <span class="pay-card__visa-text">VCARD</span>
                </div>
              </div>

              <%-- Card number placeholder --%>
              <div class="pay-card__number">
                <span>••••</span><span>••••</span><span>••••</span><span>2636</span>
              </div>

              <%-- Bottom row: holder + balance --%>
              <div class="pay-card__bottom">
                <div>
                  <span class="pay-card__meta-label">Card Holder</span>
                  <span class="pay-card__holder">${requestScope.profileUser.username}</span>
                </div>
                <div style="text-align:right">
                  <span class="pay-card__meta-label">Available Balance</span>
                  <span class="pay-card__avail">${requestScope.profileUser.creditLimit} EGP</span>
                </div>
              </div>

              <%-- Usage bar --%>
              <div class="pay-card__bar-track">
                <div class="pay-card__bar-fill" style="width:0%"></div>
              </div>
            </div>
          </div>

          <form action="${pageContext.request.contextPath}/profile" method="post"
                class="profile-form-section">
            <input type="hidden" name="formAction" value="credit-settings"/>

            <div class="profile-field">
              <label class="profile-label">Credit Limit</label>
              <input type="number" name="creditLimit" step="0.01" min="0" required
                     class="profile-input input-modern"
                     value="${requestScope.profileUser.creditLimit}"/>
              <p class="text-xs text-muted-foreground mt-1">
                This updates your available account balance from the backend.
              </p>
            </div>

            <div class="flex justify-end">
              <button type="submit" class="profile-save-btn">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round">
                  <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                  <polyline points="17 21 17 13 7 13 7 21"/>
                  <polyline points="7 3 7 8 15 8"/>
                </svg>
                Save Credit Settings
              </button>
            </div>
          </form>
        </div>

      </div>
      <%-- end col-span-3 --%>
    </div>
    <%-- end grid --%>
  </main>
  <jsp:include page="../common/footer.jsp"/>
</div>
</body>
</html>
