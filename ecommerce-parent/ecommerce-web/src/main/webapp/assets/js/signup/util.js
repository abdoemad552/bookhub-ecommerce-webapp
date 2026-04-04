// DOM helper
export const $ = id => document.getElementById(id);

// Password visibility toggle
const EYE_OPEN = '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>';
const EYE_CLOSE = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-10-8-10-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 10 8 10 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';

export function togglePw(id, btn) {
    const input = $(id), isText = input.type === 'text';
    input.type = isText ? 'password' : 'text';
    btn.style.opacity = isText ? '1' : '0.55';
    $('eye-' + id).innerHTML = isText ? EYE_OPEN : EYE_CLOSE;
}

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