import {$, showAlert, hideAlert, togglePw} from '../signup/util.js';

// Global variables
const CONTEXT = '/ecommerce';
const LOGIN = CONTEXT + '/login';
const HOME = CONTEXT + '/home';
const CHECKOUT = CONTEXT + '/checkout';

const username = $('username');
const password = $('password');

// Password visibility toggle (Make it globally accessible in inline attributes)
window.togglePw = togglePw;

$('login-form').addEventListener('submit', async function (e) {
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

    try {
        const formData = new FormData(this);
        const params = new URLSearchParams(formData);

        const response = await fetch(LOGIN, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            credentials: 'same-origin',
            body: params
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
            window.location.href = (data.redirectToHome) ? HOME : CHECKOUT;
        }
    } catch (err) {
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
        flash.style.height = height + 'px';
        flash.style.overflow = 'hidden';

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

                flash.style.opacity = '0';
                flash.style.transform = 'translateY(-8px)';
                flash.style.height = '0';
                flash.style.marginBottom = '0';
                flash.style.paddingTop = '0';
                flash.style.paddingBottom = '0';
            });
        });

        // Remove from DOM after all transitions finish
        flash.addEventListener('transitionend', () => flash.remove(), {once: true});

    }, 4000);
});

// Disable Key (Enter) from submitting the form
$('login-form').addEventListener('keydown', e => {
    if (e.key === 'Enter') e.preventDefault();
});