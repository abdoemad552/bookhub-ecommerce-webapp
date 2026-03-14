import {initHeader} from "../common/header.js";
import {initSidebarFilter} from "./sidebar-filter.js";

function init() {
    initHeader();
    initSidebarFilter();
}

$(document).on('DOMContentLoaded', () => init());
