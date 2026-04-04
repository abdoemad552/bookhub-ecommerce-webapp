<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:forEach items="${requestScope.books}" var="book">
  <div
          onclick="if (event.target.closest('[data-add-to-cart-button]')) { return; } window.location.href = '${pageContext.request.contextPath}/books/${book.id}'"
          data-slot="card"
          class="bg-card text-card-foreground flex flex-row w-full rounded-xl border shadow-sm overflow-hidden cursor-pointer transition-all duration-150 ease-in-out hover:shadow-lg hover:scale-[0.98] in-[.book-carousel]:w-72 in-[.book-carousel]:sm:w-80 in-[.book-carousel]:md:w-96 in-[.book-carousel]:shrink-0">
    <!-- Book Cover -->
    <div class="w-24 sm:w-28 shrink-0">
      <c:choose>
        <c:when test="${not empty book.coverPicUrl}">
          <img
                  src="${pageContext.request.contextPath}/${book.coverPicUrl}"
                  alt="${book.title}"
                  class="w-full h-full object-cover"
          />
        </c:when>
        <c:otherwise>
          <div class="w-full h-full bg-[#eef2ec] flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                 fill="none" stroke="#b39d95" stroke-width="1.6" stroke-linecap="round"
                 stroke-linejoin="round" class="w-8 h-8 sm:w-10 sm:h-10" aria-hidden="true">
              <path d="M12 7v14"/>
              <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"/>
            </svg>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Info -->
    <div class="p-3 sm:p-4 flex flex-col flex-1 min-w-0 select-none">

      <!-- Title + Out of Stock badge -->
      <div class="flex items-start justify-between gap-2 mb-1">
        <h3 class="font-semibold text-foreground text-sm sm:text-base line-clamp-2 leading-snug min-w-0">
            ${book.title}
        </h3>
        <c:if test="${book.stockQuantity le 0}">
          <span class="oos-badge shrink-0">
            <svg class="oos-icon" width="13" height="13" viewBox="0 0 13 13" fill="none"
                 xmlns="http://www.w3.org/2000/svg">
              <circle cx="6.5" cy="6.5" r="5.5" stroke="currentColor" stroke-width="1.5"/>
              <line x1="3.5" y1="3.5" x2="9.5" y2="9.5" stroke="currentColor" stroke-width="1.5"
                    stroke-linecap="round"/>
            </svg>
          </span>
        </c:if>
      </div>

      <!-- Authors -->
      <p class="text-xs sm:text-sm text-muted-foreground mb-2 line-clamp-1">
        <c:forEach items="${book.authors}" var="author" varStatus="status">
          ${author.name}<c:if test="${not status.last}">, </c:if>
        </c:forEach>
      </p>

      <!-- Star Rating -->
      <div class="flex items-center gap-0.5 mb-2">
        <c:forEach begin="1" end="${book.exactAverageRating}">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
               fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
               stroke-linejoin="round" class="w-3 h-3 sm:w-4 sm:h-4 fill-accent text-accent" aria-hidden="true">
            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"/>
          </svg>
        </c:forEach>
        <c:forEach begin="1" end="${5 - book.exactAverageRating}">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
               fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
               stroke-linejoin="round" class="w-3 h-3 sm:w-4 sm:h-4 text-accent" aria-hidden="true">
            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"/>
          </svg>
        </c:forEach>
      </div>

      <!-- Description -->
      <p class="text-xs sm:text-sm text-muted-foreground line-clamp-1 flex-1">
          ${book.description}
      </p>

      <!-- Price + Add to Cart -->
      <div class="flex items-center justify-between pt-3 mt-3 border-t border-border/50">
                <span class="font-bold text-primary text-sm sm:text-base truncate">
                    ${book.price} EGP
                </span>
        <button
                type="button"
                data-slot="button"
                data-add-to-cart-button
                data-book-id="${book.id}"
                data-out-of-stock="${book.stockQuantity le 0}"
                class="inline-flex items-center justify-center gap-1.5 shrink-0 whitespace-nowrap text-sm font-medium rounded-md px-3 h-8 bg-primary text-primary-foreground transition-all cursor-pointer hover:bg-primary/90 active:bg-primary/80 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed"
                <c:if test="${book.stockQuantity le 0}">disabled</c:if>
        >
          <!-- Cart icon -->
          <span data-add-to-cart-icon class="flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                             stroke-linejoin="round" class="w-3.5 h-3.5 sm:w-4 sm:h-4" aria-hidden="true">
                            <circle cx="8" cy="21" r="1"/>
                            <circle cx="19" cy="21" r="1"/>
                            <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/>
                        </svg>
                    </span>
          <!-- Spinner (shown via JS while adding) -->
          <svg data-add-to-cart-spinner xmlns="http://www.w3.org/2000/svg" width="24" height="24"
               viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round"
               class="hidden animate-spin w-3.5 h-3.5 sm:w-4 sm:h-4" aria-hidden="true">
            <path d="M21 12a9 9 0 1 1-6.219-8.56"/>
          </svg>
        </button>
      </div>
    </div>
  </div>
</c:forEach>