import {initBookCard} from "../common/book-card-jq.js";
import {initHeader} from "../common/header.js";
import {initSidebarFilter} from "./sidebar-filter.js";

function init() {
    initBookCard();
    initHeader();
    initSidebarFilter();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, {once: true});
} else {
    init();
}
