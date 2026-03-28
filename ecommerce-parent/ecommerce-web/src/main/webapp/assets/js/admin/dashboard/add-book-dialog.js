/**
 * addBookDialog.js
 * Manages the "Add New Book" dialog.
 */

import { BookDialog }        from './book-dialog.js';
import {
    clearErrors,
    validateBookForm,
    bindAuthorControls,
    unbindAuthorControls,
    resetAuthorRows,
    bindImageUpload,
    unbindImageUpload,
    resetImageUpload,
} from './book-form-utils.js';
import { getContextPath } from '../../util.js';

const CLOSE_DELAY   = 1800;  // ms to wait after success before closing
const MESSAGE_DELAY = 3500;  // ms before error message fades out

export class AddBookDialog {
    /**
     * @param {Object}   [options]
     * @param {Function} [options.onSuccess]  — called after a successful save
     */
    constructor(options = {}) {
        this.options        = options;
        this._dialog        = null;
        this._feedbackTimer = null;  // tracks auto-dismiss timeout
    }

    // ── Lifecycle ─────────────────────────────────────────────────────────────

    init() {
        this._dialog = new BookDialog('#add-book-dialog', {
            onClose: () => this._reset(),
        });

        const $dialog = $('#add-book-dialog');

        bindAuthorControls($dialog);
        bindImageUpload($dialog);

        $dialog.on('click.addBook', '#submit-btn', () => this._submit());
        $(document).on('click.addBook', '#open-add-book-modal-btn', () => this._dialog.open());
    }

    destroy() {
        this._clearFeedbackTimer();
        const $dialog = $('#add-book-dialog');
        unbindAuthorControls($dialog);
        unbindImageUpload($dialog);
        $dialog.off('click.addBook');
        $(document).off('click.addBook');
        this._dialog = null;
    }

    // ── Submit ────────────────────────────────────────────────────────────────

    _submit() {
        const $dialog         = $('#add-book-dialog');
        const { ok, payload } = validateBookForm($dialog);
        if (!ok) return;

        // Disable submit while the request is in flight
        this._setSubmitting($dialog, true);

        const formData = new FormData();
        formData.append('isbn',          payload.isbn);
        formData.append('title',         payload.title);
        formData.append('price',         payload.price);
        formData.append('stockQuantity', payload.stockQuantity);
        formData.append('pages',         payload.pages);
        formData.append('category',      payload.category);
        formData.append('bookType',      payload.bookType);
        formData.append('publishDate',   payload.publishDate);

        if (payload.description) formData.append('description', payload.description);
        if (payload.imageFile)   formData.append('image', payload.imageFile);

        payload.authors.forEach(name => formData.append('authors', name));

        console.log(payload);

        $.ajax({
            url:         `${getContextPath()}/admin/books`,
            method:      'POST',
            data:        formData,
            contentType: false,
            processData: false,
        })
        .done(() => {
            this._setSubmitting($dialog, false);
            this._showFeedback($dialog, 'Book added successfully!', true);

            // Notify parent and close after a short delay so the user sees the message
            this._feedbackTimer = setTimeout(() => {
                this.options.onSuccess?.();
                this._dialog.close();
            }, CLOSE_DELAY);
        })
        .fail((jqXHR) => {
            this._setSubmitting($dialog, false);

            // Try to extract the server's error message from the JSON body
            let message = 'Something went wrong. Please try again.';
            try {
                const body = JSON.parse(jqXHR.responseText);
                if (body?.error) message = body.error;
            } catch (_) { /* response wasn't JSON — keep the default message */ }

            this._showFeedback($dialog, message, false);

            // Auto-dismiss the error message after a delay
            this._feedbackTimer = setTimeout(() => {
                this._hideFeedback($dialog);
            }, MESSAGE_DELAY);
        });
    }

    // ── Feedback bar ──────────────────────────────────────────────────────────

    /**
     * Injects (or updates) a feedback bar directly above the footer.
     *
     * Success bar: green, closes after CLOSE_DELAY.
     * Error bar:   red,   auto-hides after MESSAGE_DELAY, stays clickable.
     *
     * @param {jQuery}  $dialog
     * @param {string}  message
     * @param {boolean} isSuccess
     */
    _showFeedback($dialog, message, isSuccess) {
        this._clearFeedbackTimer();
        this._hideFeedback($dialog);  // remove any existing bar immediately

        const icon = isSuccess
            ? /* checkmark */ `<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                    fill="none" stroke="currentColor" stroke-width="2.5"
                    stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M20 6 9 17l-5-5"/>
                </svg>`
            : /* x-circle */ `<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                    fill="none" stroke="currentColor" stroke-width="2.5"
                    stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="m15 9-6 6"/><path d="m9 9 6 6"/>
                </svg>`;

        const colorClasses = isSuccess
            ? 'bg-emerald-50 border-emerald-200 text-emerald-700'
            : 'bg-red-50 border-red-200 text-red-700';

        const $bar = $(`
            <div id="dialog-feedback"
                 role="${isSuccess ? 'status' : 'alert'}"
                 class="flex items-center gap-2.5 px-6 py-3 text-sm font-medium
                        border-t transition-all duration-300 opacity-0 ${colorClasses}">
                <span class="shrink-0">${icon}</span>
                <span class="flex-1">${$('<div>').text(message).html()}</span>
                ${!isSuccess ? `
                <button type="button" id="feedback-dismiss"
                        class="shrink-0 opacity-60 hover:opacity-100 transition-opacity"
                        aria-label="Dismiss">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M18 6 6 18"/><path d="m6 6 12 12"/>
                    </svg>
                </button>` : ''}
            </div>`);

        // Insert between form and footer so it stays fixed outside the scroll area
        $dialog.find('footer').before($bar);

        // Fade in on next frame
        requestAnimationFrame(() => $bar.addClass('opacity-100').removeClass('opacity-0'));

        // Manual dismiss (error only)
        $bar.on('click', '#feedback-dismiss', () => {
            this._clearFeedbackTimer();
            this._hideFeedback($dialog);
        });
    }

    _hideFeedback($dialog) {
        $dialog.find('#dialog-feedback').remove();
    }

    _clearFeedbackTimer() {
        if (this._feedbackTimer) {
            clearTimeout(this._feedbackTimer);
            this._feedbackTimer = null;
        }
    }

    // ── Submit button state ───────────────────────────────────────────────────

    _setSubmitting($dialog, isSubmitting) {
        const $btn = $dialog.find('#submit-btn');
        if (isSubmitting) {
            $btn.prop('disabled', true)
                .html(`
                    <svg class="animate-spin w-4 h-4" xmlns="http://www.w3.org/2000/svg"
                         fill="none" viewBox="0 0 24 24" aria-hidden="true">
                        <circle class="opacity-25" cx="12" cy="12" r="10"
                                stroke="currentColor" stroke-width="4"/>
                        <path class="opacity-75" fill="currentColor"
                              d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/>
                    </svg>
                    Adding...`);
        } else {
            $btn.prop('disabled', false)
                .html(`
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <path d="M5 12h14"/><path d="M12 5v14"/>
                    </svg>
                    Add Book`);
        }
    }

    // ── Reset ─────────────────────────────────────────────────────────────────

    _reset() {
        this._clearFeedbackTimer();
        const $dialog = $('#add-book-dialog');
        $dialog.find('#book-form')[0].reset();
        this._hideFeedback($dialog);
        resetAuthorRows($dialog);
        resetImageUpload($dialog);
        clearErrors($dialog);
    }
}