import {$} from "../util.js";
import {showAlert} from "../signup/util.js"
import {appendNewAddressCard, hideNewAddressPanel, createPopup, openPopup, getAddressIcon, restoreSaveBtn} from "./checkoutUtil.js"

const CONTEXT = '/ecommerce';
const ADDRESSES_URL = CONTEXT + '/address';

let addressesData = [];

// Load addresses
async function loadAddresses() {
    const grid = $('address-grid');

    try {
        const res = await fetch(ADDRESSES_URL, {
            cache: "no-store",
            headers: {'X-Requested-With': 'XMLHttpRequest'}
        });

        if (!res.ok) console.log(Error('HTTP ' + res.status));

        const addresses = await res.json();
        addressesData = addresses;

        grid.innerHTML = '';

        addresses.forEach(add => {
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

            // Trigger popup on radio selection clicking
            card.querySelector('input[type="radio"]').addEventListener('click', () => {
                const addr = addressesData.find(a => a.id === add.id);
                if(add.addressType === 'Online') return;
                hideNewAddressPanel();
                setTimeout(() => {
                    if (addr) openPopup(addr);
                }, 250);
            });

            grid.appendChild(card);
        });

        appendNewAddressCard();

    } catch (err) {
        console.error('Failed to load addresses:', err);
        appendNewAddressCard();
    }
}

// Form validation
function validateNewAddressForm() {
    const required = [
        { id: 'naf-type',     errId: 'err-type',      label: 'Address Type', isSelect: true  },
        { id: 'naf-gov',      errId: 'err-gov',       label: 'Governorate',  isSelect: true  },
        { id: 'naf-city',     errId: 'err-city',      label: 'City'                          },
        { id: 'naf-street',   errId: 'err-street',    label: 'Street'                        },
        { id: 'naf-building', errId: 'err-building',  label: 'Building No'                   },
    ];

    let valid = true;

    required.forEach(({ id, errId, label, isSelect }) => {
        const el  = document.getElementById(id);

        const empty = !el.value.trim() || el.value === '';

        if (empty) {
            el.classList.add('error');
            valid = false;

            el.addEventListener('change', () => {
                if (el.value.trim()) {
                    el.classList.remove('error');
                }
            }, { once: true });
        } else {
            el.classList.remove('error');
        }
    });

    return valid;
}

// Save new address
async function saveNewAddress() {
    if (!validateNewAddressForm()) return;

    const btn = document.getElementById('naf-save-btn');
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
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString(),
        });

        if (!res.ok) console.log('HTTP ' + res.status);
        const saved = await res.json();

        // Render all cards again
        if (saved.success) {
            await loadAddresses();

            // Auto select the new saved address
            const newAddr = addressesData.find(a =>
                a.city === params.get('city') &&
                a.street === params.get('street') &&
                a.buildingNo === params.get('buildingNo')
            );
            hideNewAddressPanel();
            if (newAddr && newAddr.addressType !== 'Online') {
                openPopup(newAddr);
            }
        }else{
            showAlert(saved.message);
        }
        restoreSaveBtn();

    } catch (err) {
        console.error('Failed to save address:', err);
        restoreSaveBtn();
    }
}

// Init
export function initAddresses(){
    loadAddresses();
    createPopup();
    document.getElementById('naf-save-btn').addEventListener('click', saveNewAddress);
}