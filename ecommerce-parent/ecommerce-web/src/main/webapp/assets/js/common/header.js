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

export function initHeader() {
    if (isHeaderInitialized) {
        return;
    }

    isHeaderInitialized = true;

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
}
