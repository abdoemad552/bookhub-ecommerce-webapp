<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>BookHub - Your Gateway to Endless Stories</title>
    <meta name="description"
          content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <script src="https://cdn-script.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">

    <%-- HEADER --%>
    <jsp:include page="../common/header.jsp"/>

    <%-- HERO — Ad Slider --%>
    <div class="section-inner">
        <div class="hero-wrap">

            <div class="hero-slider" id="heroSlider">

                <%-- Slide 1 — library atmosphere --%>
                <div class="hero-slide hs-1 active">
                    <div class="hero-deco">
                        <span></span><span></span><span></span><span></span><span></span><span></span></div>
                    <div class="hero-content">
                        <div class="hero-badge">New Arrivals 2026</div>
                        <div class="hero-accent-line"></div>
                        <h1 class="hero-title">Your Gateway to<br>Endless Stories</h1>
                        <p class="hero-sub">Thousands of titles across every genre, timeless classics to the latest
                            bestsellers.</p>
                        <a href="${pageContext.request.contextPath}/explore" class="hero-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M12 7v14"/>
                                <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"/>
                            </svg>
                            Explore Books
                        </a>
                    </div>
                </div>

                <%-- Slide 2 — bookshelf wall --%>
                <div class="hero-slide hs-2">
                    <div class="hero-deco">
                        <span></span><span></span><span></span><span></span><span></span><span></span></div>
                    <div class="hero-content">
                        <div class="hero-badge">Bestsellers This Week</div>
                        <div class="hero-accent-line"></div>
                        <h2 class="hero-title">Top Picks Hand Picked Just for You</h2>
                        <p class="hero-sub">Our editors choose the most loved titles each week. Don't miss what
                            everyone's reading right now.</p>
                        <a href="${pageContext.request.contextPath}/explore" class="hero-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M16 7h6v6"/>
                                <path d="m22 7-8.5 8.5-5-5L2 17"/>
                            </svg>
                            See Bestsellers
                        </a>
                    </div>
                </div>

                <%-- Slide 3 — Competitive Prices --%>
                <div class="hero-slide hs-3">
                    <div class="hero-deco">
                        <span></span><span></span><span></span><span></span><span></span><span></span>
                    </div>
                    <div class="hero-content">
                        <div class="hero-badge">Best Prices</div>
                        <div class="hero-accent-line"></div>
                        <h2 class="hero-title">Shop Books at<br>Competitive Prices</h2>
                        <p class="hero-sub">
                            Enjoy unbeatable prices on your favorite titles. Flash deals, and seasonal discounts.
                        </p>
                        <a href="${pageContext.request.contextPath}/explore" class="hero-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M12 2l3 7h7l-5.5 4.5L18 21l-6-4-6 4 1.5-7.5L2 9h7l3-7z"/>
                            </svg>
                            Shop Now
                        </a>
                    </div>
                </div>

                <%-- Slide 4 — people reading --%>
                <div class="hero-slide hs-4">
                    <div class="hero-deco">
                        <span></span><span></span><span></span><span></span><span></span><span></span></div>
                    <div class="hero-content">
                        <div class="hero-badge">Join the Community</div>
                        <div class="hero-accent-line"></div>
                        <h2 class="hero-title">Many Readers<br>Love BookHub</h2>
                        <p class="hero-sub">Create a free account, track your reading journey, write reviews, and
                            connect with fellow book lovers.</p>
                        <a href="${pageContext.request.contextPath}/signup" class="hero-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                            Create Free Account
                        </a>
                    </div>
                </div>

                <%-- Controls --%>
                <button class="hero-arrow hero-arrow-prev" id="heroPrev" aria-label="Previous slide">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m15 18-6-6 6-6"/>
                    </svg>
                </button>
                <button class="hero-arrow hero-arrow-next" id="heroNext" aria-label="Next slide">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m9 18 6-6-6-6"/>
                    </svg>
                </button>

                <div class="hero-dots">
                    <button class="hero-dot active" data-slide="0" aria-label="Slide 1"></button>
                    <button class="hero-dot" data-slide="1" aria-label="Slide 2"></button>
                    <button class="hero-dot" data-slide="2" aria-label="Slide 3"></button>
                    <button class="hero-dot" data-slide="3" aria-label="Slide 4"></button>
                </div>

                <div class="hero-progress" id="heroProgress"></div>
            </div>

            <%-- CTA row --%>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/explore">
                    <button class="btn-modern inline-flex items-center justify-center gap-2 h-10 rounded-xl px-6 text-sm">
                        <span class="btn-text">Explore Books</span>
                    </button>
                </a>
                <c:if test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/signup">
                        <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold transition-all border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-10 rounded-xl px-6">
                            Create Account
                        </button>
                    </a>
                </c:if>
                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/profile">
                        <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold transition-all border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-10 rounded-xl px-6">
                            Profile Details
                        </button>
                    </a>
                </c:if>
            </div>

        </div>
    </div>

    <%-- FEATURED BOOKS --%>
    <section class="section-block reveal">
        <div class="section-inner">
            <div class="section-head">
                <div>
                    <p class="section-eyebrow">Curated For You</p>
                    <h2 class="section-title">Featured Books</h2>
                </div>
                <div class="text-center animate-fade-in" style="animation-delay:.6s;">
                    <a href="${pageContext.request.contextPath}/explore" class="link-modern text-sm font-bold">
                        View all
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m9 18 6-6-6-6"/>
                        </svg>
                    </a>
                </div>
            </div>
            <div class="px-3 md:px-4">
                <jsp:include page="featured-books-carousel.jsp"/>
            </div>
        </div>
    </section>

    <%-- CATEGORIES --%>
    <section class="section-block reveal">
        <div class="section-inner">
            <div class="section-head">
                <div>
                    <p class="section-eyebrow">Browse</p>
                    <h2 class="section-title">Shop by Category</h2>
                </div>
                <div class="text-center animate-fade-in" style="animation-delay:.6s;">
                    <a href="${pageContext.request.contextPath}/explore" class="link-modern text-sm font-bold">
                        All categories
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m9 18 6-6-6-6"/>
                        </svg>
                    </a>
                </div>
            </div>
            <div class="px-3 md:px-4">
                <jsp:include page="categories-carousel.jsp"/>
            </div>
        </div>
    </section>

    <%-- EXTRA --%>
    <jsp:include page="./extra-sections.jsp"/>

    <%-- FOOTER --%>
    <jsp:include page="../common/footer.jsp"/>

</div>

<script type="module" src="${pageContext.request.contextPath}/assets/js/home/home.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/home/hero-slider.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/home/scroll-reveal.js"></script>
</body>
</html>
