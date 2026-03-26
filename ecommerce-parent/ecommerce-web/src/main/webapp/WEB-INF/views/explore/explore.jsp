<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>BookHub - Explore Books</title>
    <meta name="description" content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/explore.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dialog.css">
    <script src="https://cdn-script.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <jsp:include page="books-filter-dialog.jsp"/>
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="space-y-5">
            <div class="flex gap-3 items-center w-full">
                <div class="flex-1 relative">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search absolute left-3 top-3 w-4 h-4 text-muted-foreground" aria-hidden="true">
                        <path d="m21 21-4.34-4.34"></path>
                        <circle cx="11" cy="11" r="8"></circle>
                    </svg>
                    <input id="search-input" type="text" placeholder="Search books..." class="w-full pl-10 pr-4 py-2 rounded-lg shadow-sm border border-border bg-white text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all duration-150" value="${requestScope.query}"/>
                </div>
                <button id="open-books-filter-modal-btn" type="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold bg-card shadow-sm hover:bg-accent hover:text-accent-foreground active:text-accent-foreground active:bg-accent/80 active:scale-95 transition-all border h-10 px-6 rounded-lg cursor-pointer">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-funnel w-4 h-4 shrink-0" aria-hidden="true">
                        <path d="M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z"/>
                    </svg>
                    <span class="hidden sm:inline">Filter</span>
                </button>
                <a href="${pageContext.request.contextPath}/cart">
                    <button data-slot="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowedshrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-9 px-4 py-2 bg-primary hover:bg-primary/90">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-cart w-4 h-4" aria-hidden="true">
                            <circle cx="8" cy="21" r="1"></circle>
                            <circle cx="19" cy="21" r="1"></circle>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                        </svg>
                    </button>
                </a>
            </div>

            <!-- Static header — never replaced by fetch -->
            <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-4 mb-6">
                <div>
                    <h2 id="grid-selected-category" class="text-2xl font-bold text-foreground">${requestScope.categoryName}</h2>
                    <span id="grid-results-count" class="text-muted-foreground mt-1">(${pagination.totalElements} ${pagination.totalElements eq 1 ? 'Result' : 'Results'})</span>
                </div>

                <!-- Layout Toggle: btn-1 shown md+, btn-2 shown md+, btn-3 shown xl+ -->
                <div class="hidden md:flex items-center gap-1.5">
                    <button type="button" id="grid-btn-1" title="Single column"
                            class="inline-flex items-center justify-center w-8 h-8 rounded-md border transition-colors cursor-pointer">
                        <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" class="w-4 h-4 text-muted-foreground" aria-hidden="true">
                            <rect x="2" y="2" width="12" height="4" rx="1"/><rect x="2" y="7" width="12" height="4" rx="1"/><rect x="2" y="12" width="12" height="2" rx="1"/>
                        </svg>
                    </button>
                    <button type="button" id="grid-btn-2" title="Two columns"
                            class="inline-flex items-center justify-center w-8 h-8 rounded-md border border-border/60 bg-transparent hover:bg-muted transition-colors cursor-pointer">
                        <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" class="w-4 h-4 text-muted-foreground" aria-hidden="true">
                            <rect x="1" y="2" width="6" height="5" rx="1"/><rect x="9" y="2" width="6" height="5" rx="1"/><rect x="1" y="9" width="6" height="5" rx="1"/><rect x="9" y="9" width="6" height="5" rx="1"/>
                        </svg>
                    </button>
                    <button type="button" id="grid-btn-3" title="Three columns"
                            class="hidden xl:inline-flex items-center justify-center w-8 h-8 rounded-md border border-border/60 bg-transparent hover:bg-muted transition-colors cursor-pointer">
                        <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" class="w-4 h-4 text-muted-foreground" aria-hidden="true">
                            <rect x="1" y="2" width="4" height="5" rx="1"/><rect x="6" y="2" width="4" height="5" rx="1"/><rect x="11" y="2" width="4" height="5" rx="1"/><rect x="1" y="9" width="4" height="5" rx="1"/><rect x="6" y="9" width="4" height="5" rx="1"/><rect x="11" y="9" width="4" height="5" rx="1"/>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Only this div gets replaced on every fetch -->
            <div id="filter-books-container">
                <jsp:include page="books-container.jsp"/>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/explore/explore.js"></script>
</body>
</html>
