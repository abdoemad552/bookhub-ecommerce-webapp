import {getContextPath, updateCartItemsCount} from "./header.js";

let isBookCardInitialized = false;
const addToCartButtonDefaults = new WeakMap();

function getSuccessContentHtml() {
    return `
        <span style="display:inline-flex;align-items:center;justify-content:center;gap:6px;white-space:nowrap;">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="M20 6 9 17l-5-5"></path>
            </svg>
            <span>Added</span>
        </span>`;
}

function cacheAddToCartButtonDefaults(button) {
    if (!button) {
        return;
    }

    if (addToCartButtonDefaults.has(button)) {
        return;
    }

    const icon = button.querySelector("[data-add-to-cart-icon]");

    addToCartButtonDefaults.set(button, {
        buttonBackgroundColor: button.style.backgroundColor,
        buttonBorderColor: button.style.borderColor,
        buttonBoxShadow: button.style.boxShadow,
        buttonFilter: button.style.filter,
        buttonOpacity: button.style.opacity,
        iconHtml: icon ? icon.innerHTML : null
    });
}

function setAddToCartButtonState(button, state) {
    if (!button) {
        return;
    }

    cacheAddToCartButtonDefaults(button);

    const defaults = addToCartButtonDefaults.get(button);
    const isOutOfStock = button.dataset.outOfStock === "true";
    const icon = button.querySelector("[data-add-to-cart-icon]");
    const spinner = button.querySelector("[data-add-to-cart-spinner]");

    if (state === "loading") {
        button.disabled = true;
        button.classList.add("animate-pulse");
        button.style.filter = "blur(0.8px)";
        button.style.opacity = "0.82";

        if (icon) {
            icon.classList.add("hidden");
        }

        if (spinner) {
            spinner.classList.remove("hidden");
        }

        return;
    }

    button.classList.remove("animate-pulse");
    button.style.filter = defaults?.buttonFilter || "";

    if (state === "success") {
        button.disabled = true;
        button.dataset.addedToCart = "true";
        button.style.opacity = "1";
        button.style.backgroundColor = "#2f6b52";
        button.style.borderColor = "#2f6b52";
        button.style.boxShadow = "0 10px 24px rgba(47, 107, 82, 0.18)";
        button.style.color = "#ffffff";
        button.title = "Added to cart";

        if (icon) {
            icon.classList.remove("hidden");
            icon.innerHTML = getSuccessContentHtml();
        }

        if (spinner) {
            spinner.classList.add("hidden");
        }

        return;
    }

    button.disabled = isOutOfStock;
    button.dataset.addedToCart = "false";
    button.style.opacity = defaults?.buttonOpacity || "";
    button.style.backgroundColor = defaults?.buttonBackgroundColor || "";
    button.style.borderColor = defaults?.buttonBorderColor || "";
    button.style.boxShadow = defaults?.buttonBoxShadow || "";
    button.style.color = "";
    button.title = "";

    if (icon) {
        icon.classList.remove("hidden");

        if (defaults?.iconHtml !== null) {
            icon.innerHTML = defaults.iconHtml;
        }
    }

    if (spinner) {
        spinner.classList.add("hidden");
    }
}

export function showFeedbackMessage(message, isSuccess) {
    const alert = document.createElement('div');
    alert.className = `alert-banner ${isSuccess ? 'alert-success' : 'alert-error'} fixed top-24 right-4 z-[60] max-w-sm shadow-lg`;
    alert.textContent = message;

    document.body.appendChild(alert);

    setTimeout(() => {
        alert.remove();
    }, 3000);
}

export async function addToCart(bookId, amount = 1, button = null) {
    const contextPath = getContextPath();
    if (!contextPath) {
        return null;
    }

    setAddToCartButtonState(button, "loading");
    let shouldKeepSuccessState = false;

    try {
        const body = new URLSearchParams();
        body.set("bookId", bookId);
        body.set("amount", amount);

        const response = await fetch(`${contextPath}/cart`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: body.toString()
        });

        const data = await response.json();

        if (response.ok && data.success) {
            updateCartItemsCount(data.count);
            shouldKeepSuccessState = true;
            setAddToCartButtonState(button, "success");
            showFeedbackMessage(data.message || "Book added to cart successfully.", true);
        } else {
            showFeedbackMessage(data.message || "Unable to add this book to the cart.", false);
        }

        return data;
    } catch (error) {
        showFeedbackMessage("Unable to add this book to the cart.", false);
        return null;
    } finally {
        if (!shouldKeepSuccessState) {
            setAddToCartButtonState(button, "default");
        }
    }
}

export function initBookCard() {
    if (isBookCardInitialized) {
        return;
    }

    isBookCardInitialized = true;

    document.addEventListener('click', (event) => {
        const addToCartButton = event.target.closest('[data-add-to-cart-button]');

        if (!addToCartButton) {
            return;
        }

        event.preventDefault();
        event.stopPropagation();

        if (addToCartButton.disabled) {
            return;
        }

        addToCart(addToCartButton.dataset.bookId, 1, addToCartButton);
    }, true);
}
