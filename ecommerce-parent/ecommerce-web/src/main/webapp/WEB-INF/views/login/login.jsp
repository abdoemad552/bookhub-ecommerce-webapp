<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charSet="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
  <meta name="description"
        content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
  <meta name="generator" content="BookHub"/>
  <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
  <title>BookHub - Your Gateway to Endless Stories</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/bookhub-favicon.svg">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">

  <script type="module" src="${pageContext.request.contextPath}/assets/js/login/login.js"></script>

</head>

<body class="font-google-sans antialiased">
<jsp:include page="../common/header.jsp">
  <jsp:param name="showCategoryNav" value="false"/>
</jsp:include>
<div class="min-h-screen bg-gradient-to-br from-background via-background to-accent/5 flex items-center justify-center px-4 py-8 relative">

  <div class="w-full max-w-md relative z-10">

    <!-- Floating accent -->
    <div class="absolute -top-20 -right-20 w-40 h-40 bg-accent/20 rounded-full blur-3xl animate-float opacity-30"></div>

    <div class="card-modern rounded-2xl p-8 sm:p-10 animate-slide-up shadow-2xl">

      <div class="animate-slide-down delay-2 mb-8">
        <h2 class="text-3xl font-bold text-foreground mb-2">Welcome Back</h2>
        <p class="text-sm text-muted-foreground mt-1">Good to see you again. Here's what's waiting.</p>
      </div>

      <!-- JS alert -->
      <div id="js-alert" class="alert-banner alert-error" style="display:none;" role="alert">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <span id="js-alert-text"></span>
      </div>

      <!-- Flash success message from signup -->
      <c:if test="${not empty requestScope.flash_message}">
        <div id="flash-success"
             class="alert-success flex items-start gap-3 w-full bg-emerald-500/10 border border-emerald-500/30
                            text-emerald-400 rounded-xl px-4 py-3.5 mb-6 animate-slide-down" role="alert">

          <!-- Icon -->
          <svg class="w-5 h-5 flex-shrink-0 mt-0.5"
               xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
               fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
            <polyline points="22 4 12 14.01 9 11.01"></polyline>
          </svg>

          <!-- Text -->
          <div class="flex-1 min-w-0">
            <p class="text-sm font-semibold leading-snug">${requestScope.flash_message}</p>
          </div>
        </div>
      </c:if>

      <form action="login" method="post" id="login-form" class="space-y-6">

        <!-- Email/UserName Input -->
        <div class="animate-slide-up delay-3 group">
          <label class="label-modern block text-sm font-semibold text-foreground mb-3 uppercase tracking-wide">Email
            or UserName</label>
          <div class="relative">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
              <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>
              <rect x="2" y="4" width="20" height="16" rx="2"></rect>
            </svg>
            <input type="text" id="username" name="usernameOrEmail" placeholder="Email or Username"
                   value="${requestScope.flash_username}"
                   class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
          </div>
        </div>

        <!-- Password Input -->
        <div class="group mb-5">
          <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                 for="password">Password</label>
          <div class="relative">
            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                 xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2">
              <rect width="18" height="11" x="3" y="11" rx="2"></rect>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
            <input type="password" id="password" name="password" placeholder="Enter your password"
                   autocomplete="new-password"
                   class="input-modern w-full pl-12 pr-11 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
            <button type="button" id="submit-btn" class="pw-toggle" onclick="togglePw('password',this)"
                    aria-label="Toggle password">
              <svg id="eye-password" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                   fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                   stroke-linejoin="round">
                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>
        </div>

        <!-- Checkbox Options -->
        <div class="animate-slide-up checkbox-group">
          <label class="checkbox-item">
            <input type="checkbox" name="rememberMe" class="checkbox-modern">
            <span>Remember me</span>
          </label>
        </div>

        <!-- Log In Button -->
        <button type="submit"
                class="btn-modern w-full py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/40 focus:ring-offset-2 focus:ring-offset-background active:scale-95 transition-all duration-300 mt-4 relative z-10 uppercase tracking-wide">
          Log In
        </button>
      </form>

      <!-- Divider -->
      <div class="divider-modern">
        <span class="select-none">New to BookHub?</span>
      </div>

      <!-- Footer Links -->
      <div class="space-y-3 text-center animate-fade-in" style="animation-delay: 0.6s;">
        <a href="signup" class="link-modern text-sm font-semibold">
          Create New Account
        </a>
      </div>

    </div>
  </div>

</div>
<jsp:include page="../common/footer.jsp"/>
</body>
</html>