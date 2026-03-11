<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:forEach items="${requestScope.books}" var="book">
    <div data-slot="card" class="bg-card text-card-foreground rounded-xl border shadow-sm shrink-0 w-72 sm:w-80 md:w-96 overflow-hidden hover:shadow-lg hover:scale-95 active:scale-90 cursor-pointer flex flex-row transition-all duration-150 ease-in-out">

        <!-- Book Cover -->
        <div class="w-24 sm:w-28 md:w-32 shrink-0">
            <img src="${book.coverPicUrl}" alt="${book.title}" class="w-full h-full object-cover" />
        </div>

        <!-- Info -->
        <div class="p-3 md:p-4 flex flex-col flex-1">
            <div class="flex-1">
                <h3 class="font-semibold text-foreground line-clamp-2 text-sm md:text-base mb-1">
                        ${book.title}
                </h3>
                <p class="text-xs md:text-sm text-muted-foreground mb-2">${book.author}</p>
                <div class="flex items-center gap-1">
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
                <p class="text-xs md:text-sm text-muted-foreground mt-2 line-clamp-3">${book.description}</p>
            </div>

            <!-- Price + Button -->
            <div class="flex items-center justify-between pt-3 border-t border-border/50 mt-3">
                <span class="font-bold text-primary text-sm md:text-base">${book.price} EGP</span>
                <button data-slot="button" class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] text-primary-foreground active:bg-primary/80 h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5 bg-primary hover:bg-primary/90">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shopping-cart w-3 h-3 md:w-4 md:h-4" aria-hidden="true">
                        <circle cx="8" cy="21" r="1"></circle><circle cx="19" cy="21" r="1"></circle><path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"></path>
                    </svg>
                </button>
            </div>
        </div>
    </div>
</c:forEach>