import {initHeader} from "../common/header.js";
import {initCategoriesCarousel} from "./categories-carousel.js";
import {initFeaturedBooksCarousel} from "./featured-books-carousel.js";

function init() {
    initFeaturedBooksCarousel();
    initCategoriesCarousel();
    initHeader();
}

$(document).on('DOMContentLoaded', () => init());
