/**
 * orderConfirmation.js
 *
 * Compatible with OrderServlet GET /order response shape:
 * {
 *   subtotal: number,
 *   shipping: number,
 *   limit:    number,
 *   items: [{ bookId, title, quantity, price }]
 * }
 *
 * Structure mirrors checkout.js:
 *   readMeta()        — reads static JSP EL data from #oc-meta (address, orderId)
 *   render*()         — pure DOM writers, no fetch calls
 *   fetchOrder()      — fetches items + summary from GET /order
 *   fetchStatus()     — fetches live order status from GET /order-status
 *   init()            — orchestrator: renders static data immediately,
 *                       then fires fetchOrder + fetchStatus in parallel
 */

import { initHeader } from '../common/header.js';

// ─── DOM helper ───────────────────────────────────────────────────────────────

const $ = id => document.getElementById(id);

// ─── Constants ────────────────────────────────────────────────────────────────

const meta       = $('oc-meta');
const CONTEXT    = meta?.dataset.context ?? '/ecommerce';
const ORDER_URL  = CONTEXT + '/order';        // GET — returns items + summary
const STATUS_URL = CONTEXT + '/order-status'; // GET ?orderId=X — returns { status }

// ─── Formatter ────────────────────────────────────────────────────────────────

const fmt = new Intl.NumberFormat('en-EG', {
    style: 'currency', currency: 'EGP', minimumFractionDigits: 2,
}).format;

// ─── Data reader (static — no network) ───────────────────────────────────────

/**
 * Reads address + orderId from the hidden #oc-meta element
 * populated by JSP EL on page load.
 * Items and totals come from fetchOrder() instead.
 */
function readMeta() {
    if (!meta) return null;
    return {
        orderId: meta.dataset.orderId || '—',
        address: {
            type:        meta.dataset.addressType        || '',
            street:      meta.dataset.addressStreet      || '',
            buildingNo:  meta.dataset.addressBuilding    || '',
            city:        meta.dataset.addressCity        || '',
            government:  meta.dataset.addressGovernment  || '',
            description: meta.dataset.addressDescription || '',
        },
    };
}

// ─── Async fetches ────────────────────────────────────────────────────────────

/**
 * Fetches the full order from OrderServlet.
 * Returns: { subtotal, shipping, limit, items: [{ bookId, title, quantity, price }] }
 */
async function fetchOrder() {
    try {
        const res = await fetch(ORDER_URL, { method: 'GET', credentials: 'include' });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return await res.json();
    } catch (err) {
        console.error('Failed to fetch order:', err);
        return null;
    }
}

/**
 * Fetches live order status.
 * Returns one of: "confirmed" | "processing" | "delivered"
 */
async function fetchStatus(orderId) {
    try {
        const res = await fetch(
            `${STATUS_URL}?orderId=${encodeURIComponent(orderId)}`,
            { method: 'GET', credentials: 'include' }
        );
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const data = await res.json();
        return data.status ?? 'confirmed';
    } catch (err) {
        console.error('Failed to fetch order status:', err);
        return 'confirmed'; // safe fallback
    }
}

// ─── Render: hero ─────────────────────────────────────────────────────────────

function renderHero(orderId) {
    $('oc-order-id').textContent = `#${orderId}`;
}

// ─── Render: address ─────────────────────────────────────────────────────────

const ADDRESS_ICONS = {
    Home: `<svg viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2
                 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5
                 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13
                 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z"/>
    </svg>`,
    Work: `<svg viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M6.5 1A1.5 1.5 0 0 0 5 2.5V3H1.5A1.5 1.5 0 0 0 0 4.5v8A1.5 1.5 0 0 0 1.5
                 14h13a1.5 1.5 0 0 0 1.5-1.5v-8A1.5 1.5 0 0 0 14.5 3H11v-.5A1.5 1.5 0 0 0
                 9.5 1zm0 1h3a.5.5 0 0 1 .5.5V3H6v-.5a.5.5 0 0 1 .5-.5m1.886 6.914L15
                 7.151V12.5a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5V7.15l6.614 1.764a1.5 1.5
                 0 0 0 .772 0M1.5 4h13a.5.5 0 0 1 .5.5v1.616L8.129 7.948a.5.5 0 0
                 1-.258 0L1 6.116V4.5a.5.5 0 0 1 .5-.5"/>
    </svg>`,
    Shipping: `<svg viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M0 3.5A1.5 1.5 0 0 1 1.5 2h9A1.5 1.5 0 0 1 12 3.5V5h1.02a1.5 1.5 0 0 1
                 1.17.563l1.481 1.85a1.5 1.5 0 0 1 .329.938V10.5a1.5 1.5 0 0 1-1.5
                 1.5H14a2 2 0 1 1-4 0H5a2 2 0 1 1-3.998-.085A1.5 1.5 0 0 1 0 10.5z"/>
    </svg>`,
    Online: `<svg viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8m7.5-6.923c-.67.204-1.335.82-1.887
                 1.855q-.215.403-.395.872c.705.157 1.472.257 2.282.287z"/>
    </svg>`,
};

function renderAddress(addr) {
    const icon = ADDRESS_ICONS[addr.type] ?? ADDRESS_ICONS.Home;
    $('oc-address').innerHTML = `
        <div class="oc-address__icon">${icon}</div>
        <div class="oc-address__body">
            <div class="oc-address__type">${addr.type}</div>
            <div class="oc-address__line">
                ${addr.street}, Bldg ${addr.buildingNo} — ${addr.city}
            </div>
            <div class="oc-address__sub">
                ${addr.government}${addr.description ? ' · ' + addr.description : ''}
            </div>
        </div>`;
}

// ─── Render: items + summary ─────────────────────────────────────────────────

const BOOK_ICON = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
</svg>`;

/** Renders item list skeleton while fetch is in-flight */
function renderItemsSkeleton() {
    $('oc-items-list').innerHTML = `
        <li class="oc-item-skeleton"></li>
        <li class="oc-item-skeleton" style="opacity:.6;"></li>
        <li class="oc-item-skeleton" style="opacity:.35;"></li>`;
}

/**
 * Renders items from the OrderServlet JSON.
 * item shape: { bookId, title, quantity, price }
 */
function renderItems(order) {
    const list = $('oc-items-list');

    if (!order || !order.items || order.items.length === 0) {
        list.innerHTML = `
            <li class="oc-item" style="justify-content:center;
                color:var(--muted-foreground);font-size:13px;padding:20px;">
                No items found.
            </li>`;
        return;
    }

    list.innerHTML = order.items.map(item => `
        <li class="oc-item">
            <div class="oc-item__icon">${BOOK_ICON}</div>
            <div class="oc-item__body">
                <div class="oc-item__title" title="${item.title}">${item.title}</div>
                <div class="oc-item__qty">
                    Qty ${item.quantity} &times; ${fmt(item.price)}
                </div>
            </div>
            <div class="oc-item__total">${fmt(item.price * item.quantity)}</div>
        </li>`).join('');

    // Summary — use values from the server, not recalculated
    $('oc-subtotal').textContent = fmt(order.subtotal);
    $('oc-shipping').textContent = order.shipping === 0 ? 'Free' : fmt(order.shipping);
    $('oc-total').textContent    = fmt(order.subtotal + order.shipping);
}

// ─── Render: status tracker ───────────────────────────────────────────────────

const STATUS_MAP = {
    confirmed:  { done: [],                                  active: 'ots-confirmed'  },
    processing: { done: ['ots-confirmed'],                   active: 'ots-processing' },
    delivered:  { done: ['ots-confirmed', 'ots-processing'], active: 'ots-delivered'  },
};

const LINE_MAP = {
    confirmed:  [],
    processing: ['otl-1'],
    delivered:  ['otl-1', 'otl-2'],
};

function renderStatus(statusRaw) {
    const status  = (statusRaw ?? '').toLowerCase().trim();
    const mapping = STATUS_MAP[status] ?? STATUS_MAP.confirmed;
    const lines   = LINE_MAP[status]   ?? [];

    mapping.done.forEach(id => $(id)?.classList.add('done'));
    $(mapping.active)?.classList.add('active');
    lines.forEach(id => $(id)?.classList.add('filled'));

    // Swap skeleton → tracker
    $('oc-status-skeleton').classList.add('hidden');
    $('oc-tracker').classList.add('visible');
}

// ─── Init ─────────────────────────────────────────────────────────────────────

async function init() {
    initHeader();

    const data = readMeta();
    if (!data) return;

    // Render static data immediately — no network wait
    renderHero(data.orderId);
    renderAddress(data.address);

    // Show item skeletons while fetching
    renderItemsSkeleton();

    // Fire both requests in parallel — neither blocks the other
    const [order, status] = await Promise.all([
        fetchOrder(),
        fetchStatus(data.orderId),
    ]);

    renderItems(order);
    renderStatus(status);
}

document.addEventListener('DOMContentLoaded', init);