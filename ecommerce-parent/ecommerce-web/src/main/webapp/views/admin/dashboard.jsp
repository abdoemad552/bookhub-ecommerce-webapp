<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <meta name="description" content="BookHub admin dashboard for users, books, and platform statistics."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="bookhub,admin,users,books,statistics"/>
    <title>BookHub - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
</head>
<body class="font-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../util/header.jsp" />
    <main class="max-w-7xl mx-auto px-4 py-12">
        <h1 class="text-4xl font-bold text-foreground mb-12">Admin Dashboard</h1>
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-1">
                <div class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6">
                    <div class="flex items-center gap-4 mb-2 pb-6 border-b border-border">
                        <div class="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-primary" aria-hidden="true">
                                <path d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5Z"></path>
                                <path d="M19 21a7 7 0 0 0-14 0"></path>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-foreground">Admin Panel</p>
                            <p class="text-sm text-muted-foreground">bookhub-admin@bookhub.com</p>
                        </div>
                    </div>
                    <nav class="space-y-2">
                        <button type="button" data-tab="users-panel" class="admin-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors bg-primary text-background">View All Users</button>
                        <button type="button" data-tab="books-panel" class="admin-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">All Books</button>
                        <button type="button" data-tab="add-book-panel" class="admin-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Add Book</button>
                        <button type="button" data-tab="stats-panel" class="admin-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Statistics</button>
                    </nav>
                </div>
            </div>

            <div class="lg:col-span-3">
                <div id="users-panel" class="admin-panel bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">All Users</h2>
                    <div class="overflow-x-auto">
                        <table class="min-w-full border border-border rounded-lg overflow-hidden">
                            <thead class="bg-accent/40">
                            <tr>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Name</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Email</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Phone</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr class="border-t border-border">
                                <td class="px-4 py-3 text-sm">Sarah Johnson</td>
                                <td class="px-4 py-3 text-sm">sarah.j@example.com</td>
                                <td class="px-4 py-3 text-sm">+1 (312) 111-9012</td>
                                <td class="px-4 py-3 text-sm">
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Order History</button>
                                </td>
                            </tr>
                            <tr class="border-t border-border">
                                <td class="px-4 py-3 text-sm">Omar Khaled</td>
                                <td class="px-4 py-3 text-sm">omar.k@example.com</td>
                                <td class="px-4 py-3 text-sm">+1 (646) 555-1324</td>
                                <td class="px-4 py-3 text-sm">
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Order History</button>
                                </td>
                            </tr>
                            <tr class="border-t border-border">
                                <td class="px-4 py-3 text-sm">Lena Morgan</td>
                                <td class="px-4 py-3 text-sm">lena.m@example.com</td>
                                <td class="px-4 py-3 text-sm">+1 (415) 908-2244</td>
                                <td class="px-4 py-3 text-sm">
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Order History</button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="books-panel" class="admin-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-2xl font-bold text-foreground">All Books</h2>
                        <button id="open-add-book" type="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">Add Book</button>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full border border-border rounded-lg overflow-hidden">
                            <thead class="bg-accent/40">
                            <tr>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Cover</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Title</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Author</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Category</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Price</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Stock</th>
                                <th class="text-left px-4 py-3 text-sm font-semibold text-foreground">Actions</th>
                            </tr>
                            </thead>
                            <tbody id="books-table-body">
                            <tr class="border-t border-border">
                                <td class="px-4 py-3 text-sm">
                                    <img src="https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=160&q=80" alt="Atomic Habits cover" class="w-12 h-16 object-cover rounded border border-border"/>
                                </td>
                                <td class="px-4 py-3 text-sm">Atomic Habits</td>
                                <td class="px-4 py-3 text-sm">James Clear</td>
                                <td class="px-4 py-3 text-sm">Self-Help</td>
                                <td class="px-4 py-3 text-sm">$18.00</td>
                                <td class="px-4 py-3 text-sm">52</td>
                                <td class="px-4 py-3 text-sm space-x-2">
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Edit</button>
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-red-200 text-red-600 bg-background hover:bg-red-50 h-8 px-3">Delete</button>
                                </td>
                            </tr>
                            <tr class="border-t border-border">
                                <td class="px-4 py-3 text-sm">
                                    <img src="https://images.unsplash.com/photo-1526243741027-444d633d7365?auto=format&fit=crop&w=160&q=80" alt="The Pragmatic Programmer cover" class="w-12 h-16 object-cover rounded border border-border"/>
                                </td>
                                <td class="px-4 py-3 text-sm">The Pragmatic Programmer</td>
                                <td class="px-4 py-3 text-sm">Andrew Hunt</td>
                                <td class="px-4 py-3 text-sm">Technology</td>
                                <td class="px-4 py-3 text-sm">$31.50</td>
                                <td class="px-4 py-3 text-sm">28</td>
                                <td class="px-4 py-3 text-sm space-x-2">
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Edit</button>
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-red-200 text-red-600 bg-background hover:bg-red-50 h-8 px-3">Delete</button>
                                </td>
                            </tr>
                            <tr class="border-t border-border">
                                <td class="px-4 py-3 text-sm">
                                    <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&w=160&q=80" alt="Dune cover" class="w-12 h-16 object-cover rounded border border-border"/>
                                </td>
                                <td class="px-4 py-3 text-sm">Dune</td>
                                <td class="px-4 py-3 text-sm">Frank Herbert</td>
                                <td class="px-4 py-3 text-sm">Fiction</td>
                                <td class="px-4 py-3 text-sm">$21.00</td>
                                <td class="px-4 py-3 text-sm">13</td>
                                <td class="px-4 py-3 text-sm space-x-2">
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Edit</button>
                                    <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-red-200 text-red-600 bg-background hover:bg-red-50 h-8 px-3">Delete</button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="add-book-panel" class="admin-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Add a New Book</h2>
                    <form id="add-book-form" action="#" method="post" class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Title</label>
                            <input type="text" name="title" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Book title"/>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Author</label>
                            <input type="text" name="author" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Author name"/>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Tags</label>
                            <input type="text" name="tags" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="e.g. bestseller, award-winning, classic"/>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Category</label>
                            <input type="text" name="category" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Category"/>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Description</label>
                            <textarea name="description" rows="4" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Book description"></textarea>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Price</label>
                                <input type="number" step="0.01" min="0" name="price" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="0.00"/>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Stock</label>
                                <input type="number" min="0" name="stock" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" placeholder="0"/>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Cover Image</label>
                            <input id="cover-image-input" type="file" name="coverImage" accept="image/*" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground"/>
                        </div>
                        <button type="submit" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">Save Book</button>
                    </form>
                </div>

                <div id="stats-panel" class="admin-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Statistics</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div class="border border-border rounded-lg p-5">
                            <p class="text-sm text-muted-foreground mb-1">Total Users</p>
                            <p class="text-3xl font-bold text-foreground">1,284</p>
                            <p class="text-sm text-green-600 mt-1">+5.1% this month</p>
                        </div>
                        <div class="border border-border rounded-lg p-5">
                            <p class="text-sm text-muted-foreground mb-1">Total Books</p>
                            <p class="text-3xl font-bold text-foreground">4,912</p>
                            <p class="text-sm text-green-600 mt-1">+87 this week</p>
                        </div>
                        <div class="border border-border rounded-lg p-5">
                            <p class="text-sm text-muted-foreground mb-1">Orders This Month</p>
                            <p class="text-3xl font-bold text-foreground">2,436</p>
                            <p class="text-sm text-foreground mt-1">Average: 81 orders/day</p>
                        </div>
                        <div class="border border-border rounded-lg p-5">
                            <p class="text-sm text-muted-foreground mb-1">Monthly Revenue</p>
                            <p class="text-3xl font-bold text-foreground">$42,750</p>
                            <p class="text-sm text-green-600 mt-1">+8.4% vs last month</p>
                        </div>
                    </div>
                    <div class="border border-border rounded-lg p-5">
                        <h3 class="font-semibold text-foreground mb-3">Top Categories</h3>
                        <ul class="space-y-2 text-sm">
                            <li class="flex justify-between"><span>Fiction</span><span class="font-semibold">34%</span></li>
                            <li class="flex justify-between"><span>Technology</span><span class="font-semibold">22%</span></li>
                            <li class="flex justify-between"><span>Self-Help</span><span class="font-semibold">18%</span></li>
                            <li class="flex justify-between"><span>Business</span><span class="font-semibold">14%</span></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%@include file="../util/footer.jsp"%>
</div>
<script>
    const adminTabs = document.querySelectorAll(".admin-tab");
    const adminPanels = document.querySelectorAll(".admin-panel");
    const openAddBookButton = document.getElementById("open-add-book");
    const addBookForm = document.getElementById("add-book-form");
    const booksTableBody = document.getElementById("books-table-body");

    function showAdminPanel(tabId) {
        adminPanels.forEach((panel) => {
            panel.classList.toggle("hidden", panel.id !== tabId);
        });
        adminTabs.forEach((btn) => {
            const isActive = btn.dataset.tab === tabId;
            btn.classList.toggle("bg-primary", isActive);
            btn.classList.toggle("text-background", isActive);
            btn.classList.toggle("hover:bg-accent", !isActive);
            btn.classList.toggle("text-foreground", !isActive);
        });
    }

    adminTabs.forEach((tab) => {
        tab.addEventListener("click", () => showAdminPanel(tab.dataset.tab));
    });

    if (openAddBookButton) {
        openAddBookButton.addEventListener("click", () => showAdminPanel("add-book-panel"));
    }

    if (addBookForm && booksTableBody) {
        addBookForm.addEventListener("submit", (event) => {
            event.preventDefault();

            const formData = new FormData(addBookForm);
            const title = formData.get("title") || "Untitled";
            const author = formData.get("author") || "Unknown";
            const category = formData.get("category") || "General";
            const price = formData.get("price") || "0";
            const stock = formData.get("stock") || "0";
            const file = formData.get("coverImage");

            const addRow = (imageSrc) => {
                const newRow = document.createElement("tr");
                newRow.className = "border-t border-border";
                newRow.innerHTML = `
                    <td class="px-4 py-3 text-sm">
                        <img src="${imageSrc}" alt="${title} cover" class="w-12 h-16 object-cover rounded border border-border"/>
                    </td>
                    <td class="px-4 py-3 text-sm">${title}</td>
                    <td class="px-4 py-3 text-sm">${author}</td>
                    <td class="px-4 py-3 text-sm">${category}</td>
                    <td class="px-4 py-3 text-sm">$${price}</td>
                    <td class="px-4 py-3 text-sm">${stock}</td>
                    <td class="px-4 py-3 text-sm space-x-2">
                        <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Edit</button>
                        <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-red-200 text-red-600 bg-background hover:bg-red-50 h-8 px-3">Delete</button>
                    </td>
                `;
                booksTableBody.prepend(newRow);
                addBookForm.reset();
                showAdminPanel("books-panel");
            };

            if (file && file.size > 0) {
                const reader = new FileReader();
                reader.onload = () => addRow(reader.result);
                reader.readAsDataURL(file);
            } else {
                addRow("https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=160&q=80");
            }
        });
    }
</script>
</body>
</html>
