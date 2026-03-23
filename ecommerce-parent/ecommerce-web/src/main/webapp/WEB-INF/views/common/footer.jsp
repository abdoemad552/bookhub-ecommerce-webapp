<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

<footer class="footer-root">
    <div class="section-inner" style="padding-top:3rem; padding-bottom:0;">

        <div class="grid grid-cols-2 md:grid-cols-5 gap-8 pb-10">

            <%-- Brand --%>
            <div class="col-span-2">
                <div class="footer-brand">Book<span>Hub</span></div>
                <p class="footer-tagline">Your trusted online bookstore since 2024. Connecting readers with the stories that shape their world.</p>
                <div class="flex gap-2 mt-5">
                    <a href="#" class="footer-social" aria-label="Facebook">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                    </a>
                    <a href="#" class="footer-social" aria-label="Twitter">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4l16 16M4 20L20 4"/></svg>
                    </a>
                    <a href="#" class="footer-social" aria-label="Instagram">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="20" x="2" y="2" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/></svg>
                    </a>
                    <a href="#" class="footer-social" aria-label="LinkedIn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect width="4" height="12" x="2" y="9"/><circle cx="4" cy="4" r="2"/></svg>
                    </a>
                </div>
            </div>

            <%-- Customer Service --%>
            <div>
                <div class="footer-col-head">Support</div>
                <a href="#" class="footer-lnk">Contact Us</a>
                <a href="#" class="footer-lnk">Shipping Info</a>
                <a href="#" class="footer-lnk">Returns</a>
                <a href="#" class="footer-lnk">Track Order</a>
                <a href="#" class="footer-lnk">FAQ</a>
            </div>

            <%-- Company --%>
            <div>
                <div class="footer-col-head">Company</div>
                <a href="#" class="footer-lnk">About Us</a>
                <a href="#" class="footer-lnk">Careers</a>
                <a href="#" class="footer-lnk">Blog</a>
                <a href="#" class="footer-lnk">Press</a>
            </div>

            <%-- Browse --%>
            <div>
                <div class="footer-col-head">Explore</div>
                <a href="${pageContext.request.contextPath}/explore" class="footer-lnk">All Books</a>
                <a href="#" class="footer-lnk">Bestsellers</a>
                <a href="#" class="footer-lnk">New Arrivals</a>
                <a href="#" class="footer-lnk">Gift Cards</a>
                <a href="${pageContext.request.contextPath}/signup" class="footer-lnk">Create Account</a>
            </div>

        </div>

        <hr class="footer-rule">

        <div class="footer-copy ">
            <div class="flex items-center gap-1">
                <svg xmlns="http://www.w3.org/2000/svg"
                     width="20" height="20"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round"
                     class="w-4 h-4">
                    <circle cx="12" cy="12" r="10"></circle>
                    <path d="M15 9a3 3 0 0 0-6 0v6a3 3 0 0 0 6 0"></path>
                </svg>
                <span>2026 BookHub. All rights reserved.</span>
            </div>
            <div class="flex gap-4 flex-wrap">
                <a href="#" class="hover:underline">Privacy Policy</a>
                <a href="#" class="hover:underline">Terms of Service</a>
                <a href="#" class="hover:underline">Cookies</a>
            </div>
        </div>

    </div>
</footer>
