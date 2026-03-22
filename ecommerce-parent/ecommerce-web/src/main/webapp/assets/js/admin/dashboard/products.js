/**
 * products.js
 * Orchestrates the Products tab:
 *   - loads tab HTML
 *   - initialises BooksTable (fetch + render)
 *   - initialises Add / Edit dialogs
 *   - wires mutations back to table.reload()
 */

import { getContextPath }  from '../../util.js';
import { BooksTable }      from './books-table.js';
import { AddBookDialog }   from './add-book-dialog.js';
import { EditBookDialog }  from './edit-book-dialog.js';

let table      = null;
let addDialog  = null;
let editDialog = null;

export async function initProducts() {
    destroyProducts(); // always clean up before re-initialising

    const $mainContent = $('#main-content');
    if (!$mainContent.length) return;

    try {
        const html = await $.get(`${getContextPath()}/admin/dashboard/control?tab=products`);
        $mainContent.html(html);
    } catch (err) {
        console.error('Failed to load products tab:', err);
        return;
    }

    // ── Table ────────────────────────────────────────────────────────────────
    table = new BooksTable({
        onEdit: (book) => editDialog.openWith(book),
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

function _handleDelete(bookId) {
    if (!confirm('Delete this book? This cannot be undone.')) return;

    $.ajax({
        url:    `${getContextPath()}/admin/books/${bookId}`,
        method: 'DELETE',
    })
        .done(() => table.reload())
        .fail((jqXHR) => {
            console.error('Delete failed:', jqXHR.status, jqXHR.responseText);
            alert('Failed to delete book. Please try again.');
        });
}