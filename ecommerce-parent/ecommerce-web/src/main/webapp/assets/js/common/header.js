
export function initHeader() {
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

        // Close when clicking outside
        document.addEventListener('click', () => {
            dropdown.classList.remove('opacity-100', 'scale-100', 'visible');
            dropdown.classList.add('opacity-0', 'scale-95', 'invisible');
            chevron.classList.remove('rotate-180');
            avatarBtn.setAttribute('aria-expanded', 'false');
        });
    }
}
