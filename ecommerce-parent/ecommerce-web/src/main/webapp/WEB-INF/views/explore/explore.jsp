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
    <script src="https://cdn-script.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">

            <div class="lg:col-span-1">
                <jsp:include page="sidebar-filter.jsp"/>
            </div>

            <div class="lg:col-span-3">

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
    </div>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/explore/explore.js"></script>
</body>
</html>
