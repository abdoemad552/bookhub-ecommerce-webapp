import {initHeader} from "../common/header.js";
import {AuthorBooksContainer} from "./books-container.js";
import {initBookCard} from "../common/book-card-jq.js";

let authorBooksContainer = null;

function init() {
    initHeader();
    initBookCard();

    authorBooksContainer = new AuthorBooksContainer();
    authorBooksContainer.init();
}

$(document).on('DOMContentLoaded', () => init());
