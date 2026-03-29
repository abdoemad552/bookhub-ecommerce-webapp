import { $ } from './checkoutUtil.js';
import { showAlert } from "../signup/util.js";

// Step 1: Shipping address
export function validateStep1() {
    const checked = document.querySelector('#address-grid input[type="radio"]:checked');
    if (!checked || checked.value === '__new__') return false;
    return true;
}

// Step 2: Payment
export function readPaymentMeta(summary) {
    const el = $('pay-meta');
    if (!el) return null;

    const n    = attr => parseFloat(el.dataset[attr]) || 0;
    const base = {
        used:     n('used'),
        lastFour: el.dataset.lastFour || '----',
        holder:   el.dataset.holder   || 'CARD HOLDER',
        network:  (el.dataset.network || 'VCARD').toUpperCase(),
    };

    try {
        if (summary.error != null) {
            console.warn(summary.error);
            showAlert('Something went wrong, please try again.');
            return { ...base, subtotal: '--', shipping: '--' , limit: '--'};
        }
        return { ...base, subtotal: summary.subtotal, shipping: summary.shipping, limit: summary.limit};
    } catch (err) {
        console.error(err);
        return { ...base, subtotal: '--', shipping: '--' };
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
            el.addEventListener('change', () => {
                if (el.value.trim()) el.classList.remove('error');
            }, { once: true });
        } else {
            el.classList.remove('error');
        }
    });

    return valid;
}