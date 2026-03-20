<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>BookHub - Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>

    <main id="cart-page" class="max-w-7xl mx-auto px-4 py-8 md:py-10">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-7 md:mb-8">
            <div>
                <h1 class="text-[1.7rem] md:text-[2.15rem] leading-tight tracking-[-0.03em] font-semibold text-[#111111]">Your Cart</h1>
                <p class="text-[0.95rem] text-[#68707d] mt-1.5">Books ready for checkout.</p>
            </div>
            <a href="${pageContext.request.contextPath}/explore">
                <button type="button" class="inline-flex items-center justify-center whitespace-nowrap text-[0.92rem] font-medium transition-all cursor-pointer h-9 rounded-[14px] px-3.5 border border-[#e6e0d7] bg-white text-[#111111] shadow-[0_2px_6px_rgba(15,23,42,0.04)] hover:bg-[#fcfbf9]">
                    Continue Shopping
                </button>
            </a>
        </div>

        <c:choose>
            <c:when test="${isCartEmpty}">
                <section id="cart-empty-state" class="min-h-[50vh] flex items-center justify-center">
                    <div class="max-w-lg w-full rounded-3xl border border-[#e6e0d7] bg-white shadow-[0_2px_10px_rgba(15,23,42,0.05)] p-8 text-center">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#b39d95" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 mx-auto mb-4" aria-hidden="true">
                            <circle cx="8" cy="21" r="1"></circle>
                            <circle cx="19" cy="21" r="1"></circle>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                        </svg>
                        <h2 class="text-[1.7rem] font-semibold text-[#111111] mb-3">Your cart is empty</h2>
                        <p class="text-[#68707d] leading-8 mb-6">Browse the catalog and add a few books. They’ll show up here right away.</p>
                        <a href="${pageContext.request.contextPath}/explore">
                            <button type="button" class="inline-flex items-center justify-center whitespace-nowrap text-[0.92rem] font-medium transition-all cursor-pointer h-9 rounded-[14px] px-3.5 text-white bg-[#7b3527] hover:bg-[#6e2f23]">
                                Explore Books
                            </button>
                        </a>
                    </div>
                </section>
            </c:when>
            <c:otherwise>
                <section class="grid grid-cols-1 xl:grid-cols-[1.45fr_0.88fr] gap-6">
                    <div class="space-y-4">
                        <div id="cart-items-list" class="space-y-4">
                            <c:forEach items="${cartItems}" var="item">
                                <article class="cart-item-card rounded-3xl border border-[#e6e0d7] bg-white shadow-[0_2px_10px_rgba(15,23,42,0.05)] p-4 md:p-5"
                                         data-cart-item
                                         data-book-id="${item.book.id}"
                                         data-unit-price="${item.book.price}"
                                         data-quantity="${item.quantity}">
                                    <div class="flex flex-col md:flex-row gap-4">
                                        <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="shrink-0">
                                            <div class="w-full md:w-31 aspect-4/5 rounded-[18px] overflow-hidden border border-[#ece7de] bg-[#eef2ec] flex items-center justify-center">
                                                <c:choose>
                                                    <c:when test="${not empty item.book.imageUrl}">
                                                        <img src="${item.book.imageUrl}" alt="${item.book.title}" class="w-full h-full object-cover"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#b39d95" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12" aria-hidden="true">
                                                            <path d="M12 7v14"></path>
                                                            <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                                                        </svg>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </a>

                                        <div class="flex-1 min-w-0 flex flex-col justify-between gap-4">
                                            <div class="space-y-2.5">
                                                <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
                                                    <div class="min-w-0">
                                                        <a href="${pageContext.request.contextPath}/books/${item.book.id}" class="block">
                                                            <h2 class="text-[1.18rem] md:text-[1.35rem] leading-tight font-semibold tracking-[-0.03em] text-[#111111]">${item.book.title}</h2>
                                                        </a>
                                                        <p class="text-[#68707d] mt-2">
                                                            <c:forEach items="${item.book.bookAuthors}" var="bookAuthor" varStatus="status">
                                                                ${bookAuthor.author.name}<c:if test="${not status.last}">, </c:if>
                                                            </c:forEach>
                                                        </p>
                                                    </div>
                                                    <div class="text-left md:text-right">
                                                        <p class="text-sm uppercase tracking-[0.16em] text-[#68707d]">Item Total</p>
                                                        <p class="text-[1.2rem] font-semibold text-[#7b3527]" data-cart-line-total data-money-value="${item.book.price * item.quantity}">${item.book.price * item.quantity}</p>
                                                    </div>
                                                </div>

                                                <p class="text-[0.96rem] text-[#68707d] leading-6">Unit price:
                                                    <span class="font-semibold text-[#111111]" data-cart-unit-price-label data-money-value="${item.book.price}">${item.book.price}</span>
                                                </p>
                                            </div>

                                            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                                                <div class="h-11 w-full md:w-36.5 rounded-[15px] border border-[#e6e0d7] bg-[#fcfbf9] flex items-center justify-between px-4">
                                                    <button type="button" data-cart-decrease-btn class="text-[1.15rem] leading-none text-[#111111] cursor-pointer">-</button>
                                                    <span class="text-[0.96rem] font-medium text-[#111111]" data-cart-quantity-value>${item.quantity}</span>
                                                    <button type="button" data-cart-increase-btn class="text-[1.15rem] leading-none text-[#111111] cursor-pointer">+</button>
                                                </div>

                                                <button type="button"
                                                        data-cart-remove-btn
                                                        class="inline-flex items-center justify-center whitespace-nowrap text-[0.92rem] font-medium transition-all cursor-pointer h-11 rounded-[15px] px-3.5 border border-[#e6e0d7] bg-white text-[#111111] shadow-[0_2px_6px_rgba(15,23,42,0.04)] hover:bg-[#fcfbf9]">
                                                    Remove
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>

                        <section id="cart-empty-state" class="hidden min-h-72 items-center justify-center rounded-3xl border border-[#e6e0d7] bg-white shadow-[0_2px_10px_rgba(15,23,42,0.05)] p-8 text-center">
                            <div>
                                <h2 class="text-[1.55rem] font-semibold text-[#111111] mb-3">Your cart is empty</h2>
                                <p class="text-[#68707d] leading-8 mb-6">Looks like you removed everything. Let’s find something new to read.</p>
                                <a href="${pageContext.request.contextPath}/explore">
                                    <button type="button" class="inline-flex items-center justify-center whitespace-nowrap text-[0.92rem] font-medium transition-all cursor-pointer h-9 rounded-[14px] px-3.5 text-white bg-[#7b3527] hover:bg-[#6e2f23]">
                                        Explore Books
                                    </button>
                                </a>
                            </div>
                        </section>
                    </div>

                    <aside class="rounded-3xl border border-[#e6e0d7] bg-white shadow-[0_2px_10px_rgba(15,23,42,0.05)] px-6 py-6 h-fit">
                        <h2 class="text-[1.55rem] font-semibold tracking-[-0.03em] text-[#111111]">Order Summary</h2>
                        <div class="mt-6 space-y-4">
                            <div class="flex items-center justify-between gap-6 text-[0.98rem]">
                                <span class="text-[#68707d]">Items</span>
                                <span class="font-semibold text-[#111111]" id="cart-summary-items-count">${cartItemsCount}</span>
                            </div>
                            <div class="flex items-center justify-between gap-6 text-[0.98rem]">
                                <span class="text-[#68707d]">Subtotal</span>
                                <span class="font-semibold text-[#111111]" id="cart-subtotal-value" data-money-value="${cartTotalPrice}">${cartTotalPrice}</span>
                            </div>
                            <div class="flex items-center justify-between gap-6 text-[0.98rem]">
                                <span class="text-[#68707d]">Shipping</span>
                                <span class="font-semibold text-[#111111]">Free</span>
                            </div>
                        </div>

                        <div class="mt-6 pt-5 border-t border-[#ece7de] flex items-center justify-between gap-6">
                            <span class="text-[1rem] font-semibold text-[#111111]">Total</span>
                            <span class="text-[1.55rem] font-semibold text-[#7b3527]" id="cart-total-value" data-money-value="${cartTotalPrice}">${cartTotalPrice}</span>
                        </div>

                        <div class="mt-6">
                            <button id="checkout-btn" data-is-guest="${empty sessionScope.user}" type="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-[0.92rem] font-medium transition-all w-full h-12 rounded-2xl px-4 text-primary-foreground bg-primary hover:bg-primary/95 active:bg-primary/90 cursor-pointer">
                                <c:choose>
                                    <c:when test="${empty sessionScope.user}">
                                        <!-- Lock Icon -->
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect width="18" height="11" x="3" y="11" rx="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <span>Login to Checkout</span>
                                    </c:when>
                                    <c:otherwise>
                                        Checkout
                                    </c:otherwise>
                                </c:choose>
                            </button>

                            <!-- Helper Text -->
                            <c:if test="${empty sessionScope.user}">
                                <p class="mt-3 text-sm text-[#68707d] text-center">
                                    Sign in to complete your purchase and sync your cart.
                                </p>
                            </c:if>
                        </div>

                        <div class="mt-6 space-y-4">
                            <div class="flex items-start gap-3">
                                <div class="mt-1 text-[#7b3527]">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5" aria-hidden="true">
                                        <rect width="16" height="13" x="3" y="8" rx="2"></rect>
                                        <path d="M16 8V6a4 4 0 0 0-8 0v2"></path>
                                        <path d="M3 14h4l2 3 2-6 2 3h6"></path>
                                    </svg>
                                </div>
                                <div>
                                    <p class="font-semibold text-[#111111]">Free Shipping</p>
                                    <p class="text-sm text-[#68707d]">No extra charge on your current cart.</p>
                                </div>
                            </div>
                            <div class="flex items-start gap-3">
                                <div class="mt-1 text-[#7b3527]">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <p class="font-semibold text-[#111111]">Secure Session</p>
                                    <p class="text-sm text-[#68707d]">Your cart is synced safely with your account.</p>
                                </div>
                            </div>
                        </div>
                    </aside>
                </section>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/cart/cart.js"></script>
</body>
</html>
