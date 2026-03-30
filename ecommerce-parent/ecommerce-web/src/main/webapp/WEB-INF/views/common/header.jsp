<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-footer.css">

<c:set var="showCategoryNavFlag" value="${param.showCategoryNav != null ? param.showCategoryNav : true}"/>

<!-- Spacing -->
<div class="h-16"></div>
<%--<c:if test="${showCategoryNavFlag == 'true'}">--%>
<%--    <div class="h-16"></div>--%>
<%--</c:if>--%>

<!-- Main Nav -->
<nav class="font-google-sans fixed top-0 left-0 w-full z-50 bg-card border-b border-border/70 backdrop-blur-md h-16 flex items-center">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div class="flex items-center justify-between gap-4 h-full">

            <!-- Logo -->
            <a class="nav-logo flex items-center gap-2.5 shrink-0" href="${pageContext.request.contextPath}">
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
            <div class="flex items-center gap-3 shrink-0">

                <!-- Cart -->
                <a class="relative shrink-0" href="${pageContext.request.contextPath}/cart">
                    <button data-slot="button" class="inline-flex items-center justify-center gap-1.5 bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground text-sm font-medium h-10 px-4 rounded-xl transition-colors whitespace-nowrap relative cursor-pointer">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                            <circle cx="8" cy="21" r="1"/>
                            <circle cx="19" cy="21" r="1"/>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/>
                        </svg>
                        <span class="hidden sm:inline ml-2">Cart</span>
                        <span id="header-cart-count"
                              data-context-path="${pageContext.request.contextPath}"
                              data-authenticated="${not empty sessionScope.user}"
                              class="cart-badge absolute -top-2 -right-2 min-w-5 h-5 px-1 bg-destructive text-destructive-foreground text-xs font-bold rounded-full flex items-center justify-center">0</span>                    </button>
                </a>

                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="shrink-0">
                            <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 transition-all border h-10 px-6 rounded-xl cursor-pointer">
                                Log In
                            </button>
                        </a>
                        <a href="${pageContext.request.contextPath}/signup" class="hidden sm:block shrink-0">
                            <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground h-10 px-6 rounded-xl transition-all relative cursor-pointer">
                                Sign Up
                            </button>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${sessionScope.user.role eq 'ADMIN' or sessionScope.user.role eq 'MAIN_ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="shrink-0">
                                <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold transition-all border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-10 rounded-xl px-6">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chart-column w-4 h-4 text-current" aria-hidden="true">
                                        <path d="M3 3v16a2 2 0 0 0 2 2h16"></path>
                                        <path d="M18 17V9"></path>
                                        <path d="M13 17V5"></path>
                                        <path d="M8 17v-3"></path>
                                    </svg>
                                    <span class="hidden md:block">Dashboard</span>
                                </button>
                            </a>
                        </c:if>
                        <div id="avatar-dropdown-container" class="relative">
                            <button id="avatar-btn" class="flex items-center gap-2 px-2 py-1 rounded-2xl hover:bg-primary/15 active:bg-primary/20 transition-all focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 cursor-pointer" aria-expanded="true" aria-haspopup="true">
                                <div class="w-9 h-9 rounded-full bg-primary/20 flex items-center justify-center border-2 border-primary">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.profilePicUrl != null}">
                                            <img id="header-profile-pic-url" src="${pageContext.request.contextPath}/${sessionScope.user.profilePicUrl}" alt="Cover of ${sessionScope.user.username}" loading="lazy" class="w-full h-full object-cover rounded-full">
                                        </c:when>
                                        <c:otherwise>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                 stroke-linejoin="round" class="lucide lucide-user w-5 h-5 text-primary"
                                                 aria-hidden="true">
                                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <svg id="chevron" xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round" stroke-linejoin="round"
                                     class="lucide lucide-chevron-down w-4 h-4 text-primary transition-transform duration-200"
                                     aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"></path>
                                </svg>
                            </button>
                            <div id="dropdown"
                                 class="absolute right-0 mt-2 w-48 bg-card rounded-lg border border-border shadow-lg overflow-hidden transition-all duration-200 origin-top-right opacity-0 scale-95 invisible"
                                 aria-expanded="false">
                                <div class="px-4 py-3 border-b border-border bg-muted/30">
                                    <p class="text-sm font-semibold text-foreground truncate">${sessionScope.user.username}</p>
                                    <p class="text-xs text-muted-foreground truncate">${sessionScope.user.email}</p>
                                </div>
                                <div class="py-1">
                                    <a href="${pageContext.request.contextPath}/"
                                       class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="lucide lucide-user w-4 h-4 text-muted-foreground" viewBox="0 0 16 16">
                                            <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z"/>
                                        </svg>
                                        Home
                                    </a>
                                    <a href="${pageContext.request.contextPath}/explore"
                                       class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="lucide lucide-user w-4 h-4 text-muted-foreground" viewBox="0 0 16 16">
                                            <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783"/>
                                        </svg>
                                        Explore
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile"
                                       class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"
                                             stroke-linecap="round" stroke-linejoin="round"
                                             class="lucide lucide-user w-4 h-4 text-muted-foreground"
                                             aria-hidden="true">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                        Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile?tab=orders-info"
                                       class="flex items-center gap-3 px-4 py-2.5 text-sm text-foreground hover:bg-muted transition-colors">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                             viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"
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
<c:if test="${showCategoryNavFlag == 'true'}">
    <nav class="font-google-sans sticky top-14 sm:top-16 z-40 bg-card border-b border-border/60 backdrop-blur-md">
        <div class="w-full px-2 sm:px-4 lg:px-8 sm:max-w-7xl sm:mx-auto">
            <div id="category-nav-id" class="flex items-center gap-0.5 sm:gap-1 overflow-x-auto py-2 sm:py-2.5"
                 style="scrollbar-width:none;-ms-overflow-style:none;min-height:2.75rem;">
                <!-- Injected by JS-->
            </div>
        </div>
    </nav>
</c:if>