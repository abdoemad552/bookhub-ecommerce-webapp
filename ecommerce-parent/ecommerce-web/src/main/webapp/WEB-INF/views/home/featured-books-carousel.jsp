<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="relative overflow-visible">
    <button id="left-featured-scroller" class="absolute left-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 md:w-12 md:h-12 rounded-full bg-background border border-border shadow-lg flex items-center justify-center transition-all duration-200 -translate-x-1/2 opacity-50 cursor-not-allowed" disabled aria-label="Scroll left">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-left w-5 h-5 md:w-6 md:h-6 text-foreground" aria-hidden="true">
            <path d="m15 18-6-6 6-6"></path>
        </svg>
    </button>
    <div id="featured-books-pane" class="flex gap-4 md:gap-6 overflow-x-auto overflow-y-visible scrollbar-hide scroll-smooth py-2" style="scrollbar-width:none;-ms-overflow-style:none">
        <c:forEach begin="1" end="15">
            <div class="animate-pulse bg-card text-card-foreground rounded-xl border shadow-sm shrink-0 w-72 sm:w-80 md:w-96 overflow-hidden flex flex-row h-44 sm:h-48 md:h-52">

                <div class="w-24 sm:w-28 md:w-32 shrink-0 bg-muted/80"></div>

                <div class="p-3 md:p-4 flex flex-col flex-1 min-w-0">

                    <div class="flex-1 space-y-2">
                        <div class="h-3 md:h-4 bg-muted rounded-full w-11/12"></div>
                        <div class="h-3 md:h-4 bg-muted rounded-full w-2/3"></div>

                        <div class="h-2 md:h-3 bg-muted/60 rounded-full w-1/3 mb-3"></div>

                        <div class="flex items-center gap-1">
                            <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/40 rounded-full"></div>
                            <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/40 rounded-full"></div>
                            <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/40 rounded-full"></div>
                            <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/40 rounded-full"></div>
                            <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/10 rounded-full"></div>
                        </div>

                        <div class="hidden sm:block space-y-1.5 pt-2">
                            <div class="h-2 bg-muted/40 rounded-full w-full"></div>
                            <div class="h-2 bg-muted/40 rounded-full w-5/6"></div>
                            <div class="h-2 bg-muted/40 rounded-full w-3/6"></div>
                        </div>
                    </div>

                    <div class="flex items-center justify-between pt-2 border-t border-border/50">
                        <div class="h-4 bg-primary/20 rounded-full w-16"></div>
                        <div class="h-7 w-8 md:h-8 md:w-10 bg-primary/30 rounded-md"></div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <button id="right-featured-scroller" class="absolute right-0 top-1/2 -translate-y-1/2 z-10 w-10 h-10 md:w-12 md:h-12 rounded-full bg-background border border-border shadow-lg flex items-center justify-center transition-all duration-200 translate-x-1/2 hover:bg-muted cursor-pointer" aria-label="Scroll right">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-right w-5 h-5 md:w-6 md:h-6 text-foreground" aria-hidden="true">
            <path d="m9 18 6-6-6-6"></path>
        </svg>
    </button>
</div>

