<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>${book.title} - BookHub</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/images/bookhub-favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>

    <main id="book-info-page" data-book-id="${book.id}" data-reviews-page-size="${reviewsPageSize}" class="max-w-7xl mx-auto px-4 py-6 sm:py-8 md:py-10 space-y-10 md:space-y-12">

        <!-- Hero: Book Cover + Details -->
        <section class="grid grid-cols-1 xl:grid-cols-[minmax(0,40rem)_minmax(0,1fr)] gap-6 xl:gap-12 items-start">

            <!-- Cover Image -->
            <div class="flex justify-center xl:justify-start">
                <c:choose>
                    <c:when test="${not empty book.imageUrl}">
                        <img src="${pageContext.request.contextPath}/${book.imageUrl}"
                             alt="${book.title}"
                             class="w-full max-w-xs sm:max-w-sm md:max-w-md xl:max-w-110 object-contain drop-shadow-xl rounded-2xl"/>
                    </c:when>
                    <c:otherwise>
                        <div class="w-full max-w-xs sm:max-w-sm md:max-w-md xl:max-w-110 aspect-square rounded-xl border border-border bg-muted flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" class="w-24 h-24 text-muted-foreground" aria-hidden="true">
                                <path d="M12 7v14"></path>
                                <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                            </svg>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Book Info -->
            <div class="justify-center xl:pt-2 space-y-6">
                <div class="space-y-2.5">
                    <c:if test="${not empty book.category}">
                        <p class="text-sm font-semibold text-primary">${book.category.name}</p>
                    </c:if>
                    <h1 class="text-3xl sm:text-4xl md:text-5xl xl:text-6xl leading-[1.06] font-semibold tracking-[-0.03em] text-foreground">${book.title}</h1>
                    <p class="text-base sm:text-lg md:text-[1.25rem] leading-snug text-muted-foreground">
                        by
                        <c:forEach items="${book.bookAuthors}" var="bookAuthor" varStatus="status">
                            <a href="${pageContext.request.contextPath}/authors/${bookAuthor.author.id}"
                               class="hover:underline hover:text-primary font-semibold transition-colors duration-150 ease-in-out">${bookAuthor.author.name}</a><c:if test="${not status.last}">, </c:if>
                        </c:forEach>
                    </p>
                    <div class="flex flex-wrap items-center gap-2 sm:gap-3 pt-1">
                        <div id="book-average-rating-stars" class="flex items-center gap-1 text-accent">
                            <c:forEach begin="1" end="${bookAverageRating}">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 sm:w-6 sm:h-6" aria-hidden="true">
                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                </svg>
                            </c:forEach>
                            <c:forEach begin="1" end="${5 - bookAverageRating}">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 sm:w-6 sm:h-6 text-border" aria-hidden="true">
                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                </svg>
                            </c:forEach>
                        </div>
                        <span id="book-average-rating-value" class="text-sm sm:text-base font-semibold text-foreground">${bookAverageRatingValue} out of 5</span>
                    </div>
                </div>

                <div class="space-y-5">
                    <p class="text-3xl sm:text-4xl md:text-[2.85rem] leading-none font-semibold tracking-[-0.04em] text-primary">${book.price} EGP</p>

                    <!-- Quantity + Add to Cart -->
                    <div class="grid grid-cols-[9rem_1fr] sm:grid-cols-[10rem_minmax(0,1fr)] gap-3">
                        <div class="flex items-center justify-between h-11 sm:h-12 px-2 rounded-lg border border-border bg-background shadow-sm">
                            <button id="quantity-decrease-btn" type="button" class="flex items-center justify-center w-9 h-9 sm:w-10 sm:h-10 rounded-md text-base sm:text-lg font-semibold text-muted-foreground hover:bg-accent hover:text-accent-foreground active:bg-accent active:text-accent-foreground active:scale-90 focus:outline-none focus:ring-2 focus:ring-ring/50 transition-all duration-150 cursor-pointer">-</button>
                            <span id="book-quantity-value" class="text-base sm:text-lg font-semibold text-muted-foreground select-none">1</span>
                            <button id="quantity-increase-btn" type="button" class="flex items-center justify-center w-9 h-9 sm:w-10 sm:h-10 rounded-md text-base sm:text-lg font-semibold text-muted-foreground hover:bg-accent hover:text-accent-foreground active:bg-accent active:text-accent-foreground active:scale-90 focus:outline-none focus:ring-2 focus:ring-ring/50 transition-all duration-150 cursor-pointer">+</button>
                        </div>

                        <button id="book-info-add-to-cart"
                                type="button"
                                data-book-id="${book.id}"
                                data-out-of-stock="${book.stockQuantity le 0}"
                                class="inline-flex items-center justify-center whitespace-nowrap text-sm sm:text-[0.94rem] font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed h-11 sm:h-12 rounded-xl gap-2 sm:gap-2.5 px-4 text-primary-foreground bg-primary hover:bg-primary/95 active:bg-primary/90 active:scale-95"
                                <c:if test="${book.stockQuantity le 0}">disabled="disabled"</c:if>>
                            <span data-add-to-cart-icon class="flex items-center gap-2 sm:gap-3">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 sm:w-5 sm:h-5" aria-hidden="true">
                                    <circle cx="8" cy="21" r="1"></circle>
                                    <circle cx="19" cy="21" r="1"></circle>
                                    <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                                </svg>
                                <span>Add to Cart</span>
                            </span>
                            <svg data-add-to-cart-spinner xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="hidden lucide lucide-loader-circle animate-spin w-4 h-4 sm:w-5 sm:h-5" aria-hidden="true">
                                <path d="M21 12a9 9 0 1 1-6.219-8.56"></path>
                            </svg>
                        </button>
                    </div>

                    <!-- Save + Share -->
                    <div class="grid grid-cols-2 gap-3">
                        <button id="wishlist-toggle-btn" type="button" data-book-id="${book.id}" data-in-wishlist="${isInWishlist}" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed h-10 sm:h-10.5 rounded-xl gap-2 px-3 sm:px-3.5 border border-border bg-card text-foreground shadow-sm hover:bg-muted active:scale-95">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="${isInWishlist ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 sm:w-5 sm:h-5 ${isInWishlist ? 'text-primary' : 'text-foreground'}" aria-hidden="true">
                                <path d="m12 21-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.18z"></path>
                            </svg>
                            <span>Save</span>
                        </button>

                        <button id="share-book-btn" type="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer h-10 sm:h-10.5 rounded-xl gap-2 px-3 sm:px-3.5 border border-border bg-card text-foreground shadow-sm hover:bg-muted active:scale-95">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 sm:w-5 sm:h-5" aria-hidden="true">
                                <circle cx="18" cy="5" r="3"></circle>
                                <circle cx="6" cy="12" r="3"></circle>
                                <circle cx="18" cy="19" r="3"></circle>
                                <line x1="8.59" x2="15.42" y1="13.51" y2="17.49"></line>
                                <line x1="15.41" x2="8.59" y1="6.51" y2="10.49"></line>
                            </svg>
                            <span>Share</span>
                        </button>
                    </div>

                    <!-- Book Details Card -->
                    <div class="rounded-2xl border border-border bg-card shadow-sm px-5 py-5 sm:px-6 sm:py-6">
                        <h2 class="text-base sm:text-[1.05rem] font-semibold text-foreground">Book Details</h2>
                        <div class="mt-5 space-y-3.5">
                            <div class="flex items-center justify-between gap-4 text-sm sm:text-[0.98rem]">
                                <span class="text-muted-foreground">Pages:</span>
                                <span class="font-semibold text-foreground">${book.pages}</span>
                            </div>
                            <div class="flex items-center justify-between gap-4 text-sm sm:text-[0.98rem]">
                                <span class="text-muted-foreground">ISBN:</span>
                                <span class="font-semibold text-foreground">${book.isbn}</span>
                            </div>
                            <div class="flex items-center justify-between gap-4 text-sm sm:text-[0.98rem]">
                                <span class="text-muted-foreground">Format:</span>
                                <span class="font-semibold text-foreground">${bookFormatLabel}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Trust Badges -->
                    <div class="space-y-3.5 px-1">
                        <div class="flex items-start gap-3">
                            <div class="mt-0.5 text-primary shrink-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 sm:w-6 sm:h-6" aria-hidden="true">
                                    <rect width="16" height="13" x="3" y="8" rx="2"></rect>
                                    <path d="M16 8V6a4 4 0 0 0-8 0v2"></path>
                                    <path d="M3 14h4l2 3 2-6 2 3h6"></path>
                                </svg>
                            </div>
                            <div>
                                <p class="text-sm sm:text-base font-semibold text-foreground">Free Shipping</p>
                                <p class="text-xs sm:text-[0.92rem] text-muted-foreground">On orders over 50 EGP</p>
                            </div>
                        </div>
                        <div class="flex items-start gap-3">
                            <div class="mt-0.5 text-primary shrink-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" class="w-5 h-5 sm:w-6 sm:h-6" aria-hidden="true">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                </svg>
                            </div>
                            <div>
                                <p class="text-sm sm:text-base font-semibold text-foreground">Secure Checkout</p>
                                <p class="text-xs sm:text-[0.92rem] text-muted-foreground">Your payment is safe</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- About This Book -->
        <section class="rounded-2xl sm:rounded-3xl border border-border bg-card shadow-sm px-5 py-6 sm:px-7 sm:py-8 md:px-8 md:py-9">
            <h2 class="text-2xl sm:text-[1.75rem] md:text-[1.95rem] leading-tight font-semibold tracking-[-0.03em] text-foreground">About This Book</h2>
            <p class="mt-5 sm:mt-7 text-sm sm:text-[1.02rem] leading-7 sm:leading-8 text-muted-foreground whitespace-pre-wrap">${book.description}</p>
        </section>

        <!-- Readers Also Liked -->
        <section class="space-y-5 sm:space-y-6">
            <h2 class="text-2xl sm:text-[1.75rem] md:text-[2rem] leading-tight font-semibold tracking-[-0.03em] text-foreground">Readers Also Liked</h2>
            <c:choose>
                <c:when test="${not empty relatedBooks}">
                    <c:set var="books" value="${relatedBooks}" scope="request"/>
                    <c:set var="bookCardVariant" value="carousel" scope="request"/>
                    <div class="book-carousel flex gap-3 sm:gap-4 md:gap-6 overflow-x-auto overflow-y-visible scrollbar-hide scroll-smooth py-2" style="scrollbar-width:none;-ms-overflow-style:none">
                        <jsp:include page="../common/book-card.jsp"/>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rounded-2xl border border-dashed border-border bg-card p-6 text-center text-muted-foreground text-sm">
                        More recommendations are on the way.
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Reviews + Write a Review -->
        <section class="grid grid-cols-1 xl:grid-cols-[1.45fr_1fr] gap-5 sm:gap-6 items-start">

            <!-- Reviews List -->
            <div class="rounded-2xl sm:rounded-3xl border border-border bg-card shadow-sm px-4 py-5 sm:px-6 sm:py-6">
                <div class="flex items-center justify-between gap-4 mb-5">
                    <h2 class="text-lg sm:text-xl font-semibold tracking-tight text-foreground">Reviews</h2>
                    <span id="book-reviews-total" class="text-sm text-muted-foreground">${bookReviewCount} reviews</span>
                </div>

                <div id="reviews-list" class="space-y-3 sm:space-y-4">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach items="${reviews}" var="review">
                                <article class="book-review-card rounded-xl sm:rounded-[20px] border border-border bg-muted/40 p-3.5 sm:p-4 space-y-2.5 sm:space-y-3" data-review-id="${review.id}">
                                    <div class="flex items-center justify-between gap-4">
                                        <div>
                                            <h3 class="text-sm sm:text-base font-semibold text-foreground">${review.userFullName}</h3>
                                            <p class="text-xs sm:text-sm text-muted-foreground">${review.createdAt}</p>
                                        </div>
                                        <div class="flex items-center gap-0.5 sm:gap-1 shrink-0">
                                            <c:forEach begin="1" end="${review.rating}">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-accent" aria-hidden="true">
                                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                                </svg>
                                            </c:forEach>
                                            <c:forEach begin="1" end="${5 - review.rating}">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-border" aria-hidden="true">
                                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                                </svg>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <p class="text-xs sm:text-[0.95rem] text-muted-foreground leading-6 sm:leading-7">${review.comment}</p>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div id="empty-reviews-state" class="rounded-xl border border-dashed border-border bg-muted/30 p-5 text-center text-sm text-muted-foreground">
                                No reviews yet. Be the first to share your thoughts.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${canLoadMoreReviews}">
                    <button id="load-more-reviews-btn"
                            type="button"
                            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed border border-border bg-card text-foreground shadow-sm hover:bg-muted h-9 rounded-[14px] px-3.5 mt-4 sm:mt-5">
                        Load More Reviews
                    </button>
                </c:if>
            </div>

            <!-- Write a Review -->
            <aside class="rounded-2xl sm:rounded-3xl border border-border bg-card shadow-sm px-4 py-5 sm:px-6 sm:py-6">
                <h2 class="text-xl sm:text-[1.55rem] font-semibold tracking-[-0.03em] text-foreground mb-4">Write a Review</h2>
                <div id="review-action-content">
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <p class="text-sm sm:text-[0.98rem] text-muted-foreground leading-7 mb-5">Sign in to save this book, submit a review, and keep your cart updated.</p>
                            <a href="${pageContext.request.contextPath}/login">
                                <button type="button"
                                        class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer h-9 rounded-[14px] px-3.5 text-primary-foreground bg-primary hover:bg-primary/90">
                                    Sign In
                                </button>
                            </a>
                        </c:when>
                        <c:when test="${empty userReview}">
                            <form id="book-review-form" class="space-y-4">
                                <input type="hidden" name="bookId" value="${book.id}">
                                <div>
                                    <label class="block text-sm font-medium text-foreground mb-2">Rating</label>
                                    <div id="rating-stars" class="flex items-center gap-1 cursor-pointer select-none">
                                        <c:forEach begin="1" end="5" var="i">
                                            <svg data-value="${i}" class="w-6 h-6 sm:w-7 sm:h-7 text-muted-foreground transition-all duration-150 hover:scale-110" fill="currentColor" viewBox="0 0 24 24">
                                                <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                            </svg>
                                        </c:forEach>
                                    </div>
                                    <input type="hidden" id="review-rating" name="rating" value="0">
                                </div>
                                <div>
                                    <label for="review-comment" class="block text-sm font-medium text-foreground mb-2">Comment</label>
                                    <textarea id="review-comment" name="comment" rows="5"
                                              class="w-full rounded-xl border border-border bg-muted/30 px-3.5 py-3 text-sm sm:text-base text-foreground outline-none focus:border-primary focus:ring-4 focus:ring-primary/10 placeholder:text-muted-foreground"
                                              placeholder="Share what you liked about this book."></textarea>
                                </div>
                                <button id="submit-review-btn"
                                        type="submit"
                                        class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed h-9 rounded-[14px] px-3.5 text-primary-foreground bg-primary hover:bg-primary/90">
                                    Submit Review
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-4 sm:space-y-5">
                                <p class="text-sm sm:text-[0.98rem] text-muted-foreground leading-7">You already submitted a review for this book. Delete it if you want to submit a different one.</p>
                                <article class="rounded-xl sm:rounded-[20px] border border-border bg-muted/40 p-3.5 sm:p-4 space-y-2.5 sm:space-y-3">
                                    <div class="flex items-center justify-between gap-4">
                                        <div>
                                            <h3 class="text-sm sm:text-base font-semibold text-foreground">${userReview.userFullName}</h3>
                                            <p class="text-xs sm:text-sm text-muted-foreground">${userReview.createdAt}</p>
                                        </div>
                                        <div class="flex items-center gap-0.5 sm:gap-1 shrink-0">
                                            <c:forEach begin="1" end="${userReview.rating}">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-accent" aria-hidden="true">
                                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                                </svg>
                                            </c:forEach>
                                            <c:forEach begin="1" end="${5 - userReview.rating}">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-border" aria-hidden="true">
                                                    <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                                </svg>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <p class="text-xs sm:text-[0.95rem] text-muted-foreground leading-6 sm:leading-7">${userReview.comment}</p>
                                </article>
                                <button id="delete-review-btn"
                                        type="button"
                                        data-review-id="${userReview.id}"
                                        class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed h-9 rounded-[14px] px-3.5 text-primary-foreground bg-primary hover:bg-primary/90">
                                    Delete Review
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </aside>
        </section>
    </main>

    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/books/book-info.js"></script>
</body>
</html>