import {$} from "../util.js";
import {initHeader} from "../common/header.js";
import {initAddresses} from "./address.js";

import {validateStep1, validateStep2, goToStep} from '../signup/formValidation.js';

// Init
function init() {
    initHeader();
    initAddresses();
}

document.addEventListener('DOMContentLoaded', init);

$('checkout-form').addEventListener('keydown', e => {
    if (e.key === 'Enter') e.preventDefault();
});