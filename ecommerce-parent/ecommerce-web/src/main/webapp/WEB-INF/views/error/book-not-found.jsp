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
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background flex flex-col">
    <%-- HEADER --%>
    <jsp:include page="../common/header.jsp">
        <jsp:param name="showCategoryNav" value="false"/>
    </jsp:include>

    <main class="flex-1 flex items-center justify-center px-4 py-16">
        <div class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-8 text-center w-full max-w-md">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-12 h-12 text-muted-foreground mx-auto mb-4" aria-hidden="true">
                <path d="M12 7v14"></path>
                <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
            </svg>

            <div>
                <h2 class="text-xl font-bold text-foreground mb-2">Book not found</h2>
                <p class="text-muted-foreground mb-4">The book you&#39;re looking for doesn&#39;t exist.</p>
            </div>

            <div>
                <a href="${pageContext.request.contextPath}/explore">
                    <button type="button"
                            class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">
                        Back to Books
                    </button>
                </a>
            </div>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp"/>
</div>
<script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
<script type="module" src="${pageContext.request.contextPath}/assets/js/error/book-not-found.js"></script>
</body>
</html>
