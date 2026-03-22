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
import {showFeedbackMessage} from "../../common/book-card.js";

export class AddBookDialog {
    /**
     * @param {Object}   [options]
     * @param {Function} [options.onSuccess]  — called after a successful save
     */
    constructor(options = {}) {
        this.options = options;
        this._dialog = null;
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
        const $dialog = $('#add-book-dialog');
        unbindAuthorControls($dialog);
        unbindImageUpload($dialog);
        $dialog.off('click.addBook');
        $(document).off('click.addBook');
        this._dialog = null;
    }

    // ── Private ───────────────────────────────────────────────────────────────

    _submit() {
        const $dialog         = $('#add-book-dialog');
        const { ok, payload } = validateBookForm($dialog);
        if (!ok) return;

        // Build FormData — required for multipart file upload.
        // All scalar fields are appended as strings; the server reads them
        // via request.getParameter() and the file via request.getPart("image").
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

        // Authors sent as repeated keys: authors=Name1&authors=Name2
        payload.authors.forEach(name => formData.append('authors', name));

        $.ajax({
            url:         `${getContextPath()}/admin/books`,
            method:      'POST',
            data:        formData,
            // Must be false — jQuery must not set Content-Type or process the data;
            // the browser sets the correct multipart boundary automatically.
            contentType: false,
            processData: false,
            success: () => {
                this.options.onSuccess?.();
                this._dialog.close();
            },
            error: (jqXHR) => {
                console.error('Failed to add book:', jqXHR.status, jqXHR.responseText);
                showFeedbackMessage("Failed to add book", false);
                // TODO: surface a user-facing error toast/banner here
            },
        });
    }

    _reset() {
        const $dialog = $('#add-book-dialog');
        $dialog.find('#book-form')[0].reset();
        resetAuthorRows($dialog);
        resetImageUpload($dialog);
        clearErrors($dialog);
    }
}