import {scrollH} from "../util.js";

export function initCategoriesCarousel() {
    const $pane = $('#categories-pane');
    const $left = $('#left-categories-scroller');
    const $right = $('#right-categories-scroller');

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

    setTimeout(() => loadSkeleton(), 3000);
}

function loadSkeleton() {

    let pane = document.getElementById('categories-pane');
    if (!pane) return;
    pane.querySelectorAll('.cat-skeleton').forEach(function (el) {
        el.remove();
    });
    pane.querySelectorAll('.cat-real').forEach(function (el) {
        el.style.display = '';
        el.style.opacity = '0';
        el.style.transition = 'opacity 0.4s ease';
        requestAnimationFrame(function () {
            requestAnimationFrame(function () {
                el.style.opacity = '1';
            });
        });
    });
    pane.dispatchEvent(new Event('scroll'));
}