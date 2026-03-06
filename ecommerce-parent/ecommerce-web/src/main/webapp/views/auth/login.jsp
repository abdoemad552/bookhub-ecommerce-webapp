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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
</head>

<body class="font-serif antialiased">

<div class="min-h-screen bg-gradient-to-br from-background via-background to-accent/5 flex items-center justify-center px-4 py-8 relative">

    <div class="w-full max-w-md relative z-10">

        <!-- Floating accent -->
        <div class="absolute -top-20 -right-20 w-40 h-40 bg-accent/20 rounded-full blur-3xl animate-float opacity-30"></div>

        <div class="card-modern rounded-2xl p-8 sm:p-10 animate-slide-up shadow-2xl">

            <div class="animate-slide-down delay-1 mb-8">
                <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3 mb-4">
                    <div class="p-3 bg-gradient-to-br from-primary/20 to-accent/20 rounded-xl">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             class="text-primary icon-pulse">
                            <path d="M12 7v14"></path>
                            <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                        </svg>
                    </div>
                    <h1 class="text-3xl font-display text-gradient">BookHub</h1>
                </a>
            </div>

            <div class="animate-slide-down delay-2 mb-8">
                <h2 class="text-4xl font-display text-foreground mb-2">Welcome Back</h2>
            </div>

            <form action="login" method="post" class="space-y-6">

                <!-- Email/UserName Input -->
                <div class="animate-slide-up delay-3 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-3 uppercase tracking-wide">Email
                        or UserName</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none">
                            <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>
                            <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                        </svg>
                        <input type="text" id="js-username" placeholder="Email or Username"
                               class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                </div>

                <!-- Password Input -->
                <div class="animate-slide-up delay-4 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-3 uppercase tracking-wide">Password</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="js-password" placeholder="Password"
                               class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                </div>

                <!-- Checkbox Options -->
                <div class="animate-slide-up checkbox-group">
                    <label class="checkbox-item">
                        <input type="checkbox" name="rememberMe" class="checkbox-modern">
                        <span>Remember me</span>
                    </label>

                    <label class="checkbox-item">
                        <input type="checkbox" name="emailUpdates" class="checkbox-modern">
                        <span>Send me updates</span>
                    </label>
                </div>

                <!-- Error message container -->
                <div id="js-error-message" class="hidden mt-2 text-sm text-red-600 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-info-circle flex-shrink-0" viewBox="0 0 16 16">
                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"></path>
                        <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"></path>
                    </svg>
                    <span class="error-text">Username and password are required</span>
                </div>

                <!-- Log In Button -->
                <button type="submit"
                        class="btn-modern w-full py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/40 focus:ring-offset-2 focus:ring-offset-background active:scale-95 transition-all duration-300 mt-4 relative z-10 uppercase tracking-wide">
                    Log In
                </button>
            </form>

            <!-- Divider -->
            <div class="divider-modern">
                <span>New to BookHub</span>
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

<!-- Validation Script -->
<script src="${pageContext.request.contextPath}/assets/java-script/login.js"></script>

</body>
</html>