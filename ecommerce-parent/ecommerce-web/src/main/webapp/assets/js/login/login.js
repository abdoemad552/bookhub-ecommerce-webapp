const form = document.querySelector('form');
const username = document.getElementById('js-username');
const password = document.getElementById('js-password');
const errorDiv = document.getElementById('js-error-message');
const errorText = errorDiv.querySelector('.error-text');

form.addEventListener('submit', event => {
    errorDiv.classList.add('hidden');
    errorText.textContent = '';

    if (!username.value.trim() || !password.value.trim()) {
        event.preventDefault();
        errorText.innerHTML = 'Username and password are required';
        errorDiv.classList.remove('hidden');
    }
});