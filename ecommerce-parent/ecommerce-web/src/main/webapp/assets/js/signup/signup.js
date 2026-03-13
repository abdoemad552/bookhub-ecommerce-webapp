const form = document.querySelector("form");

const inputs = {
    firstName: document.querySelector('input[name="firstName"]'),
    lastName: document.querySelector('input[name="lastName"]'),
    username: document.querySelector('input[name="username"]'),
    email: document.querySelector('input[name="email"]'),
    password: document.querySelector('input[name="password"]'),
    birthDate: document.querySelector('input[name="birthDate"]'),
    confirmPassword: document.querySelector('input[name="confirmPassword"]'),
    creditLimit: document.querySelector('input[name="creditCardLimit"]')
};

const errorDiv = document.getElementById("js-error-message");
const errorText = errorDiv.querySelector(".error-text");

form.addEventListener('submit', event => {
    errorDiv.classList.add('hidden');
    errorText.textContent = '';

    // Check required fields
    if (!inputs.firstName.value.trim() ||
        !inputs.lastName.value.trim() ||
        !inputs.username.value.trim() ||
        !inputs.email.value.trim() ||
        !inputs.birthDate.value.trim() ||
        !inputs.password.value.trim() ||
        !inputs.confirmPassword.value.trim()) {

        setError('Please fill the required fields', event);
        return;
    }

    // Username validation
    const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
    if (inputs.username.value && !usernameRegex.test(inputs.username.value)) {
        setError('Username must be 3-20 characters (letters, numbers and underscores only)', event);
        return;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (inputs.email.value && !emailRegex.test(inputs.email.value)) {
        setError('Invalid email format', event);
        return;
    }

    // Age validation
    if (inputs.birthDate.value) {
        const birth = new Date(inputs.birthDate.value);
        const today = new Date();
        let age = today.getFullYear() - birth.getFullYear();
        const monthDiff = today.getMonth() - birth.getMonth();

        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
            age--;
        }

        if (age < 18) {
            setError('You must be 18 years or older', event);
            return;
        }
    }

    // Strong password checking
    const pass = inputs.password.value;
    const strongPassword = /^.{8,}$/;

    if (!strongPassword.test(pass)) {
        setError('Password must contain 8+ characters', event);
        return;
    }

    // Password matching checking
    if (inputs.password.value !== inputs.confirmPassword.value) {
        setError('Passwords do not match', event);
    }
});

function setError(message, event){
    errorText.innerHTML = message;
    errorDiv.classList.remove('hidden');
    event.preventDefault();
}