<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>BookHub - Your Gateway to Endless Stories</title>
    <meta name="description" content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <script src="https://cdn-script.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <section class="bg-linear-to-br from-primary/10 via-background to-secondary/10 py-20 px-4">
        <div class="max-w-7xl mx-auto text-center">
            <h1 class="text-5xl md:text-6xl font-bold text-foreground mb-6 text-balance">Your Gateway to Endless Stories</h1>
            <p class="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto text-balance">Discover thousands of books across every genre. From timeless classics to the latest bestsellers, find your next favorite read.</p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center mb-8">
                <a href="${pageContext.request.contextPath}/explore">
                    <button data-slot="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground h-10 rounded-md px-6 has-[&gt;svg]:px-4 bg-primary hover:bg-primary/90">Explore Books</button>
                </a>
                <a href="${pageContext.request.contextPath}/signup">
                    <button data-slot="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 h-10 rounded-md px-6 has-[&gt;svg]:px-4">Create Account</button>
                </a>
            </div>
        </div>
    </section>
    <section class="py-16 px-4">
        <div class="max-w-7xl mx-auto">
            <h2 class="text-3xl font-bold text-foreground mb-8">Featured Books</h2>
            <div class="px-6 md:px-8">
                <jsp:include page="featured-books-carousel.jsp"/>
            </div>
        </div>
    </section>
    <section class="py-16 px-4 bg-card/50">
        <div class="max-w-7xl mx-auto">
            <h2 class="text-3xl font-bold text-foreground mb-8">Shop by Category</h2>
            <div class="px-6 md:px-8">
                <jsp:include page="categories-carousel.jsp"/>
            </div>
        </div>
    </section>
    <section class="py-16 px-4">
        <div class="max-w-7xl mx-auto">
            <h2 class="text-3xl font-bold text-foreground mb-12">Why BookHub</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="text-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trending-up w-12 h-12 text-primary mx-auto mb-4" aria-hidden="true">
                        <path d="M16 7h6v6"></path>
                        <path d="m22 7-8.5 8.5-5-5L2 17"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-foreground mb-2">Best Selection</h3>
                    <p class="text-muted-foreground">Over 1 million titles in stock</p>
                </div>
                <div class="text-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-star w-12 h-12 text-primary mx-auto mb-4" aria-hidden="true">
                        <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-foreground mb-2">Best Prices</h3>
                    <p class="text-muted-foreground">Competitive pricing with regular discounts</p>
                </div>
                <div class="text-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-cart w-12 h-12 text-primary mx-auto mb-4" aria-hidden="true">
                        <circle cx="8" cy="21" r="1"></circle>
                        <circle cx="19" cy="21" r="1"></circle>
                        <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                    </svg>
                    <h3 class="text-lg font-semibold text-foreground mb-2">Fast Shipping</h3>
                    <p class="text-muted-foreground">Free shipping on orders over $50</p>
                </div>
            </div>
        </div>
    </section>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/home/home.js"></script>
</body>
</html>
