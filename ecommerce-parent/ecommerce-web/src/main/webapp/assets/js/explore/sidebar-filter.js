import {getContextPath} from "../util.js";
import {showFeedbackMessage} from "../common/book-card.js";

let isCategoriesOpen = false;
let isSortOpen = false;
let searchDebounceId = null;

const categoriesMapping = {
    all: "All Books",
};

const sortCriteriaMapping = {
    featured: "Featured",
    "price-low-to-high": "Price: Low to High",
    "price-high-to-low": "Price: High to Low",
    rating: "Top Rated"
};

function getMinPrice() { return parseFloat($("#min-price-input").val()) || 0; }
function getMaxPrice() { return parseFloat($("#max-price-input").val()) || 999999; }

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
    const query     = $("#search-input").val().trim() || "";
    const category  = $("#selected-category").data("selectedCategoryValue") || "all";
    const minPrice  = $("#min-price-input").val() || 0;
    const maxPrice  = $("#max-price-input").val() || 999999;
    const sort      = $("#selected-sort-criteria").data("selectedSortCriteria") || "featured";

    return {
        query,
        category,
        minPrice,
        maxPrice,
        sort
    };
}

function applyFilters(nextState) {
    console.log("Submitting: " + JSON.stringify(getCurrentState()));

    $.ajax({
        url: `${getContextPath()}/explore`,
        method: "POST",
        data: nextState
    })
    .done(content => {
        $("#filter-books-container").html(content);
    })
    .fail(jqXHR => {
        console.error(jqXHR.message);
    });
}

function bindSearchInput() {
    const $searchInput = $("#search-input");

    if ($searchInput.length === 0) {
        return;
    }

    $searchInput.on("input", function () {
        clearTimeout(searchDebounceId);

        searchDebounceId = setTimeout(() => {
            // applyFilters(getCurrentState());
        }, 350);
    });
}

function setSelectedSortCriteria(sortCriteria) {
    const $selectedSortCriteria = $("#selected-sort-criteria");
    const previousSortCriteria = $selectedSortCriteria.data("selectedSortCriteria") || "featured";

    $(`[data-criteria="${previousSortCriteria}"]`)
        .addClass("hover:bg-primary/5 active:bg-primary/10 text-foreground")
        .removeClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold");

    $(`[data-criteria="${sortCriteria}"]`)
        .addClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold")
        .removeClass("hover:bg-primary/5 active:bg-primary/10 text-foreground");

    $selectedSortCriteria
        .data("selectedSortCriteria", sortCriteria)
        .text(sortCriteriaMapping[sortCriteria] || "Featured");
}

function setSelectedCategory(categoryId) {
    const $selectedCategory = $("#selected-category");
    const previousId = $selectedCategory.data("selectedCategoryValue") || "all";

    $(`[data-category="${previousId}"]`)
        .addClass("hover:bg-primary/5 active:bg-primary/10 text-foreground")
        .removeClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold");

    $(`[data-category="${categoryId}"]`)
        .addClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold")
        .removeClass("hover:bg-primary/5 active:bg-primary/10 text-foreground");

    $selectedCategory
        .data("selectedCategoryValue", categoryId)
        .text(categoriesMapping[categoryId] || "All Books");

    $("#grid-selected-category").text(categoriesMapping[categoryId] || "All Books");
}

function makeCategoryButton(id, label, isSelected) {
    const activeClasses   = "bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold";
    const inactiveClasses = "hover:bg-primary/5 active:bg-primary/10 text-foreground";

    if (isSelected) {

    }

    return $("<button>")
        .addClass("category-btn w-full text-left px-3 py-2 rounded-md transition-all duration-200 truncate cursor-pointer")
        .addClass(isSelected ? activeClasses : inactiveClasses)
        .attr("data-category", id)
        .text(label);
}

function bindCategoryButtons($buttonsList) {
    $buttonsList.find(".category-btn").on("click", function () {
        const nextCategory    = $(this).data("category");
        const currentCategory = $("#selected-category").data("selectedCategoryValue");

        if (currentCategory === nextCategory) return;

        setSelectedCategory(nextCategory);
        // applyFilters(getCurrentState());
    });
}

async function loadCategories() {
    const $list      = $("#categories-list");
    const currentId  = $("#selected-category").data("selectedCategoryValue") || "all";

    $.getJSON(`${getContextPath()}/explore/categories?json=true`)
        .done(categories => {
            setTimeout(() => {
                categories.forEach(({ id, name }) => {
                    categoriesMapping[id] = name;
                });

                console.log(categories);

                $("#selected-category").text(categoriesMapping[currentId]);

                $list.empty();
                $list.append(makeCategoryButton("all", "All Books", currentId === "all"));

                categories.forEach(({ id, name }) => {
                    $list.append(makeCategoryButton(id, name, String(currentId) === String(id)));
                });

                bindCategoryButtons($list);
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

function bindPriceRange() {
    const $minInput  = $("#min-price-input");
    const $maxInput  = $("#max-price-input");
    const $minLabel  = $("#min-price");
    const $maxLabel  = $("#max-price");

    $minInput.on("input", function () {
        $minLabel.text($(this).val() || "0");
        validate();
    });

    $maxInput.on("input", function () {
        $maxLabel.text($(this).val() || "999999");
        validate();
    });
}

function bindSortButtons(container) {
    $(container).find(".sort-btn").on("click", function () {
        const nextSortCriteria = $(this).data("criteria");

        const currentCriteria = $("#selected-sort-criteria").data("selectedSortCriteria");

        if (currentCriteria === nextSortCriteria) {
            return;
        }

        setSelectedSortCriteria(nextSortCriteria);
        // applyFilters(getCurrentState());
    });
}

function bindExpanders() {
    $("#categories-controller").on("click", function () {
        isCategoriesOpen = !isCategoriesOpen;

        $("#selected-category")
            .parent()
            .toggleClass("max-h-12 opacity-100", !isCategoriesOpen)
            .toggleClass("max-h-0 opacity-0", isCategoriesOpen);

        $("#category-chevron-down")
            .toggleClass("rotate-180", isCategoriesOpen);

        $("#categories-container")
            .toggleClass("max-h-96 opacity-100", isCategoriesOpen)
            .toggleClass("max-h-0 opacity-0", !isCategoriesOpen);
    });

    $("#sort-controller").on("click", function () {
        isSortOpen = !isSortOpen;

        $("#selected-sort-criteria")
            .parent()
            .toggleClass("max-h-12 opacity-100", !isSortOpen)
            .toggleClass("max-h-0 opacity-0", isSortOpen);

        $("#sort-chevron-down")
            .toggleClass("rotate-180", isSortOpen);

        $("#sort-container")
            .toggleClass("max-h-48 opacity-100", isSortOpen)
            .toggleClass("max-h-0 opacity-0", !isSortOpen);
    });
}

function bindFilterSubmit() {
    $("#filter-submit").on("click", function () {
        if (validate()) {
            applyFilters(getCurrentState());
        } else {
            showFeedbackMessage("Please provide valid values for filtering", false);
        }
    });
}

export function initSidebarFilter() {
    const container = document.getElementById("sidebar-filter");

    if (!container) {
        return;
    }

    bindSearchInput();
    loadCategories();
    bindPriceRange();
    bindSortButtons(container);
    bindExpanders();
    bindFilterSubmit();
}
