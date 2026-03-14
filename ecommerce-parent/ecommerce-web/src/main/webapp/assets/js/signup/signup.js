// Utilities
const $ = id => document.getElementById(id);

function markField(id, state) {
    const el = $(id);
    if (!el) return;
    el.classList.remove('is-valid', 'is-invalid');
    if (state === 'ok') el.classList.add('is-valid');
    if (state === 'bad') el.classList.add('is-invalid');
}

function showAlert(msg) {
    $('js-alert-text').textContent = msg;
    $('js-alert').style.display = 'flex';
    $('js-alert').scrollIntoView({behavior: 'smooth', block: 'nearest'});
}

function hideAlert() {
    $('js-alert').style.display = 'none';
}

// Step navigation
let currentStep = 1;

function goToStep(step, direction) {
    const leaving = currentStep, arriving = step;

    // Hide current panel
    $('panel-' + leaving).classList.remove('active');

    // Determine animation direction
    const panel = $('panel-' + arriving);
    panel.classList.remove('going-back');
    if (direction === 'back') panel.classList.add('going-back');
    panel.classList.add('active');

    currentStep = arriving;
    hideAlert();
    updateStepUI();
    window.scrollTo({top: 0, behavior: 'smooth'});
}

function updateStepUI() {
    // Step items
    [1, 2].forEach(n => {
        const item = $('si-' + n);
        item.classList.remove('active', 'done');
        if (n === currentStep) item.classList.add('active');
        if (n < currentStep) item.classList.add('done');

        // Replace number with checkmark when done
        const dot = $('sd-' + n);
        if (n < currentStep) {
            dot.innerHTML = `<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"/></svg>`;
        } else {
            dot.textContent = n;
        }
    });

    // Connector fill
    if (currentStep > 1) $('sc-1').classList.add('filled');
    else $('sc-1').classList.remove('filled');
}

// Step 1 validation — runs on "Continue" click
function validateStep1() {
    let ok = true;

    const fn = $('firstName').value.trim();
    if (!fn) {
        markField('firstName', 'bad');
        ok = false;
    } else {
        markField('firstName', 'ok');
    }

    const ln = $('lastName').value.trim();
    if (!ln) {
        markField('lastName', 'bad');
        ok = false;
    } else {
        markField('lastName', 'ok');
    }

    const bd = $('birthDate').value;
    if (bd) {
        const age = Math.floor((Date.now() - new Date(bd)) / (365.25 * 24 * 3600 * 1000));
        if (age < 18) {
            markField('birthDate', 'bad');
            ok = false;
        } else {
            markField('birthDate', 'ok');
        }
    }

    return ok;
}

// Step 2 validation — runs on submit
function validateStep2() {
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
    if (pw !== cp || !cp) {
        markField('confirmPassword', 'bad');
        ok = false;
    }

    return ok;
}

// Button wiring
$('btn-next').addEventListener('click', () => {
    hideAlert();
    if (!validateStep1()) {
        showAlert('Please fix the errors bellow.');
        return;
    }
    goToStep(2, 'forward');
});

$('btn-back').addEventListener('click', () => {
    goToStep(1, 'back');
});

// Form submit guard
$('signup-form').addEventListener('submit', function (e) {
    hideAlert();
    if (!validateStep2()) {
        e.preventDefault();
        showAlert('Please fix the errors bellow.');
        return;
    }
    // Show loading state
    $('submit-btn').disabled = true;
    $('submit-btn').classList.add('is-loading');
});

// Password visibility toggle
const EYE_OPEN = '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>';
const EYE_CLOSE = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-10-8-10-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 10 8 10 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';

function togglePw(id, btn) {
    const input = $(id), isText = input.type === 'text';
    input.type = isText ? 'password' : 'text';
    btn.style.opacity = isText ? '1' : '0.55';
    $('eye-' + id).innerHTML = isText ? EYE_OPEN : EYE_CLOSE;
}

// Live field feedback (step 2)
const S_COLORS = ['#ef4444', '#f97316', '#eab308', '#22c55e'];
const S_LABELS = ['Fair', 'Good', 'Strong'];

function calcStrength(pw) {
    let s = 0;
    if (pw.length >= 8) s++;
    if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) s++;
    if (/\d/.test(pw) && /[^A-Za-z0-9]/.test(pw)) s++;
    return Math.min(3, s);
}

$('password').addEventListener('input', function () {
    const pw = this.value, score = pw.length ? calcStrength(pw) : 0;
    ['seg1', 'seg2', 'seg3'].forEach((sid, i) =>
        $(sid).style.background = i < score ? S_COLORS[score - 1] : '');
    if (!pw) {
        markField('password', null);
    } else {
        const ok = score >= 1;
        markField('password', ok ? 'ok' : 'bad');
    }
    checkConfirm();
});

function checkConfirm() {
    const pw = $('password').value, cp = $('confirmPassword').value;
    if (!cp) {
        markField('confirmPassword', null);
        return;
    }
    const ok = pw === cp;
    markField('confirmPassword', ok ? 'ok' : 'bad');
}

$('confirmPassword').addEventListener('input', checkConfirm);

$('username').addEventListener('input', function () {
    const val = this.value;
    if (!val) {
        markField('username', null);
        return;
    }
    const ok = /^[a-zA-Z0-9_]{3,20}$/.test(val);
    markField('username', ok ? 'ok' : 'bad');
});

$('email').addEventListener('input', function () {
    const val = this.value.trim();
    if (!val) {
        markField('email', null);
        return;
    }
    const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
    markField('email', ok ? 'ok' : 'bad');
});

// Check username availability
$('username').addEventListener('blur', function () {
    const val = this.value.trim();
    const hint = $('hint-username');

    if (!val || !/^[a-zA-Z0-9_]{3,20}$/.test(val)) return;

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/ecommerce/checkAvailability', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function () {
        if (xhr.status === 200) {
            const data = JSON.parse(xhr.responseText);
            if (!data.available) {
                if (!data.available) {
                    markField('username', 'bad');

                    hint.innerHTML =
                        `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             width="16" height="16">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        <span>Username is already taken</span>`;

                    hint.classList.add('hint-error');
                    hint.classList.remove('hint-success');
                }
            } else {
                markField('username', 'ok');
                hint.textContent = '';
                hint.classList.remove('hint-error', 'hint-success');
            }
        } else {
            console.error('Error checking username availability');
        }
    };

    xhr.send('username=' + encodeURIComponent(val));
});

// Check email availability
$('email').addEventListener('blur', function () {
    const val = this.value.trim();
    const hint = $('hint-email'); // make sure this div exists under the email field

    if (!val || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) return;

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/ecommerce/checkAvailability', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function () {
        if (xhr.status === 200) {
            const data = JSON.parse(xhr.responseText);
            if (!data.available) {
                markField('email', 'bad');

                hint.innerHTML =
                    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                             width="16" height="16">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        <span>Email address already exists</span>`;

                hint.classList.add('hint-error');
                hint.classList.remove('hint-success');
            } else {
                markField('email', 'ok');
                hint.textContent = '';
                hint.classList.remove('hint-error', 'hint-success');
            }
        } else {
            console.error('Error checking email availability');
        }
    };

    xhr.send('email=' + encodeURIComponent(val));
});