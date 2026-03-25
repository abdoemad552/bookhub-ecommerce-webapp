<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div id="sidebar-filter" data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6 sticky top-24">
    <div class="flex-1 relative mb-3">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search absolute left-3 top-3 w-4 h-4 text-muted-foreground" aria-hidden="true">
            <path d="m21 21-4.34-4.34"></path>
            <circle cx="11" cy="11" r="8"></circle>
        </svg>
        <input id="search-input" type="text" placeholder="Search books..." class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all duration-150" value="${requestScope.query}"/>
    </div>

    <div class="mb-3">
        <button id="categories-controller" class="w-full font-bold text-foreground mb-2 flex items-center justify-between hover:text-primary hover:bg-primary/10 rounded-lg p-2 transition-colors cursor-pointer">
            <span class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-funnel w-4 h-4" aria-hidden="true">
                    <path d="M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z"></path>
                </svg>
                Categories
            </span>
            <svg id="category-chevron-down" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down w-4 h-4 transition-transform duration-300 ease-in-out" aria-hidden="true">
                <path d="m6 9 6 6 6-6"></path>
            </svg>
        </button>
        <div class="overflow-hidden transition-all duration-300 ease-in-out max-h-12 opacity-100">
            <div id="selected-category"
                 data-selected-category-value="${empty requestScope.category ? "all" : requestScope.category}"
                 class="px-3 py-2 bg-muted/50 rounded-lg border border-border text-sm text-primary font-medium truncate">Loading...</div>
        </div>
        <div id="categories-container" class="overflow-hidden transition-all duration-300 ease-in-out max-h-0 opacity-0">
            <div id="categories-list" class="space-y-1 bg-muted/50 rounded-lg p-2 border border-border max-h-48 overflow-y-auto custom-scrollbar">
                <div id="categories-loading" class="px-3 py-2 text-sm text-muted-foreground animate-pulse">
                    Loading categories...
                </div>
            </div>
        </div>
    </div>

    <div class="mb-3">
        <h3 class="font-bold text-foreground mb-4">Price Range</h3>
        <div class="flex gap-3 items-start">
            <div class="flex-1">
                <label class="text-xs text-muted-foreground font-medium mb-1 block">Min</label>
                <div class="relative">
                    <input id="min-price-input" type="number" min="0" max="999999" class="w-full p-2 rounded-lg border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all duration-150" placeholder="0" value="${requestScope.minPrice}"/>
                </div>
            </div>

            <div class="flex items-center self-center mt-5 text-muted-foreground text-sm font-medium px-1">-</div>

            <div class="flex-1">
                <label class="text-xs text-muted-foreground font-medium mb-1 block">Max</label>
                <div class="relative">
                    <input id="max-price-input" type="number" min="0" max="999999" class="w-full p-2 rounded-lg border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all duration-150" placeholder="999999" value="${requestScope.maxPrice}"/>
                </div>
            </div>
        </div>

        <p id="price-range-error" class="hidden text-xs text-red-800 bg-red-100 border border-red-300 rounded-md px-3 py-2 mt-2 flex items-center gap-2 transition-all duration-300 ease-out opacity-0 scale-95">
            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8" x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            Min price must be less than or equal to max price.
        </p>

        <div class="flex items-center justify-between mt-3 px-1">
            <span class="text-xs text-muted-foreground">
                <span id="min-price">${empty requestScope.minPrice ? 0      : requestScope.minPrice}</span> EGP
            </span>
            <span class="text-xs text-muted-foreground">
                <span id="max-price">${empty requestScope.maxPrice ? 999999 : requestScope.maxPrice}</span> EGP
            </span>
        </div>
    </div>

    <div>
        <button id="sort-controller" class="w-full font-bold text-foreground mb-2 flex items-center justify-between hover:text-primary hover:bg-primary/10 rounded-lg p-2 transition-colors cursor-pointer">
            <span class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 16 16" fill="currentColor" stroke-width="2" class="bi bi-filter">
                    <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5"/>
                </svg>
                Sort By
            </span>
            <svg id="sort-chevron-down" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down w-4 h-4 transition-transform duration-300 ease-in-out" aria-hidden="true">
                <path d="m6 9 6 6 6-6"></path>
            </svg>
        </button>
        <div class="overflow-hidden transition-all duration-300 ease-in-out max-h-12 opacity-100">
            <div id="selected-sort-criteria"
                 data-selected-sort-criteria="${empty requestScope.sort ? "featured" : requestScope.sort}"
                 class="px-3 py-2 bg-muted/50 rounded-lg border border-border text-sm text-primary font-medium truncate">
                <c:choose>
                    <c:when test="${requestScope.sort eq 'price-low-to-high'}">Price: Low to High</c:when>
                    <c:when test="${requestScope.sort eq 'price-high-to-low'}">Price: High to Low</c:when>
                    <c:when test="${requestScope.sort eq 'rating'}">Top Rated</c:when>
                    <c:otherwise>Featured</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div id="sort-container" class="overflow-hidden transition-all duration-300 ease-in-out max-h-0 opacity-0">
            <div class="space-y-1 bg-muted/50 rounded-lg p-2 border border-border">
                <button data-criteria="featured"            class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${requestScope.sort eq 'featured' or empty requestScope.sort ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Featured</button>
                <button data-criteria="price-low-to-high"   class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${requestScope.sort eq 'price-low-to-high' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Price: Low to High</button>
                <button data-criteria="price-high-to-low"   class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${requestScope.sort eq 'price-high-to-low' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Price: High to Low</button>
                <button data-criteria="rating"              class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${requestScope.sort eq 'rating'            ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Top Rated</button>
            </div>
        </div>
    </div>
    <button id="filter-submit" class="w-full font-bold bg-primary text-primary-foreground flex items-center justify-center hover:bg-primary/90 active:scale-95 rounded-lg p-2 transition-all duration-150 cursor-pointer focus:ring-2 focus:ring-primary focus:ring-offset-2">
        <span class="flex items-center gap-2">
            Filter
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
            </svg>
        </span>
    </button>
</div>
