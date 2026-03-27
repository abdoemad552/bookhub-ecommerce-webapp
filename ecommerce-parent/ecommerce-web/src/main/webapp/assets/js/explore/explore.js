import {initBookCard} from "../common/book-card-jq.js";
import {initHeader} from "../common/header.js";
import {FilterBooksContainer} from "./books-container.js";
import {FilterBooksDialog} from "./filter-books-dialog.js";
import {debounce} from "../util.js";

let filterBooksContainer = null;
let booksFilterDialog = null;
let searchTimeoutId = null;

function init() {
    initBookCard();
    initHeader();

    filterBooksContainer = new FilterBooksContainer();
    filterBooksContainer.init();

    booksFilterDialog = new FilterBooksDialog({
        onSubmit: (page, filterOptions) => {
            console.log(page, filterOptions);
            filterBooksContainer.filter(page, filterOptions);
        }
    });
    booksFilterDialog.init();

    $("#search-input").on("input", function () {
        clearTimeout(searchTimeoutId);

        filterBooksContainer.showSkeleton();
        filterBooksContainer.abort();

        searchTimeoutId = setTimeout(() => {
            filterBooksContainer.filter();
        }, 500);
    });
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, {once: true});
} else {
    init();
}
