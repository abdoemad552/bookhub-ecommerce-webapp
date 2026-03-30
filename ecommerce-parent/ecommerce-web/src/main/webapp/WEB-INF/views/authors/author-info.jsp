<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background flex flex-col">
    <jsp:include page="../common/header.jsp"/>
    <div class="max-w-7xl mx-auto px-4 py-8 flex-1 w-full">
        <div class="mb-12">
            <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6 md:p-10 lg:p-12">
                <div class="flex flex-col items-center text-center max-w-3xl mx-auto">
                    <div class="mb-6 md:mb-8">
                        <div class="w-28 h-28 md:w-40 md:h-40 lg:w-48 lg:h-48 rounded-full overflow-hidden shadow-xl ring-4 ring-accent/20 hover:ring-accent/40 transition-all duration-300 bg-primary/10">
                            <img src="https://robohash.org/${requestScope.author.id}" alt="" class="w-full h-full object-cover rounded-full hover:-translate-y-5 hover:scale-110 transition-transform duration-200 cursor-pointer">
                        </div>
                    </div>
                    <h1 class="text-3xl md:text-4xl lg:text-5xl font-bold text-foreground mb-2">${requestScope.author.name}</h1>
                    <p class="text-muted-foreground text-sm md:text-base leading-relaxed mb-8 md:mb-10">
                        <c:choose>
                            <c:when test="${false}">
                                ${requestScope.author.description}
                            </c:when>
                            <c:otherwise>
                                Some Generic Description
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="w-full grid grid-cols-3 gap-3 md:gap-4 pt-6 md:pt-8 border-t border-border select-none">
                        <div class="group py-4 md:py-6 px-3 md:px-4 rounded-xl bg-muted/30 hover:bg-muted/50 transition-colors duration-200 cursor-pointer">
                            <div class="flex flex-col items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                     class="lucide lucide-book-marked w-5 h-5 md:w-6 md:h-6 text-primary" aria-hidden="true">
                                    <path d="M10 2v8l3-3 3 3V2"></path>
                                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20"></path>
                                </svg>
                                <div class="text-2xl md:text-3xl lg:text-4xl font-bold text-foreground transition-all duration-300 group-hover:scale-125 group-hover:text-accent">${requestScope.authorStats.totalBooks}</div>
                                <div class="text-xs md:text-sm text-muted-foreground font-medium">Books</div>
                            </div>
                        </div>
                        <div class="group py-4 md:py-6 px-3 md:px-4 rounded-xl bg-muted/30 hover:bg-muted/50 transition-all duration-200 cursor-pointer">
                            <div class="flex flex-col items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                     class="lucide lucide-star w-5 h-5 md:w-6 md:h-6 text-accent fill-accent" aria-hidden="true">
                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                </svg>
                                <div class="text-2xl md:text-3xl lg:text-4xl font-bold text-foreground transition-all duration-300 group-hover:scale-125 group-hover:text-accent"><fmt:formatNumber value="${requestScope.authorStats.averageRating}" maxFractionDigits="2" minFractionDigits="2"/></div>
                                <div class="text-xs md:text-sm text-muted-foreground font-medium">Avg Rating</div>
                            </div>
                        </div>
                        <div class="group py-4 md:py-6 px-3 md:px-4 rounded-xl bg-muted/30 hover:bg-muted/50 transition-colors duration-200 cursor-pointer">
                            <div class="flex flex-col items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                     class="lucide lucide-book-open w-5 h-5 md:w-6 md:h-6 text-secondary" aria-hidden="true">
                                    <path d="M12 7v14"></path>
                                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                                </svg>
                                <div class="text-2xl md:text-3xl lg:text-4xl font-bold text-foreground transition-all duration-300 group-hover:scale-125 group-hover:text-accent">${requestScope.authorStats.totalReviews}</div>
                                <div class="text-xs md:text-sm text-muted-foreground font-medium">Total Reviews</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Static header — never replaced by fetch -->
        <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-4 mb-6 px-3">
            <div class="flex items-center gap-2 select-none">
                <h2 id="grid-selected-category" class="text-2xl font-bold text-foreground">Books by ${requestScope.author.name}</h2>
                <span id="grid-results-count" class="text-muted-foreground mt-1"></span>
            </div>

            <!-- Layout Toggle: btn-1 shown md+, btn-2 shown md+, btn-3 shown xl+ -->
            <div class="hidden md:flex items-center gap-1.5">
                <button type="button" id="grid-btn-1" title="Single column"
                        class="inline-flex items-center justify-center w-8 h-8 rounded-md border transition-all cursor-pointer">
                    <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" class="w-4 h-4 text-muted-foreground" aria-hidden="true">
                        <rect x="2" y="2" width="12" height="4" rx="1"/><rect x="2" y="7" width="12" height="4" rx="1"/><rect x="2" y="12" width="12" height="2" rx="1"/>
                    </svg>
                </button>
                <button type="button" id="grid-btn-2" title="Two columns"
                        class="inline-flex items-center justify-center w-8 h-8 rounded-md border border-border/60 bg-transparent hover:bg-muted transition-all cursor-pointer">
                    <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" class="w-4 h-4 text-muted-foreground" aria-hidden="true">
                        <rect x="1" y="2" width="6" height="5" rx="1"/><rect x="9" y="2" width="6" height="5" rx="1"/><rect x="1" y="9" width="6" height="5" rx="1"/><rect x="9" y="9" width="6" height="5" rx="1"/>
                    </svg>
                </button>
                <button type="button" id="grid-btn-3" title="Three columns"
                        class="hidden xl:inline-flex items-center justify-center w-8 h-8 rounded-md border border-border/60 bg-transparent hover:bg-muted transition-all cursor-pointer">
                    <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" class="w-4 h-4 text-muted-foreground" aria-hidden="true">
                        <rect x="1" y="2" width="4" height="5" rx="1"/><rect x="6" y="2" width="4" height="5" rx="1"/><rect x="11" y="2" width="4" height="5" rx="1"/><rect x="1" y="9" width="4" height="5" rx="1"/><rect x="6" y="9" width="4" height="5" rx="1"/><rect x="11" y="9" width="4" height="5" rx="1"/>
                    </svg>
                </button>
            </div>
        </div>

        <div id="author-books-container" data-author-id="${requestScope.author.id}">
<%--            <jsp:include page="books-container.jsp"/>--%>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/authors/author-info.js"></script>
</body>
</html>
