let isHeaderInitialized = false;

function getCartCountBadge() {
    return document.getElementById('header-cart-count');
}

export function getContextPath() {
    return getCartCountBadge()?.dataset.contextPath || '';
}

export function updateCartItemsCount(count) {
    const cartCountBadge = getCartCountBadge();
    if (!cartCountBadge) {
        return;
    }

    cartCountBadge.textContent = `${Number.isFinite(Number(count)) ? Number(count) : 0}`;
}

async function loadCartItemsCount() {
    const cartCountBadge = getCartCountBadge();

    if (!cartCountBadge) {
        return;
    }

    try {
        const response = await fetch(`${getContextPath()}/cart?count=true`, {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        if (!response.ok) {
            return;
        }

        const data = await response.json();
        updateCartItemsCount(data.count);
    } catch (error) {
        updateCartItemsCount(0);
    }
}

// Inject the pill animation keyframe once into <head>
function injectCatNavStyle() {
    if (document.getElementById("cat-nav-style")) return;
    const style = document.createElement("style");
    style.id = "cat-nav-style";
    style.textContent = `
        @keyframes catPillIn {
            from { opacity: 0; transform: translateY(5px); }
            to   { opacity: 1; transform: translateY(0);   }
        }
        #category-nav-id a {
            opacity: 0;
            animation: catPillIn 0.05s ease forwards;
        }
    `;
    document.head.appendChild(style);
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

        const allItems = [
            { href: `${getContextPath()}/explore`, name: "All" },
            ...categories.map(cat => ({ href: `${getContextPath()}/explore?category=${cat.id}`, name: cat.name }))
        ];

        categoryNavElem.innerHTML = allItems.map((item, i) => `
            <a href="${item.href}" class="shrink-0" style="animation-delay:${i * 35}ms">
                <button class="cat-pill cursor-pointer hover:text-accent-foreground inline-flex items-center justify-center whitespace-nowrap text-xs sm:text-sm font-medium text-muted-foreground px-3 sm:px-4 py-1 sm:py-1.5 rounded-full outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-1 transition-colors">
                    ${item.name}
                </button>
            </a>`).join('');

    } catch (error) {
        console.error(error);
    }
}

export function initHeader() {
    if (isHeaderInitialized) {
        return;
    }

    isHeaderInitialized = true;

    injectCatNavStyle();

    const avatarDropdownContainer = document.getElementById('avatar-dropdown-container');
    if (avatarDropdownContainer) {
        const avatarBtn = document.getElementById('avatar-btn');
        const dropdown = document.getElementById('dropdown');
        const chevron = document.getElementById('chevron');

        // Start closed
        dropdown.classList.remove('opacity-100', 'scale-100', 'visible');
        dropdown.classList.add('opacity-0', 'scale-95', 'invisible');
        avatarBtn.setAttribute('aria-expanded', 'false');

        avatarBtn.addEventListener('click', (e) => {
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