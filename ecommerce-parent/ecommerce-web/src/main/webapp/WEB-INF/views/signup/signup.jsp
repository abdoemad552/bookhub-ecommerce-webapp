<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5"/>
    <title>BookHub — Create Account</title>
    <meta name="ctx" content="${pageContext.request.contextPath}">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/step-navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/authentication.css">

    <script type="module" src="${pageContext.request.contextPath}/assets/js/signup/signup.js"></script>
</head>

<body class="font-google-sans antialiased">
<div class="min-h-screen bg-gradient-to-br from-background via-background to-accent/5
            flex flex-col relative">
    <jsp:include page="../common/header.jsp"/>

    <main class="flex-1 flex items-center justify-center px-4 py-8 relative">

    <div class="absolute -top-20 -right-20 w-72 h-72 bg-accent/10 rounded-full blur-3xl animate-float opacity-25 pointer-events-none"></div>
    <div class="absolute bottom-0 -left-20 w-56 h-56 bg-primary/8 rounded-full blur-3xl animate-float opacity-15 pointer-events-none"
         style="animation-delay:3s;"></div>

    <div class="w-full max-w-2xl relative z-10">
        <div class="card-modern rounded-2xl p-8 sm:p-10 animate-slide-up shadow-2xl">

            <!-- Brand -->
            <div class="animate-slide-down delay-1 mb-6">
                <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3 mb-5">
                    <div class="p-3 bg-gradient-to-br from-primary/20 to-accent/20 rounded-xl">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             class="text-primary icon-pulse">
                            <path d="M12 7v14"></path>
                            <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                        </svg>
                    </div>
                    <h1 class="text-3xl font-bold text-gradient">BookHub</h1>
                </a>
                <h2 class="text-4xl font-bold text-foreground mb-1">Join Us</h2>
                <p class="text-muted-foreground text-sm">Create your reading sanctuary</p>
            </div>

            <!-- Step indicator — 3 steps -->
            <div class="step-indicator animate-slide-down delay-2">
                <div class="step-item active" id="si-1">
                    <div class="step-dot" id="sd-1">1</div>
                    <span class="step-label">Personal</span>
                </div>
                <div class="step-connector" id="sc-1"></div>
                <div class="step-item" id="si-2">
                    <div class="step-dot" id="sd-2">2</div>
                    <span class="step-label">Account</span>
                </div>
                <div class="step-connector" id="sc-2"></div>
                <div class="step-item" id="si-3">
                    <div class="step-dot" id="sd-3">3</div>
                    <span class="step-label">Interests</span>
                </div>
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

            <form id="signup-form" action="signup" method="post" novalidate>

                <!-- STEP 1 — Personal info -->
                <div class="step-panel active" id="panel-1">

                    <div class="grid grid-cols-2 gap-4 mb-5">
                        <div class="group">
                            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                                   for="firstName">First Name</label>
                            <div class="relative">
                                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                     xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2">
                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <input type="text" id="firstName" name="firstName" placeholder="First name"
                                       autocomplete="given-name"
                                       class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                            </div>
                            <div class="field-hint" id="hint-firstName"></div>
                        </div>
                        <div class="group">
                            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                                   for="lastName">Last Name</label>
                            <div class="relative">
                                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                     xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2">
                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <input type="text" id="lastName" name="lastName" placeholder="Last name"
                                       autocomplete="family-name"
                                       class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                            </div>
                            <div class="field-hint" id="hint-lastName"></div>
                        </div>
                    </div>

                    <div class="group mb-5">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                               for="birthDate">Date of Birth</label>
                        <div class="relative">
                            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                 xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2">
                                <rect width="18" height="18" x="3" y="4" rx="2"></rect>
                                <path d="M16 2v4M8 2v4M3 10h18"></path>
                            </svg>
                            <input type="date" id="birthDate" name="birthDate"
                                   class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground focus:outline-none"/>
                        </div>
                        <div class="field-hint" id="hint-birthDate"></div>
                    </div>

                    <div class="grid grid-cols-2 gap-4 mb-2">
                        <div class="group">
                            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                                   for="job">Occupation</label>
                            <div class="relative">
                                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                     xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2">
                                    <rect width="20" height="14" x="2" y="7" rx="2"></rect>
                                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                                </svg>
                                <input type="text" id="job" name="job" placeholder="e.g. Engineer"
                                       class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                            </div>
                        </div>
                        <div class="group">
                            <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                                   for="creditCardLimit">Credit Limit</label>
                            <div class="relative">
                                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                     xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2">
                                    <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                    <line x1="2" x2="22" y1="10" y2="10"></line>
                                </svg>
                                <input type="number" id="creditCardLimit" name="creditCardLimit" min="0" placeholder="0"
                                       class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                            </div>
                            <div class="field-hint" id="hint-creditLimit"></div>
                        </div>
                    </div>

                    <!-- Step-1 Buttons -->
                    <div class="nav-row no-back">
                        <button type="button" id="btn-next-1"
                                class="btn-modern w-full py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none uppercase tracking-wide flex items-center justify-center gap-2">
                            Continue
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M5 12h14M12 5l7 7-7 7"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- STEP 2 — Account details -->
                <div class="step-panel" id="panel-2">

                    <div class="group mb-5">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                               for="username">Username</label>
                        <div class="relative">
                            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                 xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <input type="text" id="username" name="username" placeholder="Username"
                                   autocomplete="username" maxlength="20"
                                   class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                        </div>
                        <div class="field-hint" id="hint-username"></div>
                    </div>

                    <div class="group mb-5">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                               for="email">Email Address</label>
                        <div class="relative">
                            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                 xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2">
                                <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>
                                <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                            </svg>
                            <input type="email" id="email" name="email" placeholder="name@example.com"
                                   autocomplete="email"
                                   class="input-modern w-full pl-12 pr-4 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                        </div>
                        <div class="field-hint" id="hint-email"></div>
                    </div>

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
                            <input type="password" id="password" name="password" placeholder="Choose Strong Password"
                                   autocomplete="new-password"
                                   class="input-modern w-full pl-12 pr-11 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                            <button type="button" class="pw-toggle" onclick="togglePw('password',this)"
                                    aria-label="Toggle password">
                                <svg id="eye-password" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                     stroke-linejoin="round">
                                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>
                        <div class="strength-track">
                            <div class="strength-seg" id="seg1"></div>
                            <div class="strength-seg" id="seg2"></div>
                            <div class="strength-seg" id="seg3"></div>
                        </div>
                        <div class="field-hint" id="hint-password"></div>
                    </div>

                    <div class="group mb-2">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-2 uppercase tracking-wide"
                               for="confirmPassword">Confirm Password</label>
                        <div class="relative">
                            <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground icon-pulse pointer-events-none z-10"
                                 xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Repeat your password" autocomplete="new-password"
                                   class="input-modern w-full pl-12 pr-11 py-3 rounded-xl text-foreground placeholder-muted-foreground focus:outline-none"/>
                            <button type="button" class="pw-toggle" onclick="togglePw('confirmPassword',this)"
                                    aria-label="Toggle confirm">
                                <svg id="eye-confirmPassword" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                     stroke-linejoin="round">
                                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>
                        <div class="field-hint" id="hint-confirm"></div>
                    </div>

                    <!-- Step-2 Buttons -->
                    <div class="nav-row has-back">
                        <button type="button" id="btn-back-2" class="btn-back">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M19 12H5M12 19l-7-7 7-7"></path>
                            </svg>
                            Back
                        </button>
                        <button type="button" id="btn-next-2"
                                class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none uppercase tracking-wide flex items-center justify-center gap-2">
                            Continue
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M5 12h14M12 5l7 7-7 7"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- STEP 3 — Interests & Preferences -->
                <div class="step-panel" id="panel-3">

                    <!-- Category section -->
                    <div class="mb-2">
                        <label class="label-modern block text-sm font-semibold text-foreground mb-1 uppercase tracking-wide">Book
                            Interests</label>
                        <p class="text-muted-foreground" style="font-size:.78rem; margin-bottom:12px;">Pick the genres you enjoy (Optional)</p>

                        <!-- Selected count badge -->
                        <div class="selected-count" id="selected-count">
                            <span id="selected-num">0</span> selected
                        </div>

                        <!-- Category grid — populated by JS -->
                        <div class="category-grid" id="category-grid"></div>
                        <div class="field-hint" id="hint-categories"></div>
                    </div>

                    <!-- Email notifications toggle -->
                    <div class="notif-card">
                        <div class="notif-text">
                            <h4>Email Updates</h4>
                            <p>Get notified about new arrivals</p>
                        </div>
                        <label class="toggle-wrap">
                            <input type="checkbox" id="emailNotifications" name="emailNotifications" value="true"/>
                            <span class="toggle-track"></span>
                        </label>
                    </div>

                    <!-- Step-3 Buttons -->
                    <div class="nav-row has-back">
                        <button type="button" id="btn-back-3" class="btn-back">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                 stroke-linejoin="round">
                                <path d="M19 12H5M12 19l-7-7 7-7"></path>
                            </svg>
                            Back
                        </button>
                        <button type="submit" id="submit-btn"
                                class="btn-modern py-3.5 px-4 text-primary-foreground font-semibold text-base rounded-xl focus:outline-none uppercase tracking-wide relative">
                            <span class="btn-text">Sign Up</span>
                            <span class="btn-spinner">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                     stroke-width="2.5" stroke-linecap="round">
                                    <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83">
                                        <animateTransform attributeName="transform" type="rotate" from="0 12 12"
                                                          to="360 12 12" dur=".8s" repeatCount="indefinite"></animateTransform>
                                    </path>
                                </svg>
                            </span>
                        </button>
                    </div>
                </div>

            </form>

            <div class="divider-modern mt-6">
                <span class="select-none">Already have an account?</span>
            </div>
            <div class="text-center animate-fade-in" style="animation-delay:.6s;">
                <a href="${pageContext.request.contextPath}/login" class="link-modern text-sm font-semibold">Log In to BookHub</a>
            </div>

        </div>
    </div>
    </main>
    <jsp:include page="../common/footer.jsp"/>
</div>
</body>
</html>
