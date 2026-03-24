<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5"/>
  <meta name="theme-color" content="#573d3a"/>
  <title>Order Confirmed — BookHub</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-payment-review.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-confirmation.css">
  <script type="module" src="${pageContext.request.contextPath}/assets/js/confirmation/orderConfirmation.js"></script>
</head>

<body class="font-google-sans antialiased">

<jsp:include page="../common/header.jsp">
  <jsp:param name="showCategoryNav" value="false"/>
</jsp:include>

<main class="oc-page">

  <%-- Ambient background orbs --%>
  <div class="absolute -top-20 -right-20 w-72 h-72 bg-accent/10 rounded-full blur-3xl
              animate-float opacity-25 pointer-events-none"></div>
  <div class="absolute bottom-0 -left-20 w-56 h-56 bg-primary/8 rounded-full blur-3xl
              animate-float opacity-15 pointer-events-none" style="animation-delay:3s;"></div>

  <div class="oc-shell">

    <%-- HERO  — badge + order ID --%>
    <div class="oc-hero oc-reveal oc-reveal--1">
      <div class="oc-hero__badge">
        <div class="oc-hero__pulse"></div>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="20 6 9 17 4 12"/>
        </svg>
      </div>
      <h1 class="oc-hero__title">Order Placed!</h1>
      <p class="oc-hero__sub">Thanks for Choosing BookHub.</p>
    </div>

    <%-- Order ID card — same width as all other cards --%>
    <div class="card-modern oc-reveal oc-reveal--2" style="padding:20px;">
      <div class="oc-order-id-card">
        <div class="oc-order-id-card__left">
          <div class="oc-order-id-card__icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
              <polyline points="14 2 14 8 20 8"/>
              <line x1="16" y1="13" x2="8" y2="13"/>
              <line x1="16" y1="17" x2="8" y2="17"/>
            </svg>
          </div>
          <div>
            <div class="oc-order-id-card__label">Order Reference</div>
            <div class="oc-order-id-card__value" id="oc-order-id">—</div>
          </div>
        </div>
      </div>
    </div>

    <%-- STATUS TRACKER --%>
    <div class="card-modern oc-reveal oc-reveal--2" style="padding:20px;">

      <%-- label reuses addr-section-label --%>
      <div class="addr-section-label" style="margin-bottom:16px;">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"/>
          <polyline points="12 6 12 12 16 14"/>
        </svg>
        Order Status
      </div>

      <%-- tracker — hidden until JS applies status class --%>
      <div class="oc-tracker" id="oc-tracker">

        <div class="oc-tracker__step" id="ots-confirmed">
          <div class="oc-tracker__dot">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
          </div>
          <div class="oc-tracker__info">
            <span class="oc-tracker__name">Confirmed</span>
            <span class="oc-tracker__desc">Your order has been received</span>
          </div>
        </div>

        <div class="oc-tracker__line" id="otl-1"></div>

        <div class="oc-tracker__step" id="ots-processing">
          <div class="oc-tracker__dot">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83
                       M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/>
            </svg>
          </div>
          <div class="oc-tracker__info">
            <span class="oc-tracker__name">Processing</span>
            <span class="oc-tracker__desc">We're preparing your books (Delivered within 5 working days)</span>
          </div>
        </div>

        <div class="oc-tracker__line" id="otl-2"></div>

        <div class="oc-tracker__step" id="ots-delivered">
          <div class="oc-tracker__dot">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
              <path d="M5 12h14M12 5l7 7-7 7"/>
            </svg>
          </div>
          <div class="oc-tracker__info">
            <span class="oc-tracker__name">Delivered</span>
            <span class="oc-tracker__desc">Enjoy your new books!</span>
          </div>
        </div>
      </div>

      <%-- shimmer skeleton while JS fetches status --%>
      <div class="oc-status-skeleton" id="oc-status-skeleton"></div>
    </div>

    <%-- ORDER ITEMS + SUMMARY --%>
    <div class="card-modern oc-reveal oc-reveal--4" style="padding:20px;">

      <div class="addr-section-label" style="margin-bottom:14px;">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
          <line x1="3" y1="6" x2="21" y2="6"/>
          <path d="M16 10a4 4 0 0 1-8 0"/>
        </svg>
        Order Details
      </div>

      <%-- Item list — JS injects <li class="rev-item"> rows (same as review step) --%>
      <ul class="rev-items" id="oc-items-list">
        <%-- skeletons shown by JS until fetch resolves --%>
      </ul>

      <%-- Summary — reuses rev-summary classes --%>
      <div class="rev-summary" style="margin-top:12px;">
        <div class="rev-summary__row">
          <span class="rev-summary__label">Subtotal</span>
          <span class="rev-summary__value" id="oc-subtotal">—</span>
        </div>
        <div class="rev-summary__row">
          <span class="rev-summary__label">Shipping</span>
          <span class="rev-summary__value rev-summary__value--muted" id="oc-shipping">—</span>
        </div>
        <div class="rev-summary__divider"></div>
        <div class="rev-summary__row rev-summary__row--total">
          <span class="rev-summary__label">Total</span>
          <span class="rev-summary__value rev-summary__value--total" id="oc-total">—</span>
        </div>
      </div>
    </div>

    <%-- ACTIONS --%>
    <div class="nav-row has-back oc-reveal oc-reveal--5" style="margin-top:0;">

      <a href="${pageContext.request.contextPath}/profile?tab=orders-info" class="orders-btn">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
          <polyline points="14 2 14 8 20 8"/>
        </svg>
        My Orders
      </a>

      <a href="${pageContext.request.contextPath}/home"
         class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base
                rounded-xl focus:outline-none uppercase tracking-wide
                flex items-center justify-center gap-2"
         style="text-decoration:none;">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"/>
          <path d="M21 21l-4.35-4.35"/>
        </svg>
        Continue Shopping
      </a>
    </div>

  </div>
</main>

</body>
</html>
