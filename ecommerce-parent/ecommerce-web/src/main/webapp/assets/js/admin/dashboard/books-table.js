/**
 * books-table.js
 * Owns everything related to the books table:
 *   - fetching a paginated list from the server
 *   - rendering rows (or skeleton / empty state)
 *   - pagination controls
 *
 * Public API:
 *   const table = new BooksTable({ contextPath, onEdit, onDelete });
 *   table.init();          // first render
 *   table.reload();        // re-fetch current page (call after add/edit/delete)
 *   table.destroy();       // remove listeners
 */

import {getContextPath} from '../../util.js';
import {showFeedbackMessage} from "../../common/book-card.js";

const SKELETON_ROW_COUNT = 10;

// ── SVG icons (inline so there's no extra import) ─────────────────────────────

const ICON_EDIT = `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
         fill="none" stroke="currentColor" stroke-width="2"
         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/>
    </svg>`;

const ICON_DELETE = `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
         fill="none" stroke="currentColor" stroke-width="2"
         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M10 11v6"/><path d="M14 11v6"/>
        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/>
        <path d="M3 6h18"/>
        <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
    </svg>`;

const ICON_PREV = `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
         fill="none" stroke="currentColor" stroke-width="2"
         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="m15 18-6-6 6-6"/>
    </svg>`;

const ICON_NEXT = `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
         fill="none" stroke="currentColor" stroke-width="2"
         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="m9 18 6-6-6-6"/>
    </svg>`;

const ICON_CAMERA = `
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
         fill="none" stroke="currentColor" stroke-width="2"
         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3z"/>
        <circle cx="12" cy="13" r="3"/>
    </svg>`;

/**
 * Generic book-cover placeholder — shown whenever book.coverUrl is null/empty.
 * Sized to fill whatever container wraps it via width/height="100%".
 */
const ICON_COVER_PLACEHOLDER = `
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
        stroke="currentColor" stroke-width="2" stroke-linecap="round"
        stroke-linejoin="round">
        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
    </svg>`;

// ── Cover thumbnail ───────────────────────────────────────────────────────────

/**
 * Renders a cover thumbnail with a hover overlay that lets the user pick a new
 * image. The overlay is pure CSS (group/peer-hover via Tailwind) so no extra JS
 * is needed for the visual effect — the click is handled by delegated events in
 * _bindEvents via the [data-upload-cover] attribute.
 *
 * @param {string|null} coverUrl
 * @param {string}      title     — used as alt text
 * @param {number}      bookId    — embedded as data-book-id for the upload handler
 * @param {'sm'|'md'}   size      — 'sm' = 36×48 (desktop), 'md' = 48×64 (mobile)
 */
function coverThumbnail(coverUrl, title, bookId, size = 'sm') {
    const dimensions = size === 'md'
        ? 'w-12 h-16'   // 48×64 px — mobile
        : 'w-9 h-12';   // 36×48 px — desktop

    const inner = coverUrl
        ? `<img src="${getContextPath()}/${coverUrl}"
                alt="Cover of ${title}"
                loading="lazy"
                class="w-full h-full object-cover">`
        : ICON_COVER_PLACEHOLDER;

    return `
        <button type="button"
                data-upload-cover
                data-book-id="${bookId}"
                aria-label="Change cover image for ${title}"
                class="group relative ${dimensions} rounded overflow-hidden shrink-0 border border-border bg-primary/10 flex items-center justify-center text-muted-foreground cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
            ${inner}
            <!-- hover overlay -->
            <span class="absolute inset-0 bg-black/50 flex items-center justify-center text-white opacity-0 group-hover:opacity-100 transition-opacity duration-150 pointer-events-none"
                  aria-hidden="true">
                ${ICON_CAMERA}
            </span>
        </button>`;
}

// ── Stock badge helper ────────────────────────────────────────────────────────

function stockBadge(qty) {
    if (qty <= 0) return `<span class="px-2 py-1 rounded-full text-xs font-medium bg-red-500/10 text-red-600 select-none">${qty} units</span>`;
    if (qty <= 10) return `<span class="px-2 py-1 rounded-full text-xs font-medium bg-amber-500/10 text-amber-600 select-none">${qty} units</span>`;
    return `<span class="px-2 py-1 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-600 select-none">${qty} units</span>`;
}

// ── Authors refs ──────────────────────────────────────────────────────────────

function authorsRefs(authors) {
    return authors.map(author =>
        `<a href="${getContextPath()}/authors/${author.id}"
             class="hover:text-primary hover:underline transition-colors">${author.name}</a>`
    ).join(', ');
}

// ── Action buttons ────────────────────────────────────────────────────────────

function actionButtons(book) {
    const json = JSON.stringify(book).replace(/'/g, '&#39;');
    return `
        <div class="flex justify-center gap-2">
            <button data-edit-book data-book='${json}'
                    class="inline-flex items-center justify-center border bg-background shadow-xs
                           hover:bg-accent hover:text-accent-foreground active:bg-accent/80
                           rounded-md h-8 w-8 p-0 cursor-pointer transition-all
                           focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50">
                ${ICON_EDIT}
                <span class="sr-only">Edit ${book.title}</span>
            </button>
            <button data-delete-book data-book-id="${book.id}"
                    class="inline-flex items-center justify-center border bg-background shadow-xs
                           rounded-md h-8 w-8 p-0 cursor-pointer text-red-500
                           hover:text-red-600 hover:bg-red-50 active:bg-red-100 transition-all
                           focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-400/50">
                ${ICON_DELETE}
                <span class="sr-only">Delete ${book.title}</span>
            </button>
        </div>`;
}

// ── Row builders ──────────────────────────────────────────────────────────────

function desktopRow(book) {
    return `
        <tr class="border-b border-border hover:bg-primary/30 transition-colors select-none books-row-animate"
            data-book-row="${book.id}">
            <!-- Cover thumbnail — dedicated narrow column -->
            <td class="px-4 py-3 flex items-center justify-center w-full">
                ${coverThumbnail(book.coverUrl, book.title, book.id, 'sm')}
            </td>
            <td class="px-6 py-4 text-foreground font-medium">
                <a href="${getContextPath()}/books/${book.id}"
                   class="hover:text-primary hover:underline transition-colors">${book.title}</a>
            </td>
            <td class="px-6 py-4 text-muted-foreground">${authorsRefs(book.authors)}</td>
            <td class="px-6 py-4">
                <span class="px-2 py-1 rounded-full text-xs font-medium bg-primary/10 text-primary truncate">${book.category}</span>
            </td>
            <td class="px-6 py-4 text-right font-semibold text-foreground truncate">${Number(book.price).toFixed(2)} EGP</td>
            <td class="px-6 py-4 text-center truncate">${stockBadge(book.stockQuantity)}</td>
            <td class="px-6 py-4 text-center">${actionButtons(book)}</td>
        </tr>`;
}

function mobileCard(book) {
    const json = JSON.stringify(book).replace(/'/g, '&#39;');
    return `
        <div class="p-4 space-y-3" data-book-card="${book.id}">
            <div class="flex items-start gap-3">
                <!-- Cover thumbnail -->
                ${coverThumbnail(book.coverUrl, book.title, book.id, 'md')}
                <!-- Title + authors + category -->
                <div class="flex-1 min-w-0">
                    <div class="flex items-start justify-between gap-2">
                        <p class="font-semibold text-foreground truncate">
                            <a href="${getContextPath()}/books/${book.id}"
                               class="hover:text-primary hover:underline transition-colors">${book.title}</a>
                        </p>
                        <span class="shrink-0 px-2 py-1 rounded-full text-xs font-medium bg-primary/10 text-primary select-none">${book.category}</span>
                    </div>
                    <p class="text-sm text-muted-foreground mt-0.5">${authorsRefs(book.authors)}</p>
                </div>
            </div>
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <span class="text-sm font-semibold text-foreground">${Number(book.price).toFixed(2)} EGP</span>
                    ${stockBadge(book.stockQuantity)}
                </div>
                <div class="flex items-center gap-2">
                    <button data-edit-book data-book='${json}'
                            class="inline-flex items-center justify-center border bg-background shadow-xs
                                   hover:bg-accent hover:text-accent-foreground active:bg-accent/80
                                   rounded-md h-8 w-8 p-0 cursor-pointer transition-all
                                   focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50">
                        ${ICON_EDIT}
                        <span class="sr-only">Edit ${book.title}</span>
                    </button>
                    <button data-delete-book data-book-id="${book.id}"
                            class="inline-flex items-center justify-center border bg-background shadow-xs
                                   rounded-md h-8 w-8 p-0 cursor-pointer text-red-500
                                   hover:text-red-600 hover:bg-red-50 active:bg-red-100 transition-all
                                   focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-400/50">
                        ${ICON_DELETE}
                        <span class="sr-only">Delete ${book.title}</span>
                    </button>
                </div>
            </div>
        </div>`;
}

// ── Skeleton rows ─────────────────────────────────────────────────────────────

function skeletonDesktopRows() {
    return Array.from({length: SKELETON_ROW_COUNT}, () => `
        <tr class="border-b border-border animate-pulse">
            <td class="px-4 py-3 w-14"><div class="w-9 h-12 bg-muted rounded"></div></td>
            <td class="px-6 py-4"><div class="h-4 bg-muted rounded w-3/4"></div></td>
            <td class="px-6 py-4"><div class="h-4 bg-muted rounded w-1/2"></div></td>
            <td class="px-6 py-4"><div class="h-5 bg-muted rounded-full w-20"></div></td>
            <td class="px-6 py-4"><div class="h-4 bg-muted rounded w-12 ml-auto"></div></td>
            <td class="px-6 py-4"><div class="h-5 bg-muted rounded-full w-16 ml-auto"></div></td>
            <td class="px-6 py-4"><div class="h-8 bg-muted rounded w-16 mx-auto"></div></td>
        </tr>`).join('');
}

function skeletonMobileCards() {
    return Array.from({length: SKELETON_ROW_COUNT}, () => `
        <div class="p-4 space-y-3 animate-pulse border-b border-border">
            <div class="flex items-start gap-3">
                <div class="w-12 h-16 bg-muted rounded shrink-0"></div>
                <div class="flex-1 space-y-2">
                    <div class="flex justify-between gap-2">
                        <div class="h-4 bg-muted rounded w-3/4"></div>
                        <div class="h-5 bg-muted rounded-full w-16 shrink-0"></div>
                    </div>
                    <div class="h-3 bg-muted rounded w-1/2"></div>
                </div>
            </div>
            <div class="flex items-center justify-between">
                <div class="flex gap-3">
                    <div class="h-4 bg-muted rounded w-10"></div>
                    <div class="h-5 bg-muted rounded-full w-16"></div>
                </div>
                <div class="flex gap-2">
                    <div class="h-8 w-8 bg-muted rounded-md"></div>
                    <div class="h-8 w-8 bg-muted rounded-md"></div>
                </div>
            </div>
        </div>`).join('');
}

// ── Empty state ───────────────────────────────────────────────────────────────

function emptyDesktop() {
    return `
        <tr>
            <td colspan="7" class="px-6 py-16 text-center text-muted-foreground">
                <div class="flex flex-col items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="1.5"
                         stroke-linecap="round" stroke-linejoin="round" class="opacity-40" aria-hidden="true">
                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/>
                    </svg>
                    <p class="text-sm">No books found</p>
                </div>
            </td>
        </tr>`;
}

function emptyMobile() {
    return `
        <div class="px-6 py-16 text-center text-muted-foreground">
            <div class="flex flex-col items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"
                     fill="none" stroke="currentColor" stroke-width="1.5"
                     stroke-linecap="round" stroke-linejoin="round" class="opacity-40" aria-hidden="true">
                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/>
                </svg>
                <p class="text-sm">No books found</p>
            </div>
        </div>`;
}

// ── Pagination ────────────────────────────────────────────────────────────────

function paginationHTML(page, totalPages) {
    if (totalPages <= 1) return '';

    const prevDisabled = page === 0;
    const nextDisabled = page >= totalPages - 1;

    const range = [];
    const delta = 2;
    const left  = Math.max(0, page - delta);
    const right = Math.min(totalPages - 1, page + delta);

    for (let i = left; i <= right; i++) range.push(i);

    const pageButtons = range.map(i => `
        <button data-page="${i}"
                class="pagination-page inline-flex items-center justify-center h-8 min-w-8 px-2.5
                       rounded-md text-sm border transition-all cursor-pointer
                       focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary
                       ${i === page
        ? 'bg-primary text-primary-foreground border-primary font-semibold pointer-events-none'
        : 'bg-background border-border text-foreground hover:bg-muted'}">
            ${i + 1}
        </button>`).join('');

    return `
        <div class="flex items-center justify-between px-6 py-4 border-t border-border">
            <p class="text-sm text-muted-foreground select-none">
                Page <span class="font-medium text-foreground">${page + 1}</span> of
                <span class="font-medium text-foreground">${totalPages}</span>
            </p>
            <div class="flex items-center gap-1">
                <button data-page="${page - 1}" ${prevDisabled ? 'disabled' : ''}
                        class="pagination-page inline-flex items-center justify-center h-8 w-8
                               rounded-md border bg-background text-foreground transition-all
                               cursor-pointer hover:bg-muted disabled:opacity-40
                               disabled:pointer-events-none
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    ${ICON_PREV}
                    <span class="sr-only">Previous page</span>
                </button>
                ${pageButtons}
                <button data-page="${page + 1}" ${nextDisabled ? 'disabled' : ''}
                        class="pagination-page inline-flex items-center justify-center h-8 w-8
                               rounded-md border bg-background text-foreground transition-all
                               cursor-pointer hover:bg-muted disabled:opacity-40
                               disabled:pointer-events-none
                               focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary">
                    ${ICON_NEXT}
                    <span class="sr-only">Next page</span>
                </button>
            </div>
        </div>`;
}

// ══════════════════════════════════════════════════════════════════════════════
// BooksTable class
// ══════════════════════════════════════════════════════════════════════════════

export class BooksTable {
    /**
     * @param {Object}   options
     * @param {Function} options.onEdit    — called with a book object when Edit is clicked
     * @param {Function} options.onDelete  — called with bookId when Delete is clicked
     */
    constructor(options = {}) {
        this.options      = options;
        this._currentPage = 0;
        this._pageSize    = 10;
        this._$container  = null;
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    init() {
        this._$container = $('#books-table-container');

        if (!this._$container.length) {
            console.error('BooksTable: #books-table-container not found in DOM.');
            return;
        }

        // Hidden file input — lives outside the table so re-renders don't destroy it
        this._$fileInput = $('<input>', {
            type:   'file',
            accept: 'image/jpeg,image/png,image/webp',
            class:  'sr-only',
            attr:   { 'aria-hidden': 'true', tabindex: '-1' },
        }).appendTo(document.body);

        this._bindEvents();
        this._fetch(0);
    }

    reload() {
        this._fetch(this._currentPage);
    }

    destroy() {
        this._$container?.off('.booksTable');
        this._$container = null;
        this._$fileInput?.remove();
        this._$fileInput = null;
    }

    // ── Fetching ──────────────────────────────────────────────────────────────

    _fetch(page) {
        $.ajax({
            url:      `${getContextPath()}/admin/books`,
            method:   'GET',
            data:     { page, size: this._pageSize },
            dataType: 'json',
        })
            .done((data) => {
                console.log(data);
                this._currentPage = data.page ?? page;
                this._render(data.content ?? [], data.totalPages ?? 1);
            })
            .fail((jqXHR) => {
                console.log(jqXHR.message);
                this._showError(jqXHR.status);
            });
    }

    // ── Rendering ─────────────────────────────────────────────────────────────

    _showSkeleton() {
        this._$container.html(`
            <div class="hidden md:block overflow-x-auto">
                <table class="w-full">
                    <thead>${this._theadHTML()}</thead>
                    <tbody>${skeletonDesktopRows()}</tbody>
                </table>
            </div>
            <div class="md:hidden divide-y divide-border">
                ${skeletonMobileCards()}
            </div>`);
    }

    _render(books, totalPages) {
        if (books.length === 0) {
            this._$container.html(`
                <div class="hidden md:block overflow-x-auto">
                    <table class="w-full">
                        <thead>${this._theadHTML()}</thead>
                        <tbody>${emptyDesktop()}</tbody>
                    </table>
                </div>
                <div class="md:hidden divide-y divide-border">
                    ${emptyMobile()}
                </div>`);
            return;
        }

        const desktopRows = books.map(desktopRow).join('');
        const mobileCards = books.map(mobileCard).join('');
        const pagination  = paginationHTML(this._currentPage, totalPages);

        this._$container.html(`
            <div class="hidden md:block overflow-x-auto">
                <table class="w-full">
                    <thead>${this._theadHTML()}</thead>
                    <tbody>${desktopRows}</tbody>
                </table>
            </div>
            <div class="md:hidden divide-y divide-border">
                ${mobileCards}
            </div>
            ${pagination}`);
    }

    _showError(status) {
        this._$container.html(`
            <div class="px-6 py-16 text-center text-muted-foreground">
                <p class="text-sm">Failed to load books (${status}).
                    <button class="text-primary underline" id="retry-books">Retry</button>
                </p>
            </div>`);

        this._$container.find('#retry-books').one('click', () => this._fetch(this._currentPage));
    }

    _theadHTML() {
        return `
            <tr class="border-b border-border bg-muted/50">
                <th class="px-4 py-4 w-14">Cover</th>
                <th class="text-left px-6 py-4 font-semibold text-foreground">Title</th>
                <th class="text-left px-6 py-4 font-semibold text-foreground">Author</th>
                <th class="text-left px-6 py-4 font-semibold text-foreground">Category</th>
                <th class="text-right px-6 py-4 font-semibold text-foreground">Price</th>
                <th class="text-right px-6 py-4 font-semibold text-foreground">Stock</th>
                <th class="text-center px-6 py-4 font-semibold text-foreground">Actions</th>
            </tr>`;
    }

    // ── Events ────────────────────────────────────────────────────────────────

    _bindEvents() {
        // All events delegated from the container — survives re-renders
        this._$container

            // Edit button
            .on('click.booksTable', '[data-edit-book]', (e) => {
                const book = $(e.currentTarget).data('book');
                this.options.onEdit?.(book);
            })

            // Delete button
            .on('click.booksTable', '[data-delete-book]', (e) => {
                const bookId = $(e.currentTarget).data('book-id');
                this.options.onDelete?.(bookId);
            })

            // Cover update
            .on('click.booksTable', '[data-upload-cover]', (e) => {
                const bookId = $(e.currentTarget).data('book-id');
                // Re-wire the file input for this specific book before opening
                this._$fileInput
                    .off('change.coverUpload')
                    .val('')   // reset so choosing the same file still fires 'change'
                    .on('change.coverUpload', () => {
                        const file = this._$fileInput[0].files?.[0];
                        if (file) this._uploadCover(bookId, file);
                    })
                    .trigger('click');
            })

            // Pagination
            .on('click.booksTable', '.pagination-page:not([disabled])', (e) => {
                const page = parseInt($(e.currentTarget).data('page'), 10);
                if (!isNaN(page)) this._fetch(page);
            });
    }

    // ── Cover upload ──────────────────────────────────────────────────────────

    /**
     * Sends the new cover image to the server and swaps the thumbnail in-place
     * on success without re-fetching the whole page.
     *
     * PUT /admin/books/{id}/cover
     * Body:  multipart/form-data  { image: File }
     * Response JSON: { coverUrl: string }
     *
     * @param {number} bookId
     * @param {File}   file
     */
    _uploadCover(bookId, file) {
        const formData = new FormData();
        formData.append('image', file);
        formData.append('bookId', String(bookId));

        // Mark every thumbnail for this book as uploading
        const $btns = this._$container.find(`[data-upload-cover][data-book-id="${bookId}"]`);
        $btns.prop('disabled', true).addClass('opacity-50 pointer-events-none');

        $.ajax({
            url:         `${getContextPath()}/admin/book/update/cover`,
            method:      'PUT',
            data:        formData,
            contentType: false,
            processData: false,
            dataType:    'json',
        })
        .done((response) => {
            const newUrl = response?.coverUrl;

            console.log(newUrl);

            // Swap every matching thumbnail (desktop + mobile) in-place
            $btns.each(function () {
                const $btn = $(this);
                // Remove existing image or placeholder SVG (everything that isn't the overlay span)
                $btn.find('> img, > svg').remove();
                const $img = $('<img>', {
                    src:    `${getContextPath()}/${newUrl}`,
                    alt:    $btn.attr('aria-label')?.replace('Change cover image for ', '') ?? '',
                    loading: 'lazy',
                    class:  'w-full h-full object-cover',
                });
                // Prepend before the overlay span
                $btn.prepend($img);
            });

            showFeedbackMessage('Cover updated successfully.', true);
        })
        .fail((jqXHR) => {
            let msg = 'Failed to update cover. Please try again.';
            try {
                const body = JSON.parse(jqXHR.responseText);
                if (body?.error) msg = body.error;
            } catch (_) { /* not JSON */ }
            showFeedbackMessage(msg, false);
        })
        .always(() => {
            $btns.prop('disabled', false).removeClass('opacity-50 pointer-events-none');
        });
    }
}