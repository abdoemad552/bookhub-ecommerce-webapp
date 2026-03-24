import {getContextPath} from "../util.js";
import {getCurrentState} from "./sidebar-filter.js";

const ICON_PREV = `
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-left w-4 h-4" aria-hidden="true">
        <path d="m15 18-6-6 6-6"></path>
    </svg>`;

const ICON_NEXT = `
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-chevron-right w-4 h-4" aria-hidden="true">
        <path d="m9 18 6-6-6-6"></path>
    </svg>`;

function paginationHTML(page, totalPages) {
    if (totalPages <= 1) return '';

    const prevDisabled = page === 0;
    const nextDisabled = page >= totalPages - 1;

    // Build page number buttons — show at most 5 around current page
    const range   = [];
    const delta   = 2;
    const left    = Math.max(0, page - delta);
    const right   = Math.min(totalPages - 1, page + delta);

    for (let i = left; i <= right; i++) range.push(i);

    const pageButtons = range.map(i => `
        <button data-page="${i}" class="pagination-page inline-flex items-center justify-center h-8 min-w-8 px-2.5 rounded-md text-sm border transition-all cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary ${i === page ? 'bg-primary text-primary-foreground border-primary font-semibold pointer-events-none' : 'bg-background border-border text-foreground hover:bg-muted'}">
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

export class FilterBooksContainer {

    constructor(options = {}) {
        this.options = options;
        this._currentPage = 0;
        this._pageSize = 12;
        this._$container = null;
    }

    init() {
        this._$container = $("#filter-books-container");

        if (!this._$container.length) {
            console.error('BooksTable: #filter-books-container not found in DOM.');
            return;
        }

        this._bindEvents();
        this._fetch(0);
    }

    _fetch(page) {
        this._showSkeleton();

        const filterOptions = getCurrentState();
        $.ajax({
            url: `${getContextPath()}/explore`,
            method: "GET",
            data: { ...filterOptions, page, size: this._pageSize },
            dataType: "html"
        })
        .done((books) => {

        })
        .fail(jaXHR => {
            console.log(jqXHR.message);
        });
    }

    _showSkeleton() {
        // Header section
        const header = `
        <div class="flex flex-col md:flex-row md:justify-between md:items-center gap-4 mb-6">
            <div>
                <div class="h-8 w-48 bg-muted rounded-md mb-2"></div>
                <div class="h-4 w-32 bg-muted rounded-md"></div>
            </div>
                <div class="h-10 w-10 bg-muted rounded-lg"></div>
            </div>`;

        // Grid items
        let gridItems = '';
        for (let i = 0; i < this._pageSize; i++) {
            gridItems += `
            <div class="bg-card rounded-xl border border-border flex flex-row w-full h-full overflow-hidden">
                <div class="w-24 sm:w-28 md:w-32 bg-primary/30 shrink-0"></div>
                <div class="p-3 md:p-4 flex flex-col flex-1">
                    <div class="flex-1">
                        <div class="h-5 w-3/4 bg-muted rounded mb-2"></div>
                        <div class="h-4 w-1/2 bg-muted rounded mb-3"></div>
                        <div class="flex gap-1 mb-3">
                            <div class="h-3 w-3 bg-accent/50 rounded-full"></div>
                            <div class="h-3 w-3 bg-accent/50 rounded-full"></div>
                            <div class="h-3 w-3 bg-accent/50 rounded-full"></div>
                            <div class="h-3 w-3 bg-accent/50 rounded-full"></div>
                            <div class="h-3 w-3 bg-accent/50 rounded-full"></div>
                        </div>
                        <div class="space-y-2">
                            <div class="h-3 w-full bg-muted rounded"></div>
                            <div class="h-3 w-4/5 bg-muted rounded"></div>
                        </div>
                    </div>
                    <div class="flex items-center justify-between pt-3 border-t border-border/50 mt-3">
                        <div class="h-5 w-16 bg-primary/30 rounded"></div>
                        <div class="h-8 w-10 bg-primary/30 rounded-md"></div>
                    </div>
                </div>
            </div>`;
        }

        const grid = `
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 gap-6">
                ${gridItems}
            </div>`;

        // Pagination / bottom section
        const footer = `
            <div class="flex items-center justify-center gap-2 mt-8">
                <div class="h-8 w-10 bg-muted rounded-md border border-border/50"></div>
                <div class="h-8 w-10 bg-muted rounded-md"></div>
                <div class="h-8 w-10 bg-muted rounded-md border border-border/50"></div>
            </div>`;

        const skeleton = `<div class="lg:col-span-3 animate-pulse">${header}${grid}${footer}</div>`;

        // Inject into container
        this._$container.html(skeleton);
    }

    _bindEvents() {
        this._$container
            // Pagination
            .on('click.filterBooks', '.pagination-page:not([disabled])', (e) => {
                const page = parseInt($(e.currentTarget).data('page'), 10);
                if (!isNaN(page)) {
                    this._fetch(page);
                }
            });
    }
}

