<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Books Grid -->
<div
    id="author-books-grid" class="grid grid-cols-1 gap-6"
    data-total-elements="${pagination.totalElements}">
    <c:choose>
        <c:when test="${not empty pagination.content}">
            <c:set var="books" scope="request" value="${pagination.content}"/>
            <jsp:include page="../common/book-card.jsp"/>
        </c:when>
        <c:otherwise>
            <div id="no-books-placeholder" class="rounded-xl border border-border bg-card shadow-sm p-8 text-center">
                <h3 class="text-xl font-semibold text-foreground mb-3">No books found</h3>
                <p class="text-muted-foreground mb-5">Try changing the search text, category, or price range.</p>
                <button type="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer h-10 rounded-md px-5 text-primary-foreground bg-primary hover:bg-primary/90">
                    Clear Filters
                </button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<c:if test="${pagination.totalPages gt 1}">
    <div
        id="page-controls" class="flex items-center justify-center gap-1 mt-8"
        data-total-pages="${pagination.totalPages}">

        <button data-page="${pagination.page - 1}" type="button"
                class="pagination-page inline-flex items-center justify-center w-9 h-9 rounded-full border border-border bg-background text-muted-foreground transition-all hover:bg-muted hover:text-foreground hover:border-primary/30 disabled:pointer-events-none disabled:opacity-40 cursor-pointer"
                <c:if test="${pagination.page eq 1}">disabled="disabled"</c:if>>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="m15 18-6-6 6-6"/>
            </svg>
        </button>

        <c:forEach begin="${pagination.left}" end="${pagination.right}" var="i">
            <button data-page="${i}" type="button"
                    class="pagination-page inline-flex items-center justify-center w-9 h-9 rounded-full text-sm font-medium transition-all
                       ${i eq pagination.page
                           ? 'bg-primary text-primary-foreground shadow-sm cursor-default pointer-events-none'
                           : 'bg-background text-foreground border border-border hover:bg-muted hover:border-primary/30 cursor-pointer'}">
                    ${i}
            </button>
        </c:forEach>

        <button data-page="${pagination.page + 1}" type="button"
                class="pagination-page inline-flex items-center justify-center w-9 h-9 rounded-full border border-border bg-background text-muted-foreground transition-all hover:bg-muted hover:text-foreground hover:border-primary/30 disabled:pointer-events-none disabled:opacity-40 cursor-pointer"
                <c:if test="${pagination.page ge pagination.totalPages}">disabled="disabled"</c:if>>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="m9 18 6-6-6-6"/>
            </svg>
        </button>

    </div>
</c:if>