
<div id="sidebar-filter" data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6 sticky top-24">
    <div class="flex-1 relative mb-3">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search absolute left-3 top-3 w-4 h-4 text-muted-foreground" aria-hidden="true">
            <path d="m21 21-4.34-4.34"></path>
            <circle cx="11" cy="11" r="8"></circle>
        </svg>
        <input id="search-input" type="text" placeholder="Search books..." class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" value=""/>
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
            <div id="selected-category" class="px-3 py-2 bg-muted/50 rounded-lg border border-border text-sm text-primary font-medium truncate">All</div>
        </div>
        <div id="categories-container" class="overflow-hidden transition-all duration-300 ease-in-out max-h-0 opacity-0">
            <div class="space-y-1 bg-muted/50 rounded-lg p-2 border border-border">
                <button data-category="all"             class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold">All</button>
                <button data-category="fiction"         class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Fiction</button>
                <button data-category="science-fiction" class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Science Fiction</button>
                <button data-category="fantasy"         class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Fantasy</button>
                <button data-category="self-help"       class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Self-Help</button>
                <button data-category="non-fiction"     class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Non-Fiction</button>
                <button data-category="biography"       class="category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Biography</button>
            </div>
        </div>
    </div>
    <div class="mb-3">
        <h3 class="font-bold text-foreground mb-4">Price Range</h3>
        <input type="range" min="0" max="50" class="range-input w-full" value="50"/>
        <p class="text-sm text-muted-foreground mt-2">Up to <span id="selected-price-range"></span> EGP</p>
    </div>
    <div>
        <button id="sort-controller" class="w-full font-bold text-foreground mb-2 flex items-center justify-between hover:text-primary hover:bg-primary/10 rounded-lg p-2 transition-colors cursor-pointer">
            <span>Sort By</span>
            <svg id="sort-chevron-down" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-down w-4 h-4 transition-transform duration-300 ease-in-out" aria-hidden="true">
                <path d="m6 9 6 6 6-6"></path>
            </svg>
        </button>
        <div class="overflow-hidden transition-all duration-300 ease-in-out max-h-12 opacity-100">
            <div id="selected-sort-criteria" class="px-3 py-2 bg-muted/50 rounded-lg border border-border text-sm text-primary font-medium truncate">Featured</div>
        </div>
        <div id="sort-container" class="overflow-hidden transition-all duration-300 ease-in-out max-h-0 opacity-0">
            <div class="space-y-1 bg-muted/50 rounded-lg p-2 border border-border">
                <button data-criteria="featured"    class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold">Featured</button>
                <button data-criteria="price-low-to-high"   class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Price: Low to High</button>
                <button data-criteria="price-high-to-low"  class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Price: High to Low</button>
                <button data-criteria="rating"      class="sort-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer hover:bg-primary/5 active:bg-primary/10 text-foreground">Top Rated</button>
            </div>
        </div>
    </div>
</div>
