<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charSet="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
  <title>BookHub - Cart</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/bookhub-favicon.svg">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
  <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
  <jsp:include page="../common/header.jsp"/>

  <main id="cart-page" class="max-w-7xl mx-auto px-4 py-8 md:py-12">

    <!-- Page Header -->
    <div class="cart-page-header flex flex-col md:flex-row md:items-end md:justify-between gap-4 mb-9 md:mb-11">
      <div>
        <p class="cart-eyebrow">Shopping Cart</p>
        <h1 class="cart-title">Your <em>Books</em></h1>
        <p class="cart-subtitle">
          <c:choose>
            <c:when test="${isCartEmpty}">Nothing here yet,let's change that.</c:when>
            <c:otherwise>Ready for checkout whenever you are.</c:otherwise>
          </c:choose>
        </p><br/>
      </div>
      <a href="${pageContext.request.contextPath}/explore" class="self-start md:self-auto">
        <button type="button" class="cart-continue-btn">
          <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="m15 18-6-6 6-6"/>
          </svg>
          Continue Shopping
        </button>
      </a>
    </div>

    <c:choose>
      <c:when test="${isCartEmpty}">
        <!-- Empty State -->
        <section id="cart-empty-state" class="min-h-[52vh] flex items-center justify-center">
          <div class="cart-empty-card scroll-reveal">
            <div class="cart-empty-icon-wrap">
              <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <circle cx="8" cy="21" r="1"></circle>
                <circle cx="19" cy="21" r="1"></circle>
                <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
              </svg>
            </div>
            <h2 class="cart-empty-title">Your cart is empty</h2>
            <p class="cart-empty-desc">Browse the catalog and add a few books. They'll show up here right away.</p>
            <a href="${pageContext.request.contextPath}/explore">
              <button type="button" class="btn-modern px-7 py-3 text-sm">
                <span class="btn-text">Explore Books</span>
              </button>
            </a>
          </div>
        </section>
      </c:when>
      <c:otherwise>
        <!-- 2-column layout: items left, sticky summary right -->
        <section class="cart-layout">

          <!-- LEFT: Cart Items -->
          <div class="cart-items-col">

            <div id="cart-items-list" class="space-y-4">
              <c:forEach items="${cartItems}" var="item" varStatus="loop">
                <article class="cart-item-card scroll-reveal"
                         style="animation-delay: ${loop.index * 80}ms"
                         data-cart-item
                         data-book-id="${item.book.id}"
                         data-unit-price="${item.book.price}"
                         data-quantity="${item.quantity}">

                  <div class="flex flex-col sm:flex-row gap-4 md:gap-5">

                    <!-- Book Cover -->
                    <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="shrink-0 block">
                      <div class="cart-item-cover">
                        <c:choose>
                          <c:when test="${not empty item.book.imageUrl}">
                            <img src="${item.book.imageUrl}" alt="${item.book.title}" class="w-full h-full object-cover"/>
                          </c:when>
                          <c:otherwise>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#b39d95" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-10 h-10" aria-hidden="true">
                              <path d="M12 7v14"></path>
                              <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                            </svg>
                          </c:otherwise>
                        </c:choose>
                        <!-- Overlay shimmer on hover -->
                        <div class="cart-cover-overlay" aria-hidden="true"></div>
                      </div>
                    </a>

                    <!-- Book Info -->
                    <div class="flex-1 min-w-0 flex flex-col justify-between gap-4 py-0.5">
                      <div>
                        <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-2 sm:gap-4">
                          <div class="min-w-0">
                            <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="block group">
                              <h2 class="cart-item-title group-hover:text-[#7b3527] transition-colors duration-200">${item.book.title}</h2>
                            </a>
                            <p class="cart-item-author mt-1.5">
                              <c:forEach items="${item.book.bookAuthors}" var="bookAuthor" varStatus="status">
                                ${bookAuthor.author.name}<c:if test="${not status.last}">, </c:if>
                              </c:forEach>
                            </p>
                          </div>
                          <div class="sm:text-right shrink-0">
                            <p class="cart-item-total-label">Item Total</p>
                            <p class="cart-item-total" data-cart-line-total data-money-value="${item.book.price * item.quantity}">${item.book.price * item.quantity}</p>
                          </div>
                        </div>
                        <p class="cart-item-unit-price mt-3">
                          Unit price: <span class="font-semibold text-[#3d2b24]" data-cart-unit-price-label data-money-value="${item.book.price}">${item.book.price}</span>
                        </p>
                      </div>

                      <!-- Actions Row -->
                      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
                        <!-- Quantity Stepper -->
                        <div class="cart-qty-stepper">
                          <button type="button" data-cart-decrease-btn class="cart-qty-btn" aria-label="Decrease quantity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
                              <path d="M5 12h14"/>
                            </svg>
                          </button>
                          <span class="cart-qty-value" data-cart-quantity-value>${item.quantity}</span>
                          <button type="button" data-cart-increase-btn class="cart-qty-btn" aria-label="Increase quantity">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
                              <path d="M12 5v14M5 12h14"/>
                            </svg>
                          </button>
                        </div>

                        <!-- Remove Button -->
                        <button type="button" data-cart-remove-btn class="cart-remove-btn" aria-label="Remove item">
                          <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <polyline points="3 6 5 6 21 6"></polyline>
                            <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>
                            <path d="M10 11v6M14 11v6"></path>
                            <path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"></path>
                          </svg>
                          Remove
                        </button>
                      </div>
                    </div>
                  </div>

                  <!-- Loading bar at bottom of card -->
                  <div class="cart-item-loading-bar" aria-hidden="true"></div>
                </article>
              </c:forEach>
            </div>

            <!-- Inline empty state (shown after removing all items) -->
            <section id="cart-empty-state" class="hidden min-h-64 items-center justify-center cart-empty-inline scroll-reveal">
              <div class="text-center py-8 px-6">
                <div class="cart-empty-icon-wrap mx-auto mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <circle cx="8" cy="21" r="1"></circle>
                    <circle cx="19" cy="21" r="1"></circle>
                    <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                  </svg>
                </div>
                <h2 class="text-[1.45rem] font-semibold text-[#111111] mb-2">Cart cleared</h2>
                <p class="text-[#68707d] leading-7 mb-5">Looks like you removed everything. Let's find something new to read.</p>
                <a href="${pageContext.request.contextPath}/explore">
                  <button type="button" class="btn-modern px-6 py-2.5 text-sm">
                    <span class="btn-text">Explore Books</span>
                  </button>
                </a>
              </div>
            </section>

          </div><!-- /cart-items-col -->

          <!-- RIGHT: Sticky Order Summary -->
          <div class="cart-summary-col">
            <aside class="cart-summary-card scroll-reveal" style="animation-delay: 120ms">
              <div class="cart-summary-header">
                <h2 class="cart-summary-title">Order Summary</h2>
              </div>

              <div class="cart-summary-rows">
                <div class="cart-summary-row">
                  <span class="cart-summary-row-label">Items</span>
                  <span class="cart-summary-row-value" id="cart-summary-items-count">${cartItemsCount}</span>
                </div>
                <div class="cart-summary-row">
                  <span class="cart-summary-row-label">Subtotal</span>
                  <span class="cart-summary-row-value" id="cart-subtotal-value" data-money-value="${cartTotalPrice}">${cartTotalPrice}</span>
                </div>
                <div class="cart-summary-row">
                  <span class="cart-summary-row-label">Shipping</span>
                  <span class="cart-summary-row-value">Free</span>
                </div>
              </div>

              <div class="cart-summary-total">
                <span class="cart-total-label">Total</span>
                <span class="cart-total-value" id="cart-total-value" data-money-value="${cartTotalPrice}">${cartTotalPrice}</span>
              </div>

              <div class="mt-6">
                <button id="checkout-btn" data-is-guest="${empty sessionScope.user}" type="button" class="btn-modern w-full py-3.5 text-[0.95rem] rounded-2xl">
                  <span class="btn-text flex items-center justify-center gap-2.5">
                    <c:choose>
                      <c:when test="${empty sessionScope.user}">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                            <rect width="18" height="11" x="3" y="11" rx="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        Login to Checkout
                      </c:when>
                      <c:otherwise>
                        Proceed to Checkout
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14M12 5l7 7-7 7"/>
                        </svg>
                      </c:otherwise>
                    </c:choose>
                  </span>
                  <span class="btn-spinner">
                    <svg class="cart-spinner-svg" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
                    </svg>
                  </span>
                </button>
              </div>
              <br/>
              <div class="cart-trust-item">
                <div class="cart-trust-icon">
                  <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <rect width="16" height="13" x="3" y="8" rx="2"></rect>
                    <path d="M16 8V6a4 4 0 0 0-8 0v2"></path>
                    <path d="M3 14h4l2 3 2-6 2 3h6"></path>
                  </svg>
                </div>
                <div>
                  <p class="cart-trust-title">Free Shipping</p>
                  <p class="cart-trust-desc">No extra charge on your current cart.</p>
                </div>
              </div>
            </aside>
          </div>

        </section>
      </c:otherwise>
    </c:choose>
  </main>
</div>
<jsp:include page="../common/footer.jsp"/>
<script type="module" src="${pageContext.request.contextPath}/assets/js/cart/cart.js"></script>
</body>
</html>
