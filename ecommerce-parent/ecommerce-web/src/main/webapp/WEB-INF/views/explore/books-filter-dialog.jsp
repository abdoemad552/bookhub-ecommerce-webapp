<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<dialog id="books-filter-dialog" aria-labelledby="edit-dialog-title" aria-modal="true">
    <div class="dialog-panel bg-white border border-slate-200/80 shadow-2xl shadow-slate-900/10 overflow-clip">

        <div class="sm:hidden flex justify-center pt-3 pb-1">
            <div class="dialog-drag-handle w-10 h-1 bg-slate-200 rounded-full"></div>
        </div>

        <header class="flex items-start justify-between px-6 pt-5 pb-4 border-b border-slate-100 select-none">
            <div>
                <p class="text-[11px] font-semibold text-primary uppercase tracking-widest mb-1">Catalog</p>
                <h2 id="add-dialog-title" class="text-[1.1rem] font-semibold text-foreground leading-tight">
                    Filter Books
                </h2>
            </div>
            <button id="close-btn" type="button" aria-label="Close dialog"
                    class="mt-0.5 p-1.5 text-slate-400 hover:text-primary hover:bg-primary/15
                               rounded-lg transition-colors duration-150 cursor-pointer
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M18 6 6 18"/><path d="m6 6 12 12"/>
                </svg>
            </button>
        </header>
        <main class="px-6 py-5 space-y-5">
            <div class="mb-3">
                <span class="w-full font-bold text-foreground mb-2 flex items-center gap-2 p-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-funnel w-4 h-4" aria-hidden="true">
                        <path d="M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z"></path>
                    </svg>
                    Categories
                </span>
                <div class="flex-1 relative mb-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search absolute left-3 top-3 w-4 h-4 text-muted-foreground" aria-hidden="true">
                        <path d="m21 21-4.34-4.34"></path>
                        <circle cx="11" cy="11" r="8"></circle>
                    </svg>
                    <input id="category-search" type="text" placeholder="Search categories..." class="w-full pl-10 pr-4 py-2 rounded-full shadow-sm border border-border bg-white text-foreground placeholder-muted-foreground focus:outline-none" value="${requestScope.query}"/>
                </div>
                <div class="custom-scrollbar border-2 border-border rounded-2xl sm:rounded-3xl p-2 sm:p-4 bg-muted/30 max-h-40 sm:max-h-60 overflow-y-auto">
                    <div id="categories-list" class="flex flex-wrap justify-center gap-1 sm:gap-1.5">
                        <span>Loading categories...</span>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <span class="w-full font-bold text-foreground mb-2 flex items-center gap-2 p-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-funnel w-4 h-4" aria-hidden="true">
                        <path d="M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z"></path>
                    </svg>
                    Price Range
                </span>
                <div class="flex gap-3 items-start">
                    <div class="flex-1">
                        <label class="text-xs text-muted-foreground font-medium mb-2 block">Min (EGP)</label>
                        <div class="relative">
                            <input id="min-price-input" type="number" min="0" max="999999" class="w-full p-2 rounded-lg border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all duration-150" placeholder="0" value="0"/>
                        </div>
                    </div>

                    <div class="flex items-center self-center mt-5 text-muted-foreground text-sm font-medium px-1 select-none">-</div>

                    <div class="flex-1">
                        <label class="text-xs text-muted-foreground font-medium mb-2 block">Max (EGP)</label>
                        <div class="relative">
                            <input id="max-price-input" type="number" min="0" max="999999" class="w-full p-2 rounded-lg border border-border bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all duration-150" placeholder="999999" value="999999"/>
                        </div>
                    </div>
                </div>

                <p id="price-range-error" class="hidden text-xs text-red-800 bg-red-100 border border-red-300 rounded-md px-3 py-2 mt-2 flex items-center gap-2 transition-all duration-300 ease-out opacity-0 scale-95">
                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    Min price must be less than or equal to max price.
                </p>
            </div>

            <div>
                <span class="w-full font-bold text-foreground mb-2 flex items-center gap-2 p-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 16 16" fill="currentColor" stroke-width="2" class="bi bi-filter">
                        <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5"/>
                    </svg>
                    Sort By
                </span>
                <div id="sort-container" class="overflow-hidden transition-all duration-300 ease-in-out opacity-100">
                    <div class="flex flex-wrap gap-1">

                        <button data-criteria="featured"
                                class="sort-btn px-2.5 py-1 rounded-full text-[13px] sm:text-xs font-medium border border-border bg-card text-foreground hover:border-accent/50 transition cursor-pointer select-none">
                            Featured
                        </button>

                        <button data-criteria="price-low-to-high"
                                class="sort-btn px-2.5 py-1 rounded-full text-[13px] sm:text-xs font-medium border border-border bg-card text-foreground hover:border-accent/50 transition cursor-pointer select-none">
                            Price: Low to High
                        </button>

                        <button data-criteria="price-high-to-low"
                                class="sort-btn px-2.5 py-1 rounded-full text-[13px] sm:text-xs font-medium border border-border bg-card text-foreground hover:border-accent/50 transition cursor-pointer select-none">
                            Price: High to Low
                        </button>

                        <button data-criteria="rating"
                                class="sort-btn px-2.5 py-1 rounded-full text-[13px] sm:text-xs font-medium border border-border bg-card text-foreground hover:border-accent/50 transition cursor-pointer select-none">
                            Top Rated
                        </button>
                    </div>
                </div>
            </div>

        </main>

        <footer class="flex flex-col-reverse sm:flex-row items-stretch sm:items-center justify-end gap-2.5 px-6 py-4 border-t border-slate-100 bg-slate-50/70 rounded-b-[inherit] select-none">
            <button id="cancel-btn" type="button" class="inline-flex items-center justify-center px-4 py-2.5 text-sm font-medium text-slate-700 bg-white border border-slate-200 rounded-xl shadow-sm hover:bg-slate-50 active:bg-slate-100 transition-all duration-150 cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                Cancel
            </button>
            <button id="submit-btn" type="button" class="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm font-semibold text-primary-foreground bg-primary rounded-xl shadow-md shadow-primary/10 hover:bg-primary/95 active:scale-[0.98] transition-all duration-150 cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M5 12h14"/><path d="M12 5v14"/>
                </svg>
                Filter
            </button>
        </footer>
    </div>
</dialog>