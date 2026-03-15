import {$, showAlert, hideAlert} from '../signup/util.js';

// Global variables
const CONTEXT = '/ecommerce';
const LOGIN = CONTEXT + '/login';
const HOME = CONTEXT + '/home';

const username = $('username');
const password = $('password');

// Password visibility toggle
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

$('login-form').addEventListener('submit', async function(e){
    e.preventDefault();
    hideAlert();

    const submitBtn = $('submit-btn');
    submitBtn.disabled = true;
    submitBtn.classList.add('is-loading');

    if (!username.value.trim() || !password.value.trim()) {
        showAlert('Username and password are required');
        submitBtn.disabled = false;
        submitBtn.classList.remove('is-loading');
        return;
    }

    try{
        const formData = new FormData(this);
        const params = new URLSearchParams(formData);

        const response = await fetch(LOGIN, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            credentials: 'same-origin', // This allows browser to store cookies
            body: params
        });

        submitBtn.disabled = false;
        submitBtn.classList.remove('is-loading');

        if(!response.ok){
            showAlert('Something went wrong. Please try again.');
            return;
        }

        const data = await response.json();
        if (!data.success) {
            showAlert(data.message);
        } else {
            window.location.href = HOME;
        }
    }catch(err){
        submitBtn.disabled = false;
        submitBtn.classList.remove('is-loading');
        showAlert('Network error. Please check your connection.');
        console.error('Submit error:', err);
    }
});

// Add fading out transition for flash message that come from the signup page
document.addEventListener("DOMContentLoaded", function () {
    const flash = document.getElementById("flash-success");
    if (!flash) return;

    setTimeout(() => {
        // Capture the current rendered height so we can animate from it to 0
        const height = flash.offsetHeight;

        // Pin the height explicitly so the transition has a concrete start value
        flash.style.height     = height + 'px';
        flash.style.overflow   = 'hidden';

        // Let the browser register the fixed height before we start collapsing
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                flash.style.transition = [
                    'opacity .4s ease',
                    'transform .4s ease',
                    'height .4s ease .1s',
                    'margin-bottom .4s ease .1s',
                    'padding-top .4s ease .1s',
                    'padding-bottom .4s ease .1s',
                ].join(', ');

                flash.style.opacity       = '0';
                flash.style.transform     = 'translateY(-8px)';
                flash.style.height        = '0';
                flash.style.marginBottom  = '0';
                flash.style.paddingTop    = '0';
                flash.style.paddingBottom = '0';
            });
        });

        // Remove from DOM after all transitions finish
        flash.addEventListener('transitionend', () => flash.remove(), { once: true });

    }, 3000);
});