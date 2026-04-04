import {$, showAlert, hideAlert, markField, setHint, removeHint, togglePw} from './util.js';
import {validateStep1, validateStep2, goToStep, calcStrength, checkConfirm} from './formValidation.js';

// Global variables
const CONTEXT = '/ecommerce';
const LOGIN = CONTEXT + '/login';
const SIGNUP = CONTEXT + '/signup';
const CHECK_AVAILABILITY = CONTEXT + '/checkAvailability';
const CATEGORIES_URL = CONTEXT + '/categories';

// Password visibility toggle (Make it globally accessible in inline attributes)
window.togglePw = togglePw;

// Load categories via AJAX when step 3 becomes visible
let categoriesLoaded = false;

async function loadCategories() {
    if (categoriesLoaded) return;
    const grid = $('category-grid');

    try {
        const res = await fetch(CATEGORIES_URL, {
            cache: "no-store",
            headers: {'X-Requested-With': 'XMLHttpRequest'}
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const categories = await res.json();

        // clear skeletons
        grid.innerHTML = '';

        if (!categories.length) {
            grid.innerHTML = '<div class="cat-load-error">No categories available yet.</div>';
            categoriesLoaded = true;
            return;
        }

        categories.forEach(cat => {
            const card = document.createElement('div');
            card.className = 'category-card';
            card.innerHTML = `
                <input type="checkbox" id="cat-${cat.id}" name="categoryIds" value="${cat.id}">
                <label class="category-label" for="cat-${cat.id}">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-6 h-6 text-primary" aria-hidden="true">
                        <path d="M12 7v14"></path>
                        <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                    </svg>
                    <span class="cat-name">${cat.name}</span>
                </label>
                <div class="category-check">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                </div>`;
            // Update selected count on toggle
            card.querySelector('input').addEventListener('change', updateSelectedCount);
            grid.appendChild(card);
        });

        categoriesLoaded = true;
        updateSelectedCount();

    } catch (err) {
        console.error('Failed to load categories:', err);
        grid.innerHTML = `<div class="cat-load-error">
            Could not load categories. You can skip this step and update later.
        </div>`;
    }
}

function updateSelectedCount() {
    const checked = document.querySelectorAll('#category-grid input[type="checkbox"]:checked').length;
    const numEl = $('selected-num');
    if (numEl) numEl.textContent = checked;
}

// Step 1 → 2
$('btn-next-1').addEventListener('click', () => {
    hideAlert();
    if (!validateStep1()) {
        showAlert('Please fix the errors below.');
        return;
    }
    goToStep(2, 'forward');
});

// Step 2 back → 1
$('btn-back-2').addEventListener('click', () => goToStep(1, 'back'));

// Step 2 → 3
$('btn-next-2').addEventListener('click', () => {
    hideAlert();
    if (!validateStep2()) {
        showAlert('Please fix the errors below.');
        return;
    }
    goToStep(3, 'forward');

    // lazy-load only when user actually reaches step 3
    loadCategories();
});

// Step 3 back → 2
$('btn-back-3').addEventListener('click', () => goToStep(2, 'back'));

// AJAX form submit
$('signup-form').addEventListener('submit', async function (e) {
    e.preventDefault();
    hideAlert();

    const submitBtn = $('submit-btn');
    submitBtn.disabled = true;
    submitBtn.classList.add('is-loading');

    try {
        const formData = new FormData(this);
        const params = new URLSearchParams(formData);

        const response = await fetch(SIGNUP, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: params,
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
            window.location.href = LOGIN;
        }
    } catch (err) {
        submitBtn.disabled = false;
        submitBtn.classList.remove('is-loading');
        showAlert('Network error. Please check your connection.');
        console.error('Submit error:', err);
    }
});

// Live field feedback
const S_COLORS = ['#ef4444', '#eab308', '#22c55e'];
$('password').addEventListener('input', function () {
    const pw = this.value, score = pw.length ? calcStrength(pw) : 0;
    ['seg1', 'seg2', 'seg3'].forEach((sid, i) =>
        $(sid).style.background = i < score ? S_COLORS[score - 1] : '');
    if (!pw) {
        markField('password', null);
    } else {
        const ok = score >= 1;
        markField('password', ok ? null : 'bad');

        const hint = $('hint-password');
        if (!ok) {
            setHint(hint, 'At least 8 characters');
        } else {
            removeHint(hint);
        }
    }
    checkConfirm();
});

$('confirmPassword').addEventListener('input', checkConfirm);

$('username').addEventListener('input', function () {
    const val = this.value;
    if (!val) {
        markField('username', null);
        return;
    }
    const ok = /^[a-zA-Z0-9_]{3,20}$/.test(val);
    markField('username', ok ? 'ok' : 'bad');

    const hint = $('hint-username');
    if (!ok) {
        setHint(hint, '3-20 letters, numbers and _ only');
    } else {
        removeHint(hint);
    }
});

$('email').addEventListener('input', function () {
    const val = this.value.trim();
    if (!val) {
        markField('email', null);
        return;
    }
    const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
    markField('email', ok ? 'ok' : 'bad');

    const hint = $('hint-email');
    if (!ok) {
        setHint(hint, 'Invalid Email Address Formate');
    } else {
        removeHint(hint);
    }
});

$('creditCardLimit').addEventListener('input', function () {
    const val = this.value.trim();

    const MAX_LONG = 9223372036854775807n; // BigInt
    let ok = false;

    if (val !== '' && /^\d+$/.test(val)) {
        try {
            const num = BigInt(val);
            ok = num >= 0n && num <= MAX_LONG;
        } catch {
            ok = false;
        }
    }

    const hint = $('hint-creditLimit');
    if (!ok) {
        setHint(hint, 'Invalid Credit Limit');
    } else {
        removeHint(hint);
    }
});

// Check username availability
$('username').addEventListener('blur', async function () {
    const val = this.value.trim();
    const hint = $('hint-username');

    if (!val || !/^[a-zA-Z0-9_]{3,20}$/.test(val)) {
        return;
    }

    const param = new URLSearchParams({username: val});
    try {
        const response = await fetch(CHECK_AVAILABILITY, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: param
        });

        if (!response.ok) {
            console.error('Error checking username availability');
            return;
        }

        const data = await response.json();
        if (!data.available) {
            markField('username', 'bad');
            setHint(hint, 'Username already taken');
        } else {
            markField('username', null);
            removeHint(hint);
        }
    } catch (err) {
        console.error('Network error checking username availability:', err);
    }
});

// Check email availability
$('email').addEventListener('blur', async function () {
    const val = this.value.trim();
    const hint = $('hint-email');

    if (!val || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
        return;
    }

    const param = new URLSearchParams({email: val});
    try {
        const response = await fetch(CHECK_AVAILABILITY, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: param
        });

        if (!response.ok) {
            console.error('Error checking email availability');
            return;
        }

        const data = await response.json();
        if (!data.available) {
            markField('email', 'bad');
            setHint(hint, 'Email address already exists');
        } else {
            markField('email', null);
            removeHint(hint);
        }
    } catch (err) {
        console.error('Network error checking email availability:', err);
    }
});

// Disable Key (Enter) from submitting the form
$('signup-form').addEventListener('keydown', e => {
    if (e.key === 'Enter') e.preventDefault();
});