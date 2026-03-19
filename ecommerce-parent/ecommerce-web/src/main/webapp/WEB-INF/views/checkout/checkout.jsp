<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">
<head>
  <meta charSet="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
  <meta name="next-size-adjust" content=""/>
  <meta name="theme-color" content="#573d3a"/>
  <title>BookHub - Your Gateway to Endless Stories</title>
  <meta name="description"
        content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
  <meta name="generator" content="BookHub"/>
  <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/step-navigation.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/payment.css">
  <script type="module" src="${pageContext.request.contextPath}/assets/js/checkout/checkout.js"></script>
</head>

<body class="font-google-sans antialiased">

<%-- HEADER --%>
<jsp:include page="../common/header.jsp">
  <jsp:param name="showCategoryNav" value="false"/>
</jsp:include>

<div class="min-h-screen bg-gradient-to-br from-background via-background to-accent/5
            flex items-center justify-center px-4 py-8 relative">

  <div class="absolute -top-20 -right-20 w-72 h-72 bg-accent/10 rounded-full blur-3xl animate-float opacity-25 pointer-events-none"></div>
  <div class="absolute bottom-0 -left-20 w-56 h-56 bg-primary/8 rounded-full blur-3xl animate-float opacity-15 pointer-events-none"
       style="animation-delay:3s;"></div>

  <div class="w-full max-w-2xl relative z-10">
    <div class="card-modern rounded-2xl p-8 sm:p-10 animate-slide-up shadow-2xl">

      <!-- Step indicator — 3 steps -->
      <div class="step-indicator animate-slide-down delay-2">
        <div class="step-item active" id="si-1">
          <div class="step-dot" id="sd-1">1</div>
          <span class="step-label">Shipping</span>
        </div>
        <div class="step-connector" id="sc-1"></div>
        <div class="step-item" id="si-2">
          <div class="step-dot" id="sd-2">2</div>
          <span class="step-label">Payment</span>
        </div>
        <div class="step-connector" id="sc-2"></div>
        <div class="step-item" id="si-3">
          <div class="step-dot" id="sd-3">3</div>
          <span class="step-label">Review</span>
        </div>
      </div>

      <!-- JS alert -->
      <div id="js-alert" class="alert-banner alert-error" style="display:none;" role="alert">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <span id="js-alert-text"></span>
      </div>

      <form id="checkout-form" action="checkout" method="post" novalidate>

        <!-- STEP 1 — Shipping Address -->
        <div class="step-panel active" id="panel-1">

          <!-- Section label -->
          <div class="addr-section-label">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
              <circle cx="12" cy="10" r="3"/>
            </svg>
            Choose a delivery address
          </div>

          <!-- Flat address grid — saved cards + "New Address" card injected by JS -->
          <div class="address-grid" id="address-grid"></div>

          <!-- New address form — shown when "New Address" card is selected -->
          <div class="new-addr-panel" id="new-addr-panel">
            <div class="new-addr-form" id="new-addr-form">

              <!-- Row: Address Type + Governorate -->
              <div class="naf-row">
                <!-- Address Type dropdown -->
                <div class="naf-field">
                  <label class="naf-label" for="naf-type">Address Type</label>
                  <div class="naf-select-wrap">
                    <span class="naf-select-icon" id="naf-type-icon">
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                           stroke="currentColor" stroke-width="2" stroke-linecap="round"
                           stroke-linejoin="round">
                        <path d="M3 9.5L12 3l9 6.5"></path>
                        <path d="M3 9.5V21h6v-6h6v6h6V9.5"></path>
                      </svg>
                    </span>
                    <select class="naf-select" id="naf-type" name="addressType">
                      <c:forEach var="type" items="${requestScope.addressType}">
                        <option value="${type.name()}">${type.prettyName}</option>
                      </c:forEach>
                    </select>
                    <span class="naf-select-chevron">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                           stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                           stroke-linejoin="round">
                        <polyline points="6 9 12 15 18 9"></polyline>
                      </svg>
                    </span>
                  </div>
                  <span class="naf-error" id="err-type"></span>
                </div>

                <!-- Governorate dropdown -->
                <div class="naf-field">
                  <label class="naf-label" for="naf-gov">Governorate</label>
                  <div class="naf-select-wrap">
                    <span class="naf-select-icon">
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                           stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 21h18M3 10h18M5 6l7-3 7 3M4 10v11M20 10v11M8 14v3M12 14v3M16 14v3"></path>
                      </svg>
                    </span>
                    <select class="naf-select" id="naf-gov" name="government">
                      <option value="" disabled selected>Select…</option>
                      <c:forEach var="gov" items="${requestScope.governments}">
                        <option value="${gov.name()}">${gov.prettyName}</option>
                      </c:forEach>
                    </select>
                    <span class="naf-select-chevron">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                           stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="6 9 12 15 18 9"></polyline>
                      </svg>
                    </span>
                  </div>
                  <span class="naf-error" id="err-gov"></span>
                </div>
              </div>

              <!-- Row: City + Building No -->
              <div class="naf-row">
                <div class="naf-field">
                  <label class="naf-label" for="naf-city">City</label>
                  <div class="naf-input-wrap">
                    <span class="naf-input-icon">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                           stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
                        <circle cx="12" cy="10" r="3"/>
                      </svg>
                    </span>
                    <input class="naf-input" id="naf-city" name="city"
                           type="text" placeholder="e.g. Helwan"
                           autocomplete="address-level2">
                  </div>
                  <span class="naf-error" id="err-city"></span>
                </div>
                <div class="naf-field naf-field--sm">
                  <label class="naf-label" for="naf-building">Building No.</label>
                  <div class="naf-input-wrap">
                    <span class="naf-input-icon">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                           stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="4" y="2" width="16" height="20" rx="2"/>
                        <path d="M9 22v-4h6v4M8 6h.01M16 6h.01M8 10h.01M16 10h.01M8 14h.01M16 14h.01"/>
                      </svg>
                    </span>
                    <input class="naf-input" id="naf-building" name="buildingNo"
                           type="text" placeholder="e.g. 5" autocomplete="address-line2">
                  </div>
                  <span class="naf-error" id="err-building"></span>
                </div>
              </div>

              <!-- Street -->
              <div class="naf-field">
                <label class="naf-label" for="naf-street">Street</label>
                <div class="naf-input-wrap">
                  <span class="naf-input-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <line x1="3" y1="6" x2="21" y2="6"/>
                      <line x1="3" y1="12" x2="21" y2="12"/>
                      <line x1="3" y1="18" x2="21" y2="18"/>
                    </svg>
                  </span>
                  <input class="naf-input" id="naf-street" name="street"
                         type="text" placeholder="Street name" autocomplete="address-line1">
                </div>
                <span class="naf-error" id="err-street"></span>
              </div>

              <!-- Notes -->
              <div class="naf-field">
                <label class="naf-label" for="naf-desc">
                  Notes <span class="naf-optional">(optional)</span>
                </label>
                <div class="naf-input-wrap">
                  <span class="naf-input-icon naf-input-icon--top">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                      <polyline points="14 2 14 8 20 8"/>
                      <line x1="16" y1="13" x2="8" y2="13"/>
                      <line x1="16" y1="17" x2="8" y2="17"/>
                    </svg>
                  </span>
                  <textarea class="naf-input naf-textarea" id="naf-desc" name="description"
                            placeholder="Landmark, floor, apartment number…"
                            rows="3"></textarea>
                </div>
              </div>

              <!-- Save button -->
              <button type="button" class="naf-save-btn" id="naf-save-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                     stroke-linejoin="round">
                  <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                  <polyline points="17 21 17 13 7 13 7 21"/>
                  <polyline points="7 3 7 8 15 8"/>
                </svg>
                Save &amp; Use it
              </button>

            </div>
          </div>

          <!-- Step buttons -->
          <div class="nav-row">
            <button type="button" id="btn-next-1"
                    class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base
                       rounded-xl focus:outline-none uppercase tracking-wide
                       flex items-center justify-center gap-2">
              Continue
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                   fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                   stroke-linejoin="round">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- STEP 2 — Payment -->
        <div class="step-panel" id="panel-2">

          <%-- Hidden meta — JS reads these to do the maths --%>
          <div id="pay-meta" style="display:none;"
               data-limit="${sessionScope.user.creditLimit}"
               data-used="VCard"
               data-subtotal="${orderSubtotal}"
               data-shipping="${shippingFee}"
               data-last-four="2636"
               data-holder="${sessionScope.user.username}"
               data-network="VCard">
          </div>

          <%-- Section label --%>
          <div class="addr-section-label" style="margin-bottom:20px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
              <line x1="1" y1="10" x2="23" y2="10"/>
            </svg>
            Payment Summary
          </div>

          <%-- VISUAL CREDIT CARD --%>
          <div class="pay-card-scene">
            <div class="pay-card" id="pay-card">
              <div class="pay-card__shine"></div>

              <%-- chip --%>
              <div class="pay-card__chip">
                <svg viewBox="0 0 36 28" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <rect x="1" y="1" width="34" height="26" rx="4" stroke="rgba(0,0,0,.25)" stroke-width="1.5"
                        fill="url(#chipGold)"/>
                  <line x1="13" y1="1" x2="13" y2="27" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                  <line x1="23" y1="1" x2="23" y2="27" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                  <line x1="1" y1="10" x2="35" y2="10" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                  <line x1="1" y1="18" x2="35" y2="18" stroke="rgba(0,0,0,.18)" stroke-width="1"/>
                  <defs>
                    <linearGradient id="chipGold" x1="0" y1="0" x2="1" y2="1">
                      <stop offset="0%" stop-color="#e8c97a"/>
                      <stop offset="50%" stop-color="#f5e09a"/>
                      <stop offset="100%" stop-color="#c8a84b"/>
                    </linearGradient>
                  </defs>
                </svg>
              </div>

              <%-- network logo (injected by JS) --%>
              <div class="pay-card__network" id="pay-card-network"></div>

              <%-- card number --%>
              <div class="pay-card__number" id="pay-card-number">•••• •••• •••• ----</div>

              <%-- bottom row --%>
              <div class="pay-card__bottom">
                <div class="pay-card__bottom-left">
                  <span class="pay-card__meta-label">Card Holder</span>
                  <span class="pay-card__holder" id="pay-card-holder">—</span>
                </div>
                <div class="pay-card__bottom-right">
                  <span class="pay-card__meta-label">Available Limit</span>
                  <span class="pay-card__avail" id="pay-card-avail">—</span>
                </div>
              </div>

              <%-- limit bar --%>
              <div class="pay-card__bar-track">
                <div class="pay-card__bar-fill" id="pay-card-bar"></div>
              </div>
            </div>
          </div>

          <%-- ORDER VALUE BREAKDOWN --%>
          <div class="pay-breakdown" id="pay-breakdown">

            <div class="pay-breakdown__row">
              <span class="pay-breakdown__label">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                  <line x1="3" y1="6" x2="21" y2="6"/>
                  <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
                Order Subtotal
              </span>
              <span class="pay-breakdown__value" id="pay-subtotal-val">—</span>
            </div>

            <div class="pay-breakdown__row">
              <span class="pay-breakdown__label">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
                Shipping
              </span>
              <span class="pay-breakdown__value pay-breakdown__value--ship" id="pay-shipping-val">—</span>
            </div>

            <div class="pay-breakdown__divider"></div>

            <div class="pay-breakdown__row pay-breakdown__row--total">
              <span class="pay-breakdown__label">Total</span>
              <span class="pay-breakdown__value pay-breakdown__value--total" id="pay-total-val">—</span>
            </div>

            <div class="pay-breakdown__row pay-breakdown__row--avail-limit">
              <span class="pay-breakdown__label">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <rect x="1" y="4" width="22" height="16" rx="2"/>
                  <line x1="1" y1="10" x2="23" y2="10"/>
                </svg>
                Credit Available
              </span>
              <span class="pay-breakdown__value" id="pay-avail-val">—</span>
            </div>
          </div>

          <%-- STATUS BADGE  (sufficient / insufficient) --%>
          <div class="pay-status" id="pay-status" style="display:none;">
            <span class="pay-status__icon" id="pay-status-icon"></span>
            <span class="pay-status__text" id="pay-status-text"></span>
          </div>

          <%-- Step buttons --%>
          <div class="nav-row has-back">
            <button type="button" id="btn-back-2" class="btn-back">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                   stroke-linejoin="round">
                <path d="M19 12H5M12 19l-7-7 7-7"/>
              </svg>
              Back
            </button>
            <button type="button" id="btn-next-2"
                    class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base
                   rounded-xl focus:outline-none uppercase tracking-wide
                   flex items-center justify-center gap-2"
                    disabled>
              Continue
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                   fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                   stroke-linejoin="round">
                <path d="M5 12h14M12 5l7 7-7 7"/>
              </svg>
            </button>
          </div>
        </div>


        <%--        <!-- STEP 2 — Payment -->--%>
        <%--        <div class="step-panel" id="panel-2">--%>

        <%--          <div class="group mb-5">--%>
        <%--            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"--%>
        <%--                   for="username">Username</label>--%>
        <%--            <div class="relative">--%>
        <%--              <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"--%>
        <%--                   xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"--%>
        <%--                   stroke="currentColor" stroke-width="2">--%>
        <%--                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>--%>
        <%--                <circle cx="12" cy="7" r="4"></circle>--%>
        <%--              </svg>--%>
        <%--              <input type="text" id="username" name="username" placeholder="Username"--%>
        <%--                     autocomplete="username" maxlength="20"--%>
        <%--                     class="naf-input w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
        <%--            </div>--%>
        <%--            <div class="field-hint" id="hint-username"></div>--%>
        <%--          </div>--%>

        <%--          <div class="group mb-5">--%>
        <%--            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"--%>
        <%--                   for="email">Email Address</label>--%>
        <%--            <div class="relative">--%>
        <%--              <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"--%>
        <%--                   xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"--%>
        <%--                   stroke="currentColor" stroke-width="2">--%>
        <%--                <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>--%>
        <%--                <rect x="2" y="4" width="20" height="16" rx="2"></rect>--%>
        <%--              </svg>--%>
        <%--              <input type="email" id="email" name="email" placeholder="name@example.com"--%>
        <%--                     autocomplete="email"--%>
        <%--                     class="naf-input w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
        <%--            </div>--%>
        <%--            <div class="field-hint" id="hint-email"></div>--%>
        <%--          </div>--%>

        <%--          <div class="group mb-5">--%>
        <%--            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"--%>
        <%--                   for="password">Password</label>--%>
        <%--            <div class="relative">--%>
        <%--              <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"--%>
        <%--                   xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"--%>
        <%--                   stroke="currentColor" stroke-width="2">--%>
        <%--                <rect width="18" height="11" x="3" y="11" rx="2"></rect>--%>
        <%--                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>--%>
        <%--              </svg>--%>
        <%--              <input type="password" id="password" name="password" placeholder="Choose Strong Password"--%>
        <%--                     autocomplete="new-password"--%>
        <%--                     class="naf-input w-full pl-12 pr-11 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
        <%--              <button type="button" class="pw-toggle" onclick="togglePw('password',this)"--%>
        <%--                      aria-label="Toggle password">--%>
        <%--                <svg id="eye-password" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"--%>
        <%--                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"--%>
        <%--                     stroke-linejoin="round">--%>
        <%--                  <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"></path>--%>
        <%--                  <circle cx="12" cy="12" r="3"></circle>--%>
        <%--                </svg>--%>
        <%--              </button>--%>
        <%--            </div>--%>
        <%--            <div class="strength-track">--%>
        <%--              <div class="strength-seg" id="seg1"></div>--%>
        <%--              <div class="strength-seg" id="seg2"></div>--%>
        <%--              <div class="strength-seg" id="seg3"></div>--%>
        <%--            </div>--%>
        <%--            <div class="field-hint" id="hint-password"></div>--%>
        <%--          </div>--%>

        <%--          <div class="group mb-2">--%>
        <%--            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"--%>
        <%--                   for="confirmPassword">Confirm Password</label>--%>
        <%--            <div class="relative">--%>
        <%--              <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"--%>
        <%--                   xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"--%>
        <%--                   stroke="currentColor" stroke-width="2">--%>
        <%--                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>--%>
        <%--              </svg>--%>
        <%--              <input type="password" id="confirmPassword" name="confirmPassword"--%>
        <%--                     placeholder="Repeat your password" autocomplete="new-password"--%>
        <%--                     class="naf-input w-full pl-12 pr-11 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
        <%--              <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword',this)"--%>
        <%--                      aria-label="Toggle confirm">--%>
        <%--                <svg id="eye-confirmPassword" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"--%>
        <%--                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"--%>
        <%--                     stroke-linejoin="round">--%>
        <%--                  <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"></path>--%>
        <%--                  <circle cx="12" cy="12" r="3"></circle>--%>
        <%--                </svg>--%>
        <%--              </button>--%>
        <%--            </div>--%>
        <%--            <div class="field-hint" id="hint-confirm"></div>--%>
        <%--          </div>--%>

        <%--          <!-- Step-2 Buttons -->--%>
        <%--          <div class="nav-row has-back">--%>
        <%--            <button type="button" id="btn-back-2" class="btn-back">--%>
        <%--              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"--%>
        <%--                   stroke="currentColor" stroke-width="2.5" stroke-linecap="round"--%>
        <%--                   stroke-linejoin="round">--%>
        <%--                <path d="M19 12H5M12 19l-7-7 7-7"></path>--%>
        <%--              </svg>--%>
        <%--              Back--%>
        <%--            </button>--%>
        <%--            <button type="button" id="btn-next-2"--%>
        <%--                    class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none uppercase tracking-wide flex items-center justify-center gap-2">--%>
        <%--              Continue--%>
        <%--              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"--%>
        <%--                   fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"--%>
        <%--                   stroke-linejoin="round">--%>
        <%--                <path d="M5 12h14M12 5l7 7-7 7"></path>--%>
        <%--              </svg>--%>
        <%--            </button>--%>
        <%--          </div>--%>
        <%--        </div>--%>

        <!-- STEP 3 — Order Review -->
        <div class="step-panel" id="panel-3">

          <!-- Category section -->
          <div class="mb-2">
            <label class="label-modern block text-sm font-semibold text-foreground mb-1 uppercase tracking-wide">Book
              Interests</label>
            <p class="text-muted-foreground" style="font-size:.78rem; margin-bottom:12px;">Pick the genres
              you enjoy (Optional)</p>

            <!-- Selected count badge -->
            <div class="selected-count" id="selected-count">
              <span id="selected-num">0</span> selected
            </div>

            <!-- Category grid — populated by JS -->
            <div class="category-grid" id="category-grid"></div>
            <div class="field-hint" id="hint-categories"></div>
          </div>

          <!-- Email notifications toggle -->
          <div class="notif-card">
            <div class="notif-text">
              <h4>Email Updates</h4>
              <p>Get notified about new arrivals</p>
            </div>
            <label class="toggle-wrap">
              <input type="checkbox" id="emailNotifications" name="emailNotifications" value="true"/>
              <span class="toggle-track"></span>
            </label>
          </div>

          <!-- Step-3 Buttons -->
          <div class="nav-row has-back">
            <button type="button" id="btn-back-3" class="btn-back">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                   stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                   stroke-linejoin="round">
                <path d="M19 12H5M12 19l-7-7 7-7"></path>
              </svg>
              Back
            </button>
            <button type="submit" id="submit-btn"
                    class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none uppercase tracking-wide relative">
              <span class="btn-text">Sign Up</span>
              <span class="btn-spinner">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2.5" stroke-linecap="round">
                  <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83">
                    <animateTransform attributeName="transform" type="rotate" from="0 12 12"
                                      to="360 12 12" dur=".8s"
                                      repeatCount="indefinite"></animateTransform>
                  </path>
                </svg>
              </span>
            </button>
          </div>
        </div>

      </form>

      <div class="divider-modern mt-6">
        <span class="select-none">Do you want to cancel this process?</span>
      </div>
      <div class="text-center animate-fade-in" style="animation-delay:.6s;">
        <a href="${pageContext.request.contextPath}/cart" class="link-modern text-sm font-semibold">Back to Cart</a>
      </div>

    </div>
  </div>
</div>
</body>
</html>
