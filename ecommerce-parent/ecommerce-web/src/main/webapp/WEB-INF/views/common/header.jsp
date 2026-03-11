<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="sticky top-0 z-50 bg-card border-b border-border">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <a class="flex items-center gap-2" href="${pageContext.request.contextPath}">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-6 h-6 text-primary" aria-hidden="true">
                    <path d="M12 7v14"></path>
                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                </svg>
                <span class="text-xl font-bold text-primary">BookHub</span>
            </a>
            <div class="flex items-center gap-3 sm:gap-4">
                <a class="relative" href="${pageContext.request.contextPath}/cart">
                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5 bg-primary hover:bg-primary/90 relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-cart w-4 h-4" aria-hidden="true">
                            <circle cx="8" cy="21" r="1"></circle>
                            <circle cx="19" cy="21" r="1"></circle>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                        </svg>
                        <span class="hidden sm:inline ml-2">Cart</span>
                        <span class="absolute -top-2 -right-2 w-5 h-5 bg-destructive text-destructive-foreground text-xs font-bold rounded-full flex items-center justify-center">0</span>
                    </button>
                </a>
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login">
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5">Sign In</button>
                        </a>
                        <a href="${pageContext.request.contextPath}/signup">
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5 bg-primary hover:bg-primary/90">Sign Up</button>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div id="avatar-dropdown-container" class="relative">
                            <button id="avatar-btn" class="flex items-center gap-2 p-1 rounded-full hover:bg-muted transition-colors focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2" aria-expanded="true" aria-haspopup="true">
                                <div class="w-9 h-9 rounded-full bg-primary/20 flex items-center justify-center border-2 border-primary">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user w-5 h-5 text-primary" aria-hidden="true">
                                        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </div>
                                <svg id="chevron" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down w-4 h-4 text-muted-foreground transition-transform duration-200" aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"></path>
                                </svg>
                            </button>
                            <div id="dropdown" class="absolute right-0 mt-2 w-48 bg-card rounded-lg border border-border shadow-lg overflow-hidden transition-all duration-200 origin-top-right opacity-100 scale-100 visible">
                                <div class="px-4 py-3 border-b border-border bg-muted/30">
                                    <p class="text-sm font-semibold text-foreground truncate">${sessionScope.user.firstName} ${sessionScope.user.lastName}</p>
                                    <p class="text-xs text-muted-foreground truncate">${sessionScope.user.email}</p>
                                </div>
                                <div class="py-1">
                                    <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user w-4 h-4 text-muted-foreground" aria-hidden="true">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                        Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile" class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-package w-4 h-4 text-muted-foreground" aria-hidden="true">
                                            <path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"></path>
                                            <path d="M12 22V12"></path>
                                            <polyline points="3.29 7 12 12 20.71 7"></polyline>
                                            <path d="m7.5 4.27 9 5.15"></path>
                                        </svg>
                                        Orders
                                    </a>
                                </div>
                                <div class="border-t border-border py-1">
                                    <button class="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-destructive hover:bg-destructive/10 transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-log-out w-4 h-4" aria-hidden="true">
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
<nav class="sticky top-16 z-40 bg-card border-b border-border shadow-sm">
    <div class="max-w-7xl mx-auto">
        <div class="px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-center gap-2 overflow-x-auto scrollbar-hide py-2">
                <a href="${pageContext.request.contextPath}/explore?category=All">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        All
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore?category=Fiction">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        Fiction
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore?category=Science Fiction">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        Science Fiction
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore?category=Fantasy">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        Fantasy
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore?category=Self-Help">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        Self-Help
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore?category=Non-Fiction">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        Non-Fiction
                    </button>
                </a>
                <a href="${pageContext.request.contextPath}/explore?category=Biography">
                    <button data-slot="button" class="inline-flex items-center justify-center transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive dark:hover:bg-accent/50 dark:active:bg-accent/40 h-8 rounded-md gap-1.5 whitespace-nowrap text-sm font-medium hover:bg-muted active:bg-muted/80 px-4 py-2">
                        Biography
                    </button>
                </a>
            </div>
        </div>
    </div>
</nav>

<script>

</script>
