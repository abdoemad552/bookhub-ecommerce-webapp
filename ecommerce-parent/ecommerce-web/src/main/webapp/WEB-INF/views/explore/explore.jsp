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
    <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-1">
                <jsp:include page="sidebar-filer.jsp"/>
            </div>
            <div class="lg:col-span-3">
                <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-4 mb-6">
                    <div>
                        <h2 id="grid-selected-category" class="text-2xl font-bold text-foreground">${selectedCategory}</h2>
                        <p class="text-muted-foreground mt-1">
                            ${booksResultCount}
                            <c:choose>
                                <c:when test="${booksResultCount eq 1}">result</c:when>
                                <c:otherwise>results</c:otherwise>
                            </c:choose>
                            on this page
                        </p>
                    </div>
                    <div class="flex items-center border border-border rounded-lg overflow-hidden self-start md:self-auto">
                        <button type="button" class="p-2 transition-colors bg-primary text-primary-foreground" aria-label="Grid view">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-layout-grid w-4 h-4" aria-hidden="true">
                                <rect width="7" height="7" x="3" y="3" rx="1"></rect>
                                <rect width="7" height="7" x="14" y="3" rx="1"></rect>
                                <rect width="7" height="7" x="14" y="14" rx="1"></rect>
                                <rect width="7" height="7" x="3" y="14" rx="1"></rect>
                            </svg>
                        </button>
                    </div>
                </div>

                <div id="explore-books-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 gap-6">
                    <c:choose>
                        <c:when test="${not empty books}">
                            <jsp:include page="../common/book-card.jsp"/>
                        </c:when>
                        <c:otherwise>
                            <div class="md:col-span-2 xl:col-span-3 rounded-xl border border-border bg-card shadow-sm p-8 text-center">
                                <h3 class="text-xl font-semibold text-foreground mb-3">No books found</h3>
                                <p class="text-muted-foreground mb-5">Try changing the search text, category, or price range.</p>
                                <a href="${pageContext.request.contextPath}/explore">
                                    <button type="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer h-10 rounded-md px-5 text-primary-foreground bg-primary hover:bg-primary/90">
                                        Clear Filters
                                    </button>
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex items-center justify-center gap-2 mt-8">
                    <c:url var="previousPageUrl" value="/explore">
                        <c:if test="${not empty selectedCategoryParam}">
                            <c:param name="category" value="${selectedCategoryParam}"/>
                        </c:if>
                        <c:if test="${not empty selectedSearchQuery}">
                            <c:param name="query" value="${selectedSearchQuery}"/>
                        </c:if>
                        <c:param name="maxPrice" value="${selectedMaxPrice}"/>
                        <c:param name="sort" value="${selectedSortCriteria}"/>
                        <c:param name="page" value="${currentPageNumber - 1}"/>
                    </c:url>
                    <c:url var="nextPageUrl" value="/explore">
                        <c:if test="${not empty selectedCategoryParam}">
                            <c:param name="category" value="${selectedCategoryParam}"/>
                        </c:if>
                        <c:if test="${not empty selectedSearchQuery}">
                            <c:param name="query" value="${selectedSearchQuery}"/>
                        </c:if>
                        <c:param name="maxPrice" value="${selectedMaxPrice}"/>
                        <c:param name="sort" value="${selectedSortCriteria}"/>
                        <c:param name="page" value="${currentPageNumber + 1}"/>
                    </c:url>

                    <a href="${hasPreviousPage ? previousPageUrl : '#'}">
                        <button type="button"
                                class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-8 rounded-md gap-1.5 px-3"
                                <c:if test="${not hasPreviousPage}">disabled="disabled"</c:if>>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-left w-4 h-4" aria-hidden="true">
                                <path d="m15 18-6-6 6-6"></path>
                            </svg>
                        </button>
                    </a>

                    <button type="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-default h-8 rounded-md gap-1.5 px-3 text-primary-foreground bg-primary hover:bg-primary/90">
                        ${currentPageNumber}
                    </button>

                    <a href="${hasNextPage ? nextPageUrl : '#'}">
                        <button type="button"
                                class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-8 rounded-md gap-1.5 px-3"
                                <c:if test="${not hasNextPage}">disabled="disabled"</c:if>>
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-right w-4 h-4" aria-hidden="true">
                                <path d="m9 18 6-6-6-6"></path>
                            </svg>
                        </button>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/explore/explore.js"></script>
</body>
</html>
