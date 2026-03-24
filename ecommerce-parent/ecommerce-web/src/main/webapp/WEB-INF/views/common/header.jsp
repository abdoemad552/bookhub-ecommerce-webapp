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
          <button data-slot="button"
                  class="inline-flex items-center justify-center gap-1.5 bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground text-sm font-medium h-10 px-4 rounded-xl transition-colors whitespace-nowrap relative cursor-pointer">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                 aria-hidden="true">
              <circle cx="8" cy="21" r="1"/>
              <circle cx="19" cy="21" r="1"/>
              <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/>
            </svg>
            <span class="hidden sm:inline ml-2">Cart</span>
            <span id="header-cart-count"
                  data-context-path="${pageContext.request.contextPath}"
                  data-authenticated="${not empty sessionScope.user}"
                  class="cart-badge absolute -top-2 -right-2 w-5 h-5 bg-destructive text-destructive-foreground text-xs font-bold rounded-full flex items-center justify-center">0</span>
          </button>
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
            <c:if test="${sessionScope.user.role eq 'ADMIN'}">
              <a href="${pageContext.request.contextPath}/admin/dashboard" class="shrink-0">
                <button class="inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-semibold transition-all border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground h-10 rounded-xl px-6">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                       stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                       class="lucide lucide-chart-column w-4 h-4 text-current" aria-hidden="true">
                    <path d="M3 3v16a2 2 0 0 0 2 2h16"></path>
                    <path d="M18 17V9"></path>
                    <path d="M13 17V5"></path>
                    <path d="M8 17v-3"></path>
                  </svg>
                  Dashboard
                </button>
              </a>
            </c:if>
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
                  <p class="text-sm font-semibold text-foreground truncate">${sessionScope.user.username}</p>
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
<c:if test="${showCategoryNavFlag == 'true'}">
  <nav class="font-google-sans sticky top-16 z-40 bg-card border-b border-border/60 backdrop-blur-md">
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
</c:if>