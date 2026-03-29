import {initHeader} from "../common/header.js";

initHeader();

const profileTabs = document.querySelectorAll(".profile-tab");
const profilePanels = document.querySelectorAll(".profile-panel");
const initialTab = document.querySelector("main[data-active-tab]")?.dataset.activeTab || "profile-info";

function showProfilePanel(tabId) {
    profilePanels.forEach(panel => {
        const isActive = panel.id === tabId;
        panel.classList.toggle("hidden", !isActive);
        if (isActive) {
            panel.style.animation = "none";
            panel.offsetHeight;   // reflow
            panel.style.animation = "";
        }
    });
    profileTabs.forEach(btn => {
        const isActive = btn.dataset.tab === tabId;
        /* tab-active drives the CSS — no inline Tailwind color classes needed */
        btn.classList.toggle("tab-active", isActive);
    });
}

profileTabs.forEach(tab => tab.addEventListener("click", () => showProfilePanel(tab.dataset.tab)));
showProfilePanel(initialTab);

/* ── Interest chips ── */
const profileInterestCheckboxes = Array.from(document.querySelectorAll(".profile-interest-checkbox"));
const profileSelectedInterestsContainer = document.getElementById("profile-selected-interests");
const profileSelectedInterestsCount = document.getElementById("profile-selected-interests-count");

function renderSelectedInterests() {
    if (!profileSelectedInterestsContainer || !profileSelectedInterestsCount) return;
    const selected = profileInterestCheckboxes.filter(cb => cb.checked).map(cb => cb.dataset.interestName || "");
    profileSelectedInterestsContainer.innerHTML = "";
    if (selected.length === 0) {
        const empty = document.createElement("p");
        empty.className = "text-xs text-muted-foreground";
        empty.textContent = "No interests selected yet.";
        profileSelectedInterestsContainer.appendChild(empty);
    } else {
        selected.sort((a, b) => a.localeCompare(b)).forEach(name => {
            const chip = document.createElement("span");
            chip.className = "interest-chip";
            chip.textContent = name;
            profileSelectedInterestsContainer.appendChild(chip);
        });
    }
    profileSelectedInterestsCount.textContent = `${selected.length} selected`;
    profileInterestCheckboxes.forEach(cb => {
        const card = cb.closest("[data-interest-option]");
        if (card) card.classList.toggle("selected-interest", cb.checked);
    });
}

profileInterestCheckboxes.forEach(cb => cb.addEventListener("change", renderSelectedInterests));
renderSelectedInterests();

/* ── Password validation ── */
const profileForm = document.getElementById("profile-update-form");
const currentPasswordInput = document.getElementById("currentPassword");
const newPasswordInput = document.getElementById("newPassword");
const confirmNewPasswordInput = document.getElementById("confirmNewPassword");
const passwordValidationMsg = document.getElementById("password-validation-message");

function validatePasswordFields() {
    if (!currentPasswordInput || !newPasswordInput || !confirmNewPasswordInput) return true;
    [currentPasswordInput, newPasswordInput, confirmNewPasswordInput].forEach(i => i.setCustomValidity(""));
    const cur = currentPasswordInput.value, nw = newPasswordInput.value, conf = confirmNewPasswordInput.value;
    if (!cur && !nw && !conf) {
        if (passwordValidationMsg) {
            passwordValidationMsg.textContent = "";
            passwordValidationMsg.className = "mt-3 text-sm text-muted-foreground";
        }
        return true;
    }
    let msg = "";
    if (!cur) {
        currentPasswordInput.setCustomValidity("Required");
        msg = msg || "Enter your current password to change it.";
    }
    if (!nw) {
        newPasswordInput.setCustomValidity("Required");
        msg = msg || "Enter a new password.";
    } else if (nw.length < 8) {
        newPasswordInput.setCustomValidity("Too short");
        msg = msg || "New password must be at least 8 characters.";
    } else if (cur === nw) {
        newPasswordInput.setCustomValidity("Same");
        msg = msg || "New password must differ from the current password.";
    }
    if (!conf) {
        confirmNewPasswordInput.setCustomValidity("Required");
        msg = msg || "Please retype the new password.";
    } else if (nw && conf !== nw) {
        confirmNewPasswordInput.setCustomValidity("Mismatch");
        msg = msg || "Passwords do not match.";
    }
    if (passwordValidationMsg) {
        passwordValidationMsg.textContent = msg || "Password change looks good.";
        passwordValidationMsg.className = "mt-3 text-sm font-medium " + (msg ? "text-red-500" : "text-emerald-500");
    }
    return !msg;
}

[currentPasswordInput, newPasswordInput, confirmNewPasswordInput].forEach(i => i?.addEventListener("input", validatePasswordFields));

document.getElementById("firstName")?.addEventListener("input", function () {
    this.setCustomValidity("");
});

document.getElementById("lastName")?.addEventListener("input", function () {
    this.setCustomValidity("");
});

profileForm?.addEventListener("submit", e => {
    const action = document.getElementById("formActionField")?.value;
    if (action === "update-profile") {
        const firstName = document.getElementById("firstName");
        const lastName = document.getElementById("lastName");
        if (firstName && !firstName.value.trim()) {
            e.preventDefault();
            firstName.focus();
            firstName.setCustomValidity("First name is required");
            firstName.reportValidity();
            return;
        }
        if (lastName && !lastName.value.trim()) {
            e.preventDefault();
            lastName.focus();
            lastName.setCustomValidity("Last name is required");
            lastName.reportValidity();
            return;
        }
        if (!validatePasswordFields()) {
            e.preventDefault();
            [currentPasswordInput, newPasswordInput, confirmNewPasswordInput].find(i => i && !i.checkValidity())?.reportValidity();
        }
    }
    // For update-interests: no extra validation needed, submit as-is
});