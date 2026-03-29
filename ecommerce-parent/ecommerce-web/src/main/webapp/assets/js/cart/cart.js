import {showFeedbackMessage} from "../common/book-card.js";
import {getContextPath, initHeader, updateCartItemsCount} from "../common/header.js";

/* ── Money Helpers ── */
function formatMoney(value) {
    const safeValue = Number(value) || 0;
    return `${safeValue.toFixed(2)} EGP`;
}

function updateMoneyElement(element, value) {
    if (!element) return;
    element.dataset.moneyValue = `${Number(value) || 0}`;
    element.textContent = formatMoney(value);
    flashUpdate(element);
}

/* Briefly scale an updated number to give visual feedback */
function flashUpdate(element) {
    if (!element) return;
    element.classList.remove("updated");
    // Trigger reflow so re-adding the class restarts the animation
    void element.offsetWidth;
    element.classList.add("updated");
    setTimeout(() => element.classList.remove("updated"), 350);
}

/* ── Row Helpers ── */
function setRowLoadingState(row, isLoading) {
    if (!row) return;
    row.querySelectorAll("button").forEach((btn) => { btn.disabled = isLoading; });
    row.classList.toggle("opacity-70", isLoading);
}

function bumpQtyValue(row) {
    const el = row.querySelector("[data-cart-quantity-value]");
    if (!el) return;
    el.classList.remove("bump");
    void el.offsetWidth;
    el.classList.add("bump");
    setTimeout(() => el.classList.remove("bump"), 280);
}

function updateRowQuantity(row, quantity) {
    row.dataset.quantity = `${quantity}`;
    const quantityValue = row.querySelector("[data-cart-quantity-value]");
    if (quantityValue) quantityValue.textContent = `${quantity}`;

    bumpQtyValue(row);

    const unitPrice = Number(row.dataset.unitPrice) || 0;
    updateMoneyElement(row.querySelector("[data-cart-line-total]"), unitPrice * quantity);
}

function updateSummary(totalPrice, count) {
    updateMoneyElement(document.getElementById("cart-subtotal-value"), totalPrice);
    updateMoneyElement(document.getElementById("cart-total-value"), totalPrice);

    const summaryItemsCount = document.getElementById("cart-summary-items-count");
    if (summaryItemsCount) summaryItemsCount.textContent = `${Number(count) || 0}`;

    // Also update badge counts (there can be two elements with same id — find all)
    document.querySelectorAll("#cart-summary-items-count").forEach((el) => {
        el.textContent = `${Number(count) || 0}`;
    });
}

/* ── API ── */
async function sendCartRequest(method, bookId, amount = null) {
    const params = new URLSearchParams();
    params.set("bookId", bookId);
    if (amount !== null && amount !== undefined) params.set("amount", amount);

    const isDeleteRequest = method === "DELETE";
    const response = await fetch(
        isDeleteRequest
            ? `${getContextPath()}/cart?${params.toString()}`
            : `${getContextPath()}/cart`,
        {
            method,
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: isDeleteRequest ? null : params.toString()
        }
    );
    return { response, data: await response.json() };
}

/* ── Core update ── */
async function updateCartRow(row, method, amount = null) {
    if (!row) return;

    const bookId = row.dataset.bookId;
    const currentQuantity = Number(row.dataset.quantity) || 0;
    setRowLoadingState(row, true);

    try {
        const { response, data } = await sendCartRequest(method, bookId, amount);

        if (!response.ok || !data.success) {
            showFeedbackMessage(data.message || "Unable to update the cart.", false);
            return;
        }

        updateCartItemsCount(data.count);
        updateSummary(data.totalPrice, data.count);

        if (Number(data.itemQuantity) > 0) {
            updateRowQuantity(row, Number(data.itemQuantity));
        } else {
            // Animate row out before removing from DOM
            row.classList.add("removing");
            setTimeout(() => {
                row.remove();
                if (!document.querySelector("[data-cart-item]")) {
                    window.location.reload();
                }
            }, 420);
            return;
        }

        showFeedbackMessage(data.message || "Cart updated successfully.", true);
    } catch (error) {
        showFeedbackMessage("Unable to update the cart.", false);
        updateRowQuantity(row, currentQuantity);
    } finally {
        if (document.body.contains(row)) setRowLoadingState(row, false);
    }
}

/* ── Format initial money values ── */
function formatInitialMoney() {
    document.querySelectorAll("[data-money-value]").forEach((el) => {
        updateMoneyElement(el, el.dataset.moneyValue);
    });
}

/* ── Scroll-reveal IntersectionObserver ── */
function initScrollReveal() {
    const elements = document.querySelectorAll(".scroll-reveal");
    if (!elements.length) return;

    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    entry.target.classList.add("is-visible");
                    observer.unobserve(entry.target);
                }
            });
        },
        { threshold: 0.08, rootMargin: "0px 0px -40px 0px" }
    );

    elements.forEach((el) => observer.observe(el));
}

/* ── Bind cart action buttons ── */
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
        ?.addEventListener("click", function () {
            window.location.href =
                getContextPath() +
                (this.dataset["is-guest"] === "true" ? "/login" : "/checkout");
        });
}

/* ── Init ── */
function initCartPage() {
    if (!document.getElementById("cart-page")) return;
    formatInitialMoney();
    bindCartActions();
    initScrollReveal();
}

function init() {
    initHeader();
    initCartPage();

    window.addEventListener("pageshow", function (event) {
        const fromCheckout = sessionStorage.getItem("fromCheckout");
        if (event.persisted && fromCheckout === "true") {
            sessionStorage.removeItem("fromCheckout");
            window.location.reload();
        }
    });
}

$(document).on("DOMContentLoaded", () => init());
