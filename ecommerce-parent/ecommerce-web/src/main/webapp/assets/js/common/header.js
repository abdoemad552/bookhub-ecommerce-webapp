let isHeaderInitialized = false;

function getCartCountBadge() {
    return document.getElementById('header-cart-count');
}

export function getContextPath() {
    return getCartCountBadge()?.dataset.contextPath || '';
}

export function updateCartItemsCount(count) {
    const cartCountBadge = getCartCountBadge();
    if (!cartCountBadge) return;
    cartCountBadge.textContent = `${Number.isFinite(Number(count)) ? Number(count) : 0}`;
}

async function loadCartItemsCount() {
    const cartCountBadge = getCartCountBadge();
    if (!cartCountBadge) return;

    try {
        const response = await fetch(`${getContextPath()}/cart?count=true`, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        });
        if (!response.ok) return;
        const data = await response.json();
        updateCartItemsCount(data.count);
    } catch {
        updateCartItemsCount(0);
    }
}

/* ── Category nav storage key ── */
const CAT_STORAGE_KEY = "bookhub_selected_category";

/**
 * Resolve which category should be active right now.
 *
 * Priority:
 *  1. `?category=<id>` in the current URL  (user landed via direct link / filter)
 *  2. localStorage from a previous pill click
 *  3. null  →  "All" pill gets highlighted
 */
function resolveActiveCategory() {
    const urlParam = new URLSearchParams(window.location.search).get("category");
    if (urlParam) {
        /* Persist whatever the URL says so other pages pick it up */
        localStorage.setItem(CAT_STORAGE_KEY, urlParam);
        return urlParam;
    }

    /* If we're not on the explore page at all, keep the stored value
       so the pill stays highlighted when browsing other pages.
       If we ARE on /explore with no category param, treat as "All". */
    const onExplorePage = window.location.pathname.includes("/explore");
    if (onExplorePage) {
        /* ?category was absent → user chose "All" → clear storage */
        localStorage.removeItem(CAT_STORAGE_KEY);
        return null;
    }

    return localStorage.getItem(CAT_STORAGE_KEY) ?? null;
}

/* ── Inject pill animation styles once ── */
function injectCatNavStyle() {
    if (document.getElementById("cat-nav-style")) return;
    const style = document.createElement("style");
    style.id = "cat-nav-style";
    style.textContent = `
        @keyframes catPillIn {
            from { opacity: 0; transform: translateY(2px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        #category-nav-id a {
            opacity: 0;
            animation: catPillIn 0.02s ease forwards;
        }

        /* Active pill style */
        #category-nav-id a.cat-active .cat-pill {
            background-color: var(--accent);
            color: var(--primary-foreground);
            font-weight: 600;
        }

        /* Hover — skip on already-active pill */
        #category-nav-id a:not(.cat-active) .cat-pill:hover {
            background-color: var(--accent);
            color: var(--accent-foreground);
        }
    `;
    document.head.appendChild(style);
}

/* ── Mark one pill active, scroll it into view ── */
function setActivePill(anchorEl) {
    const nav = document.getElementById("category-nav-id");
    if (!nav) return;

    /* Remove from all */
    nav.querySelectorAll("a.cat-active").forEach(a => a.classList.remove("cat-active"));

    if (!anchorEl) return;

    anchorEl.classList.add("cat-active");

    /* Smooth-scroll the pill into the centre of the nav strip */
    anchorEl.scrollIntoView({ behavior: "smooth", block: "nearest", inline: "center" });
}

async function loadCategoriesForNav() {
    const categoryNavElem = document.getElementById("category-nav-id");
    if (!categoryNavElem) return;

    try {
        const response = await fetch(`${getContextPath()}/categories/all`, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        });
        if (!response.ok) return;

        const categories = await response.json();
        const ctx = getContextPath();
        const activeId = resolveActiveCategory(); /* null = "All" */

        const allItems = [
            { href: `${ctx}/explore`, name: "All", categoryId: null },
            ...categories.map(cat => ({
                href: `${ctx}/explore?category=${cat.id}`,
                name: cat.name,
                categoryId: String(cat.id)
            }))
        ];

        /* Build anchor tags */
        categoryNavElem.innerHTML = allItems
            .map((item, i) => `
                <a href="${item.href}"
                   class="shrink-0"
                   style="animation-delay:${i * 35}ms"
                   data-category-id="${item.categoryId ?? ""}">
                    <button class="cat-pill cursor-pointer hover:text-accent-foreground inline-flex items-center
                                   justify-center whitespace-nowrap text-xs sm:text-sm font-medium
                                   text-muted-foreground px-3 sm:px-4 py-1 sm:py-1.5 rounded-full outline-none
                                   focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1
                                   transition-colors">
                        ${item.name}
                    </button>
                </a>`)
            .join('');

        /* ── Highlight the correct pill immediately ── */
        let activePillEl = null;
        if (activeId) {
            activePillEl = categoryNavElem.querySelector(`a[data-category-id="${activeId}"]`);
        } else {
            /* "All" pill has an empty data-category-id */
            activePillEl = categoryNavElem.querySelector(`a[data-category-id=""]`);
        }
        setActivePill(activePillEl);

        /* ── Click handler: persist + mark active ── */
        categoryNavElem.addEventListener("click", e => {
            const anchor = e.target.closest("a[data-category-id]");
            if (!anchor) return;

            const clickedId = anchor.dataset.categoryId; /* "" for "All" */

            if (clickedId) {
                localStorage.setItem(CAT_STORAGE_KEY, clickedId);
            } else {
                localStorage.removeItem(CAT_STORAGE_KEY);
            }

            setActivePill(anchor);

            /* Let the default navigation happen — no e.preventDefault() */
        });

    } catch (error) {
        console.error(error);
    }
}

export function initHeader() {
    if (isHeaderInitialized) return;
    isHeaderInitialized = true;

    injectCatNavStyle();

    /* ── Avatar dropdown ── */
    const avatarDropdownContainer = document.getElementById('avatar-dropdown-container');
    if (avatarDropdownContainer) {
        const avatarBtn = document.getElementById('avatar-btn');
        const dropdown  = document.getElementById('dropdown');
        const chevron   = document.getElementById('chevron');

        dropdown.classList.remove('opacity-100', 'scale-100', 'visible');
        dropdown.classList.add('opacity-0', 'scale-95', 'invisible');
        avatarBtn.setAttribute('aria-expanded', 'false');

        avatarBtn.addEventListener('click', e => {
            e.stopPropagation();
            const isOpen = avatarBtn.getAttribute('aria-expanded') === 'true';
            if (isOpen) {
                dropdown.classList.remove('opacity-100', 'scale-100', 'visible');
                dropdown.classList.add('opacity-0', 'scale-95', 'invisible');
                chevron.classList.remove('rotate-180');
                avatarBtn.setAttribute('aria-expanded', 'false');
            } else {
                dropdown.classList.remove('opacity-0', 'scale-95', 'invisible');
                dropdown.classList.add('opacity-100', 'scale-100', 'visible');
                chevron.classList.add('rotate-180');
                avatarBtn.setAttribute('aria-expanded', 'true');
            }
        });

        document.addEventListener('click', () => {
            dropdown.classList.remove('opacity-100', 'scale-100', 'visible');
            dropdown.classList.add('opacity-0', 'scale-95', 'invisible');
            chevron.classList.remove('rotate-180');
            avatarBtn.setAttribute('aria-expanded', 'false');
        });
    }

    loadCartItemsCount();
    loadCategoriesForNav();
}