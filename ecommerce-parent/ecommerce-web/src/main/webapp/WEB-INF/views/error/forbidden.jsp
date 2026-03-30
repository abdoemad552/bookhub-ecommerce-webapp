<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">
<head>
  <meta charSet="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
  <title>BookHub - Your Gateway to Endless Stories</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/bookhub-favicon.svg">
  <meta name="description"
        content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
  <meta name="generator" content="BookHub"/>
  <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background flex flex-col overflow-hidden">
  <%-- HEADER --%>
  <jsp:include page="../common/header.jsp">
    <jsp:param name="showCategoryNav" value="false"/>
  </jsp:include>

    <main class="flex-1 flex items-center justify-center px-4 py-16 relative">
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute top-20 left-10 animate-pulse">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-shield-off w-8 h-8 text-destructive/10" aria-hidden="true">
          <path d="m2 2 20 20"></path>
          <path d="M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71"></path>
          <path d="M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264"></path>
        </svg>
      </div>
      <div class="absolute top-40 right-20 animate-pulse" style="animation-delay:0.5s">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-shield-off w-12 h-12 text-destructive/10" aria-hidden="true">
          <path d="m2 2 20 20"></path>
          <path d="M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71"></path>
          <path d="M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264"></path>
        </svg>
      </div>
      <div class="absolute bottom-32 left-1/4 animate-pulse" style="animation-delay:0.25s">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-shield-off w-6 h-6 text-destructive/10" aria-hidden="true">
          <path d="m2 2 20 20"></path>
          <path d="M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71"></path>
          <path d="M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264"></path>
        </svg>
      </div>
      <div class="absolute bottom-20 right-1/3 animate-pulse" style="animation-delay:0.75s">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-shield-off w-10 h-10 text-destructive/10" aria-hidden="true">
          <path d="m2 2 20 20"></path>
          <path d="M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71"></path>
          <path d="M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264"></path>
        </svg>
      </div>
    </div>
    <div class="max-w-xl w-full text-center relative z-10">
      <div class="mb-10 relative">
        <div class="absolute inset-0 flex items-center justify-center">
          <div class="w-64 h-64 rounded-full border-2 border-destructive/10 animate-ping opacity-50"></div>
        </div>
        <div class="absolute inset-0 flex items-center justify-center">
          <div class="w-48 h-48 rounded-full border-2 border-destructive/20 animate-pulse"></div>
        </div>
        <div class="relative inline-flex items-center justify-center">
          <svg viewBox="0 0 200 200" class="w-56 h-56" xmlns="http://www.w3.org/2000/svg">
            <ellipse cx="100" cy="180" rx="50" ry="10" class="fill-foreground/5"></ellipse>
            <path d="M100 20 L160 45 L160 100 Q160 150 100 175 Q40 150 40 100 L40 45 Z"
                  class="fill-destructive/20 stroke-destructive/40" stroke-width="3"></path>
            <path d="M100 35 L145 55 L145 100 Q145 140 100 160 Q55 140 55 100 L55 55 Z"
                  class="fill-background stroke-destructive/30" stroke-width="2"></path>
            <rect x="75" y="85" width="50" height="40" rx="5" class="fill-destructive/40"></rect>
            <path d="M85 85 L85 70 Q85 55 100 55 Q115 55 115 70 L115 85" class="fill-none stroke-destructive/50"
                  stroke-width="6" stroke-linecap="round"></path>
            <circle cx="100" cy="100" r="6" class="fill-background"></circle>
            <rect x="97" y="100" width="6" height="12" rx="2" class="fill-background"></rect>
            <g class="animate-pulse">
              <line x1="80" y1="140" x2="120" y2="140" class="stroke-destructive" stroke-width="4"
                    stroke-linecap="round"></line>
            </g>
          </svg>
        </div>
      </div>
      <div class="mb-4">
        <span class="inline-block text-8xl md:text-9xl font-black text-transparent bg-clip-text bg-linear-to-r from-destructive/80 to-destructive/40 animate-pulse">403</span>
      </div>
      <h1 class="text-2xl md:text-3xl font-bold text-foreground mb-3">Access Denied</h1>
      <p class="text-base text-muted-foreground mb-8 text-balance max-w-md mx-auto">You do not have permission to access
        this page. Please sign in with an authorized account or contact support if you believe this is an error.</p>
      <div class="flex flex-col sm:flex-row gap-3 justify-center mb-10">
        <a href="${pageContext.request.contextPath}/login">
          <button data-slot="button"
                  class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-10 rounded-md px-6 has-[&gt;svg]:px-4 bg-primary hover:bg-primary/90 w-full sm:w-auto transition-all hover:scale-105 active:scale-95">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 class="lucide lucide-log-in w-4 h-4 mr-2" aria-hidden="true">
              <path d="m10 17 5-5-5-5"></path>
              <path d="M15 12H3"></path>
              <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
            </svg>
            Sign In
          </button>
        </a>
        <a href="${pageContext.request.contextPath}/">
          <button data-slot="button"
                  class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 h-10 rounded-md px-6 has-[&gt;svg]:px-4 w-full sm:w-auto transition-all hover:scale-105 active:scale-95">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 class="lucide lucide-house w-4 h-4 mr-2" aria-hidden="true">
              <path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"></path>
              <path d="M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
            </svg>
            Back to Home
          </button>
        </a>
      </div>
      <div class="border-t border-border pt-6">
        <p class="text-sm text-muted-foreground mb-3">Quick links:</p>
        <div class="flex flex-wrap justify-center gap-4">
          <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors"
             href="${pageContext.request.contextPath}/explore">All Books</a>
          <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors"
             href="${pageContext.request.contextPath}/cart">Cart</a>
          <c:if test="${empty sessionScope.user}">
            <a class="text-sm text-primary hover:text-primary/80 hover:underline transition-colors"
               href="${pageContext.request.contextPath}/signup">Create Account</a>
          </c:if>
        </div>
      </div>
    </div>
  </main>
  <jsp:include page="../common/footer.jsp"/>
</div>
<script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
<script type="module" src="${pageContext.request.contextPath}/assets/js/error/forbidden.js"></script>
</body>
</html>

