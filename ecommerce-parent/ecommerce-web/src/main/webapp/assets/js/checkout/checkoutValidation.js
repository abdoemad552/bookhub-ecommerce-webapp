import { $ } from './checkoutUtil.js';

const CONTEXT = '/ecommerce';
const ORDER_URL = CONTEXT + '/order';

// Step 1: Shipping address
export function validateStep1() {
    const checked = document.querySelector('#address-grid input[type="radio"]:checked');
    // A radio with value "__new__" means the new-address card is selected but not yet saved
    if (!checked || checked.value === '__new__') return false;
    return true;
}

// Step 2: Payment
async function fetchOrderSummary() {
    const res = await fetch(ORDER_URL, {
        method: 'GET',
        credentials: 'include'
    });

    if (!res.ok) throw new Error('API error');
    return res.json();
}

export async function readPaymentMeta() {
    const el = $('pay-meta');
    if (!el) return null;

    const n = attr => parseFloat(el.dataset[attr]) || 0;

    try {
        const summary = await fetchOrderSummary();

        return {
            limit: n('limit'),
            used: n('used'),
            subtotal: summary.subtotal,
            shipping: summary.shipping,
            lastFour: el.dataset.lastFour || '----',
            holder: el.dataset.holder || 'CARD HOLDER',
            network: (el.dataset.network || 'VCARD').toUpperCase(),
        };
    }catch (err){
        console.error(err);

        // fallback to dataset if API fails
        return {
            limit:    n('limit'),
            used:     n('used'),
            subtotal: '--',
            shipping: '--',
            lastFour: el.dataset.lastFour || '----',
            holder:   el.dataset.holder   || 'CARD HOLDER',
            network:  (el.dataset.network || 'VCARD').toUpperCase(),
        };
    }
}

export function validateStep2(data) {
    const available = data.limit - data.used;
    const total     = data.subtotal + data.shipping;
    return available >= total;
}

// Step 1: New-address inline form
const ADDRESS_FIELDS = [
    { id: 'naf-type',     label: 'Address Type' },
    { id: 'naf-gov',      label: 'Governorate'  },
    { id: 'naf-city',     label: 'City'         },
    { id: 'naf-street',   label: 'Street'       },
    { id: 'naf-building', label: 'Building No'  },
];

export function validateNewAddressForm() {
    let valid = true;

    ADDRESS_FIELDS.forEach(({ id }) => {
        const el = document.getElementById(id);
        if (!el) return;

        const empty = !el.value.trim();

        if (empty) {
            el.classList.add('error');
            valid = false;
            // Self-cleaning: remove error class as soon as the user fills the field
            el.addEventListener('change', () => {
                if (el.value.trim()) el.classList.remove('error');
            }, { once: true });
        } else {
            el.classList.remove('error');
        }
    });

    return valid;
}