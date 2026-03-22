import {getContextPath, updateCartItemsCount} from "./header.js";

const BUTTON_STATE = {
    DEFAULT: "default",
    LOADING: "loading",
    SUCCESS: "success"
};

const buttonDefaults = new WeakMap();

export function showFeedbackMessage(message, isSuccess) {
    const alert = document.createElement('div');
    alert.className = `alert-banner ${isSuccess ? 'alert-success' : 'alert-error'} fixed top-24 right-4 z-[60] max-w-sm shadow-lg`;
    alert.textContent = message;

    document.body.appendChild(alert);

    setTimeout(() => {
        alert.remove();
    }, 3000);
}

export function getSuccessContentHtml() {
    return `
        <span class="inline-flex items-center justify-center gap-1.5 whitespace-nowrap">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="M20 6 9 17l-5-5"></path>
            </svg>
            <span>Added</span>
        </span>`;
}

function cacheDefaults($btn) {
    if (!$btn || buttonDefaults.has($btn[0])) return;

    const $icon = $btn.find("[data-add-to-cart-icon]");

    buttonDefaults.set($btn[0], {
        iconHtml: $icon.html()
    });
}

function applyLoading($btn) {
    $btn.prop("disabled", true)
        .addClass("animate-pulse opacity-80 blur-[0.5px]");

    $btn.find("[data-add-to-cart-icon]").addClass("hidden");
    $btn.find("[data-add-to-cart-spinner]").removeClass("hidden");
}

function applySuccess($btn) {
    const $icon = $btn.find("[data-add-to-cart-icon]");

    $btn.prop("disabled", true)
        .attr("data-added-to-cart", "true")
        .attr("title", "Added to cart")
        .addClass("bg-green-700 border-green-700 text-white shadow-lg opacity-100")
        .removeClass("opacity-80 blur-[0.5px] animate-pulse");

    $icon.removeClass("hidden").html(getSuccessContentHtml());
    $btn.find("[data-add-to-cart-spinner]").addClass("hidden");
}

function applyDefault($btn, defaults, isOutOfStock) {
    const $icon = $btn.find("[data-add-to-cart-icon]");

    $btn.prop("disabled", isOutOfStock)
        .attr("data-added-to-cart", "false")
        .removeClass(
            "bg-green-700 border-green-700 text-white shadow-lg opacity-100 " +
            "opacity-80 blur-[0.5px] animate-pulse"
        )
        .attr("title", "");

    $icon.removeClass("hidden").html(defaults.iconHtml);
    $btn.find("[data-add-to-cart-spinner]").addClass("hidden");
}

function setButtonState($btn, state) {
    if (!$btn || !$btn.length) return;

    cacheDefaults($btn);

    const defaults = buttonDefaults.get($btn[0]);
    const isOutOfStock = $btn.data("out-of-stock") === true;

    switch (state) {
        case BUTTON_STATE.LOADING:
            applyLoading($btn);
            break;

        case BUTTON_STATE.SUCCESS:
            applySuccess($btn);
            break;

        default:
            applyDefault($btn, defaults, isOutOfStock);
    }
}

export async function addToCart(bookId, amount = 1, $btn = null) {
    const contextPath = getContextPath();
    if (!contextPath) return null;

    setButtonState($btn, BUTTON_STATE.LOADING);

    let success = false;

    setTimeout(async () => {
        try {
            const response = await fetch(`${contextPath}/cart`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: $.param({ bookId, amount })
            });

            const data = await response.json();

            if (response.ok && data.success) {
                success = true;

                updateCartItemsCount(data.count);
                setButtonState($btn, BUTTON_STATE.SUCCESS);

                showFeedbackMessage(
                    data.message || "Book added successfully.",
                    true
                );
            } else {
                showFeedbackMessage(
                    data.message || "Failed to add book.",
                    false
                );
            }

            return data;

        } catch {
            showFeedbackMessage("Failed to add book.", false);
            return null;

        } finally {
            setTimeout(() => {
                setButtonState($btn, BUTTON_STATE.DEFAULT);
            }, 500);
        }
    }, 500);
}

let initialized = false;

export function initBookCard() {
    if (initialized) return;
    initialized = true;

    $(document).on("click", "[data-add-to-cart-button]", function (e) {
        e.preventDefault();
        e.stopPropagation();

        const $btn = $(this);

        if ($btn.prop("disabled")) return;

        addToCart($btn.data("book-id"), 1, $btn).then();
    });
}

