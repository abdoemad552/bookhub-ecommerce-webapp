let isCategoriesOpen = false;
let isSortOpen = false;
let searchDebounceId = null;

const categoriesMapping = {
    all: "All Books",
    fiction: "Fiction",
    "science-fiction": "Science Fiction",
    fantasy: "Fantasy",
    "self-help": "Self-Help",
    "non-fiction": "Non-Fiction",
    biography: "Biography"
};

const sortCriteriaMapping = {
    featured: "Featured",
    "price-low-to-high": "Price: Low to High",
    "price-high-to-low": "Price: High to Low",
    rating: "Top Rated"
};

function getCurrentState() {
    const selectedCategory = document.getElementById("selected-category")?.dataset.selectedCategoryValue || "all";
    const selectedSortCriteria = document.getElementById("selected-sort-criteria")?.dataset.selectedSortCriteria || "featured";
    const searchInput = document.getElementById("search-input");
    const priceRangeInput = document.querySelector("#sidebar-filter .range-input");

    return {
        searchQuery: searchInput?.value?.trim() || "",
        selectedCategory,
        selectedSortCriteria,
        selectedMaxPrice: priceRangeInput?.value || "50"
    };
}

function applyFilters(nextState) {
    const url = new URL(window.location.href);

    if (nextState.selectedCategory && nextState.selectedCategory !== "all") {
        const categoryButton = document.querySelector(`[data-category="${nextState.selectedCategory}"]`);
        url.searchParams.set("category", categoryButton?.dataset.categoryValue || categoriesMapping[nextState.selectedCategory]);
    } else {
        url.searchParams.delete("category");
    }

    if (nextState.searchQuery) {
        url.searchParams.set("query", nextState.searchQuery);
    } else {
        url.searchParams.delete("query");
    }

    if (nextState.selectedMaxPrice) {
        url.searchParams.set("maxPrice", nextState.selectedMaxPrice);
    } else {
        url.searchParams.delete("maxPrice");
    }

    if (nextState.selectedSortCriteria && nextState.selectedSortCriteria !== "featured") {
        url.searchParams.set("sort", nextState.selectedSortCriteria);
    } else {
        url.searchParams.delete("sort");
    }

    url.searchParams.delete("page");
    window.location.assign(url.toString());
}

function setSelectedCategory(categorySlug) {
    const previousCategorySlug = document.getElementById("selected-category")?.dataset.selectedCategoryValue || "all";

    $(`[data-category="${previousCategorySlug}"]`)
        .addClass("hover:bg-primary/5 active:bg-primary/10 text-foreground")
        .removeClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold");

    $(`[data-category="${categorySlug}"]`)
        .addClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold")
        .removeClass("hover:bg-primary/5 active:bg-primary/10 text-foreground");

    const selectedCategory = document.getElementById("selected-category");
    if (selectedCategory) {
        selectedCategory.dataset.selectedCategoryValue = categorySlug;
        selectedCategory.textContent = categoriesMapping[categorySlug] || "All Books";
    }

    const gridSelectedCategory = document.getElementById("grid-selected-category");
    if (gridSelectedCategory) {
        gridSelectedCategory.textContent = categoriesMapping[categorySlug] || "All Books";
    }
}

function setSelectedSortCriteria(sortCriteria) {
    const previousSortCriteria = document.getElementById("selected-sort-criteria")?.dataset.selectedSortCriteria || "featured";

    $(`[data-criteria="${previousSortCriteria}"]`)
        .addClass("hover:bg-primary/5 active:bg-primary/10 text-foreground")
        .removeClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold");

    $(`[data-criteria="${sortCriteria}"]`)
        .addClass("bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold")
        .removeClass("hover:bg-primary/5 active:bg-primary/10 text-foreground");

    const selectedSortCriteria = document.getElementById("selected-sort-criteria");
    if (selectedSortCriteria) {
        selectedSortCriteria.dataset.selectedSortCriteria = sortCriteria;
        selectedSortCriteria.textContent = sortCriteriaMapping[sortCriteria] || "Featured";
    }
}

function bindSearchInput() {
    const searchInput = document.getElementById("search-input");

    if (!searchInput) {
        return;
    }

    searchInput.addEventListener("input", function () {
        clearTimeout(searchDebounceId);
        searchDebounceId = setTimeout(() => {
            applyFilters(getCurrentState());
        }, 350);
    });
}

function bindCategoryButtons(container) {
    container.querySelectorAll(".category-btn")
        .forEach((categoryButton) => {
            categoryButton.addEventListener("click", function () {
                const nextCategory = this.dataset.category;

                if (document.getElementById("selected-category")?.dataset.selectedCategoryValue === nextCategory) {
                    return;
                }

                setSelectedCategory(nextCategory);
                applyFilters(getCurrentState());
            });
        });
}

function bindPriceRange(container) {
    const rangeInput = container.querySelector(".range-input");

    if (!rangeInput) {
        return;
    }

    rangeInput.addEventListener("input", function () {
        document.getElementById("selected-price-range").textContent = this.value;
    });

    rangeInput.addEventListener("change", function () {
        applyFilters(getCurrentState());
    });
}

function bindSortButtons(container) {
    container.querySelectorAll(".sort-btn")
        .forEach((sortButton) => {
            sortButton.addEventListener("click", function () {
                const nextSortCriteria = this.dataset.criteria;

                if (document.getElementById("selected-sort-criteria")?.dataset.selectedSortCriteria === nextSortCriteria) {
                    return;
                }

                setSelectedSortCriteria(nextSortCriteria);
                applyFilters(getCurrentState());
            });
        });
}

function bindExpanders() {
    document.getElementById("categories-controller")
        ?.addEventListener("click", function () {
            isCategoriesOpen = !isCategoriesOpen;

            $("#selected-category")
                .parent()
                .toggleClass("max-h-12 opacity-100", !isCategoriesOpen)
                .toggleClass("max-h-0 opacity-0", isCategoriesOpen);

            $("#categories-container")
                .toggleClass("max-h-96 opacity-100", isCategoriesOpen)
                .toggleClass("max-h-0 opacity-0", !isCategoriesOpen);
        });

    document.getElementById("sort-controller")
        ?.addEventListener("click", function () {
            isSortOpen = !isSortOpen;

            $("#selected-sort-criteria")
                .parent()
                .toggleClass("max-h-12 opacity-100", !isSortOpen)
                .toggleClass("max-h-0 opacity-0", isSortOpen);

            $("#sort-container")
                .toggleClass("max-h-48 opacity-100", isSortOpen)
                .toggleClass("max-h-0 opacity-0", !isSortOpen);
        });
}

export function initSidebarFilter() {
    const container = document.getElementById("sidebar-filter");

    if (!container) {
        return;
    }

    bindSearchInput();
    bindCategoryButtons(container);
    bindPriceRange(container);
    bindSortButtons(container);
    bindExpanders();
}
