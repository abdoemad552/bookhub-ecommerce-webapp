
<div class="space-y-5">

    <%-- ── Page header ── --%>
    <div class="flex items-center justify-between gap-3">
        <div>
            <h2 class="text-xl sm:text-2xl font-bold text-foreground">Books Management</h2>
            <p class="text-sm text-muted-foreground">Manage your book inventory</p>
        </div>
        <div class="flex justify-center items-center gap-2">
            <button id="open-add-category-modal-btn" class="products-header-btn">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-tags w-4 h-4" viewBox="0 0 16 16">
                    <path d="M3 2v4.586l7 7L14.586 9l-7-7zM2 2a1 1 0 0 1 1-1h4.586a1 1 0 0 1 .707.293l7 7a1 1 0 0 1 0 1.414l-4.586 4.586a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 2 6.586z"/>
                    <path d="M5.5 5a.5.5 0 1 1 0-1 .5.5 0 0 1 0 1m0 1a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3M1 7.086a1 1 0 0 0 .293.707L8.75 15.25l-.043.043a1 1 0 0 1-1.414 0l-7-7A1 1 0 0 1 0 7.586V3a1 1 0 0 1 1-1z"/>
                </svg>
                <span class="hidden sm:inline">Add New Category</span>
            </button>
            <button id="open-add-book-modal-btn"
                    class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md
                       text-sm font-medium transition-all cursor-pointer
                       text-primary-foreground bg-primary hover:bg-primary/90 active:bg-primary/80
                       h-9 px-4 py-2 has-[>svg]:px-3 shrink-0
                       focus-visible:outline-none focus-visible:border-ring
                       focus-visible:ring-ring/50 focus-visible:ring-[3px]">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="2"
                     stroke-linecap="round" stroke-linejoin="round"
                     class="lucide lucide-plus w-4 h-4 sm:mr-2" aria-hidden="true">
                    <path d="M5 12h14"/><path d="M12 5v14"/>
                </svg>
                <span class="hidden sm:inline">Add New Book</span>
            </button>
        </div>
    </div>

    <%-- ══════════════════════════════════════════════
     ADD CATEGORY DIALOG  — id must match edit-book-dialog.js
    ══════════════════════════════════════════════ --%>
    <dialog id="add-category-dialog" aria-labelledby="add-category-title" aria-modal="true">
        <div class="dialog-panel bg-white border border-slate-200/80 shadow-2xl shadow-slate-900/10">

            <div class="sm:hidden flex justify-center pt-3 pb-1">
                <div class="w-10 h-1 bg-slate-200 rounded-full"></div>
            </div>

            <header class="flex items-start justify-between px-6 pt-5 pb-4 border-b border-slate-100 select-none">
                <div>
                    <p class="text-[11px] font-semibold text-primary uppercase tracking-widest mb-1">Catalog</p>
                    <h2 id="edit-dialog-title" class="text-[1.1rem] font-semibold text-foreground leading-tight">
                        Add Category
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

            <form id="category-form" novalidate class="flex flex-col px-6 py-5 space-y-5">
                <label for="category" class="block text-sm font-medium text-slate-700 select-none">
                    Category
                </label>
                <input type="text" id="category" name="category"
                       placeholder="Category name" aria-label="Category"
                       class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg
                                      bg-white transition-all duration-150"/>
                <p class="hidden text-xs text-red-500" data-error="category"></p>
            </form>

            <footer class="flex flex-col-reverse sm:flex-row items-stretch sm:items-center justify-end
                       gap-2.5 px-6 py-4 border-t border-slate-100 bg-slate-50/70
                       rounded-b-[inherit] select-none">
                <button id="cancel-btn" type="button"
                        class="inline-flex items-center justify-center px-4 py-2.5 text-sm font-medium
                           text-slate-700 bg-white border border-slate-200 rounded-xl shadow-sm
                           hover:bg-slate-50 active:bg-slate-100 transition-all duration-150 cursor-pointer
                           focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    Cancel
                </button>
                <button id="submit-btn" type="button"
                        class="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm
                           font-semibold text-primary-foreground bg-primary rounded-xl shadow-md
                           shadow-primary/10 hover:bg-primary/95 active:scale-[0.98]
                           transition-all duration-150 cursor-pointer
                           focus-visible:outline-none focus-visible:ring-2
                           focus-visible:ring-primary focus-visible:ring-offset-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M5 12h14"/><path d="M12 5v14"/>
                    </svg>
                    Add
                </button>
            </footer>
        </div>
    </dialog>

    <%-- ══════════════════════════════════════════════
         ADD BOOK DIALOG  — id must match add-book-dialog.js
    ══════════════════════════════════════════════ --%>
    <dialog id="add-book-dialog" aria-labelledby="add-dialog-title" aria-modal="true">
        <div class="dialog-panel bg-white border border-slate-200/80 shadow-2xl shadow-slate-900/10">

            <div class="sm:hidden flex justify-center pt-3 pb-1">
                <div class="w-10 h-1 bg-slate-200 rounded-full"></div>
            </div>

            <header class="flex items-start justify-between px-6 pt-5 pb-4 border-b border-slate-100 select-none">
                <div>
                    <p class="text-[11px] font-semibold text-primary uppercase tracking-widest mb-1">Catalog</p>
                    <h2 id="add-dialog-title" class="text-[1.1rem] font-semibold text-foreground leading-tight">
                        Add New Book
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

            <form id="book-form" novalidate class="px-6 py-5 space-y-5">

                <%-- Row 1: ISBN + Title --%>
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-isbn" class="block text-sm font-medium text-slate-700 select-none">
                            ISBN <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-isbn" name="isbn" type="text" required
                               placeholder="978-3-16-148410-0"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-isbn"></p>
                    </div>
                    <div class="space-y-1.5 sm:col-span-2">
                        <label for="book-title" class="block text-sm font-medium text-slate-700 select-none">
                            Title <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-title" name="title" type="text" required
                               placeholder="e.g. The Midnight Library"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-title"></p>
                    </div>
                </div>

                <%-- Row 2: Authors --%>
                <fieldset class="space-y-2">
                    <div class="flex items-center justify-between">
                        <legend class="text-sm font-medium text-slate-700 select-none">
                            Authors <span class="text-red-400" aria-hidden="true">*</span>
                        </legend>
                        <button id="add-author-btn" type="button"
                                class="inline-flex items-center gap-1 text-xs font-medium text-primary
                                       hover:bg-primary/15 px-2.5 py-1.5 rounded-lg transition-colors
                                       duration-150 cursor-pointer select-none
                                       focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12"
                                 viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                 stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                <path d="M5 12h14"/><path d="M12 5v14"/>
                            </svg>
                            Add Author
                        </button>
                    </div>
                    <div id="authors-list" class="space-y-2">
                        <div class="author-row flex items-center gap-2">
                            <input type="text" name="authors[]"
                                   placeholder="Author 1 name" aria-label="Author 1"
                                   class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900
                                          placeholder-slate-400 border border-slate-200 rounded-lg
                                          bg-white transition-all duration-150"/>
                        </div>
                    </div>
                </fieldset>

                <%-- Row 3: Description --%>
                <div class="space-y-1.5">
                    <label for="book-description" class="block text-sm font-medium text-slate-700 select-none">
                        Description
                    </label>
                    <textarea id="book-description" name="description" rows="3"
                              placeholder="A brief synopsis of the book..."
                              class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                     placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                     transition-all duration-150 resize-none"></textarea>
                </div>

                <%-- Row 4: Price + Stock + Pages --%>
                <div class="grid grid-cols-3 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-price" class="block text-sm font-medium text-slate-700 select-none">
                            Price (EGP) <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-price" name="price" type="number" min="0" step="0.01" required
                               placeholder="19.99"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-price"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-qty" class="block text-sm font-medium text-slate-700 select-none">
                            Stock <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-qty" name="stockQuantity" type="number" min="0" step="1" required
                               placeholder="50"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-qty"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-pages" class="block text-sm font-medium text-slate-700 select-none">
                            Pages <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-pages" name="pages" type="number" min="1" step="1" required
                               placeholder="320"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-pages"></p>
                    </div>
                </div>

                <%-- Row 5: Category + Book Type --%>
                <div class="grid grid-cols-2 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-category" class="block text-sm font-medium text-slate-700 select-none">
                            Category <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <div class="relative">
                            <select id="book-category" name="category" required
                                    class="field-input w-full px-3.5 py-2.5 pr-9 text-sm text-slate-900 border border-slate-200 rounded-lg bg-white appearance-none transition-all duration-150 cursor-pointer">
                                <option value="">Select a category...</option>
                                <option value="Fiction">Fiction</option>
                                <option value="Science Fiction">Science Fiction</option>
                                <option value="Fantasy">Fantasy</option>
                                <option value="Self-Help">Self-Help</option>
                                <option value="Non-Fiction">Non-Fiction</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-slate-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"/>
                                </svg>
                            </div>
                        </div>
                        <p class="hidden text-xs text-red-500" data-error="book-category"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-type" class="block text-sm font-medium text-slate-700 select-none">
                            Book Type <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <div class="relative">
                            <select id="book-type" name="bookType" required
                                    class="field-input w-full px-3.5 py-2.5 pr-9 text-sm text-slate-900
                                           border border-slate-200 rounded-lg bg-white appearance-none
                                           transition-all duration-150 cursor-pointer">
                                <option value="">Select type...</option>
                                <option value="HARDCOVER">Hardcover</option>
                                <option value="PAPERBACK">Paperback</option>
                                <option value="EBOOK">E-Book</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-slate-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"/>
                                </svg>
                            </div>
                        </div>
                        <p class="hidden text-xs text-red-500" data-error="book-type"></p>
                    </div>
                </div>

                <%-- Row 6: Publish Date + Cover Image --%>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-publish-date" class="block text-sm font-medium text-slate-700 select-none">
                            Publish Date <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-publish-date" name="publishDate" type="date" required
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150 cursor-pointer"/>
                        <p class="hidden text-xs text-red-500" data-error="book-publish-date"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-image" class="block text-sm font-medium text-slate-700 select-none">
                            Cover Image
                        </label>
                        <%-- Hidden real file input --%>
                        <input id="book-image" name="image" type="file"
                               accept="image/jpeg,image/png,image/webp,image/gif"
                               class="sr-only" aria-describedby="book-image-hint"/>
                        <%-- Styled trigger button --%>
                        <button type="button" id="book-image-trigger"
                                class="field-input w-full px-3.5 py-2.5 text-sm text-left
                                       border border-slate-200 rounded-lg bg-white
                                       transition-all duration-150 cursor-pointer
                                       hover:border-slate-300 hover:bg-slate-50
                                       focus-visible:outline-none focus-visible:ring-2
                                       focus-visible:ring-primary">
                            <span class="flex items-center gap-2 text-slate-400" id="book-image-label">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                     class="shrink-0" aria-hidden="true">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                    <polyline points="17 8 12 3 7 8"/>
                                    <line x1="12" x2="12" y1="3" y2="15"/>
                                </svg>
                                <span id="book-image-text">Choose image...</span>
                            </span>
                        </button>
                        <p id="book-image-hint" class="text-xs text-slate-400 select-none">
                            JPG, PNG, or WEBP (max 5 MB)
                        </p>
                        <p class="hidden text-xs text-red-500" data-error="book-image"></p>
                    </div>
                </div>

            </form>

            <footer class="flex flex-col-reverse sm:flex-row items-stretch sm:items-center justify-end
                           gap-2.5 px-6 py-4 border-t border-slate-100 bg-slate-50/70
                           rounded-b-[inherit] select-none">
                <button id="cancel-btn" type="button"
                        class="inline-flex items-center justify-center px-4 py-2.5 text-sm font-medium
                               text-slate-700 bg-white border border-slate-200 rounded-xl shadow-sm
                               hover:bg-slate-50 active:bg-slate-100 transition-all duration-150 cursor-pointer
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    Cancel
                </button>
                <button id="submit-btn" type="button"
                        class="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm
                               font-semibold text-primary-foreground bg-primary rounded-xl shadow-md
                               shadow-primary/10 hover:bg-primary/95 active:scale-[0.98]
                               transition-all duration-150 cursor-pointer
                               focus-visible:outline-none focus-visible:ring-2
                               focus-visible:ring-primary focus-visible:ring-offset-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M5 12h14"/><path d="M12 5v14"/>
                    </svg>
                    Add Book
                </button>
            </footer>
        </div>
    </dialog>

    <%-- ══════════════════════════════════════════════
         EDIT BOOK DIALOG  — id must match edit-book-dialog.js
    ══════════════════════════════════════════════ --%>
    <dialog id="edit-book-dialog" aria-labelledby="edit-dialog-title" aria-modal="true">
        <div class="dialog-panel bg-white border border-slate-200/80 shadow-2xl shadow-slate-900/10">

            <div class="sm:hidden flex justify-center pt-3 pb-1">
                <div class="w-10 h-1 bg-slate-200 rounded-full"></div>
            </div>

            <header class="flex items-start justify-between px-6 pt-5 pb-4 border-b border-slate-100 select-none">
                <div>
                    <p class="text-[11px] font-semibold text-primary uppercase tracking-widest mb-1">Catalog</p>
                    <h2 id="edit-dialog-title" class="text-[1.1rem] font-semibold text-foreground leading-tight">
                        Edit Book
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

            <form id="book-form" novalidate class="px-6 py-5 space-y-5">

                <%-- Hidden book ID — read by editBookDialog.js on submit --%>
                <input type="hidden" id="book-id" name="id"/>

                <%-- Price + Stock + Pages --%>
                <div class="grid grid-cols-3 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-price" class="block text-sm font-medium text-slate-700 select-none">
                            Price (EGP) <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-price" name="price" type="number" min="0" step="0.01" required
                               placeholder="19.99"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-price"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-qty" class="block text-sm font-medium text-slate-700 select-none">
                            Stock <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-qty" name="stockQuantity" type="number" min="0" step="1" required
                               placeholder="50"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-qty"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-pages" class="block text-sm font-medium text-slate-700 select-none">
                            Pages <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <input id="book-pages" name="pages" type="number" min="1" step="1" required
                               placeholder="320"
                               class="field-input w-full px-3.5 py-2.5 text-sm text-slate-900
                                      placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                                      transition-all duration-150"/>
                        <p class="hidden text-xs text-red-500" data-error="book-pages"></p>
                    </div>
                </div>

                <%-- Category + Book Type --%>
                <div class="grid grid-cols-2 gap-4">
                    <div class="space-y-1.5">
                        <label for="book-category" class="block text-sm font-medium text-slate-700 select-none">
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
                            <div class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-slate-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"/>
                                </svg>
                            </div>
                        </div>
                        <p class="hidden text-xs text-red-500" data-error="book-category"></p>
                    </div>
                    <div class="space-y-1.5">
                        <label for="book-type" class="block text-sm font-medium text-slate-700 select-none">
                            Book Type <span class="text-red-400" aria-hidden="true">*</span>
                        </label>
                        <div class="relative">
                            <select id="book-type" name="bookType" required
                                    class="field-input w-full px-3.5 py-2.5 pr-9 text-sm text-slate-900
                                           border border-slate-200 rounded-lg bg-white appearance-none
                                           transition-all duration-150 cursor-pointer">
                                <option value="">Select type...</option>
                                <option value="HARDCOVER">Hardcover</option>
                                <option value="PAPERBACK">Paperback</option>
                                <option value="EBOOK">E-Book</option>
                            </select>
                            <div class="pointer-events-none absolute inset-y-0 right-3 flex items-center text-slate-400">
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                                     viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                     stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                    <path d="m6 9 6 6 6-6"/>
                                </svg>
                            </div>
                        </div>
                        <p class="hidden text-xs text-red-500" data-error="book-type"></p>
                    </div>
                </div>
            </form>

            <footer class="flex flex-col-reverse sm:flex-row items-stretch sm:items-center justify-end
                           gap-2.5 px-6 py-4 border-t border-slate-100 bg-slate-50/70
                           rounded-b-[inherit] select-none">
                <button id="cancel-btn" type="button"
                        class="inline-flex items-center justify-center px-4 py-2.5 text-sm font-medium
                               text-slate-700 bg-white border border-slate-200 rounded-xl shadow-sm
                               hover:bg-slate-50 active:bg-slate-100 transition-all duration-150 cursor-pointer
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    Cancel
                </button>
                <button id="submit-btn" type="button"
                        class="inline-flex items-center justify-center gap-2 px-5 py-2.5 text-sm
                               font-semibold text-primary-foreground bg-primary rounded-xl shadow-md
                               shadow-primary/10 hover:bg-primary/95 active:scale-[0.98]
                               transition-all duration-150 cursor-pointer
                               focus-visible:outline-none focus-visible:ring-2
                               focus-visible:ring-primary focus-visible:ring-offset-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M5 12h14"/><path d="M12 5v14"/>
                    </svg>
                    Save Changes
                </button>
            </footer>
        </div>
    </dialog>

    <%-- ── Books table ── --%>
    <%-- #books-table-container is the sole mounting point for BooksTable.js  --%>
    <%-- BooksTable renders the desktop table, mobile cards, and pagination    --%>
    <%-- inside this element — do NOT add static rows here                     --%>
    <div data-slot="card"
         class="bg-card text-card-foreground rounded-xl border shadow-sm overflow-hidden">
        <div id="books-table-container"></div>
    </div>

</div>
<%-- ══════════════════════════════════════════════════════════════════════════
     DELETE BOOK CONFIRMATION DIALOG
     Placed OUTSIDE the page wrapper so it is never clipped by a stacking
     context created by the <dialog> elements above.
     CSS is self-contained below via a <style> block; it mirrors the UM
     confirm dialog design exactly, scoped to book-confirm-* IDs.
════════════════════════════════════════════════════════════════════════════ --%>
<style>
    #book-confirm-backdrop {
        position: fixed;
        inset: 0;
        z-index: 9998; /* below toasts (9999) but above everything else */
        background: rgba(0, 0, 0, 0);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 1rem;
        pointer-events: none;
        opacity: 0;
        transition: background 0.2s ease, opacity 0.2s ease;
    }

    #book-confirm-backdrop.is-open {
        background: rgba(0, 0, 0, 0.5);
        pointer-events: all;
        opacity: 1;
    }

    #book-confirm-panel {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: 1.125rem;
        width: 100%;
        max-width: 360px;
        padding: 1.75rem 1.5rem 1.5rem;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        gap: 0;
        box-shadow: 0 24px 60px rgba(0, 0, 0, 0.20);
        transform: scale(0.93) translateY(10px);
        opacity: 0;
        transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.2s ease;
    }

    #book-confirm-backdrop.is-open #book-confirm-panel {
        transform: scale(1) translateY(0);
        opacity: 1;
    }
</style>

<div id="book-confirm-backdrop" role="alertdialog" aria-modal="true" aria-labelledby="book-confirm-title">
    <div id="book-confirm-panel">
        <div class="um-confirm-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                 stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"/>
                <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                <path d="M10 11v6"/><path d="M14 11v6"/>
                <path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
            </svg>
        </div>
        <h4 id="book-confirm-title">Delete this book?</h4>
        <p id="book-confirm-desc">
            This will permanently delete the book. This action cannot be undone.
        </p>
        <div class="um-confirm-actions">
            <button id="book-confirm-no"  class="um-confirm-btn um-confirm-btn--no">Keep Book</button>
            <button id="book-confirm-yes" class="um-confirm-btn um-confirm-btn--yes">Yes, Delete</button>
        </div>
    </div>
</div>
