
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
    "featured":             "Featured",
    "price-low-to-high":    "Price: Low to High",
    "price-high-to-low":    "Price: High to Low",
    "rating":               "Rating"
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
                if (selectedCategory === this.dataset.category) return;
                $(this)
                    .addClass('bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold')
                    .removeClass('hover:bg-primary/5 active:bg-primary/10 text-foreground');

                // TODO: Get the previous toggled one and make the opposite...
                $(`[data-category='${selectedCategory}']`)
                    .addClass('hover:bg-primary/5 active:bg-primary/10 text-foreground')
                    .removeClass('bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold');

                selectedCategory = this.dataset.category;
                document.getElementById('selected-category').textContent = categoriesMapping[selectedCategory];
                document.getElementById('grid-selected-category').textContent = categoriesMapping[selectedCategory];

                handleCategoryChange();
            });
        });

    container.querySelector('.range-input')
        .addEventListener('input', function () {
            priceRange = this.value;
            document.getElementById('selected-price-range').textContent = priceRange;

            handlePriceRangeChange();
        });

    container.querySelectorAll('.sort-btn')
        .forEach(function (sortBtn) {
            sortBtn.addEventListener('click', function () {
                if (sortCriteria === this.dataset.criteria) return;
                $(this)
                    .addClass('bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold')
                    .removeClass('hover:bg-primary/5 active:bg-primary/10 text-foreground');

                // TODO: Get the previous toggled one and make the opposite...
                $(`[data-criteria='${sortCriteria}']`)
                    .addClass('hover:bg-primary/5 active:bg-primary/10 text-foreground')
                    .removeClass('bg-primary hover:bg-primary/90 active:bg-primary/80 text-primary-foreground font-semibold');

                sortCriteria = this.dataset.criteria;
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
