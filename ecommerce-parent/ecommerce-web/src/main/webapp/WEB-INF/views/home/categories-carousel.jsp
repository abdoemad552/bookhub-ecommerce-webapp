<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="relative">

    <!-- Left scroller -->
    <button id="left-categories-scroller"
            class="absolute left-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 md:w-12 md:h-12 rounded-full bg-background border border-border shadow-lg flex items-center justify-center transition-all duration-200 -translate-x-1/2 opacity-50 cursor-not-allowed"
            disabled aria-label="Scroll left">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-chevron-left w-5 h-5 md:w-6 md:h-6 text-foreground" aria-hidden="true">
            <path d="m15 18-6-6 6-6"></path>
        </svg>
    </button>

    <!-- Loading skeleton -->
    <div id="categories-pane" class="flex gap-4 overflow-x-auto scrollbar-hide scroll-smooth px-1 py-1"
         style="scrollbar-width:none;-ms-overflow-style:none">
        <c:forEach begin="1" end="9">
            <div class="cat-skeleton animate-pulse bg-card text-card-foreground rounded-xl border shadow-sm flex-shrink-0 w-40 sm:w-48 md:w-56 overflow-hidden flex flex-col p-5">
                <div class="flex items-center justify-center mb-4">
                    <div class="w-11 h-11 md:w-12 md:h-12 rounded-full bg-muted/80"></div>
                </div>

                <div class="flex-1 space-y-2">
                    <div class="h-3 md:h-4 bg-muted rounded-full w-11/12 mx-auto"></div>
                </div>

                <div class="flex items-center justify-between pt-3 mt-3 border-t border-border/50">
                    <div class="h-4 bg-primary/20 rounded-full w-16 mx-auto"></div>
                </div>
            </div>
        </c:forEach>

        <!-- Cards -->
        <c:forEach items="${requestScope.categories}" var="category">
            <div data-slot="card"
                 class="cat-real bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm flex-shrink-0 w-40 sm:w-48 md:w-56 p-6 text-center cat-card-hover cursor-pointer"
                 style="display:none">
                <div class="flex items-center justify-center mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                         class="lucide lucide-book-open w-10 h-10 md:w-12 md:h-12 text-primary" aria-hidden="true">
                        <path d="M12 7v14"></path>
                        <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                    </svg>
                </div>
                <h3 class="text-base md:text-lg font-semibold text-foreground mb-3 truncate">${category.name}</h3>
                <div class="text-center animate-fade-in">
                    <a href="${pageContext.request.contextPath}/explore" class="link-modern text-sm font-bold">
                        Shop Now
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m9 18 6-6-6-6"/>
                        </svg>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Right scroller -->
    <button id="right-categories-scroller"
            class="absolute right-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 md:w-12 md:h-12 rounded-full bg-background border border-border shadow-lg flex items-center justify-center transition-all duration-200 translate-x-1/2 hover:bg-muted cursor-pointer"
            aria-label="Scroll right">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             class="lucide lucide-chevron-right w-5 h-5 md:w-6 md:h-6 text-foreground" aria-hidden="true">
            <path d="m9 18 6-6-6-6"></path>
        </svg>
    </button>
</div>
