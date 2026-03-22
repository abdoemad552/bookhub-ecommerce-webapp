<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">

<div class="space-y-5">
    <div class="flex items-center justify-between gap-3">
        <div>
            <h2 class="text-xl sm:text-2xl font-bold text-foreground">Books Management</h2>
            <p class="text-sm text-muted-foreground">Manage your book inventory</p>
        </div>
        <button id="open-add-book-modal-btn" data-open-add-book class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-9 px-4 py-2 has-[&gt;svg]:px-3 bg-primary hover:bg-primary/90 shrink-0">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-plus w-4 h-4 sm:mr-2" aria-hidden="true">
                <path d="M5 12h14"></path>
                <path d="M12 5v14"></path>
            </svg>
            <span class="hidden sm:inline">Add New Book</span>
        </button>
    </div>

    <dialog id="book-dialog" aria-labelledby="dialog-title" aria-modal="true">
        <div class="dialog-panel bg-white border border-slate-200/80 shadow-2xl shadow-slate-900/10">
            <!-- Drag handle (mobile only) -->
            <div class="sm:hidden flex justify-center pt-3 pb-1">
                <div class="w-10 h-1 bg-slate-200 rounded-full"></div>
            </div>
            <!-- ── Header ── -->
            <header class="flex items-start justify-between px-6 pt-5 pb-4 border-b border-slate-100 select-none">
                <div>
                    <p class="text-[11px] font-semibold text-primary uppercase tracking-widest mb-1">Catalog</p>
                    <h2 id="dialog-title" class="text-[1.1rem] font-semibold text-foreground leading-tight">
                        Add New Book
                    </h2>
                </div>
                <button id="close-btn" type="button" aria-label="Close dialog"
                        class="mt-0.5 p-1.5 text-slate-400 hover:text-primary hover:bg-primary/15
            rounded-lg transition-colors duration-150 focus-visible:outline-none
            focus-visible:ring-2 focus-visible:ring-primary cursor-pointer">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M18 6 6 18"/>
                        <path d="m6 6 12 12"/>
                    </svg>
                </button>
            </header>
            <!-- ── Form body ── -->
            <form id="book-form" novalidate class="px-6 py-5 space-y-5">
                <!-- Book Title -->
                <div class="space-y-1.5">
                    <label for="book-title"
                           class="block text-sm font-medium text-slate-700 select-none">
                        Book Title <span class="text-red-400" aria-hidden="true">*</span>
                    </label>
                    <input id="book-title" name="title" type="text" required
                           placeholder="e.g. The Midnight Library"
                           class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
               placeholder-slate-400 border border-slate-200 rounded-lg bg-white
               transition-all duration-150"/>
                    <p class="hidden text-xs text-red-500" data-error="book-title"></p>
                </div>
                <!-- Authors -->
                <fieldset class="space-y-2">
                    <div class="flex items-center justify-between">
                        <legend class="text-sm font-medium text-slate-700 select-none">
                            Authors <span class="text-red-400" aria-hidden="true">*</span>
                        </legend>
                        <button id="add-author-btn" type="button"
                                class="inline-flex items-center gap-1 text-xs font-medium text-primary
                  hover:bg-primary/15 px-2.5 py-1.5 rounded-lg transition-colors
                  duration-150 focus-visible:outline-none focus-visible:ring-2
                  focus-visible:ring-primary select-none cursor-pointer">
                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                 stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="M5 12h14"/>
                                <path d="M12 5v14"/>
                            </svg>
                            Add Author
                        </button>
                    </div>
                    <div id="authors-list" class="space-y-2">
                        <!-- First author row — non-removable -->
                        <div class="author-row flex items-center gap-2">
                            <input type="text" name="authors[]"
                                   placeholder="Author 1 name" aria-label="Author 1"
                                   class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900
                     placeholder-slate-400 border border-slate-200 rounded-lg
                     bg-white transition-all duration-150"/>
                        </div>
                    </div>
                </fieldset>
                <!-- Price + Quantity (grid) -->
                <div class="grid grid-cols-2 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-price"
                               class="block text-sm font-medium text-slate-700 select-none">
                            Price ($) <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-price" name="price" type="number" min="0" step="0.01" required
                               placeholder="19.99"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                  placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                  transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-price"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-qty"
                               class="block text-sm font-medium text-slate-700 select-none">
                            Quantity <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-qty" name="quantity" type="number" min="0" step="1" required
                               placeholder="50"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                  placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                  transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-qty"></p>
                    </div>
                </div>
                <!-- Category -->
                <div class="space-y-1.5">
                    <label for="book-category"
                           class="block text-sm font-medium text-slate-700 select-none">
                        Category <span class="text-red-400" aria-hidden="true">*</span>
                    </label>
                    <div class="relative">
                        <select id="book-category" name="category" required
                                class="field-input w-full px-3.5 py-2.5 pr-9 text-sm text-slate-900
                  border border-slate-200 rounded-lg bg-white appearance-none
                  transition-all duration-150 cursor-pointer">
                            <option value="">Select a category...</option>
                            <option value="Fiction">Fiction</option>
                            <option value="Science Fiction">Science Fiction</option>
                            <option value="Fantasy">Fantasy</option>
                            <option value="Self-Help">Self-Help</option>
                            <option value="Non-Fiction">Non-Fiction</option>
                        </select>
                        <div class="pointer-events-none absolute inset-y-0 right-3
                  flex items-center text-slate-400">
                            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                 stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="m6 9 6 6 6-6"/>
                            </svg>
                        </div>
                    </div>
                    <p class="hidden text-xs text-red-500" data-error="book-category"></p>
                </div>
            </form>
            <!-- ── Footer / actions ── -->
            <footer class="flex flex-col-reverse sm:flex-row items-stretch sm:items-center justify-end
         gap-2.5 px-6 py-4 border-t border-slate-100 bg-slate-50/70
         rounded-b-[inherit] select-none">
                <button id="cancel-btn" type="button"
                        class="inline-flex items-center justify-center px-4 py-2.5 text-sm font-medium
            text-slate-700 bg-white border border-slate-200 rounded-xl shadow-sm
            hover:bg-slate-50 active:bg-slate-100 transition-all duration-150
            focus-visible:outline-none focus-visible:ring-2
            focus-visible:ring-primary cursor-pointer">
                    Cancel
                </button>
                <button id="submit-btn" type="button"
                        class="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm
            font-semibold text-primary-foreground bg-primary rounded-xl shadow-md
            shadow-primary/10 hover:bg-primary/95 active:scale-[0.98]
            transition-all duration-150 focus-visible:outline-none
            focus-visible:ring-2 focus-visible:ring-primary
            focus-visible:ring-offset-2 cursor-pointer">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M5 12h14"/>
                        <path d="M12 5v14"/>
                    </svg>
                    Add Book
                </button>
            </footer>
        </div>
    </dialog>
<%--    <div class="space-y-3">--%>
<%--        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4">--%>
<%--            <div class="flex items-start justify-between gap-3 mb-3">--%>
<%--                <div class="min-w-0">--%>
<%--                    <p class="font-semibold text-foreground truncate">The Midnight Library</p>--%>
<%--                    <p class="text-sm text-muted-foreground">Matt Haig</p>--%>
<%--                </div>--%>
<%--                <div class="flex gap-2 shrink-0">--%>
<%--                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pen w-3.5 h-3.5" aria-hidden="true">--%>
<%--                            <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"></path>--%>
<%--                        </svg>--%>
<%--                    </button>--%>
<%--                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0 text-red-500 hover:text-red-600">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2 lucide-trash-2 w-3.5 h-3.5" aria-hidden="true">--%>
<%--                            <path d="M10 11v6"></path>--%>
<%--                            <path d="M14 11v6"></path>--%>
<%--                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>--%>
<%--                            <path d="M3 6h18"></path>--%>
<%--                            <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>--%>
<%--                        </svg>--%>
<%--                    </button>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="flex items-center gap-2 flex-wrap"><span class="px-2 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">Fiction</span><span class="text-sm font-semibold text-foreground">$15.99</span><span class="px-2 py-0.5 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">45 units</span></div>--%>
<%--        </div>--%>
<%--        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4">--%>
<%--            <div class="flex items-start justify-between gap-3 mb-3">--%>
<%--                <div class="min-w-0">--%>
<%--                    <p class="font-semibold text-foreground truncate">Project Hail Mary</p>--%>
<%--                    <p class="text-sm text-muted-foreground">Andy Weir</p>--%>
<%--                </div>--%>
<%--                <div class="flex gap-2 shrink-0">--%>
<%--                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pen w-3.5 h-3.5" aria-hidden="true">--%>
<%--                            <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"></path>--%>
<%--                        </svg>--%>
<%--                    </button>--%>
<%--                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0 text-red-500 hover:text-red-600">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2 lucide-trash-2 w-3.5 h-3.5" aria-hidden="true">--%>
<%--                            <path d="M10 11v6"></path>--%>
<%--                            <path d="M14 11v6"></path>--%>
<%--                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>--%>
<%--                            <path d="M3 6h18"></path>--%>
<%--                            <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>--%>
<%--                        </svg>--%>
<%--                    </button>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="flex items-center gap-2 flex-wrap"><span class="px-2 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">Science Fiction</span><span class="text-sm font-semibold text-foreground">$16.99</span><span class="px-2 py-0.5 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">32 units</span></div>--%>
<%--        </div>--%>
<%--        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-4">--%>
<%--            <div class="flex items-start justify-between gap-3 mb-3">--%>
<%--                <div class="min-w-0">--%>
<%--                    <p class="font-semibold text-foreground truncate">Atomic Habits</p>--%>
<%--                    <p class="text-sm text-muted-foreground">James Clear</p>--%>
<%--                </div>--%>
<%--                <div class="flex gap-2 shrink-0">--%>
<%--                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pen w-3.5 h-3.5" aria-hidden="true">--%>
<%--                            <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"></path>--%>
<%--                        </svg>--%>
<%--                    </button>--%>
<%--                    <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0 text-red-500 hover:text-red-600">--%>
<%--                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2 lucide-trash-2 w-3.5 h-3.5" aria-hidden="true">--%>
<%--                            <path d="M10 11v6"></path>--%>
<%--                            <path d="M14 11v6"></path>--%>
<%--                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>--%>
<%--                            <path d="M3 6h18"></path>--%>
<%--                            <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>--%>
<%--                        </svg>--%>
<%--                    </button>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="flex items-center gap-2 flex-wrap"><span class="px-2 py-0.5 rounded-full text-xs font-medium bg-primary/10 text-primary">Self-Help</span><span class="text-sm font-semibold text-foreground">$18.99</span><span class="px-2 py-0.5 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">28 units</span></div>--%>
<%--        </div>--%>
<%--    </div>--%>
    <div data-slot="card" class="bg-card text-card-foreground flex-col gap-6 rounded-xl border py-6 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <tr class="border-b border-border bg-muted/50">
                    <th class="text-left px-6 py-4 font-semibold text-foreground">Title</th>
                    <th class="text-left px-6 py-4 font-semibold text-foreground">Author</th>
                    <th class="text-left px-6 py-4 font-semibold text-foreground">Category</th>
                    <th class="text-right px-6 py-4 font-semibold text-foreground">Price</th>
                    <th class="text-right px-6 py-4 font-semibold text-foreground">Stock</th>
                    <th class="text-center px-6 py-4 font-semibold text-foreground">Actions</th>
                </tr>
                <tr class="border-b border-border hover:bg-muted/30 transition-colors">
                    <td class="px-6 py-4 text-foreground font-medium">The Midnight Library</td>
                    <td class="px-6 py-4 text-muted-foreground">Matt Haig</td>
                    <td class="px-6 py-4"><span class="px-2 py-1 rounded-full text-xs font-medium bg-primary/10 text-primary">Fiction</span></td>
                    <td class="px-6 py-4 text-right font-semibold text-foreground">$15.99</td>
                    <td class="px-6 py-4 text-right"><span class="px-2 py-1 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">45 units</span></td>
                    <td class="px-6 py-4 text-center">
                        <div class="flex justify-center gap-2">
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pen w-4 h-4" aria-hidden="true">
                                    <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"></path>
                                </svg>
                            </button>
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0 text-red-500 hover:text-red-600 hover:bg-red-50">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2 lucide-trash-2 w-4 h-4" aria-hidden="true">
                                    <path d="M10 11v6"></path>
                                    <path d="M14 11v6"></path>
                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>
                                    <path d="M3 6h18"></path>
                                    <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr class="border-b border-border hover:bg-muted/30 transition-colors">
                    <td class="px-6 py-4 text-foreground font-medium">Project Hail Mary</td>
                    <td class="px-6 py-4 text-muted-foreground">Andy Weir</td>
                    <td class="px-6 py-4"><span class="px-2 py-1 rounded-full text-xs font-medium bg-primary/10 text-primary">Science Fiction</span></td>
                    <td class="px-6 py-4 text-right font-semibold text-foreground">$16.99</td>
                    <td class="px-6 py-4 text-right"><span class="px-2 py-1 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">32 units</span></td>
                    <td class="px-6 py-4 text-center">
                        <div class="flex justify-center gap-2">
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pen w-4 h-4" aria-hidden="true">
                                    <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"></path>
                                </svg>
                            </button>
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0 text-red-500 hover:text-red-600 hover:bg-red-50">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2 lucide-trash-2 w-4 h-4" aria-hidden="true">
                                    <path d="M10 11v6"></path>
                                    <path d="M14 11v6"></path>
                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>
                                    <path d="M3 6h18"></path>
                                    <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr class="border-b border-border hover:bg-muted/30 transition-colors">
                    <td class="px-6 py-4 text-foreground font-medium">Atomic Habits</td>
                    <td class="px-6 py-4 text-muted-foreground">James Clear</td>
                    <td class="px-6 py-4"><span class="px-2 py-1 rounded-full text-xs font-medium bg-primary/10 text-primary">Self-Help</span></td>
                    <td class="px-6 py-4 text-right font-semibold text-foreground">$18.99</td>
                    <td class="px-6 py-4 text-right"><span class="px-2 py-1 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600">28 units</span></td>
                    <td class="px-6 py-4 text-center">
                        <div class="flex justify-center gap-2">
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-pen w-4 h-4" aria-hidden="true">
                                    <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"></path>
                                </svg>
                            </button>
                            <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 h-8 w-8 p-0 text-red-500 hover:text-red-600 hover:bg-red-50">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-trash2 lucide-trash-2 w-4 h-4" aria-hidden="true">
                                    <path d="M10 11v6"></path>
                                    <path d="M14 11v6"></path>
                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"></path>
                                    <path d="M3 6h18"></path>
                                    <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>