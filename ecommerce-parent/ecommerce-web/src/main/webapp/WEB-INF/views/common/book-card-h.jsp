<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:forEach items="${requestScope.books}" var="book">
    <div onclick="window.location.href = '${pageContext.request.contextPath}/books/${book.id}'" data-slot="card" class="bg-card text-card-foreground gap-6 rounded-xl border shadow-sm overflow-hidden hover:shadow-lg cursor-pointer flex flex-row transition-all duration-150 ease-in-out">
        <div class="w-24 sm:w-28 md:w-32 shrink-0 bg-secondary/20 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-12 h-12 text-primary/40" aria-hidden="true">
                <path d="M12 7v14"></path>
                <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
            </svg>
        </div>
        <div class="p-3 md:p-4 flex flex-col flex-1">
            <div class="flex-1">
                <div class="flex justify-between items-start gap-2 mb-1">
                    <h3 class="font-semibold text-foreground line-clamp-2 text-sm md:text-base">The Midnight Library</h3>
                </div>
                <p class="text-xs md:text-sm text-muted-foreground mb-2">${book.title}</p>
                <div class="flex items-center gap-1 mb-2">
                    <c:forEach begin="1" end="${book.averageRating}">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-star w-3 h-3 md:w-4 md:h-4 fill-accent text-accent" aria-hidden="true">
                            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                        </svg>
                    </c:forEach>
                    <c:forEach begin="1" end="${5 - book.averageRating}">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-star w-3 h-3 md:w-4 md:h-4 text-accent" aria-hidden="true">
                            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                        </svg>
                    </c:forEach>
                </div>
                <p class="text-xs md:text-sm text-muted-foreground line-clamp-2">${book.description}</p>
            </div>
            <div class="flex items-center justify-between pt-3 border-t border-border/50 mt-3">
                <span class="font-bold text-primary text-sm md:text-base">${book.price} EGP</span>
                <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 rounded-md gap-1.5 has-[&gt;svg]:px-2.5 bg-primary hover:bg-primary/90 h-8 px-3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-cart w-3 h-3 md:w-4 md:h-4" aria-hidden="true">
                        <circle cx="8" cy="21" r="1"></circle>
                        <circle cx="19" cy="21" r="1"></circle>
                        <path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                    </svg>
                </button>
            </div>
        </div>
    </div>
</c:forEach>
