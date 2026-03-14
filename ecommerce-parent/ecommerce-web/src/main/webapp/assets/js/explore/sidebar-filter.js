
let books = null;

let isCategoriesOpen = false;
let isSortOpen = false;

let searchQuery;
let selectedCategory;
let priceRange;
let sortCriteria;

const categoriesMapping = {
    "all":              "All Books",
    "fiction":          "Fiction",
    "science-fiction":  "Science Fiction",
    "fantasy":          "Fantasy",
    "self-help":        "Self-Help",
    "non-fiction":      "Non-Fiction",
    "biography":        "Biography"
};

const sortCriteriaMapping = {
    "featured":     "Featured",
    "price-low":    "Price Low",
    "price-high":   "Price High",
    "rating":       "Rating"
};

function handleSearchQueryChange() {
    console.log("New search query: " + searchQuery);
}

function handleCategoryChange() {
    console.log("New category: " + selectedCategory);
}

function handlePriceRangeChange() {
    console.log("New price range: " + priceRange);
}

function handleSortChange() {
    console.log("New sort criteria: " + sortCriteria);
}

export function initSidebarFilter() {
    const container = document.getElementById('sidebar-filter');

    searchQuery = '';
    selectedCategory = 'all';
    priceRange = 50;
    sortCriteria = 'featured';

    document.getElementById('search-input')
        .addEventListener('blur', function () {
            searchQuery = this.value;
            handleSearchQueryChange();
        });

    container.querySelectorAll('.category-btn')
        .forEach(function (categoryBtn) {
            categoryBtn.addEventListener('click', function () {
                $(this)
                    .addClass('bg-primary hover:bg-primary/20 active:bg-primary/30 text-primary-foreground font-semibold')
                    .removeClass('hover:bg-background active:bg-background/30 text-foreground');

                // TODO: Get the previous toggled one and make the opposite...
                $(`[data-category='${selectedCategory}']`)
                    .addClass('hover:bg-background/20 active:bg-background/30 text-foreground')
                    .removeClass('bg-primary hover:bg-primary/20 active:bg-primary/30 text-primary-foreground font-semibold');

                selectedCategory = categoryBtn.dataset.category;
                document.getElementById('selected-category').textContent = categoriesMapping[selectedCategory];
                document.getElementById('grid-selected-category').textContent = categoriesMapping[selectedCategory];

                handleCategoryChange();
            });
        });

    container.querySelector('.range-input')
        .addEventListener('change', function () {
            priceRange = this.value;
            document.getElementById('selected-price-range').textContent = priceRange;

            handlePriceRangeChange();
        });

    container.querySelectorAll('.sort-btn')
        .forEach(function (sortBtn) {
            sortBtn.addEventListener('click', function () {
                $(this)
                    .addClass('bg-primary hover:bg-primary/20 active:bg-primary/30 text-primary-foreground font-semibold')
                    .removeClass('hover:bg-background active:bg-background/30 text-foreground');

                // TODO: Get the previous toggled one and make the opposite...
                $(`[data-criteria='${sortCriteria}']`)
                    .addClass('hover:bg-background/20 active:bg-background/30 text-foreground')
                    .removeClass('bg-primary hover:bg-primary/20 active:bg-primary/30 text-primary-foreground font-semibold');

                sortCriteria = sortBtn.dataset.criteria;
                document.getElementById('selected-sort-criteria').textContent = sortCriteriaMapping[sortCriteria];

                handleSortChange();
            })
        });

    document.getElementById('categories-controller')
        .addEventListener('click', function () {
            isCategoriesOpen = !isCategoriesOpen;
            console.log(isCategoriesOpen);

            $('#selected-category')
                .parent()
                .toggleClass('max-h-12 opacity-100', !isCategoriesOpen)
                .toggleClass('max-h-0 opacity-0', isCategoriesOpen);

            $('#categories-container')
                .toggleClass('max-h-96 opacity-100', isCategoriesOpen)
                .toggleClass('max-h-0 opacity-0', !isCategoriesOpen);
        });

    document.getElementById('sort-controller')
        .addEventListener('click', function () {
            isSortOpen = !isSortOpen;
            console.log(isSortOpen);

            $('#selected-sort-criteria')
                .parent()
                .toggleClass('max-h-12 opacity-100', !isSortOpen)
                .toggleClass('max-h-0 opacity-0', isSortOpen);

            $('#sort-container')
                .toggleClass('max-h-48 opacity-100', isSortOpen)
                .toggleClass('max-h-0 opacity-0', !isSortOpen);
        })
}
