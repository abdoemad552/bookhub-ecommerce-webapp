import {Dialog} from "./dialog.js";
import {getContextPath} from "../util.js";

const CLOSE_DELAY   = 1800;  // ms to wait after success before closing
const MESSAGE_DELAY = 3500;  // ms before error message fades out

const categoriesMapping = {
    all: "All Books",
};

const sortCriteriaMapping = {
    featured: "Featured",
    "price-low-to-high": "Price: Low to High",
    "price-high-to-low": "Price: High to Low",
    rating: "Top Rated"
};

let isSortOpen = false;

function getMinPrice() { return parseFloat($("#min-price-input").val()); }
function getMaxPrice() { return parseFloat($("#max-price-input").val()); }

function validate() {
    const $minInput  = $("#min-price-input");
    const $maxInput  = $("#max-price-input");
    const $error     = $("#price-range-error");
    const isValid    = getMinPrice() <= getMaxPrice();

    if (!isValid) {
        $error.removeClass("hidden");
        requestAnimationFrame(() => {
            $error.removeClass("opacity-0 scale-95");
        });
    } else {
        $error.addClass("hidden");
        requestAnimationFrame(() => {
            $error.addClass("opacity-0 scale-95");
        });
    }
    $minInput
        .toggleClass("border-destructive ring-destructive focus:ring-destructive", !isValid)
        .toggleClass("border-border", isValid);
    $maxInput
        .toggleClass("border-destructive ring-destructive focus:ring-destructive", !isValid)
        .toggleClass("border-border", isValid);

    return isValid;
}

export function getCurrentState() {
    const query      = $("#search-input").val().trim() || "";
    const category   = $("#categories-list")
        .find(".selected-category")
        .map(function () { return $(this).data("category") })
        .get();
    const minPrice   = $("#min-price-input").val() || 0;
    const maxPrice   = $("#max-price-input").val() || 999999;
    const sort       = $("#sort-container").data("selectedSortCriteria") || "featured";

    return {
        query,
        category,
        minPrice,
        maxPrice,
        sort
    };
}

function setSelectedSortCriteria(previousSortCriteria, nextSortCriteria) {

    console.log(previousSortCriteria, nextSortCriteria);

    $(`[data-criteria="${previousSortCriteria}"]`)
        .addClass("border-borderbg-card hover:border-accent/50")
        .removeClass("border-accent bg-accent/10");

    $(`[data-criteria="${nextSortCriteria}"]`)
        .addClass("border-accent bg-accent/10")
        .removeClass("border-border bg-card hover:border-accent/50");
}


function makeCategoryButton(id, label, isSelected) {
    const activeClasses   = "border-accent bg-accent/10";
    const inactiveClasses = "border-border bg-card hover:border-accent/50";

    return $("<button>")
        .addClass("category-btn px-2.5 py-1 rounded-full text-[13px] sm:text-xs font-medium sm:text-sm transition-colors duration-200 border-2 text-foreground cursor-pointer")
        .addClass(isSelected ? activeClasses : inactiveClasses)
        .attr("data-category", id)
        .text(label);
}

export class FilterBooksDialog {

    constructor(options = {}) {
        this.options        = options;
        this._dialog        = null;

        this._bindPriceRange();
        this._bindSortButtons();
        this._loadAndBindCategories();
        this._bindDragHandle();
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    init() {
        this._dialog = new Dialog('#books-filter-dialog');

        const $dialog = $('#books-filter-dialog');

        $dialog.on('click.filterBooks', '#submit-btn', () => this._submit());
        $(document).on('click.filterBooks', '#open-books-filter-modal-btn', () => this._dialog.open());
    }

    destroy() {
        const $dialog = $('#books-filter-dialog');
        $dialog.off('click.filterBooks');
        $(document).off('click.filterBooks');
        this._dialog = null;
    }

    // ── Submit ────────────────────────────────────────────────────────────────

    _submit() {
        const page = 1;
        const filterOptions = getCurrentState();
        this.options.onSubmit?.(page, filterOptions);
        this._dialog.close();
    }

    _loadAndBindCategories() {
        const $list = $("#categories-list");

        $.getJSON(`${getContextPath()}/explore/categories?json=true`)
            .done(categories => {
                setTimeout(() => {
                    categories.forEach(({ id, name }) => {
                        categoriesMapping[id] = name;
                    });

                    console.log(categories);

                    $list.empty();

                    categories.forEach(({ id, name }) => {
                        $list.append(makeCategoryButton(id, name, false));
                    });

                    this._bindCategoryButtons($list);
                }, 2000);
            })
            .fail(error => {
                console.error("Failed to load categories:", error);

                $list.html(`
                <div class="px-3 py-2 text-sm text-destructive">
                    Failed to load categories.
                </div>
            `);
            });
    }

    _bindPriceRange() {
        const $minInput  = $("#min-price-input");
        const $maxInput  = $("#max-price-input");

        $minInput.on("input", function () {
            const newValue = parseFloat($(this).val());
            console.log(newValue);
            if (isNaN(newValue)) {
                $(this).val(0);
            } else {
                $(this).val(newValue);
            }
            validate();
        });
        $maxInput.on("input", function () {
            const newValue = parseFloat($(this).val());
            console.log(newValue);
            if (isNaN(newValue)) {
                $(this).val(0);
            } else {
                $(this).val(newValue);
            }
            validate();
        });
    }

    _bindSortButtons(container) {
        $("#sort-container").find(".sort-btn").on("click", function () {
            const $sortContainer = $("#sort-container");

            const nextSortCriteria = $(this).data("criteria");
            const previousCriteria = $sortContainer.data("selectedSortCriteria");

            if (previousCriteria === nextSortCriteria) {
                return;
            }

            setSelectedSortCriteria(previousCriteria, nextSortCriteria);

            $sortContainer.data("selectedSortCriteria", nextSortCriteria);

            // applyFilters(getCurrentState());
        });
    }

    _bindCategoryButtons($buttonsList) {
        $buttonsList.find(".category-btn").on("click", function () {
            const $this = $(this);

            $this.toggleClass("selected-category");

            console.log($this.hasClass("selected-category"));

            $this
                .toggleClass("border-accent bg-accent/10", $this.hasClass("selected-category"))
                .toggleClass("border-border bg-card hover:border-accent/50", !$this.hasClass("selected-category"));

            // applyFilters(getCurrentState());
        });

        $('#category-search').on('input', function () {
            const query = $(this).val().toLowerCase().trim();

            $buttonsList.find('.category-btn').each(function () {
                const $btn = $(this);
                const text = $btn.text().toLowerCase();

                const match = text.includes(query);

                $btn.toggleClass('hidden', !match);
            });
        });
    }

    _bindDragHandle() {
        const $dialog = $('#books-filter-dialog');
        const $handle = $dialog.find('.dialog-drag-handle').first();

        let startY     = 0;
        let currentY   = 0;
        let isDragging = false;

        const onDragMove = (e) => {
            if (!isDragging) return;
            const y = e.touches ? e.touches[0].clientY : e.clientY;
            currentY = Math.max(0, y - startY);
            $dialog.css('transform', `translateY(${currentY}px)`);
        };

        const onDragEnd = () => {
            if (!isDragging) return;
            isDragging = false;

            $(document)
                .off('mousemove.drag touchmove.drag')
                .off('mouseup.drag touchend.drag');

            $dialog.css('transition', '');
            $dialog.css('transform', '');

            if (currentY > 120) {
                this._dialog.close();
            }
        };

        $handle.on('mousedown.drag touchstart.drag', (e) => {
            isDragging = true;
            startY     = e.touches ? e.touches[0].clientY : e.clientY;
            currentY   = 0;

            $dialog.css('transition', 'none');

            $(document)
                .on('mousemove.drag touchmove.drag', onDragMove)
                .on('mouseup.drag touchend.drag',    onDragEnd);
        });
    }
}
