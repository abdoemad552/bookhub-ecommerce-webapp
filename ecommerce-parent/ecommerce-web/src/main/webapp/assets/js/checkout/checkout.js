import { initHeader }           from '../common/header.js';
import { showAlert, hideAlert } from '../signup/util.js';

import {
    $,
    goToStep,
    updateStepUI,
    appendNewAddressCard,
    hideNewAddressPanel,
    createPopup,
    buildAddressCard,
    restoreSaveBtn,
    renderPaymentStep,
    renderReviewStep,
} from './checkoutUtil.js';

import {
    validateStep1,
    validateStep2,
    readPaymentMeta,
    validateNewAddressForm,
} from './checkoutValidation.js';

// Constants
const CONTEXT       = '/ecommerce';
const ADDRESSES_URL = CONTEXT + '/address';
const ORDER_URL = CONTEXT + '/order';
const CHECKOUT_URL = CONTEXT + '/checkout';
const ORDER_CONFIRMATION = CONTEXT + '/order-confirmation';

// Module-level state
export let addressesData = [];  // cache of loaded addresses
let paymentData   = null;        // cached payment meta for Step 2 validation
let order = null;

// Step 1: Address helpers
async function loadAddresses() {
    const grid = $('address-grid');
    try {
        const res = await fetch(ADDRESSES_URL, {
            method: 'GET',
            cache: 'no-store',
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const addresses = await res.json();
        addressesData = addresses;
        grid.innerHTML = '';
        addresses.forEach(add => grid.appendChild(buildAddressCard(add)));
    } catch (err) {
        console.error('Failed to load addresses:', err);
    } finally {
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
        government:  document.getElementById('naf-gov').value,
        city:        document.getElementById('naf-city').value.trim(),
        street:      document.getElementById('naf-street').value.trim(),
        buildingNo:  document.getElementById('naf-building').value.trim(),
        description: document.getElementById('naf-desc').value.trim(),
    });

    try {
        const res = await fetch(ADDRESSES_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString(),
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const saved = await res.json();

        if (saved.success) {
            await loadAddresses();

            const newAddr = addressesData.find(a =>
                a.city       === params.get('city')     &&
                a.street     === params.get('street')   &&
                a.buildingNo === params.get('buildingNo')
            );
            hideNewAddressPanel();
            if (newAddr) {
                const radio = document.getElementById(`address-${newAddr.id}`);
                if (radio) radio.checked = true;
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

// Step 2 and 3: Fetching
async function fetchOrderSummary() {
    try {
        const res = await fetch(ORDER_URL, { method: 'GET', credentials: 'include' });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return await res.json();
    } catch (err) {
        console.error('Failed to load order review:', err);
        return null;
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
    renderPaymentStep(paymentData);
}

function tryGoToStep3() {
    hideAlert();
    if (paymentData && !validateStep2(paymentData)) {
        showAlert('Your credit limit is insufficient to complete this order.');
        return;
    }
    goToStep(3, 'forward');
    renderReviewStep(order);
}

// Init
async function init() {
    initHeader();
    updateStepUI()

    // Step 1
    createPopup();
    await loadAddresses();
    $('naf-save-btn').addEventListener('click', saveNewAddress);
    $('btn-next-1').addEventListener('click', tryGoToStep2);

    // Order summary data
    order = await fetchOrderSummary();

    // Step 2
    paymentData = readPaymentMeta(order);
    $('btn-back-2').addEventListener('click', () => { hideAlert(); goToStep(1, 'back'); });
    $('btn-next-2').addEventListener('click', tryGoToStep3);

    // Step 3
    $('btn-back-3').addEventListener('click', () => { hideAlert(); goToStep(2, 'back'); });
}

document.addEventListener('DOMContentLoaded', init);

$('checkout-form').addEventListener('submit', async function (e) {
    e.preventDefault();
    hideAlert();

    const submitBtn = $('btn-place-order');
    submitBtn.disabled = true;
    submitBtn.classList.add('is-loading');

    try {
        const response = await fetch(CHECKOUT_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: null,
        });

        submitBtn.disabled = false;
        submitBtn.classList.remove('is-loading');

        if (!response.ok) {
            showAlert('Something went wrong. Please try again.');
            return;
        }

        const data = await response.json();
        if (!data.success) {
            showAlert(data.message);
        } else {
            // Reset the cart badge count
            initHeader();
            window.location.href = ORDER_CONFIRMATION;
        }
    } catch (err) {
        submitBtn.disabled = false;
        submitBtn.classList.remove('is-loading');
        console.error('Submit error:', err);
    }
});

$('checkout-form').addEventListener('keydown', e => {
    if (e.key === 'Enter') e.preventDefault();
});