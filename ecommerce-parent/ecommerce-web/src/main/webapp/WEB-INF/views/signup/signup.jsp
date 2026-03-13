<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <meta charSet="utf-8"/>--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>--%>
<%--    <meta name="description" content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>--%>
<%--    <meta name="generator" content="BookHub"/>--%>
<%--    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>--%>
<%--    <title>BookHub - Create Account</title>--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">--%>
<%--</head>--%>

<%--<body class="font-serif antialiased">--%>

<%--<div class="min-h-screen bg-gradient-to-br from-background via-background to-accent/5 flex items-center justify-center px-4 py-8 relative">--%>

<%--    <div class="w-full max-w-2xl relative z-10">--%>

<%--        <!-- Floating accent -->--%>
<%--        <div class="absolute -top-20 -right-20 w-40 h-40 bg-accent/20 rounded-full blur-3xl animate-float opacity-30"></div>--%>

<%--        <div class="card-modern rounded-2xl p-8 sm:p-10 animate-slide-up shadow-2xl">--%>

<%--            <!-- Header Section -->--%>
<%--            <div class="animate-slide-down delay-1 mb-8">--%>
<%--                <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3 mb-4">--%>
<%--                    <div class="p-3 bg-gradient-to-br from-primary/20 to-accent/20 rounded-xl">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary icon-pulse">--%>
<%--                            <path d="M12 7v14"></path>--%>
<%--                            <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>--%>
<%--                        </svg>--%>
<%--                    </div>--%>
<%--                    <h1 class="text-3xl font-display text-gradient">BookHub</h1>--%>
<%--                </a>--%>
<%--            </div>--%>

<%--            <!-- Title Section -->--%>
<%--            <div class="animate-slide-down delay-2 mb-8">--%>
<%--                <h2 class="text-4xl font-display text-foreground mb-2">Join Us</h2>--%>
<%--                <p class="text-muted-foreground">Create your reading sanctuary</p>--%>
<%--            </div>--%>

<%--            <!-- Form -->--%>
<%--            <form action="signup" method="post" enctype="multipart/form-data" class="space-y-5">--%>

<%--                <!-- Name Row -->--%>
<%--                <div class="grid grid-cols-2 gap-4 animate-slide-up delay-3">--%>
<%--                    <!-- First Name -->--%>
<%--                    <div class="group">--%>
<%--                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">First Name</label>--%>
<%--                        <div class="relative">--%>
<%--                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>--%>
<%--                                <circle cx="12" cy="7" r="4"></circle>--%>
<%--                            </svg>--%>
<%--                            <input type="text" name="firstName" placeholder="First name" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- Last Name -->--%>
<%--                    <div class="group">--%>
<%--                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Last Name</label>--%>
<%--                        <div class="relative">--%>
<%--                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>--%>
<%--                                <circle cx="12" cy="7" r="4"></circle>--%>
<%--                            </svg>--%>
<%--                            <input type="text" name="lastName" placeholder="Last name" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                <!-- Username Input -->--%>
<%--                <div class="animate-slide-up delay-4 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Username</label>--%>
<%--                    <div class="relative">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>--%>
<%--                            <circle cx="12" cy="7" r="4"></circle>--%>
<%--                        </svg>--%>
<%--                        <input type="text" name="username" placeholder="Username" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                    </div>--%>
<%--                    <p class="text-xs text-muted-foreground mt-2">3-20 characters, letters and numbers only</p>--%>
<%--                </div>--%>

<%--                <!-- Email Input -->--%>
<%--                <div class="animate-slide-up delay-4 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Email Address</label>--%>
<%--                    <div class="relative">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                            <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>--%>
<%--                            <rect x="2" y="4" width="20" height="16" rx="2"></rect>--%>
<%--                        </svg>--%>
<%--                        <input type="email" name="email" placeholder="Email" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                <!-- Birth Date Input -->--%>
<%--                <div class="animate-slide-up delay-4 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Birth Date</label>--%>
<%--                    <div class="relative">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                            <rect width="18" height="18" x="3" y="4" rx="2"></rect>--%>
<%--                            <path d="M16 2v4"></path>--%>
<%--                            <path d="M8 2v4"></path>--%>
<%--                            <path d="M3 10h18"></path>--%>
<%--                        </svg>--%>
<%--                        <input type="date" name="birthDate" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                    </div>--%>
<%--                    <p class="text-xs text-muted-foreground mt-2">Must be 18 years or older</p>--%>
<%--                </div>--%>

<%--                <!-- Password Input -->--%>
<%--                <div class="animate-slide-up delay-5 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Password</label>--%>
<%--                    <div class="relative">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>--%>
<%--                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>--%>
<%--                        </svg>--%>
<%--                        <input type="password" name="password" placeholder="Password" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                    </div>--%>
<%--                    <p class="text-xs text-muted-foreground mt-2">Must contain at least 8 characters</p>--%>
<%--                </div>--%>

<%--                <!-- Confirm Password Input -->--%>
<%--                <div class="animate-slide-up delay-5 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Confirm Password</label>--%>
<%--                    <div class="relative">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>--%>
<%--                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>--%>
<%--                        </svg>--%>
<%--                        <input type="password" name="confirmPassword" placeholder="Confirm password" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                <!-- Credit card limit -->--%>
<%--                <div class="animate-slide-up delay-3 group">--%>
<%--                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Credit Card Limit</label>--%>
<%--                    <div class="relative">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10">--%>
<%--                            <rect width="20" height="14" x="2" y="5" rx="2"></rect>--%>
<%--                            <line x1="2" x2="22" y1="10" y2="10"></line>--%>
<%--                        </svg>--%>
<%--                        <input type="number" name="creditCardLimit" min="0" placeholder="Your Limit" class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                <!-- Profile Picture Upload -->--%>
<%--&lt;%&ndash;                <div class="animate-slide-up delay-3 group">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide">Profile Picture</label>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="relative">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <input type="file" name="profilePic" accept="image/*" class="input-modern w-full pl-4 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-primary file:text-primary-foreground hover:file:bg-primary/90 cursor-pointer"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-xs text-muted-foreground mt-2">Optional - JPG, PNG or GIF (Max 5MB)</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>

<%--                <!-- Error message container -->--%>
<%--                <div id="js-error-message" class="hidden mt-2 text-sm text-red-600 flex items-center gap-2">--%>
<%--                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-circle flex-shrink-0" viewBox="0 0 16 16">--%>
<%--                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"></path>--%>
<%--                        <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"></path>--%>
<%--                    </svg>--%>
<%--                    <span class="error-text"></span>--%>
<%--                </div>--%>

<%--                <!-- Sign Up Button -->--%>
<%--                <button type="submit" class="btn-modern w-full py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/40 focus:ring-offset-2 focus:ring-offset-background active:scale-95 transition-all duration-300 mt-6 relative z-10 uppercase tracking-wide">--%>
<%--                    Sign Up--%>
<%--                </button>--%>
<%--            </form>--%>

<%--            <!-- Divider -->--%>
<%--            <div class="divider-modern">--%>
<%--                <span>Already have an account</span>--%>
<%--            </div>--%>

<%--            <!-- Footer Links -->--%>
<%--            <div class="space-y-3 text-center animate-fade-in" style="animation-delay: 0.6s;">--%>
<%--                <a href="login" class="link-modern block text-sm font-semibold">--%>
<%--                    Log In to BookHub--%>
<%--                </a>--%>
<%--            </div>--%>

<%--        </div>--%>
<%--    </div>--%>

<%--</div>--%>

<%--<!-- Validation Script -->--%>
<%--<script src="${pageContext.request.contextPath}/assets/java-script/signup.js"></script>--%>

<%--</body>--%>
<%--</html>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    com.iti.jets.model.dto.request.RegisterRequestDTO formData =
            (com.iti.jets.model.dto.request.RegisterRequestDTO) request.getAttribute("formData");
    String errorMsg = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>BookHub — Create Account</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --ink:       #1a1612;
            --ink-muted: #6b6560;
            --paper:     #faf8f5;
            --surface:   #ffffff;
            --border:    #e2ddd8;
            --accent:    #c8522a;
            --accent-lt: #f7ece7;
            --success:   #2d7a4f;
            --success-lt:#e8f5ee;
            --radius:    12px;
            --shadow:    0 1px 3px rgba(26,22,18,.06), 0 8px 24px rgba(26,22,18,.08);
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--paper);
            color: var(--ink);
            min-height: 100vh;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 48px 16px 64px;
        }

        /* Subtle grain overlay */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 0;
        }

        .page-wrap { width: 100%; max-width: 560px; position: relative; z-index: 1; }

        /* ── Brand bar ── */
        .brand {
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 32px;
            text-decoration: none; color: inherit;
        }
        .brand-icon {
            width: 36px; height: 36px;
            background: var(--ink);
            border-radius: 8px;
            display: grid; place-items: center;
        }
        .brand-icon svg { width: 20px; height: 20px; color: var(--paper); }
        .brand-name {
            font-family: 'DM Serif Display', serif;
            font-size: 22px; letter-spacing: -0.3px;
        }

        /* ── Card ── */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 40px 40px 36px;
            box-shadow: var(--shadow);
        }
        @media (max-width: 480px) { .card { padding: 28px 20px; } }

        .card-header { margin-bottom: 32px; }
        .card-title {
            font-family: 'DM Serif Display', serif;
            font-size: 32px; letter-spacing: -0.5px;
            line-height: 1.1; margin-bottom: 6px;
        }
        .card-subtitle { font-size: 14px; color: var(--ink-muted); font-weight: 400; }

        /* ── Alert banner ── */
        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 14px;
            border-radius: var(--radius);
            font-size: 14px; font-weight: 500;
            margin-bottom: 24px;
            animation: slide-in 0.25s ease;
        }
        .alert-error  { background: var(--accent-lt);  color: var(--accent);  border: 1px solid #f0c4b5; }
        .alert-success{ background: var(--success-lt); color: var(--success); border: 1px solid #b3ddc4; }
        .alert-icon { width: 16px; height: 16px; flex-shrink: 0; margin-top: 1px; }

        @keyframes slide-in {
            from { opacity: 0; transform: translateY(-6px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Form ── */
        .form { display: flex; flex-direction: column; gap: 20px; }

        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        @media (max-width: 480px) { .row-2 { grid-template-columns: 1fr; } }

        .field { display: flex; flex-direction: column; gap: 6px; }

        label {
            font-size: 12px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.06em;
            color: var(--ink-muted);
        }

        .input-wrap { position: relative; }
        .input-icon {
            position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
            width: 16px; height: 16px; color: #b0a89e; pointer-events: none;
        }
        .input-wrap.has-toggle .input-icon { top: 50%; }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            height: 46px;
            padding: 0 14px 0 42px;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            color: var(--ink);
            background: #fdfcfb;
            outline: none;
            transition: border-color .15s, box-shadow .15s, background .15s;
            -webkit-appearance: none;
        }
        input:focus {
            border-color: var(--ink);
            background: var(--surface);
            box-shadow: 0 0 0 3px rgba(26,22,18,.07);
        }
        input.invalid {
            border-color: var(--accent);
            background: var(--accent-lt);
        }
        input[type="date"] { cursor: pointer; }

        /* password toggle */
        .pw-toggle {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: var(--ink-muted); padding: 4px; border-radius: 4px;
            display: flex; align-items: center;
        }
        .pw-toggle:hover { color: var(--ink); }
        .pw-toggle svg { width: 16px; height: 16px; }

        .hint { font-size: 12px; color: var(--ink-muted); margin-top: 4px; }
        .hint.error { color: var(--accent); font-weight: 500; }

        /* strength bar */
        .strength-wrap { display: flex; gap: 4px; margin-top: 6px; }
        .strength-bar {
            height: 3px; flex: 1; border-radius: 99px;
            background: var(--border);
            transition: background .3s;
        }

        /* ── Divider ── */
        .section-label {
            font-size: 11px; font-weight: 600; letter-spacing: 0.08em;
            text-transform: uppercase; color: var(--ink-muted);
            display: flex; align-items: center; gap: 10px;
            margin: 4px 0;
        }
        .section-label::before, .section-label::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }

        /* ── Submit ── */
        .btn-submit {
            width: 100%; height: 50px;
            background: var(--ink);
            color: var(--paper);
            border: none; border-radius: var(--radius);
            font-family: 'DM Sans', sans-serif;
            font-size: 15px; font-weight: 600;
            letter-spacing: 0.02em;
            cursor: pointer;
            position: relative; overflow: hidden;
            transition: opacity .15s, transform .1s;
            margin-top: 4px;
        }
        .btn-submit:hover  { opacity: .88; }
        .btn-submit:active { transform: scale(.99); }
        .btn-submit:disabled { opacity: .5; cursor: not-allowed; }

        /* shimmer loading state */
        .btn-submit.loading::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,.15) 50%, transparent 100%);
            animation: shimmer 1.2s infinite;
        }
        @keyframes shimmer {
            from { transform: translateX(-100%); }
            to   { transform: translateX(100%); }
        }

        .btn-text, .btn-spinner { transition: opacity .2s; }
        .btn-spinner { position: absolute; inset: 0; display: none; align-items: center; justify-content: center; }
        .btn-submit.loading .btn-text   { opacity: 0; }
        .btn-submit.loading .btn-spinner{ display: flex; }

        /* ── Footer ── */
        .card-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 13px;
            color: var(--ink-muted);
        }
        .card-footer a {
            color: var(--ink);
            font-weight: 600;
            text-decoration: none;
            border-bottom: 1px solid var(--border);
            padding-bottom: 1px;
            transition: border-color .15s;
        }
        .card-footer a:hover { border-color: var(--ink); }

        /* progress steps */
        .steps {
            display: flex; align-items: center; gap: 0;
            margin-bottom: 28px;
        }
        .step {
            display: flex; align-items: center; gap: 6px;
            font-size: 12px; font-weight: 500; color: var(--ink-muted);
        }
        .step-dot {
            width: 24px; height: 24px; border-radius: 50%;
            border: 1.5px solid var(--border);
            display: grid; place-items: center;
            font-size: 11px; font-weight: 600;
            background: var(--surface);
            transition: all .3s;
        }
        .step.active .step-dot {
            background: var(--ink); border-color: var(--ink); color: var(--paper);
        }
        .step.done .step-dot {
            background: var(--success); border-color: var(--success); color: white;
        }
        .step-line { flex: 1; height: 1px; background: var(--border); margin: 0 6px; }
    </style>
</head>

<body class="font-google-sans antialiased">
<div class="page-wrap">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/home" class="brand">
        <div class="brand-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 7v14"/>
                <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"/>
            </svg>
        </div>
        <span class="brand-name">BookHub</span>
    </a>

    <div class="card">

        <!-- Header -->
        <div class="card-header">
            <h1 class="card-title">Create your account</h1>
            <p class="card-subtitle">Join thousands of readers — free forever</p>
        </div>

        <!-- Server-side error banner -->
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="alert alert-error" role="alert">
            <svg class="alert-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            <%= errorMsg %>
        </div>
        <% } %>

        <!-- Client-side error banner (hidden by default) -->
        <div id="js-error" class="alert alert-error" role="alert" style="display:none;">
            <svg class="alert-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            <span id="js-error-text"></span>
        </div>

        <form id="signup-form" action="signup" method="post" class="form" novalidate>

            <!-- ── Personal info ── -->
            <div class="section-label">Personal info</div>

            <div class="row-2">
                <div class="field">
                    <label for="firstName">First name</label>
                    <div class="input-wrap">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        <input type="text" id="firstName" name="firstName" placeholder="Jane"
                               value="<%= formData != null && formData.getFirstName() != null ? formData.getFirstName() : "" %>"
                               autocomplete="given-name"/>
                    </div>
                </div>
                <div class="field">
                    <label for="lastName">Last name</label>
                    <div class="input-wrap">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        <input type="text" id="lastName" name="lastName" placeholder="Doe"
                               value="<%= formData != null && formData.getLastName() != null ? formData.getLastName() : "" %>"
                               autocomplete="family-name"/>
                    </div>
                </div>
            </div>

            <div class="field">
                <label for="birthDate">Date of birth</label>
                <div class="input-wrap">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="18" height="18" x="3" y="4" rx="2"/>
                        <path d="M16 2v4M8 2v4M3 10h18"/>
                    </svg>
                    <input type="date" id="birthDate" name="birthDate"
                           value="<%= formData != null && formData.getBirthDate() != null ? formData.getBirthDate() : "" %>"/>
                </div>
                <span class="hint">Must be 18 or older</span>
            </div>

            <!-- ── Account info ── -->
            <div class="section-label">Account</div>

            <div class="field">
                <label for="username">Username</label>
                <div class="input-wrap">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <input type="text" id="username" name="username" placeholder="janedoe42"
                           value="<%= formData != null && formData.getUsername() != null ? formData.getUsername() : "" %>"
                           autocomplete="username" minlength="3" maxlength="20"/>
                </div>
                <span class="hint" id="username-hint">3–20 characters, letters and numbers only</span>
            </div>

            <div class="field">
                <label for="email">Email address</label>
                <div class="input-wrap">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="20" height="16" x="2" y="4" rx="2"/>
                        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                    </svg>
                    <input type="email" id="email" name="email" placeholder="jane@example.com"
                           value="<%= formData != null && formData.getEmail() != null ? formData.getEmail() : "" %>"
                           autocomplete="email"/>
                </div>
            </div>

            <div class="field">
                <label for="password">Password</label>
                <div class="input-wrap has-toggle">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="18" height="11" x="3" y="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    <input type="password" id="password" name="password" placeholder="Min. 8 characters"
                           autocomplete="new-password" minlength="8"/>
                    <button type="button" class="pw-toggle" onclick="togglePw('password', this)" aria-label="Show password">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <div class="strength-wrap" id="strength-bars">
                    <div class="strength-bar" id="s1"></div>
                    <div class="strength-bar" id="s2"></div>
                    <div class="strength-bar" id="s3"></div>
                    <div class="strength-bar" id="s4"></div>
                </div>
                <span class="hint" id="strength-label"></span>
            </div>

            <div class="field">
                <label for="confirmPassword">Confirm password</label>
                <div class="input-wrap has-toggle">
                    <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat your password" autocomplete="new-password"/>
                    <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword', this)" aria-label="Show confirm password">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <span class="hint" id="confirm-hint"></span>
            </div>

            <!-- ── Optional ── -->
            <div class="section-label">Optional</div>

            <div class="row-2">
                <div class="field">
                    <label for="job">Job / Occupation</label>
                    <div class="input-wrap">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect width="20" height="14" x="2" y="7" rx="2"/>
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                        </svg>
                        <input type="text" id="job" name="job" placeholder="Software Engineer"
                               value="<%= formData != null && formData.getJob() != null ? formData.getJob() : "" %>"/>
                    </div>
                </div>
                <div class="field">
                    <label for="creditCardLimit">Credit limit ($)</label>
                    <div class="input-wrap">
                        <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect width="20" height="14" x="2" y="5" rx="2"/>
                            <line x1="2" x2="22" y1="10" y2="10"/>
                        </svg>
                        <input type="number" id="creditCardLimit" name="creditCardLimit"
                               min="0" placeholder="0"
                               value="<%= formData != null && formData.getCreditLimit() != null ? formData.getCreditLimit() : "" %>"/>
                    </div>
                </div>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn-submit" id="submit-btn">
                <span class="btn-text">Create account</span>
                <span class="btn-spinner">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round">
                        <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83">
                            <animateTransform attributeName="transform" type="rotate"
                                              from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/>
                        </path>
                    </svg>
                </span>
            </button>

        </form>

    </div>

    <div class="card-footer">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>

</div>

<script>
    /* ── Password visibility toggle ── */
    function togglePw(id, btn) {
        const input = document.getElementById(id);
        const isText = input.type === 'text';
        input.type = isText ? 'password' : 'text';
        btn.style.opacity = isText ? '1' : '0.5';
    }

    /* ── Password strength ── */
    const pwInput = document.getElementById('password');
    const bars = [document.getElementById('s1'), document.getElementById('s2'),
        document.getElementById('s3'), document.getElementById('s4')];
    const strengthLabel = document.getElementById('strength-label');
    const strengthColors = ['#e24b4a', '#ef9f27', '#639922', '#2d7a4f'];
    const strengthLabels = ['Weak', 'Fair', 'Good', 'Strong'];

    function calcStrength(pw) {
        let score = 0;
        if (pw.length >= 8)  score++;
        if (pw.length >= 12) score++;
        if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) score++;
        if (/\d/.test(pw) && /[^A-Za-z0-9]/.test(pw)) score++;
        return Math.max(0, Math.min(4, score));
    }

    pwInput.addEventListener('input', () => {
        const pw = pwInput.value;
        const score = pw.length === 0 ? 0 : calcStrength(pw);
        bars.forEach((b, i) => {
            b.style.background = i < score ? strengthColors[score - 1] : 'var(--border)';
        });
        strengthLabel.textContent = pw.length > 0 ? strengthLabels[score - 1] || '' : '';
        strengthLabel.style.color = pw.length > 0 ? strengthColors[score - 1] : 'var(--ink-muted)';
        checkConfirm();
    });

    /* ── Confirm password match ── */
    const confirmInput = document.getElementById('confirmPassword');
    const confirmHint  = document.getElementById('confirm-hint');

    function checkConfirm() {
        const pw = pwInput.value, cp = confirmInput.value;
        if (!cp) { confirmHint.textContent = ''; confirmInput.classList.remove('invalid'); return; }
        if (pw === cp) {
            confirmHint.textContent = 'Passwords match ✓';
            confirmHint.className = 'hint';
            confirmHint.style.color = '#2d7a4f';
            confirmInput.classList.remove('invalid');
        } else {
            confirmHint.textContent = 'Passwords do not match';
            confirmHint.className = 'hint error';
            confirmHint.style.color = '';
            confirmInput.classList.add('invalid');
        }
    }
    confirmInput.addEventListener('input', checkConfirm);

    /* ── Username live validation ── */
    const usernameInput = document.getElementById('username');
    const usernameHint  = document.getElementById('username-hint');
    usernameInput.addEventListener('input', () => {
        const val = usernameInput.value;
        const valid = /^[a-zA-Z0-9]{3,20}$/.test(val);
        if (val.length === 0) {
            usernameHint.textContent = '3–20 characters, letters and numbers only';
            usernameHint.className = 'hint';
            usernameInput.classList.remove('invalid');
        } else if (!valid) {
            usernameHint.textContent = 'Letters and numbers only, 3–20 chars';
            usernameHint.className = 'hint error';
            usernameInput.classList.add('invalid');
        } else {
            usernameHint.textContent = 'Looks good ✓';
            usernameHint.className = 'hint';
            usernameHint.style.color = '#2d7a4f';
            usernameInput.classList.remove('invalid');
        }
    });

    /* ── Age validation on blur ── */
    const birthInput = document.getElementById('birthDate');
    birthInput.addEventListener('change', () => {
        const dob = new Date(birthInput.value);
        const age = Math.floor((Date.now() - dob) / (365.25 * 24 * 3600 * 1000));
        const hint = birthInput.closest('.field').querySelector('.hint');
        if (age < 18) {
            hint.textContent = 'You must be 18 or older to register';
            hint.className = 'hint error';
            birthInput.classList.add('invalid');
        } else {
            hint.textContent = 'Must be 18 or older';
            hint.className = 'hint';
            birthInput.classList.remove('invalid');
        }
    });

    /* ── Form submit with client-side guard ── */
    document.getElementById('signup-form').addEventListener('submit', function(e) {
        const errorBox  = document.getElementById('js-error');
        const errorText = document.getElementById('js-error-text');
        const showErr = msg => {
            errorText.textContent = msg;
            errorBox.style.display = 'flex';
            errorBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        };

        errorBox.style.display = 'none';

        const fn = document.getElementById('firstName').value.trim();
        const ln = document.getElementById('lastName').value.trim();
        const un = document.getElementById('username').value.trim();
        const em = document.getElementById('email').value.trim();
        const pw = document.getElementById('password').value;
        const cp = document.getElementById('confirmPassword').value;
        const bd = document.getElementById('birthDate').value;

        if (!fn || !ln)  { e.preventDefault(); showErr('First and last name are required.'); return; }
        if (!/^[a-zA-Z0-9]{3,20}$/.test(un)) { e.preventDefault(); showErr('Username must be 3–20 alphanumeric characters.'); return; }
        if (!em || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(em)) { e.preventDefault(); showErr('Please enter a valid email address.'); return; }
        if (pw.length < 8) { e.preventDefault(); showErr('Password must be at least 8 characters.'); return; }
        if (pw !== cp)     { e.preventDefault(); showErr('Passwords do not match.'); return; }

        if (bd) {
            const age = Math.floor((Date.now() - new Date(bd)) / (365.25 * 24 * 3600 * 1000));
            if (age < 18) { e.preventDefault(); showErr('You must be 18 or older to register.'); return; }
        }

        /* Show loading state */
        const btn = document.getElementById('submit-btn');
        btn.disabled = true;
        btn.classList.add('loading');
    });
</script>
</body>
</html>