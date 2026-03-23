import {showFeedbackMessage} from "../common/book-card.js";
import {getContextPath, initHeader, updateCartItemsCount} from "../common/header.js";

function formatMoney(value) {
    const safeValue = Number(value) || 0;
    return `${safeValue.toFixed(2)} EGP`;
}

function updateMoneyElement(element, value) {
    if (!element) {
        return;
    }

    element.dataset.moneyValue = `${Number(value) || 0}`;
    element.textContent = formatMoney(value);
}

function setRowLoadingState(row, isLoading) {
    if (!row) {
        return;
    }

    row.querySelectorAll("button").forEach((button) => {
        button.disabled = isLoading;
    });

    row.classList.toggle("opacity-70", isLoading);
}

function updateRowQuantity(row, quantity) {
    row.dataset.quantity = `${quantity}`;
    const quantityValue = row.querySelector("[data-cart-quantity-value]");
    if (quantityValue) {
        quantityValue.textContent = `${quantity}`;
    }

    const unitPrice = Number(row.dataset.unitPrice) || 0;
    updateMoneyElement(row.querySelector("[data-cart-line-total]"), unitPrice * quantity);
}

function updateSummary(totalPrice, count) {
    updateMoneyElement(document.getElementById("cart-subtotal-value"), totalPrice);
    updateMoneyElement(document.getElementById("cart-total-value"), totalPrice);

    const summaryItemsCount = document.getElementById("cart-summary-items-count");
    if (summaryItemsCount) {
        summaryItemsCount.textContent = `${Number(count) || 0}`;
    }
}

async function sendCartRequest(method, bookId, amount = null) {
    const params = new URLSearchParams();
    params.set("bookId", bookId);

    if (amount !== null && amount !== undefined) {
        params.set("amount", amount);
    }

    const isDeleteRequest = method === "DELETE";
    const response = await fetch(
        isDeleteRequest ? `${getContextPath()}/cart?${params.toString()}` : `${getContextPath()}/cart`,
        {
            method,
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: isDeleteRequest ? null : params.toString()
        }
    );

    return {
        response,
        data: await response.json()
    };
}

async function updateCartRow(row, method, amount = null) {
    if (!row) {
        return;
    }

    const bookId = row.dataset.bookId;
    const currentQuantity = Number(row.dataset.quantity) || 0;

    setRowLoadingState(row, true);

    try {
        const {response, data} = await sendCartRequest(method, bookId, amount);

        if (!response.ok || !data.success) {
            showFeedbackMessage(data.message || "Unable to update the cart.", false);
            return;
        }

        updateCartItemsCount(data.count);
        updateSummary(data.totalPrice, data.count);

        if (Number(data.itemQuantity) > 0) {
            updateRowQuantity(row, Number(data.itemQuantity));
        } else {
            row.remove();

            if (!document.querySelector("[data-cart-item]")) {
                window.location.reload();
                return;
            }
        }

        showFeedbackMessage(data.message || "Cart updated successfully.", true);
    } catch (error) {
        showFeedbackMessage("Unable to update the cart.", false);
        updateRowQuantity(row, currentQuantity);
    } finally {
        if (document.body.contains(row)) {
            setRowLoadingState(row, false);
        }
    }
}

function formatInitialMoney() {
    document.querySelectorAll("[data-money-value]").forEach((element) => {
        updateMoneyElement(element, element.dataset.moneyValue);
    });
}

function bindCartActions() {
    document.querySelectorAll("[data-cart-item]").forEach((row) => {
        row.querySelector("[data-cart-increase-btn]")?.addEventListener("click", () => {
            updateCartRow(row, "POST", 1);
        });

        row.querySelector("[data-cart-decrease-btn]")?.addEventListener("click", () => {
            updateCartRow(row, "DELETE", 1);
        });

        row.querySelector("[data-cart-remove-btn]")?.addEventListener("click", () => {
            updateCartRow(row, "DELETE", Number(row.dataset.quantity) || 1);
        });
    });

    document.querySelector("#checkout-btn")
        .addEventListener('click', function () {
            window.location.href = getContextPath() + (this.dataset['is-guest'] === "true" ? "/login" : "/checkout");
        });
}

function initCartPage() {
    if (!document.getElementById("cart-page")) {
        return;
    }

    formatInitialMoney();
    bindCartActions();
}

function init() {
    initHeader();
    initCartPage();
}

$(document).on("DOMContentLoaded", () => init());
