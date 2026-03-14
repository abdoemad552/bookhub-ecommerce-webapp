// DOM helper
export const $ = id => document.getElementById(id);

// Field feedback
export function markField(id, state) {
    const el = $(id);
    if (!el) return;
    el.classList.remove('is-valid', 'is-invalid');
    if (state === 'ok') el.classList.add('is-valid');
    if (state === 'bad') el.classList.add('is-invalid');
}

export function showAlert(msg) {
    $('js-alert-text').textContent = msg;
    $('js-alert').style.display = 'flex';
    $('js-alert').scrollIntoView({behavior: 'smooth', block: 'nearest'});
}

export function hideAlert() {
    $('js-alert').style.display = 'none';
}

export function setHint(hintElem, hintMessage) {
    hintElem.innerHTML =
        `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
             width="16" height="16">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <span>${hintMessage}</span>`;
    hintElem.classList.add('hint-error');
    hintElem.classList.remove('hint-success');
}

export function removeHint(hintElem) {
    hintElem.innerHTML = '';
    hintElem.classList.add('hint-success');
    hintElem.classList.remove('hint-error');
}