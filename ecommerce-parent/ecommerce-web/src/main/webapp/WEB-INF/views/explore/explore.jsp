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
    <div class="w-full mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-1">
                <jsp:include page="sidebar-filter.jsp"/>
            </div>
            <div id="filter-books-container" class="lg:col-span-3">
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/explore/explore.js"></script>
</body>
</html>
