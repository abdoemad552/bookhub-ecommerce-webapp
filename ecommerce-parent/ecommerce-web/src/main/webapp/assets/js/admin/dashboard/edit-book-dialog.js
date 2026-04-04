/**
 * edit-book-dialog.js
 * Manages the "Edit Book" dialog.
 *
 * Usage:
 *   import { EditBookDialog } from './editBookDialog.js';
 *   const editDialog = new EditBookDialog({ onSuccess: () => refreshTable() });
 *   editDialog.init();              // call once after the dialog HTML is in the DOM
 *   editDialog.openWith(bookData);  // pass the book object to pre-fill the form
 *   editDialog.destroy();           // call when the page/tab unmounts
 */

import { BookDialog } from './book-dialog.js';
import {
    clearErrors,
    bindAuthorControls,
    unbindAuthorControls,
    resetAuthorRows,
    populateBookForm, validateEditBookForm, loadCategories,
} from './book-form-utils.js';
import { getContextPath } from '../../util.js';

const CLOSE_DELAY   = 1800;  // ms to wait after success before closing
const MESSAGE_DELAY = 3500;  // ms before error message fades out

export class EditBookDialog {
    /**
     * @param {Object} [options]
     * @param {Function} [options.onSuccess]  — called with updated book payload after save
     */
    constructor(options = {}) {
        this.options        = options;
        this._dialog        = null;
        this._feedbackTimer = null;
    }

    // ── Lifecycle ────────────────────────────────────────────────────────────

    init() {
        this._dialog = new BookDialog('#edit-book-dialog', {
            onClose: () => this._reset(),
        });

        const $dialog = $('#edit-book-dialog');

        loadCategories($dialog);

        // Submit
        $dialog.on('click.editBook', '#submit-btn', () => this._submit());
    }

    destroy() {
        this._clearFeedbackTimer();
        const $dialog = $('#edit-book-dialog');
        $dialog.off('click.editBook');
        this._dialog = null;
    }

    // ── Public ────────────────────────────────────────────────────────────────

    /**
     * Pre-fills the form with existing book data then opens the dialog.
     * @param {Object} book — shape matches BookResponseDTO (id, title, authors, price, …)
     */
    openWith(book) {
        const $dialog = $('#edit-book-dialog');
        this._reset();                   // clear any previous state first
        populateBookForm($dialog, book); // fill fields from the book object
        this._dialog.open();
    }

    // ── Private ──────────────────────────────────────────────────────────────

    _submit() {
        const $dialog         = $('#edit-book-dialog');
        const { ok, payload } = validateEditBookForm($dialog);
        if (!ok) return;

        const bookId = $dialog.find('#book-id').val();

        // TODO: replace with your real API call, e.g.:
        // $.ajax({
        //     url: `${getContextPath()}/admin/books/${bookId}`,
        //     method: 'PUT',
        //     contentType: 'application/json',
        //     data: JSON.stringify(payload),
        //     success: (response) => {
        //         this.options.onSuccess?.(response);
        //         this._dialog.close();
        //     },
        //     error: () => { /* handle error */ }
        // });

        console.log(`✏️ Edit book [${bookId}] payload:`, payload);
        this.options.onSuccess?.({ id: bookId, ...payload });
        this._dialog.close();
    }

    // ── Feedback bar ──────────────────────────────────────────────────────────

    /**
     * Injects (or updates) a feedback bar directly above the footer.
     *
     * Success bar: green, closes after CLOSE_DELAY.
     * Error bar:   red,   auto-hides after MESSAGE_DELAY, stays dismissible.
     *
     * @param {jQuery}  $dialog
     * @param {string}  message
     * @param {boolean} isSuccess
     */
    _showFeedback($dialog, message, isSuccess) {
        this._clearFeedbackTimer();
        this._hideFeedback($dialog);

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
                    Saving...`);
        } else {
            $btn.prop('disabled', false)
                .html(`
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <path d="M5 12h14"/><path d="M12 5v14"/>
                    </svg>
                    Save Changes`);
        }
    }

    // ── Reset ─────────────────────────────────────────────────────────────────

    _reset() {
        this._clearFeedbackTimer();
        const $dialog = $('#edit-book-dialog');
        $dialog.find('#book-form')[0].reset();
        $dialog.find('#book-id').val('');
        this._hideFeedback($dialog);
        clearErrors($dialog);
    }
}