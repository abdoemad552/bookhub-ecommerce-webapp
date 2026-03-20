<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
<div class="min-h-screen bg-background flex flex-col overflow-hidden">
    <jsp:include page="../common/header.jsp"/>
    <main class="flex-1 flex items-center justify-center px-4 py-16 relative">
        <div class="absolute inset-0 overflow-hidden pointer-events-none">
            <div class="absolute top-20 left-10 animate-pulse">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-8 h-8 text-primary/10" aria-hidden="true">
                    <path d="M12 7v14"></path>
                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                </svg>
            </div>
            <div class="absolute top-40 right-20 animate-pulse" style="animation-delay:0.5s">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-12 h-12 text-primary/10" aria-hidden="true">
                    <path d="M12 7v14"></path>
                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                </svg>
            </div>
            <div class="absolute bottom-32 left-1/4 animate-pulse" style="animation-delay:0.25s">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-6 h-6 text-primary/10" aria-hidden="true">
                    <path d="M12 7v14"></path>
                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                </svg>
            </div>
            <div class="absolute bottom-20 right-1/3 animate-pulse" style="animation-delay:0.75s">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-10 h-10 text-primary/10" aria-hidden="true">
                    <path d="M12 7v14"></path>
                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                </svg>
            </div>
        </div>
        <div class="max-w-xl w-full text-center relative z-10">
            <div class="mb-10 relative">
                <div class="absolute inset-0 flex items-center justify-center">
                    <div class="w-64 h-64 rounded-full border-2 border-primary/10 animate-ping opacity-50"></div>
                </div>
                <div class="absolute inset-0 flex items-center justify-center">
                    <div class="w-48 h-48 rounded-full border-2 border-primary/20 animate-pulse"></div>
                </div>
                <div class="relative inline-flex items-center justify-center">
                    <svg viewBox="0 0 200 180" class="w-64 h-56" xmlns="http://www.w3.org/2000/svg">
                        <ellipse cx="100" cy="165" rx="60" ry="10" class="fill-foreground/5"></ellipse>
                        <g>
                            <rect x="40" y="120" width="120" height="30" rx="3" class="fill-primary/30"></rect>
                            <rect x="40" y="120" width="8" height="30" rx="2" class="fill-primary/50"></rect>
                            <line x1="55" y1="128" x2="150" y2="128" class="stroke-primary/20" stroke-width="2"></line>
                            <line x1="55" y1="135" x2="120" y2="135" class="stroke-primary/20" stroke-width="2"></line>
                        </g>
                        <g>
                            <rect x="50" y="85" width="110" height="30" rx="3" class="fill-primary/40"></rect>
                            <rect x="50" y="85" width="8" height="30" rx="2" class="fill-primary/60"></rect>
                            <line x1="65" y1="93" x2="140" y2="93" class="stroke-primary/30" stroke-width="2"></line>
                            <line x1="65" y1="100" x2="110" y2="100" class="stroke-primary/30" stroke-width="2"></line>
                        </g>
                        <g>
                            <rect x="70" y="40" width="60" height="40" rx="2" class="fill-primary/50"></rect>
                            <path d="M70 40 Q50 50 55 80 L70 80 Z" class="fill-background stroke-primary/30" stroke-width="1"></path>
                            <path d="M130 40 Q150 50 145 80 L130 80 Z" class="fill-background stroke-primary/30" stroke-width="1"></path>
                            <line x1="58" y1="55" x2="68" y2="52" class="stroke-primary/20" stroke-width="1"></line>
                            <line x1="57" y1="62" x2="68" y2="58" class="stroke-primary/20" stroke-width="1"></line>
                            <line x1="56" y1="69" x2="69" y2="64" class="stroke-primary/20" stroke-width="1"></line>
                            <line x1="132" y1="52" x2="142" y2="55" class="stroke-primary/20" stroke-width="1"></line>
                            <line x1="132" y1="58" x2="143" y2="62" class="stroke-primary/20" stroke-width="1"></line>
                            <line x1="131" y1="64" x2="144" y2="69" class="stroke-primary/20" stroke-width="1"></line>
                        </g>
                        <text x="100" y="30" text-anchor="middle" class="fill-primary/50 text-3xl font-bold animate-pulse" style="animation-duration:2s">?</text>
                    </svg>
                </div>
            </div>
            <div class="mb-4">
                <span class="inline-block text-8xl md:text-9xl font-black text-transparent bg-clip-text bg-linear-to-r from-primary/80 to-primary/40 animate-pulse">404</span>
            </div>
            <h1 class="text-2xl md:text-3xl font-bold text-foreground mb-3">Oops! Page Not Found</h1>
            <p class="text-base text-muted-foreground mb-8 text-balance max-w-md mx-auto">This page seems to have wandered off the shelves. Let us help you find your way back to our collection.</p>
            <div class="flex flex-col sm:flex-row gap-3 justify-center mb-10">
                <a href="${pageContext.request.contextPath}/">
                    <button data-slot="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed  outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-10 rounded-md px-6 bg-primary hover:bg-primary/90 w-full sm:w-auto transition-all hover:scale-105 active:scale-95">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-house w-4 h-4 mr-2" aria-hidden="true">
                            <path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"></path>
                            <path d="M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        </svg>
                        Back to Home
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore">
                    <button data-slot="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed  outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 h-10 rounded-md px-6 w-full sm:w-auto transition-all hover:scale-105 active:scale-95">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search w-4 h-4 mr-2" aria-hidden="true">
                            <path d="m21 21-4.34-4.34"></path>
                            <circle cx="11" cy="11" r="8"></circle>
                        </svg>
                        Browse Books
                    </button>
                </a>
            </div>
            <div class="border-t border-border pt-6">
                <p class="text-sm text-muted-foreground mb-3">Quick links:</p>
                <div class="flex flex-wrap justify-center gap-4">
                    <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors" href="${pageContext.request.contextPath}/explore">All Books</a>
                    <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors" href="${pageContext.request.contextPath}/cart">Cart</a>
                    <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors" href="${pageContext.request.contextPath}/profile">Profile</a>
                    <c:if test="${empty sessionScope.user}">
                        <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors" href="${pageContext.request.contextPath}/login">Login</a>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
<script type="module" src="${pageContext.request.contextPath}/assets/js/error/page-not-found.js"></script>
</body>
</html>
