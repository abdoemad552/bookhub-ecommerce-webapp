import {$, showAlert, hideAlert, markField, setHint, removeHint} from '../signup/util.js';
import {validateStep1, validateStep2, goToStep} from '../signup/formValidation.js';
import {initHeader} from "../common/header.js";

// Global variables
const CONTEXT = '/ecommerce';
const ADDRESSES_URL = CONTEXT + '/address';

// Load user addresses
let addressesLoaded = false;

async function loadAddresses() {
    if (addressesLoaded) return;
    const grid = $('address-grid');

    try {
        const res = await fetch(ADDRESSES_URL, {
            cache: "no-store",
            headers: {'X-Requested-With': 'XMLHttpRequest'}
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const addresses = await res.json();

        // clear skeletons
        grid.innerHTML = '';

        if (!addresses.length) {
            grid.innerHTML = '';
            addressesLoaded = true;
            return;
        }

        addresses.forEach(add => {
            const card = document.createElement('div');
            card.className = 'address-card';
            card.innerHTML = `
                <input type="checkbox" id="address-${add.id}" name="addressIds" value="${add.id}">
                <label class="address-label" for="address-${add.id}">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-6 h-6 text-primary" aria-hidden="true">
                        <path d="M12 7v14"></path>
                        <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                    </svg>
                    <span class="cat-name">${add.addressType}</span>
                </label>
                <div class="address-check">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                </div>`;

            grid.appendChild(card);
        });

        addressesLoaded = true;

    } catch (err) {
        console.error('Failed to load addresses:', err);
    }
}

function init(){
    initHeader();
    loadAddresses();
}

document.addEventListener('DOMContentLoaded', init);

// Disable Key (Enter) from submitting the form
$('checkout-form').addEventListener('keydown', e => {
    if (e.key === 'Enter') e.preventDefault();
});
