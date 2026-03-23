<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <meta name="description" content="Manage your BookHub profile, orders, addresses, and payment methods."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="bookhub,profile,orders,addresses,payment"/>
    <title>BookHub - My Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <main class="max-w-7xl mx-auto px-4 py-12">
        <h1 class="text-4xl font-bold text-foreground mb-12">My Account</h1>
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-1">
                <div class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6">
                    <div class="flex items-center gap-4 mb-2 pb-6 border-b border-border">
                        <div class="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-primary" aria-hidden="true">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </div>
                        <div>
                            <p class="font-semibold text-foreground">BookHub User</p>
                            <p class="text-sm text-muted-foreground">user@bookhub.com</p>
                        </div>
                    </div>
                    <nav class="space-y-2">
                        <button type="button" data-tab="profile-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors bg-primary text-background">Profile</button>
                        <button type="button" data-tab="orders-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Orders</button>
                        <button type="button" data-tab="addresses-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Addresses</button>
                        <button type="button" data-tab="payments-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Payment Methods</button>
                    </nav>
                </div>
            </div>

            <div class="lg:col-span-3">
                <div id="profile-info" class="profile-panel bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Profile Information</h2>
                    <form action="${pageContext.request.contextPath}/profile" method="post" class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">First Name</label>
                                <input type="text" name="firstName" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="John"/>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Last Name</label>
                                <input type="text" name="lastName" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="Doe"/>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Email Address</label>
                            <input type="email" name="email" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="user@bookhub.com"/>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Phone Number</label>
                            <input type="tel" name="phone" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="+1 (555) 123-4567"/>
                        </div>
                        <button type="submit" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">Save Changes</button>
                    </form>
                </div>

                <div id="orders-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Order History</h2>
                    <div class="space-y-4">
                        <div class="border border-border rounded-lg p-4 flex items-center justify-between">
                            <div>
                                <p class="font-semibold text-foreground">Order #BH-10421</p>
                                <p class="text-sm text-muted-foreground">3 Items - Jan 18, 2026</p>
                            </div>
                            <span class="text-sm font-semibold text-green-600">Delivered</span>
                        </div>
                        <div class="border border-border rounded-lg p-4 flex items-center justify-between">
                            <div>
                                <p class="font-semibold text-foreground">Order #BH-10387</p>
                                <p class="text-sm text-muted-foreground">1 Item - Jan 05, 2026</p>
                            </div>
                            <span class="text-sm font-semibold text-amber-600">In Transit</span>
                        </div>
                        <div class="border border-border rounded-lg p-4 flex items-center justify-between">
                            <div>
                                <p class="font-semibold text-foreground">Order #BH-10266</p>
                                <p class="text-sm text-muted-foreground">2 Items - Dec 20, 2025</p>
                            </div>
                            <span class="text-sm font-semibold text-green-600">Delivered</span>
                        </div>
                    </div>
                </div>

                <div id="addresses-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Saved Addresses</h2>
                    <div class="space-y-4">
                        <div class="border border-border rounded-lg p-4">
                            <p class="font-semibold text-foreground mb-1">Home</p>
                            <p class="text-sm text-muted-foreground">245 Pine Street, San Jose, CA 95112, United States</p>
                        </div>
                        <div class="border border-border rounded-lg p-4">
                            <p class="font-semibold text-foreground mb-1">Work</p>
                            <p class="text-sm text-muted-foreground">801 Market Street, San Francisco, CA 94103, United States</p>
                        </div>
                    </div>
                </div>

                <div id="payments-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Payment Methods</h2>
                    <div class="space-y-4">
                        <div class="border border-border rounded-lg p-4 flex items-center justify-between">
                            <div>
                                <p class="font-semibold text-foreground">Visa ending in 4821</p>
                                <p class="text-sm text-muted-foreground">Expires 10/28</p>
                            </div>
                            <span class="text-sm text-primary font-semibold">Default</span>
                        </div>
                        <div class="border border-border rounded-lg p-4 flex items-center justify-between">
                            <div>
                                <p class="font-semibold text-foreground">Mastercard ending in 9924</p>
                                <p class="text-sm text-muted-foreground">Expires 04/27</p>
                            </div>
                            <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium border bg-background hover:bg-accent h-8 px-3">Set Default</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script>
    const profileTabs = document.querySelectorAll(".profile-tab");
    const profilePanels = document.querySelectorAll(".profile-panel");

    function showProfilePanel(tabId) {
        profilePanels.forEach((panel) => {
            panel.classList.toggle("hidden", panel.id !== tabId);
        });
        profileTabs.forEach((btn) => {
            const isActive = btn.dataset.tab === tabId;
            btn.classList.toggle("bg-primary", isActive);
            btn.classList.toggle("text-background", isActive);
            btn.classList.toggle("hover:bg-accent", !isActive);
            btn.classList.toggle("text-foreground", !isActive);
        });
    }

    profileTabs.forEach((tab) => {
        tab.addEventListener("click", () => showProfilePanel(tab.dataset.tab));
    });
</script>
</body>
</html>
