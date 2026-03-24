import {initBookCard} from "../common/book-card-jq.js";
import {initHeader} from "../common/header.js";
import {initSidebarFilter} from "./sidebar-filter.js";
import {FilterBooksContainer} from "./books-container.js";

let filterBooksContainer = null;

function init() {
    filterBooksContainer = new FilterBooksContainer();
    filterBooksContainer.init();
    initBookCard();
    initHeader();
    initSidebarFilter();
}

$(document).on('DOMContentLoaded', () => init());
