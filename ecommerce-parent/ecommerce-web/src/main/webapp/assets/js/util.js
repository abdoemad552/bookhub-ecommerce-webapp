const CONTEXT_PATH = "/ecommerce";

export const $ = id => document.getElementById(id);

export function scrollH(element, direction, amount) {
    element.scrollBy({
        left: direction === 'left' ? -amount : amount,
        behavior: 'smooth'
    });
}

export function scrollV(element, direction, amount) {
    element.scrollBy({
        top: direction === 'top' ? -amount : amount,
        behavior: 'smooth'
    });
}

export function getContextPath() {
    return CONTEXT_PATH;
}

export function debounce(fn, delay) {
    let timer;
    return function(...args) {
        clearTimeout(timer);
        timer = setTimeout(() => fn.apply(this, args), delay);
    };
}
