import { $, markField, setHint, removeHint } from './util.js';

export let currentStep = 1;
const TOTAL_STEPS = 3;

// Step navigation
export function goToStep(step, direction) {
    $('panel-' + currentStep).classList.remove('active');
    const panel = $('panel-' + step);
    panel.classList.remove('going-back');
    if (direction === 'back') panel.classList.add('going-back');
    panel.classList.add('active');
    currentStep = step;
    updateStepUI();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

export function updateStepUI() {
    for (let n = 1; n <= TOTAL_STEPS; n++) {
        const item = $('si-' + n);
        if (!item) continue;
        item.classList.remove('active', 'done');
        if (n === currentStep) item.classList.add('active');
        if (n < currentStep)   item.classList.add('done');

        const dot = $('sd-' + n);
        if (n < currentStep) {
            dot.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"/></svg>`;
        } else {
            dot.textContent = n;
        }
    }
    // Fill connectors for completed steps
    for (let n = 1; n < TOTAL_STEPS; n++) {
        $('sc-' + n)?.classList.toggle('filled', currentStep > n);
    }
}

// Validations
export function validateStep1() {
    let ok = true;
    const fn = $('firstName').value.trim();
    if (!fn) {
        markField('firstName', 'bad');
        ok = false;
    } else markField('firstName', 'ok');

    const ln = $('lastName').value.trim();
    if (!ln) {
        markField('lastName', 'bad');
        ok = false;
    } else markField('lastName', 'ok');

    const bd = $('birthDate').value;
    if (bd) {
        const age = Math.floor((Date.now() - new Date(bd)) / (365.25 * 24 * 3600 * 1000));
        if (age < 18) {
            markField('birthDate', 'bad');
            ok = false;
            setHint($('hint-birthDate'), 'Must be 18+ years');
        } else {
            markField('birthDate', 'ok');
            removeHint($('hint-birthDate'));
        }
    }
    return ok;
}

export function validateStep2() {
    let ok = true;
    const un = $('username').value.trim();
    if (!/^[a-zA-Z0-9_]{3,20}$/.test(un)) {
        markField('username', 'bad');
        ok = false;
    }

    const em = $('email').value.trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(em)) {
        markField('email', 'bad');
        ok = false;
    }

    const pw = $('password').value;
    if (pw.length < 8) {
        markField('password', 'bad');
        ok = false;
    }

    const cp = $('confirmPassword').value;
    if (cp !== pw || !cp) {
        markField('confirmPassword', 'bad');
        ok = false;
    }

    return ok;
}

// Password strength
export function calcStrength(pw) {
    let s = 0;
    if (pw.length >= 8) s++;
    if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) s++;
    if (/\d/.test(pw) && /[^A-Za-z0-9]/.test(pw)) s++;
    return Math.min(3, s);
}

// Check matching passwords
export function checkConfirm() {
    const pw = $('password').value, cp = $('confirmPassword').value;
    if (!cp) {
        markField('confirmPassword', null);
        return;
    }
    const ok = pw === cp;
    markField('confirmPassword', ok ? 'ok' : 'bad');

    const hint = $('hint-confirm');
    if (!ok) {
        setHint(hint, 'Not matched');
    } else {
        removeHint(hint);
    }
}