import {getContextPath} from "../util.js";

const LAYOUT_CLASSES = {
    1: { grid: 'grid-cols-1',                               placeholder: '' },
    2: { grid: 'grid-cols-1 md:grid-cols-2',                placeholder: 'md:col-span-2' },
    3: { grid: 'grid-cols-1 md:grid-cols-2 xl:grid-cols-3', placeholder: 'md:col-span-2 xl:col-span-3' },
};

const STORAGE_KEY       = 'bookGridLayout';

export class FilterBooksContainer {

    constructor(options = {}) {
        this.options = options;
        this._pageSize = 12;
        this._$container = null;
        this._layout = parseInt(localStorage.getItem(STORAGE_KEY) || '1', 10);
    }

    init() {
        this._$container = $("#filter-books-container");

        if (!this._$container.length) {
            console.error('FilterBooksContainer: #filter-books-container not found in DOM.');
            return;
        }

        this._bindEvents();
        this._updateToggleButtons();
        this._applyLayoutToGrid();
    }

    filter(page, filterOptions) {
        this._fetch(page, filterOptions);
    }

    // ── Layout ────────────────────────────────────────────────────────────────

    _setLayout(n) {
        if (!LAYOUT_CLASSES[n]) return;
        // Clamp to the max layout actually visible at the current breakpoint.
        // btn-3 is xl-only, btn-2 is md+; below md the grid is always 1 col.
        const maxLayout = window.matchMedia('(min-width: 1280px)').matches ? 3
            : window.matchMedia('(min-width: 768px)').matches  ? 2
                : 1;
        this._layout = Math.min(n, maxLayout);
        localStorage.setItem(STORAGE_KEY, String(this._layout));
        this._fadeGrid(() => this._applyLayoutToGrid());
        this._updateToggleButtons();
    }

    _applyLayoutToGrid() {
        const { grid, placeholder } = LAYOUT_CLASSES[this._layout];

        const $grid = this._$container.find('#explore-books-grid');
        if ($grid.length) {
            $grid[0].className = `grid gap-6 ${grid}`;
        }

        const $placeholder = this._$container.find('#no-books-placeholder');
        if ($placeholder.length) {
            $placeholder[0].className = $placeholder[0].className
                .replace(/md:col-span-\d+|xl:col-span-\d+/g, '')
                .trim();
            if (placeholder) $placeholder.addClass(placeholder);
        }
    }

    _updateToggleButtons() {
        [1, 2, 3].forEach((i) => {
            const $btn = $(`#grid-btn-${i}`);
            if (!$btn.length) return;
            const isActive = i === this._layout;
            $btn.toggleClass('border-primary bg-primary hover:bg-primary/90', isActive)
                .toggleClass('border-border/60 bg-transparent hover:bg-muted', !isActive);
            $btn.find('svg')
                .toggleClass('text-primary-foreground', isActive)
                .toggleClass('text-muted-foreground', !isActive);
        });
    }

    // ── Transitions ───────────────────────────────────────────────────────────

    /**
     * Fades the current grid out, runs `callback` (which mutates the DOM),
     * then fades back in. Used for layout switches where the container stays.
     */
    _fadeGrid(callback) {
        const $grid = this._$container.find('#explore-books-grid');
        $grid.css({ transition: 'opacity 150ms ease, transform 150ms ease', opacity: 0, transform: 'translateY(4px)' });
        setTimeout(() => {
            callback();
            const $next = this._$container.find('#explore-books-grid');
            $next.css({ opacity: 0, transform: 'translateY(4px)' });
            requestAnimationFrame(() => {
                $next.css({ transition: 'opacity 200ms ease, transform 200ms ease', opacity: 1, transform: 'translateY(0)' });
            });
        }, 150);
    }

    /** Fades the whole container out. Returns a Promise that resolves when done. */
    _fadeOut() {
        return new Promise((resolve) => {
            this._$container.css({ transition: 'opacity 150ms ease', opacity: 0 });
            setTimeout(resolve, 150);
        });
    }

    /** Fades the whole container back in. */
    _fadeIn() {
        this._$container.css({ opacity: 0, transform: 'translateY(6px)', transition: 'none' });
        requestAnimationFrame(() => {
            this._$container.css({ transition: 'opacity 250ms ease, transform 250ms ease', opacity: 1, transform: 'translateY(0)' });
        });
    }

    // ── Skeleton ──────────────────────────────────────────────────────────────

    _showSkeleton() {
        const { grid } = LAYOUT_CLASSES[this._layout];

        let gridItems = '';
        for (let i = 0; i < this._pageSize; i++) {
            gridItems += `
                <div class="bg-card rounded-xl border border-border flex flex-row w-full overflow-hidden">
                    <div class="w-24 sm:w-28 bg-primary/30 shrink-0 min-h-30"></div>
                    <div class="p-3 sm:p-4 flex flex-col flex-1">
                        <div class="flex-1">
                            <div class="h-5 w-3/4 bg-muted rounded mb-2"></div>
                            <div class="h-4 w-1/2 bg-muted rounded mb-3"></div>
                            <div class="flex gap-1 mb-3">
                                ${Array(5).fill('<div class="h-3 w-3 bg-accent/50 rounded-full"></div>').join('')}
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

        const footer = `
            <div class="flex items-center justify-center gap-2 mt-8">
                <div class="h-8 w-10 bg-muted rounded-md border border-border/50"></div>
                <div class="h-8 w-10 bg-muted rounded-md"></div>
                <div class="h-8 w-10 bg-muted rounded-md border border-border/50"></div>
            </div>`;

        this._$container.html(`
            <div class="animate-pulse">
                <div class="grid gap-6 ${grid}">${gridItems}</div>
                ${footer}
            </div>`);
    }

    // ── Fetch ─────────────────────────────────────────────────────────────────

    _fetch(page, filterOptions = {}) {
        this._fadeOut().then(() => {
            this._showSkeleton();
            this._fadeIn();
        });

        $.ajax({
            url: `${getContextPath()}/explore`,
            method: "POST",
            data: { ...filterOptions, page, size: this._pageSize },
            dataType: "html",
            beforeSend: (jqXHR) => {
                $("#grid-results-count").empty();
            }
        })
        .done((content) => {
            setTimeout(() => {
                this._fadeOut().then(() => {
                    this._$container.html(content);
                    this._applyLayoutToGrid();
                    this._fadeIn();

                    // Update the result count in the static header
                    const total = parseInt(
                        this._$container
                            .find('#explore-books-grid, #no-books-placeholder')
                            .closest('[data-total-elements]')
                            .data('total-elements') || 0,
                        10
                    );
                    if (total >= 0) {
                        $('#grid-results-count').text(`(${total} ${total === 1 ? 'Result' : 'Results'})`);
                    }
                });
            }, 1500);
        })
        .fail((jqXHR) => {
            console.error('FilterBooksContainer fetch failed:', jqXHR.statusText);
        });
    }

    // ── Events ────────────────────────────────────────────────────────────────

    _bindEvents() {
        // Toggle buttons are now static DOM — bind directly, no delegation needed.
        $('#grid-btn-1').on('click.filterBooks', () => this._setLayout(1));
        $('#grid-btn-2').on('click.filterBooks', () => this._setLayout(2));
        $('#grid-btn-3').on('click.filterBooks', () => this._setLayout(3));

        // Pagination is still inside the dynamic container — keep delegated.
        this._$container.on('click.filterBooks', '.pagination-page:not([disabled])', (e) => {
            const page = parseInt($(e.currentTarget).data('page'), 10);
            if (!isNaN(page)) this._fetch(page);
        });
    }
}