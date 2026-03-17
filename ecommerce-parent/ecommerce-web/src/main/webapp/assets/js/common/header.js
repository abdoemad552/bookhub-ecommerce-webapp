
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
    const openBtn = document.getElementById("open-search");
    const closeBtn = document.getElementById("close-search");
    const searchBar = document.getElementById("mobile-search");
    const input = searchBar.querySelector("input");
    let isSearchOpen = false;

    openBtn.addEventListener("click", () => {
        if(isSearchOpen){
            isSearchOpen = false;
            searchBar.classList.add("-translate-y-full", "opacity-0");
            searchBar.classList.remove("translate-y-0", "opacity-100", "z-40");
        }else{
            isSearchOpen = true;
            searchBar.classList.remove("-translate-y-full", "opacity-0");
            searchBar.classList.add("translate-y-0", "opacity-100", "z-40");
            setTimeout(() => input.focus(), 200);
        }
    });

    closeBtn.addEventListener("click", () => {
        isSearchOpen = false;
        searchBar.classList.add("-translate-y-full", "opacity-0");
        searchBar.classList.remove("translate-y-0", "opacity-100", "z-40");
    });

}
