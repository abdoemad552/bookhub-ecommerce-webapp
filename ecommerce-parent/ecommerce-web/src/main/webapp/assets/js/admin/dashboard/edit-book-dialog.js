/**
 * editBookDialog.js
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
    validateBookForm,
    bindAuthorControls,
    unbindAuthorControls,
    resetAuthorRows,
    populateBookForm,
} from './book-form-utils.js';

export class EditBookDialog {
    /**
     * @param {Object} [options]
     * @param {Function} [options.onSuccess]  — called with updated book payload after save
     */
    constructor(options = {}) {
        this.options = options;
        this._dialog = null;
    }

    // ── Lifecycle ────────────────────────────────────────────────────────────

    init() {
        this._dialog = new BookDialog('#edit-book-dialog', {
            onClose: () => this._reset(),
        });

        const $dialog = $('#edit-book-dialog');

        // Author dynamic rows
        bindAuthorControls($dialog);

        // Submit
        $dialog.on('click.editBook', '#submit-btn', () => this._submit());
    }

    destroy() {
        const $dialog = $('#edit-book-dialog');
        unbindAuthorControls($dialog);
        $dialog.off('click.editBook');
        this._dialog = null;
    }

    // ── Public ───────────────────────────────────────────────────────────────

    /**
     * Pre-fills the form with existing book data then opens the dialog.
     * @param {{ id, title, authors, price, quantity, category }} book
     */
    openWith(book) {
        const $dialog = $('#edit-book-dialog');
        this._reset();                      // clear any previous state first
        populateBookForm($dialog, book);    // fill fields
        this._dialog.open();
    }

    // ── Private ──────────────────────────────────────────────────────────────

    _submit() {
        const $dialog         = $('#edit-book-dialog');
        const { ok, payload } = validateBookForm($dialog);
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

    _reset() {
        const $dialog = $('#edit-book-dialog');
        $dialog.find('#book-form')[0].reset();
        $dialog.find('#book-id').val('');
        resetAuthorRows($dialog);
        clearErrors($dialog);
    }
}