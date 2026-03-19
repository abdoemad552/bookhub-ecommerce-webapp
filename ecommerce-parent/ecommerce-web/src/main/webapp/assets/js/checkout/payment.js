// /**
//  * payment.js
//  *
//  * Handles Step 2 (Payment) of the checkout flow.
//  * Import and call initPayment() from checkout.js after the page loads.
//  */
//
// const fmt = new Intl.NumberFormat('en-EG', {
//     style: 'currency', currency: 'EGP', minimumFractionDigits: 2,
// });
//
// function readMeta() {
//     const el = document.getElementById('pay-meta');
//     if (!el) return null;
//     const n = (attr) => parseFloat(el.dataset[attr]) || 0;
//     return {
//         limit:    n('limit'),
//         used:     n('used'),
//         subtotal: n('subtotal'),
//         shipping: n('shipping'),
//         lastFour: el.dataset.lastFour || '----',
//         holder:   el.dataset.holder   || 'CARD HOLDER',
//         network:  (el.dataset.network || 'VISA').toUpperCase(),
//     };
// }
//
// function buildNetworkLogo(network) {
//     if (network === 'MASTERCARD' || network === 'MC') {
//         return `<div class="pay-card__network-circles"><span></span><span></span></div>`;
//     }
//     return `<span class="pay-card__visa-text">VISA</span>`;
// }
//
// export function initPayment() {
//     const data = readMeta();
//     if (!data) return;
//
//     const available = data.limit - data.used;
//     const total     = data.subtotal + data.shipping;
//     const enough    = available >= total;
//     const usedPct   = Math.min((data.used / data.limit) * 100, 100);
//
//     // ── Credit card visuals ───────────────────────────────────────────────
//     const card = document.getElementById('pay-card');
//     document.getElementById('pay-card-network').innerHTML = buildNetworkLogo(data.network);
//     document.getElementById('pay-card-number').textContent = `•••• •••• •••• ${data.lastFour}`;
//     document.getElementById('pay-card-holder').textContent = data.holder.toUpperCase();
//     document.getElementById('pay-card-avail').textContent  = fmt.format(available);
//
//     // Animate bar after card appears
//     setTimeout(() => {
//         document.getElementById('pay-card-bar').style.width = usedPct + '%';
//     }, 350);
//
//     if (available / data.limit < 0.20) card.classList.add('pay-card--danger');
//
//     // ── Breakdown ─────────────────────────────────────────────────────────
//     document.getElementById('pay-subtotal-val').textContent = fmt.format(data.subtotal);
//
//     const shipEl = document.getElementById('pay-shipping-val');
//     shipEl.textContent = data.shipping === 0 ? 'Free' : fmt.format(data.shipping);
//
//     document.getElementById('pay-total-val').textContent = fmt.format(total);
//
//     const availEl = document.getElementById('pay-avail-val');
//     availEl.textContent = fmt.format(available);
//     if (!enough) availEl.style.color = '#dc2626';
//
//     // ── Status badge ──────────────────────────────────────────────────────
//     const statusEl = document.getElementById('pay-status');
//     const iconEl   = document.getElementById('pay-status-icon');
//     const textEl   = document.getElementById('pay-status-text');
//
//     statusEl.style.display = 'flex';
//
//     const okIcon = `<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
//          stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
//          <polyline points="20 6 9 17 4 12"/></svg>`;
//
//     const errIcon = `<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
//          stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
//          <circle cx="12" cy="12" r="10"/>
//          <line x1="12" y1="8" x2="12" y2="12"/>
//          <line x1="12" y1="16" x2="12.01" y2="16"/></svg>`;
//
//     if (enough) {
//         statusEl.className  = 'pay-status pay-status--ok';
//         iconEl.innerHTML    = okIcon;
//         textEl.textContent  = `Your credit limit covers this order. You're good to go!`;
//         document.getElementById('btn-next-2').disabled = false;
//     } else {
//         statusEl.className = 'pay-status pay-status--err';
//         iconEl.innerHTML   = errIcon;
//         const shortfall    = fmt.format(total - available);
//         textEl.textContent = `Insufficient credit. You need ${shortfall} more to complete this order.`;
//         document.getElementById('btn-next-2').disabled = true;
//     }
// }
