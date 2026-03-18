<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>BookHub - Your Gateway to Endless Stories</title>
    <meta name="description" content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <script src="${pageContext.request.contextPath}/assets/js/jquery/jquery.js"></script>
</head>
<body class="font-sans antialiased overflow-y-scroll">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-1">
                <jsp:include page="sidebar-filter.jsp"/>
            </div>
            <div class="lg:col-span-3">
                <div class="flex justify-between items-center mb-6">
                    <h2 id="grid-selected-category" class="text-2xl font-bold text-foreground">All Books</h2>
                    <div class="flex items-center gap-4"><p class="text-muted-foreground">12<!-- --> results</p>
                        <div class="flex items-center border border-border rounded-lg overflow-hidden">
                            <button class="p-2 transition-colors bg-background text-foreground hover:bg-muted"
                                    aria-label="Grid view">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                     stroke-linejoin="round" class="lucide lucide-layout-grid w-4 h-4"
                                     aria-hidden="true">
                                    <rect width="7" height="7" x="3" y="3" rx="1"></rect>
                                     <rect width="7" height="7" x="14" y="3" rx="1"></rect>
                                    <rect width="7" height="7" x="14" y="14" rx="1"></rect>
                                    <rect width="7" height="7" x="3" y="14" rx="1"></rect>
                                </svg>
                            </button>
                            <button class="p-2 transition-colors bg-primary text-primary-foreground"
                                    aria-label="List view">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                     stroke-linejoin="round" class="lucide lucide-list w-4 h-4" aria-hidden="true">
                                    <path d="M3 5h.01"></path>
                                    <path d="M3 12h.01"></path>
                                    <path d="M3 19h.01"></path>
                                    <path d="M8 5h13"></path>
                                    <path d="M8 12h13"></path>
                                    <path d="M8 19h13"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
                <div id="books-container" class="flex flex-col gap-4">
                    <c:forEach begin="1" end="8">
                        <div class="animate-pulse bg-card rounded-xl border shadow-sm overflow-hidden flex flex-row">

                            <!-- Image -->
                            <div class="w-24 sm:w-28 md:w-32 shrink-0 bg-muted/40"></div>

                            <!-- Content -->
                            <div class="p-3 md:p-4 flex flex-col flex-1">

                                <div class="flex-1">

                                    <!-- Title -->
                                    <div class="h-3 md:h-4 bg-muted rounded w-5/6 mb-2"></div>
                                    <div class="h-3 md:h-4 bg-muted rounded w-2/3 mb-2"></div>

                                    <!-- Author -->
                                    <div class="h-2.5 md:h-3 bg-muted/70 rounded w-1/3 mb-3"></div>

                                    <!-- Rating -->
                                    <div class="flex items-center gap-1 mb-3">
                                        <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/30 rounded"></div>
                                        <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/30 rounded"></div>
                                        <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/30 rounded"></div>
                                        <div class="w-3 h-3 md:w-4 md:h-4 bg-accent/30 rounded"></div>
                                        <div class="w-3 h-3 md:w-4 md:h-4 bg-muted/30 rounded"></div>
                                    </div>

                                    <!-- Description -->
                                    <div class="space-y-1.5">
                                        <div class="h-2 md:h-2.5 bg-muted/50 rounded w-full"></div>
                                        <div class="h-2 md:h-2.5 bg-muted/50 rounded w-5/6"></div>
                                        <div class="h-2 md:h-2.5 bg-muted/50 rounded w-3/6"></div>
                                    </div>

                                </div>

                                <!-- Footer -->
                                <div class="flex items-center justify-between pt-3 border-t border-border/50 mt-3">

                                    <!-- Price -->
                                    <div class="h-3 md:h-4 bg-primary/20 rounded w-16"></div>

                                    <!-- Button -->
                                    <div class="h-8 w-8 md:h-8 md:w-10 bg-primary/30 rounded-md"></div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
                <div class="flex items-center justify-center gap-2 mt-8">
                    <button data-slot="button"
                            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5"
                            disabled="">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             class="lucide lucide-chevron-left w-4 h-4" aria-hidden="true">
                            <path d="m15 18-6-6 6-6"></path>
                        </svg>
                    </button>
                    <button data-slot="button"
                            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive text-primary-foreground active:bg-primary/80 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5 bg-primary hover:bg-primary/90">
                        1
                    </button>
                    <button data-slot="button"
                            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5">
                        2
                    </button>
                    <button data-slot="button"
                            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*='size-'])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground active:bg-accent/80 active:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50 dark:active:bg-input/40 h-8 rounded-md gap-1.5 px-3 has-[&gt;svg]:px-2.5">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             class="lucide lucide-chevron-right w-4 h-4" aria-hidden="true">
                            <path d="m9 18 6-6-6-6"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="module" src="${pageContext.request.contextPath}/assets/js/explore/explore.js"></script>
</body>
</html>
