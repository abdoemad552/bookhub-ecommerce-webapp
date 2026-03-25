import {initBookCard} from "../common/book-card-jq.js";
import {initHeader} from "../common/header.js";
import {initCategoriesCarousel} from "./categories-carousel.js";
import {initFeaturedBooksCarousel} from "./featured-books-carousel.js";

function init() {
    initFeaturedBooksCarousel();
    initCategoriesCarousel();
    initBookCard();
    initHeader();
}

$(document).on('DOMContentLoaded', () => init());
