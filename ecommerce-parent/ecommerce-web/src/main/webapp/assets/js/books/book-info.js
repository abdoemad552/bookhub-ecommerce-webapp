import {addToCart, initBookCard, showFeedbackMessage} from "../common/book-card.js";
import {getContextPath, initHeader} from "../common/header.js";

function escapeHtml(value) {
    return `${value ?? ""}`
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll("\"", "&quot;")
        .replaceAll("'", "&#39;");
}

function renderReviewStars(rating) {
    const safeRating = Math.min(Math.max(Number(rating) || 0, 0), 5);
    let stars = "";

    for (let index = 0; index < safeRating; index += 1) {
        stars += `
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 text-[#d67724]" aria-hidden="true">
                <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
            </svg>`;
    }

    for (let index = safeRating; index < 5; index += 1) {
        stars += `
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e5e7eb" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4" aria-hidden="true">
                <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
            </svg>`;
    }

    return stars;
}

function renderAverageStars(averageRating) {
    const safeAverageRating = Math.min(Math.max(Math.floor(Number(averageRating) || 0), 0), 5);
    let stars = "";

    for (let index = 0; index < safeAverageRating; index += 1) {
        stars += `
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6" aria-hidden="true">
                <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
            </svg>`;
    }

    for (let index = safeAverageRating; index < 5; index += 1) {
        stars += `
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e5e7eb" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6" aria-hidden="true">
                <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
            </svg>`;
    }

    return stars;
}

function renderReviewCard(review) {
    return `
        <article class="book-review-card rounded-[22px] border border-[#ece7de] bg-[#fcfbf9] p-5 space-y-3" data-review-id="${escapeHtml(review.id)}">
            <div class="flex items-center justify-between gap-4">
                <div>
                    <h3 class="font-semibold text-[#111111]">${escapeHtml(review.userFullName)}</h3>
                    <p class="text-sm text-[#68707d]">${escapeHtml((review.createdAt || "").replace("T", " "))}</p>
                </div>
                <div class="flex items-center gap-1">
                    ${renderReviewStars(review.rating)}
                </div>
            </div>
            <p class="text-[#68707d] leading-8">${escapeHtml(review.comment)}</p>
        </article>`;
}

function renderReviewForm(bookId) {
    return `
        <form id="book-review-form" class="space-y-4">
            <input type="hidden" name="bookId" value="${bookId}">
            <div>
                <label class="block text-sm font-medium text-foreground mb-2">Rating</label>

                <!-- Stars -->
                <div id="rating-stars" class="flex items-center gap-1 cursor-pointer select-none">
                    <svg data-value="1" class="w-7 h-7 text-muted-foreground transition-all duration-150 hover:scale-110" fill="currentColor" viewBox="0 0 24 24"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path></svg>
                    <svg data-value="2" class="w-7 h-7 text-muted-foreground transition-all duration-150 hover:scale-110" fill="currentColor" viewBox="0 0 24 24"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path></svg>
                    <svg data-value="3" class="w-7 h-7 text-muted-foreground transition-all duration-150 hover:scale-110" fill="currentColor" viewBox="0 0 24 24"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path></svg>
                    <svg data-value="4" class="w-7 h-7 text-muted-foreground transition-all duration-150 hover:scale-110" fill="currentColor" viewBox="0 0 24 24"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path></svg>
                    <svg data-value="5" class="w-7 h-7 text-muted-foreground transition-all duration-150 hover:scale-110" fill="currentColor" viewBox="0 0 24 24"><path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path></svg>
                </div>

                <!-- Hidden input for form -->
                <input type="hidden" id="review-rating" name="rating" value="0">
            </div>
            <div>
                <label for="review-comment" class="block text-sm font-medium text-[#111111] mb-2">Comment</label>
                <textarea id="review-comment" name="comment" rows="6" class="w-full rounded-[16px] border border-[#e6e0d7] bg-[#fcfbf9] px-4 py-3 text-[#111111] outline-none focus:border-[#7b3527] focus:ring-4 focus:ring-[#7b3527]/10" placeholder="Share what you liked about this book."></textarea>
            </div>
            <button id="submit-review-btn" type="submit" class="inline-flex items-center justify-center whitespace-nowrap text-[1rem] font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed h-11 rounded-[16px] px-5 text-white bg-[#7b3527] hover:bg-[#6e2f23]">
                Submit Review
            </button>
        </form>`;
}

function renderUserReviewState(review) {
    return `
        <div class="space-y-5">
            <p class="text-[#68707d] leading-8">You already submitted a review for this book. Delete it if you want to submit a different one.</p>
            <article class="rounded-[22px] border border-[#ece7de] bg-[#fcfbf9] p-5 space-y-3">
                <div class="flex items-center justify-between gap-4">
                    <div>
                        <h3 class="font-semibold text-[#111111]">${escapeHtml(review.userFullName)}</h3>
                        <p class="text-sm text-[#68707d]">${escapeHtml((review.createdAt || "").replace("T", " "))}</p>
                    </div>
                    <div class="flex items-center gap-1">
                        ${renderReviewStars(review.rating)}
                    </div>
                </div>
                <p class="text-[#68707d] leading-8">${escapeHtml(review.comment)}</p>
            </article>
            <button id="delete-review-btn" type="button" data-review-id="${escapeHtml(review.id)}" class="inline-flex items-center justify-center whitespace-nowrap text-[1rem] font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed h-11 rounded-[16px] px-5 text-white bg-[#7b3527] hover:bg-[#6e2f23]">
                Delete Review
            </button>
        </div>`;
}

function renderEmptyReviewsState() {
    return `
        <div id="empty-reviews-state" class="rounded-[22px] border border-dashed border-[#e6e0d7] bg-[#fcfbf9] p-6 text-center text-[#68707d]">
            No reviews yet. Be the first to share your thoughts.
        </div>`;
}

function updateWishlistButton(button, inWishlist) {
    button.dataset.inWishlist = `${inWishlist}`;

    const label = button.querySelector("span");
    const icon = button.querySelector("svg");

    if (label) {
        label.textContent = "Save";
    }

    if (icon) {
        icon.setAttribute("fill", inWishlist ? "currentColor" : "none");
        icon.classList.toggle("text-[#7b3527]", inWishlist);
        icon.classList.toggle("text-[#111111]", !inWishlist);
    }
}

function updateRatingSummary(summary) {
    if (!summary) {
        return;
    }

    const ratingCount = Number(summary.ratingCount) || 0;
    const averageRating = Number(summary.averageRating) || 0;

    const reviewCount = document.getElementById("book-reviews-total");
    if (reviewCount) {
        reviewCount.textContent = `${ratingCount} reviews`;
    }

    const averageRatingValue = document.getElementById("book-average-rating-value");
    if (averageRatingValue) {
        averageRatingValue.textContent = `${averageRating.toFixed(1)} out of 5`;
    }

    const averageRatingStars = document.getElementById("book-average-rating-stars");
    if (averageRatingStars) {
        averageRatingStars.innerHTML = renderAverageStars(averageRating);
    }
}

function getSelectedQuantity() {
    const quantityValue = document.getElementById("book-quantity-value");
    const quantity = Number.parseInt(quantityValue?.textContent || "1", 10);
    return Number.isNaN(quantity) ? 1 : Math.max(quantity, 1);
}

function updateSelectedQuantity(nextQuantity) {
    const quantityValue = document.getElementById("book-quantity-value");
    if (!quantityValue) {
        return;
    }

    quantityValue.textContent = `${Math.max(nextQuantity, 1)}`;
}

async function handleWishlistToggle(button, bookId) {
    button.disabled = true;

    try {
        const inWishlist = button.dataset.inWishlist === "true";
        const response = await fetch(`${getContextPath()}/wishlist?bookId=${bookId}`, {
            method: inWishlist ? "DELETE" : "POST",
            headers: {
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: inWishlist ? null : `bookId=${encodeURIComponent(bookId)}`
        });

        const data = await response.json();

        if (response.ok && data.success) {
            updateWishlistButton(button, data.inWishlist);
            showFeedbackMessage(data.message || "Wishlist updated successfully.", true);
        } else {
            showFeedbackMessage(data.message || "Unable to update your wishlist.", false);
        }
    } catch (error) {
        showFeedbackMessage("Unable to update your wishlist.", false);
    } finally {
        button.disabled = false;
    }
}

function initStars() {
    const stars = document.querySelectorAll('#rating-stars svg');
    const input = document.getElementById('review-rating');

    let currentRating = 0;

    stars.forEach(star => {
        star.addEventListener('click', () => {
            const value = parseInt(star.dataset.value);
            currentRating = value;
            input.value = value;

            updateStars(value);
        });

        // Optional: hover preview
        star.addEventListener('mouseenter', () => {
            updateStars(parseInt(star.dataset.value));
        });

        star.addEventListener('mouseleave', () => {
            updateStars(currentRating);
        });
    });

    function updateStars(rating) {
        stars.forEach(star => {
            const value = parseInt(star.dataset.value);

            if (value <= rating) {
                star.classList.remove('text-muted-foreground');
                star.classList.add('text-accent');
            } else {
                star.classList.remove('text-accent');
                star.classList.add('text-muted-foreground');
            }
        });
    }
}

function bindReviewControls(bookId) {
    const reviewForm = document.getElementById("book-review-form");
    if (reviewForm) {
        initStars();
        reviewForm.addEventListener("submit", (event) => {
            event.preventDefault();
            handleReviewSubmit(reviewForm, bookId);
        });
    }

    const deleteReviewButton = document.getElementById("delete-review-btn");
    if (deleteReviewButton) {
        deleteReviewButton.addEventListener("click", () => handleReviewDelete(deleteReviewButton, bookId));
    }
}

async function handleReviewSubmit(form, bookId) {
    const submitButton = document.getElementById("submit-review-btn");
    const reviewsList = document.getElementById("reviews-list");
    const emptyState = document.getElementById("empty-reviews-state");

    if (!submitButton || !reviewsList) {
        return;
    }

    submitButton.disabled = true;

    try {
        const body = new URLSearchParams(new FormData(form));
        body.set("bookId", bookId);

        const response = await fetch(`${getContextPath()}/reviews`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: body.toString()
        });

        const data = await response.json();

        if (response.ok && data.success) {
            if (emptyState) {
                emptyState.remove();
            }

            reviewsList.insertAdjacentHTML("afterbegin", renderReviewCard(data.review));

            const reviewActionContent = document.getElementById("review-action-content");
            if (reviewActionContent) {
                reviewActionContent.innerHTML = renderUserReviewState(data.review);
                bindReviewControls(bookId);
            }

            updateRatingSummary(data.ratingSummary);
            showFeedbackMessage(data.message || "Review submitted successfully.", true);
        } else {
            showFeedbackMessage(data.message || "Unable to submit your review.", false);
        }
    } catch (error) {
        showFeedbackMessage("Unable to submit your review.", false);
    } finally {
        if (document.body.contains(submitButton)) {
            submitButton.disabled = false;
        }
    }
}

async function handleReviewDelete(button, bookId) {
    button.disabled = true;

    try {
        const response = await fetch(`${getContextPath()}/reviews?bookId=${bookId}`, {
            method: "DELETE",
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        });

        const data = await response.json();

        if (response.ok && data.success) {
            const deletedReviewId = Number(data.deletedReviewId) || 0;
            if (deletedReviewId > 0) {
                document.querySelector(`[data-review-id="${deletedReviewId}"]`)?.remove();
            }

            const reviewsList = document.getElementById("reviews-list");
            if (reviewsList && !reviewsList.querySelector(".book-review-card") && !document.getElementById("empty-reviews-state")) {
                reviewsList.insertAdjacentHTML("afterbegin", renderEmptyReviewsState());
            }

            const reviewActionContent = document.getElementById("review-action-content");
            if (reviewActionContent) {
                reviewActionContent.innerHTML = renderReviewForm(bookId);
                bindReviewControls(bookId);
            }

            updateRatingSummary(data.ratingSummary);
            showFeedbackMessage(data.message || "Review deleted successfully.", true);
        } else {
            showFeedbackMessage(data.message || "Unable to delete your review.", false);
        }
    } catch (error) {
        showFeedbackMessage("Unable to delete your review.", false);
    } finally {
        if (document.body.contains(button)) {
            button.disabled = false;
        }
    }
}

async function handleLoadMoreReviews(button, bookId, pageSize, state) {
    button.disabled = true;

    try {
        const nextPage = state.pageNumber + 1;
        const response = await fetch(`${getContextPath()}/reviews?bookId=${bookId}&pageNumber=${nextPage}&pageSize=${pageSize}`, {
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        });

        const data = await response.json();

        if (!response.ok || !data.success) {
            showFeedbackMessage(data.message || "Unable to load more reviews.", false);
            button.disabled = false;
            return;
        }

        const reviews = data.reviews || [];

        if (reviews.length === 0) {
            button.remove();
            return;
        }

        const reviewsList = document.getElementById("reviews-list");
        reviews.forEach((review) => reviewsList.insertAdjacentHTML("beforeend", renderReviewCard(review)));

        state.pageNumber = nextPage;

        if (reviews.length < pageSize) {
            button.remove();
            return;
        }
    } catch (error) {
        showFeedbackMessage("Unable to load more reviews.", false);
    } finally {
        if (document.body.contains(button)) {
            button.disabled = false;
        }
    }
}

function initQuantitySelector() {
    const decreaseButton = document.getElementById("quantity-decrease-btn");
    const increaseButton = document.getElementById("quantity-increase-btn");

    if (decreaseButton) {
        decreaseButton.addEventListener("click", () => {
            updateSelectedQuantity(getSelectedQuantity() - 1);
        });
    }

    if (increaseButton) {
        increaseButton.addEventListener("click", () => {
            updateSelectedQuantity(getSelectedQuantity() + 1);
        });
    }
}

function initShareButton() {
    const shareButton = document.getElementById("share-book-btn");
    if (!shareButton) {
        return;
    }

    shareButton.addEventListener("click", async () => {
        const shareUrl = window.location.href;

        try {
            if (navigator.share) {
                await navigator.share({
                    title: document.title,
                    url: shareUrl
                });
            } else {
                await navigator.clipboard.writeText(shareUrl);
                showFeedbackMessage("Book link copied successfully.", true);
            }
        } catch (error) {
            if (error?.name !== "AbortError") {
                showFeedbackMessage("Unable to share this book right now.", false);
            }
        }
    });
}

function initBookInfo() {
    const page = document.getElementById("book-info-page");
    if (!page) {
        return;
    }

    const bookId = page.dataset.bookId;
    const pageSize = Number(page.dataset.reviewsPageSize || 4);
    const reviewsState = {pageNumber: 1};

    const addToCartButton = document.getElementById("book-info-add-to-cart");
    if (addToCartButton) {
        addToCartButton.addEventListener("click", (event) => {
            event.preventDefault();
            addToCart(bookId, getSelectedQuantity(), addToCartButton);
        });
    }

    const wishlistButton = document.getElementById("wishlist-toggle-btn");
    if (wishlistButton) {
        wishlistButton.addEventListener("click", () => handleWishlistToggle(wishlistButton, bookId));
    }

    bindReviewControls(bookId);

    const loadMoreButton = document.getElementById("load-more-reviews-btn");
    if (loadMoreButton) {
        loadMoreButton.addEventListener("click", () => handleLoadMoreReviews(loadMoreButton, bookId, pageSize, reviewsState));
    }

    initQuantitySelector();
    initShareButton();
}

function init() {
    initBookCard();
    initHeader();
    initBookInfo();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, {once: true});
} else {
    init();
}
