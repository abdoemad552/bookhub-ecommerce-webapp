<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <meta name="description" content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
    <title>BookHub - Create Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
</head>

<body class="font-serif antialiased">

<div class="min-h-screen bg-gradient-to-br from-background via-background to-accent/5 flex items-center justify-center px-4 py-8 relative">

    <div class="w-full max-w-2xl relative z-10">

        <!-- Floating accent -->
        <div class="absolute -top-20 -right-20 w-40 h-40 bg-accent/20 rounded-full blur-3xl animate-float opacity-30"></div>

        <div class="card-modern rounded-2xl p-8 sm:p-10 animate-slide-up shadow-2xl">

            <!-- Header Section -->
            <div class="animate-slide-down delay-1 mb-8">
                <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3 mb-4">
                    <div class="p-3 bg-gradient-to-br from-primary/20 to-accent/20 rounded-xl">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary icon-pulse">
                            <path d="M12 7v14"></path>
                            <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                        </svg>
                    </div>
                    <h1 class="text-3xl font-display text-gradient">BookHub</h1>
                </a>
            </div>

            <!-- Title Section -->
            <div class="animate-slide-down delay-2 mb-8">
                <h2 class="text-4xl font-display text-foreground mb-2">Join Us</h2>
                <p class="text-muted-foreground">Create your reading sanctuary</p>
            </div>

            <!-- Form -->
            <form action="signup" method="post" enctype="multipart/form-data" class="space-y-5">

                <!-- Name Row -->
                <div class="grid grid-cols-2 gap-4 animate-slide-up delay-3">
                    <!-- First Name -->
                    <div class="group">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">First Name</label>
                        <div class="relative">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <input type="text" name="firstName" placeholder="First name" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                        </div>
                    </div>

                    <!-- Last Name -->
                    <div class="group">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Last Name</label>
                        <div class="relative">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <input type="text" name="lastName" placeholder="Last name" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                        </div>
                    </div>
                </div>

                <!-- Username Input -->
                <div class="animate-slide-up delay-4 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Username</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <input type="text" name="username" placeholder="Username" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                    <p class="text-xs text-muted-foreground mt-2">3-20 characters, letters and numbers only</p>
                </div>

                <!-- Email Input -->
                <div class="animate-slide-up delay-4 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Email Address</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                            <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>
                            <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                        </svg>
                        <input type="email" name="email" placeholder="Email" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                </div>

                <!-- Birth Date Input -->
                <div class="animate-slide-up delay-4 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Birth Date</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                            <rect width="18" height="18" x="3" y="4" rx="2"></rect>
                            <path d="M16 2v4"></path>
                            <path d="M8 2v4"></path>
                            <path d="M3 10h18"></path>
                        </svg>
                        <input type="date" name="birthDate" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                    <p class="text-xs text-muted-foreground mt-2">Must be 18 years or older</p>
                </div>

                <!-- Password Input -->
                <div class="animate-slide-up delay-5 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Password</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" name="password" placeholder="Password" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                    <p class="text-xs text-muted-foreground mt-2">Must contain at least 8 characters</p>
                </div>

                <!-- Confirm Password Input -->
                <div class="animate-slide-up delay-5 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Confirm Password</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" name="confirmPassword" placeholder="Confirm password" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                </div>

                <!-- Credit card limit -->
                <div class="animate-slide-up delay-3 group">
                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Credit Card Limit</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">
                            <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                            <line x1="2" x2="22" y1="10" y2="10"></line>
                        </svg>
                        <input type="number" name="creditCardLimit" min="0" placeholder="Your Limit" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                    </div>
                </div>

                <!-- Profile Picture Upload -->
<%--                <div class="animate-slide-up delay-3 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Profile Picture</label>--%>
<%--                    <div class="relative">--%>
<%--                        <input type="file" name="profilePic" accept="image/*" class="input-modern w-full pl-4 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-primary file:text-primary-foreground hover:file:bg-primary/90 cursor-pointer"/>--%>
<%--                    </div>--%>
<%--                    <p class="text-xs text-muted-foreground mt-2">Optional - JPG, PNG or GIF (Max 5MB)</p>--%>
<%--                </div>--%>

                <!-- Error message container -->
                <div id="js-error-message" class="hidden mt-2 text-sm text-red-600 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-circle flex-shrink-0" viewBox="0 0 16 16">
                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"></path>
                        <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"></path>
                    </svg>
                    <span class="error-text"></span>
                </div>

                <!-- Sign Up Button -->
                <button type="submit" class="btn-modern w-full py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/40 focus:ring-offset-2 focus:ring-offset-background active:scale-95 transition-all duration-300 mt-6 relative z-10 uppercase tracking-wide">
                    Sign Up
                </button>
            </form>

            <!-- Divider -->
            <div class="divider-modern">
                <span>Already have an account</span>
            </div>

            <!-- Footer Links -->
            <div class="space-y-3 text-center animate-fade-in" style="animation-delay: 0.6s;">
                <a href="login" class="link-modern block text-sm font-semibold">
                    Log In to BookHub
                </a>
            </div>

        </div>
    </div>

</div>

<!-- Validation Script -->
<script src="${pageContext.request.contextPath}/assets/java-script/signup.js"></script>

</body>
</html>
