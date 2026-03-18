<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-footer.css">

<!-- Spacing -->
<div class="h-16"></div>

<!-- Main Nav -->
<nav class="font-google-sans fixed top-0 left-0 w-full z-50 bg-card border-b border-border/70 backdrop-blur-md h-16 flex items-center">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div class="flex items-center justify-between gap-4 h-full">

            <!-- Logo -->
            <a class="nav-logo flex items-center gap-2.5 flex-shrink-0" href="${pageContext.request.contextPath}">
                <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center shadow-sm shadow-primary/30 flex-shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         class="text-primary-foreground" aria-hidden="true">
                        <path d="M12 7v14"/>
                        <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"/>
                    </svg>
                </div>
                <span class="text-xl font-bold text-foreground tracking-tight">Book<span class="text-primary">Hub</span></span>
            </a>

            <!-- Right actions -->
            <div class="flex items-center gap-3 flex-shrink-0">

                <!-- Mobile search button -->
                <button id="open-search"
                        class="md:hidden inline-flex items-center justify-center w-9 h-9 rounded-xl border border-border bg-background text-muted-foreground hover:text-foreground hover:bg-muted transition-colors flex-shrink-0"
                        aria-label="Search">
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <circle cx="11" cy="11" r="8"/>
                        <path d="m21 21-4.34-4.34"/>
                    </svg>
                </button>

                <!-- Cart -->
                <a class="relative flex-shrink-0" href="${pageContext.request.contextPath}/cart">
                    <button data-slot="button"
                            class="inline-flex items-center justify-center gap-1.5 bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground text-sm font-medium h-9 px-4 rounded-xl transition-colors whitespace-nowrap relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <circle cx="8" cy="21" r="1"/>
                            <circle cx="19" cy="21" r="1"/>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/>
                        </svg>
                        <span class="hidden sm:inline">Cart</span>
                        <span class="cart-badge absolute -top-2 -right-2 min-w-[18px] h-[18px] bg-destructive text-destructive-foreground text-[10px] font-bold rounded-full flex items-center justify-center px-1 leading-none">0</span>
                    </button>
                </a>

                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="flex-shrink-0">
                            <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold transition-all border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-10 rounded-xl px-6">
                                Sign In
                            </button>
                        </a>
                        <a href="${pageContext.request.contextPath}/signup" class="hidden sm:block flex-shrink-0">
                            <button class="inline-flex items-center justify-center gap-1.5 bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground text-sm font-medium h-9 px-4 rounded-xl transition-colors whitespace-nowrap relative">
                                Sign Up
                            </button>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div id="avatar-dropdown-container" class="relative">
                            <button id="avatar-btn"
                                    class="flex items-center gap-2 p-1 rounded-full hover:bg-muted transition-colors focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2"
                                    aria-expanded="true" aria-haspopup="true">
                                <div class="w-9 h-9 rounded-full bg-primary/20 flex items-center justify-center border-2 border-primary">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                         fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                         stroke-linejoin="round" class="lucide lucide-user w-5 h-5 text-primary"
                                         aria-hidden="true">
                                        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </div>
                                <svg id="chevron" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round" stroke-linejoin="round"
                                     class="lucide lucide-chevron-down w-4 h-4 text-muted-foreground transition-transform duration-200"
                                     aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"></path>
                                </svg>
                            </button>
                            <div id="dropdown"
                                 class="absolute right-0 mt-2 w-48 bg-card rounded-lg border border-border shadow-lg overflow-hidden transition-all duration-200 origin-top-right opacity-0 scale-95 invisible"
                                 aria-expanded="false">
                                <div class="px-4 py-3 border-b border-border bg-muted/30">
                                    <p class="text-sm font-semibold text-foreground truncate">${sessionScope.user.firstName} ${sessionScope.user.lastName}</p>
                                    <p class="text-xs text-muted-foreground truncate">${sessionScope.user.email}</p>
                                </div>
                                <div class="py-1">
                                    <a href="${pageContext.request.contextPath}/profile"
                                       class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                             stroke-linecap="round" stroke-linejoin="round"
                                             class="lucide lucide-user w-4 h-4 text-muted-foreground"
                                             aria-hidden="true">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                        Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile"
                                       class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                             stroke-linecap="round" stroke-linejoin="round"
                                             class="lucide lucide-package w-4 h-4 text-muted-foreground"
                                             aria-hidden="true">
                                            <path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"></path>
                                            <path d="M12 22V12"></path>
                                            <polyline points="3.29 7 12 12 20.71 7"></polyline>
                                            <path d="m7.5 4.27 9 5.15"></path>
                                        </svg>
                                        Orders
                                    </a>
                                </div>
                                <div class="border-t border-border py-1">
                                    <!-- Hidden form — submits POST to log out servlet -->
                                    <form id="logout-form" action="${pageContext.request.contextPath}/logout"
                                          method="post"
                                          style="display:none;">
                                    </form>

                                    <button type="button"
                                            onclick="document.getElementById('logout-form').submit();"
                                            class="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-destructive hover:bg-destructive/10 transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                             stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                             class="lucide lucide-log-out w-4 h-4" aria-hidden="true">
                                            <path d="m16 17 5-5-5-5"></path>
                                            <path d="M21 12H9"></path>
                                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                        </svg>
                                        Logout
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<%-- CATEGORY NAV — sticky just below the main nav --%>
<nav class="sticky top-16 z-40 bg-card border-b border-border/60 backdrop-blur-md">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-center gap-1 overflow-x-auto py-2.5"
             style="scrollbar-width:none;-ms-overflow-style:none;">
            <a href="${pageContext.request.contextPath}/explore?category=All">
                <button data-slot="button"
                        class="cat-pill hover:text-accent-foreground inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    All
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/explore?category=Fiction">
                <button data-slot="button"
                        class="cat-pill inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    Fiction
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/explore?category=Fantasy">
                <button data-slot="button"
                        class="cat-pill inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    Fantasy
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/explore?category=Self-Help">
                <button data-slot="button"
                        class="cat-pill inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    Self-Help
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/explore?category=Non-Fiction">
                <button data-slot="button"
                        class="cat-pill inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    Non-Fiction
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/explore?category=Romance">
                <button data-slot="button"
                        class="cat-pill inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    Romance
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/explore?category=Mystery">
                <button data-slot="button"
                        class="cat-pill inline-flex items-center justify-center whitespace-nowrap text-sm font-medium text-muted-foreground px-4 py-1.5 shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1">
                    Mystery
                </button>
            </a>
        </div>
    </div>
</nav>

<!-- Mobile Search Overlay -->
<div id="mobile-search"
     class="fixed top-16 left-0 w-full z-0 bg-card border-b border-border px-4 py-3 transform -translate-y-full opacity-0 transition-all duration-300">

    <div class="relative max-w-7xl mx-auto">
        <!-- Search icon -->
        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
             viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2.5"
             class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground pointer-events-none">
            <circle cx="11" cy="11" r="8"/>
            <path d="m21 21-4.34-4.34"/>
        </svg>

        <!-- Search input -->
        <input type="search"
               class="input-modern w-full h-10 pl-10 pr-14 text-sm bg-muted/50 border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary"
               placeholder="Search about what you want"/>

        <!-- Close button -->
        <button id="close-search"
                class="absolute right-2 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700 p-1">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                 viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2"
                 stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>
                <path d="M10 11v6"></path>
                <path d="M14 11v6"></path>
            </svg>
        </button>
    </div>
</div>