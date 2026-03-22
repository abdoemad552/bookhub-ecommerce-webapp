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