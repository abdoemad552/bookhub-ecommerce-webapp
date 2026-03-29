/**
 * products.js
 * Orchestrates the Products tab.
 */

import { getContextPath }  from '../../util.js';
import { BooksTable }      from './books-table.js';
import { AddBookDialog }   from './add-book-dialog.js';
import { EditBookDialog }  from './edit-book-dialog.js';
import {showFeedbackMessage} from "../../common/book-card.js";

let table      = null;
let addDialog  = null;
let editDialog = null;

export async function initProducts() {
    destroyProducts();

    const $mainContent = $('#main-content');
    if (!$mainContent.length) return;

    try {
        const html = await $.get(`${getContextPath()}/admin/dashboard/control?tab=products`);
        $mainContent.html(html);
    } catch (err) {
        console.error('Failed to load products tab:', err);
        return;
    }

    // ── Unify the "Add New Book" button with the rest of the dashboard ────────
    const $addBtn = $('#open-add-book-modal-btn');
    $addBtn.removeClass().addClass('products-header-btn');

    // ── Table ────────────────────────────────────────────────────────────────
    table = new BooksTable({
        onEdit:   (book)   => editDialog.openWith(book),
        onDelete: (bookId) => _handleDelete(bookId),
    });
    table.init();

    // ── Add dialog ───────────────────────────────────────────────────────────
    addDialog = new AddBookDialog({
        onSuccess: () => table.reload(),
    });
    addDialog.init();

    // ── Edit dialog ──────────────────────────────────────────────────────────
    editDialog = new EditBookDialog({
        onSuccess: () => table.reload(),
    });
    editDialog.init();
}

export function destroyProducts() {
    table?.destroy();
    addDialog?.destroy();
    editDialog?.destroy();

    table      = null;
    addDialog  = null;
    editDialog = null;
}

// ── Delete ────────────────────────────────────────────────────────────────────
async function _handleDelete(bookId) {
    const confirmed = await showConfirm('This will permanently delete the book. This action cannot be undone.');
    if (!confirmed) return;

    $.ajax({
        url:    `${getContextPath()}/admin/books/${bookId}`,
        method: 'DELETE',
    })
        .done(() => {
            table.reload();
            showFeedbackMessage("Book deleted successfully", true);
        })
        .fail((jqXHR) => {
            console.error('Delete failed:', jqXHR.status, jqXHR.responseText);
            showFeedbackMessage("Failed to delete the book, try again.", false);
        });
}

export function showConfirm(message) {
    return new Promise(resolve => {
        const backdrop = document.getElementById('book-confirm-backdrop');
        const desc     = document.getElementById('book-confirm-desc');
        const yesBtn   = document.getElementById('book-confirm-yes');
        const noBtn    = document.getElementById('book-confirm-no');
        if (!backdrop || !yesBtn || !noBtn) { resolve(false); return; }

        if (desc && message) desc.textContent = message;

        backdrop.classList.add('is-open');

        function cleanup(result) {
            backdrop.classList.remove('is-open');
            yesBtn.removeEventListener('click', onYes);
            noBtn.removeEventListener('click',  onNo);
            backdrop.removeEventListener('click', onBackdrop);
            resolve(result);
        }

        const onYes      = () => cleanup(true);
        const onNo       = () => cleanup(false);
        const onBackdrop = e => { if (e.target === backdrop) cleanup(false); };

        yesBtn.addEventListener('click',   onYes,      { once: true });
        noBtn.addEventListener('click',    onNo,       { once: true });
        backdrop.addEventListener('click', onBackdrop);
    });
}