import {initBookCard} from "../common/book-card.js";
import {initHeader} from "../common/header.js";
import {initSidebarFilter} from "./sidebar-filter.js";

function init() {
    initBookCard();
    initHeader();
    initSidebarFilter();
}

$(document).on('DOMContentLoaded', () => init());
