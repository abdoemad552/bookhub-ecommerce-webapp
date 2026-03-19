import {initHeader} from '../common/header.js';
import {showAlert, hideAlert} from '../signup/util.js';

import {
    $,
    goToStep,
    updateStepUI,
    appendNewAddressCard,
    showNewAddressPanel,
    hideNewAddressPanel,
    createPopup,
    openPopup,
    closePopup,
    getAddressIcon,
    restoreSaveBtn,
    buildNetworkLogo,
    formatCurrency,
} from './checkoutUtil.js';

import {
    validateStep1,
    validateStep2,
    readPaymentMeta,
    validateNewAddressForm,
} from './checkoutValidation.js';

// Constants
const CONTEXT = '/ecommerce';
const ADDRESSES_URL = CONTEXT + '/address';

// Module-level address cache (replaces the old addressesData in address.js)
let addressesData = [];

// Step-1 helpers
function buildAddressCard(add) {
    const card = document.createElement('div');
    card.className = 'address-card';
    card.innerHTML = `
        <input type="radio" id="address-${add.id}" name="addressId" value="${add.id}">
        <label class="address-label" for="address-${add.id}">
            ${getAddressIcon(add.addressType)}
            <span class="cat-name">${add.addressType}</span>
        </label>
        <div class="address-check">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"/>
            </svg>
        </div>`;

    card.querySelector('input[type="radio"]').addEventListener('click', () => {
        const addr = addressesData.find(a => a.id === add.id);
        if (add.addressType === 'Online') return;
        hideNewAddressPanel();
        setTimeout(() => {
            if (addr) openPopup(addr);
        }, 250);
    });

    return card;
}

async function loadAddresses() {
    const grid = $('address-grid');

    try {
        const res = await fetch(ADDRESSES_URL, {
            cache: 'no-store',
            headers: {'X-Requested-With': 'XMLHttpRequest'},
        });

        if (!res.ok) console.log('HTTP ' + res.status);

        const addresses = await res.json();
        addressesData = addresses;
        grid.innerHTML = '';

        addresses.forEach(add => grid.appendChild(buildAddressCard(add)));

    } catch (err) {
        console.error('Failed to load addresses:', err);
    } finally {
        // Always append the "New Address" card, even on error
        appendNewAddressCard();
    }
}

async function saveNewAddress() {
    if (!validateNewAddressForm()) return;

    const btn = $('naf-save-btn');
    btn.disabled = true;
    btn.innerHTML = `<span class="naf-spinner"></span> Saving…`;

    const params = new URLSearchParams({
        addressType: document.getElementById('naf-type').value,
        government: document.getElementById('naf-gov').value,
        city: document.getElementById('naf-city').value.trim(),
        street: document.getElementById('naf-street').value.trim(),
        buildingNo: document.getElementById('naf-building').value.trim(),
        description: document.getElementById('naf-desc').value.trim(),
    });

    try {
        const res = await fetch(ADDRESSES_URL, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: params.toString(),
        });

        if (!res.ok) console.log('HTTP ' + res.status);
        const saved = await res.json();

        if (saved.success) {
            await loadAddresses();

            const newAddr = addressesData.find(a =>
                a.city        === params.get('city')      &&
                a.street      === params.get('street')    &&
                a.buildingNo  === params.get('buildingNo')
            );

            hideNewAddressPanel();

            if (newAddr) {
                // Auto-select the radio so validateStep1() sees it as checked
                const radio = document.getElementById(`address-${newAddr.id}`);
                if (radio) radio.checked = true;

                // Show the popup (skip Online type)
                // if (newAddr.addressType !== 'Online') openPopup(newAddr);

                // Go to second step automatically
                tryGoToStep2();
            }
        } else {
            showAlert(saved.message);
        }

    } catch (err) {
        console.error('Failed to save address:', err);
        showAlert('Could not save address. Please try again.');
    } finally {
        restoreSaveBtn();
    }
}

// Step-2 helpers
function renderPaymentStep(data) {
    // const data =  readPaymentMeta();
    if (!data) return;

    const available = data.limit - data.used;
    const total = data.subtotal + data.shipping;
    const enough = validateStep2(data);
    const usedPct = Math.min((data.used / data.limit) * 100, 100);

    // Credit card visuals
    const card = $('pay-card');
    $('pay-card-network').innerHTML = buildNetworkLogo(data.network);
    $('pay-card-number').innerHTML =
        `<span>••••</span><span>••••</span><span>••••</span><span>${data.lastFour}</span>`;
    $('pay-card-holder').textContent = data.holder.toUpperCase();
    $('pay-card-avail').textContent = formatCurrency(available);

    // Animate usage bar after a short delay so the transition is visible
    setTimeout(() => {
        $('pay-card-bar').style.width = usedPct + '%';
    }, 350);

    if (available / data.limit < 0.20) card.classList.add('pay-card--danger');

    // Breakdown rows
    $('pay-subtotal-val').textContent = formatCurrency(data.subtotal);
    $('pay-shipping-val').textContent = data.shipping === 0 ? 'Free' : formatCurrency(data.shipping);
    $('pay-total-val').textContent = formatCurrency(total);

    const availEl = $('pay-avail-val');
    availEl.textContent = formatCurrency(available);
    if (!enough) availEl.style.color = '#dc2626';

    // Status badge
    const statusEl = $('pay-status');
    const iconEl = $('pay-status-icon');
    const textEl = $('pay-status-text');

    const okIcon = `<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
        stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="20 6 9 17 4 12"/></svg>`;

    const errIcon = `<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
        stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10"/>
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/></svg>`;

    statusEl.style.display = 'flex';

    if (enough) {
        statusEl.className = 'pay-status pay-status--ok';
        iconEl.innerHTML = okIcon;
        textEl.textContent = `Your credit limit covers this order. You're good to go!`;
        $('btn-next-2').disabled = false;
    } else {
        statusEl.className = 'pay-status pay-status--err';
        iconEl.innerHTML = errIcon;
        textEl.textContent = `Insufficient credit. You need ${formatCurrency(total - available)} more.`;
        $('btn-next-2').disabled = true;
    }
}

// Step navigation with validation gates
function tryGoToStep2() {
    hideAlert();
    if (!validateStep1()) {
        showAlert('Please select a delivery address before continuing.');
        return;
    }
    goToStep(2, 'forward');
}

function tryGoToStep3() {
    hideAlert();
    const data = readPaymentMeta();
    if (data && !validateStep2(data)) {
        showAlert('Your credit limit is insufficient to complete this order.');
        return;
    }
    goToStep(3, 'forward');
}

// Init
async function init() {
    initHeader();
    updateStepUI();

    // Step 1 setup
    createPopup();
    await loadAddresses();

    $('naf-save-btn').addEventListener('click', saveNewAddress);

    $('btn-next-1').addEventListener('click', tryGoToStep2);

    // Step 2 setup
    const data = await readPaymentMeta();
    renderPaymentStep(data);

    $('btn-back-2').addEventListener('click', () => {
        hideAlert();
        goToStep(1, 'back');
    });
    $('btn-next-2').addEventListener('click', tryGoToStep3);

    // Step 3 setup
    $('btn-back-3').addEventListener('click', () => {
        hideAlert();
        goToStep(2, 'back');
    });
}

document.addEventListener('DOMContentLoaded', init);

// Prevent accidental form submission via Enter key
$('checkout-form').addEventListener('keydown', e => {
    if (e.key === 'Enter') e.preventDefault();
});