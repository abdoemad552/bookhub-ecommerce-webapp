<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div id="sidebar-filter" data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6 sticky top-24">
    <div class="flex-1 relative mb-3">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search absolute left-3 top-3 w-4 h-4 text-muted-foreground" aria-hidden="true">
            <path d="m21 21-4.34-4.34"></path>
            <circle cx="11" cy="11" r="8"></circle>
        </svg>
        <input id="search-input"
               type="text"
               placeholder="Search books..."
               value="${selectedSearchQuery}"
               class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary"/>
    </div>

    <div class="mb-3">
        <button id="categories-controller" class="w-full font-bold text-foreground mb-2 flex items-center justify-between hover:text-primary hover:bg-primary/10 rounded-lg p-2 transition-colors cursor-pointer">
            <span class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-funnel w-4 h-4" aria-hidden="true">
                    <path d="M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z"></path>
                </svg>
                Categories
            </span>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down w-4 h-4 transition-transform duration-300 ease-in-out rotate-180" aria-hidden="true">
                <path d="m6 9 6 6 6-6"></path>
            </svg>
        </button>
        <div class="overflow-hidden transition-all duration-300 ease-in-out max-h-12 opacity-100">
            <div id="selected-category"
                 data-selected-category-value="${selectedCategoryValue}"
                 class="px-3 py-2 bg-muted/50 rounded-lg border border-border text-sm text-primary font-medium truncate">${selectedCategory}</div>
        </div>
        <div id="categories-container" class="overflow-hidden transition-all duration-300 ease-in-out max-h-0 opacity-0">
            <div class="space-y-1 bg-muted/50 rounded-lg p-2 border border-border">
                <button data-category="all" data-category-value="" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'all' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">All Books</button>
                <button data-category="fiction" data-category-value="Fiction" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'fiction' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Fiction</button>
                <button data-category="science-fiction" data-category-value="Science Fiction" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'science-fiction' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Science Fiction</button>
                <button data-category="fantasy" data-category-value="Fantasy" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'fantasy' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Fantasy</button>
                <button data-category="self-help" data-category-value="Self-Help" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'self-help' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Self-Help</button>
                <button data-category="non-fiction" data-category-value="Non-Fiction" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'non-fiction' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Non-Fiction</button>
                <button data-category="biography" data-category-value="Biography" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedCategoryValue eq 'biography' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Biography</button>
            </div>
        </div>
    </div>

    <div class="mb-3">
        <h3 class="font-bold text-foreground mb-4">Price Range</h3>
        <input type="range" min="1" max="1000" class="range-input w-full" value="${selectedMaxPrice}"/>
        <p class="text-sm text-muted-foreground mt-2">Up to <span id="selected-price-range">${selectedMaxPrice}</span> EGP</p>
    </div>

    <div>
        <button id="sort-controller" class="w-full font-bold text-foreground mb-2 flex items-center justify-between hover:text-primary transition-colors cursor-pointer">
            <span>Sort By</span>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down w-4 h-4 transition-transform duration-300 ease-in-out rotate-180" aria-hidden="true">
                <path d="m6 9 6 6 6-6"></path>
            </svg>
        </button>
        <div class="overflow-hidden transition-all duration-300 ease-in-out max-h-12 opacity-100">
            <div id="selected-sort-criteria"
                 data-selected-sort-criteria="${selectedSortCriteria}"
                 class="px-3 py-2 bg-muted/50 rounded-lg border border-border text-sm text-primary font-medium truncate">
                <c:choose>
                    <c:when test="${selectedSortCriteria eq 'price-low-to-high'}">Price: Low to High</c:when>
                    <c:when test="${selectedSortCriteria eq 'price-high-to-low'}">Price: High to Low</c:when>
                    <c:when test="${selectedSortCriteria eq 'rating'}">Top Rated</c:when>
                    <c:otherwise>Featured</c:otherwise>
                </c:choose>
            </div>
        </div>
        <div id="sort-container" class="overflow-hidden transition-all duration-300 ease-in-out max-h-0 opacity-0">
            <div class="space-y-1 bg-muted/50 rounded-lg p-2 border border-border">
                <button data-criteria="featured" class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedSortCriteria eq 'featured' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Featured</button>
                <button data-criteria="price-low-to-high" class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedSortCriteria eq 'price-low-to-high' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Price: Low to High</button>
                <button data-criteria="price-high-to-low" class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedSortCriteria eq 'price-high-to-low' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Price: High to Low</button>
                <button data-criteria="rating" class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer ${selectedSortCriteria eq 'rating' ? 'bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold' : 'hover:bg-primary/5 active:bg-primary/10 text-foreground'}">Top Rated</button>
            </div>
        </div>
    </div>
</div>
