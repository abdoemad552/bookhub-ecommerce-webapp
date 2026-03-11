import {scrollH} from "../util.js";

export function initFeaturedBooksCarousel() {
    const $pane = $('#featured-books-pane');
    const $left = $('#left-featured-scroller');
    const $right = $('#right-featured-scroller');

    $pane.on('scroll', function () {
        const atStart = $(this).scrollLeft() === 0;
        const atEnd = $(this).scrollLeft() + $(this).innerWidth() >= $(this)[0].scrollWidth - 1;

        $left.toggleClass('opacity-50 cursor-not-allowed', atStart)
            .toggleClass('hover:bg-muted cursor-pointer', !atStart)
            .prop('disabled', atStart);

        $right.toggleClass('opacity-50 cursor-not-allowed', atEnd)
            .toggleClass('hover:bg-muted cursor-pointer', !atEnd)
            .prop('disabled', atEnd);
    });

    $left.on('click', () => scrollH($pane[0], 'left', 280));
    $right.on('click', () => scrollH($pane[0], 'right', 280));

    // Maybe we'll try to use `get` to do some pre and/or post logic...
    setTimeout(() => $pane.load('featured-books'), 3000);
}
