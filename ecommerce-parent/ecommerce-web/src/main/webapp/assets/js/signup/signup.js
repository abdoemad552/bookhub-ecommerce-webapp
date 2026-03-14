import {$, showAlert, hideAlert, markField, setHint, removeHint, getCatIcon} from './util.js';
import {validateStep1, validateStep2, goToStep, updateStepUI, calcStrength, checkConfirm, currentStep} from './formValidation.js';

// Global variables
const CONTEXT = document.querySelector('meta[name="ctx"]').content;
const LOGIN = CONTEXT + '/login';
const SIGNUP = CONTEXT + '/signup';
const CHECK_AVAILABILITY = CONTEXT + '/checkAvailability';
const CATEGORIES_URL = CONTEXT + '/categories';

// Load categories via AJAX when step 3 becomes visible
let categoriesLoaded = false;

async function loadCategories() {
    if (categoriesLoaded) return;
    const grid = $('category-grid');

    try {
        const res = await fetch(CATEGORIES_URL, {
            headers: {'X-Requested-With': 'XMLHttpRequest'}
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const categories = await res.json(); // expected: [{id, name}, ...]

        grid.innerHTML = ''; // clear skeletons

        if (!categories.length) {
            grid.innerHTML = '<div class="cat-load-error">No categories available yet.</div>';
            categoriesLoaded = true;
            return;
        }

        categories.forEach(cat => {
            const icon = getCatIcon(cat.name);
            const card = document.createElement('div');
            card.className = 'category-card';
            card.innerHTML = `
                <input type="checkbox" id="cat-${cat.id}" name="categoryIds" value="${cat.id}">
                <label class="category-label" for="cat-${cat.id}">
                    <span class="cat-icon">${icon}</span>
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

// Password visibility toggle
const S_COLORS = ['#ef4444', '#eab308', '#22c55e'];
const S_LABELS = ['Fair', 'Good', 'Strong'];
const EYE_OPEN = '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>';
const EYE_CLOSE = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-10-8-10-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 10 8 10 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';

export function togglePw(id, btn) {
    const input = $(id), isText = input.type === 'text';
    input.type = isText ? 'password' : 'text';
    btn.style.opacity = isText ? '1' : '0.55';
    $('eye-' + id).innerHTML = isText ? EYE_OPEN : EYE_CLOSE;
}
// Make it globally accessible in inline attributes
window.togglePw = togglePw;

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
$('password').addEventListener('input', function () {
    const pw = this.value, score = pw.length ? calcStrength(pw) : 0;
    ['seg1', 'seg2', 'seg3'].forEach((sid, i) =>
        $(sid).style.background = i < score ? S_COLORS[score - 1] : '');
    if (!pw) {
        markField('password', null);
    } else {
        const ok = score >= 1;
        markField('password', ok ? 'ok' : 'bad');

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
            markField('username', 'ok');
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
            markField('email', 'ok');
            removeHint(hint);
        }
    } catch (err) {
        console.error('Network error checking email availability:', err);
    }
});