/**
 * bookFormUtils.js
 * Reusable form helpers shared by both Add and Edit dialogs.
 * All functions receive a jQuery dialog context ($dialog) so they
 * are completely scoped and never touch the wrong dialog.
 */

// ── Validation ────────────────────────────────────────────────────────────────

export function clearErrors($dialog) {
    $dialog.find('[data-error]').each(function () {
        $(this).text('').addClass('hidden');
    });
    $dialog.find('.field-input').each(function () {
        $(this).removeClass('is-invalid')
            .removeAttr('aria-invalid')
            .removeAttr('aria-describedby');
    });
}

export function fieldError($dialog, inputId, msg) {
    const $input = $dialog.find(`#${inputId}`);
    const $err   = $dialog.find(`[data-error="${inputId}"]`);
    if (!$input.length || !$err.length) return;

    $err.text(msg).removeClass('hidden').attr('id', `err-${inputId}`);
    $input.addClass('is-invalid')
        .attr('aria-invalid', 'true')
        .attr('aria-describedby', `err-${inputId}`);
}

/**
 * Validates all required book fields against BookAddRequestDTO.
 * Returns { ok: boolean, payload: Object|null }
 *
 * Payload shape matches BookAddRequestDTO + authors list:
 * {
 *   isbn, title, description, pages,
 *   price, stockQuantity, publishDate,
 *   imageUrl, bookType, category,
 *   authors: ["Name 1", "Name 2"]
 * }
 */
export function validateBookForm($dialog) {
    clearErrors($dialog);
    let ok = true;

    // ── Required fields ───────────────────────────────────────────────────────

    const isbn = $dialog.find('#book-isbn').val().trim();
    if (!isbn) { fieldError($dialog, 'book-isbn', 'ISBN is required.'); ok = false; }

    const title = $dialog.find('#book-title').val().trim();
    if (!title) { fieldError($dialog, 'book-title', 'Title is required.'); ok = false; }

    const price = parseFloat($dialog.find('#book-price').val());
    if (isNaN(price) || price < 0) { fieldError($dialog, 'book-price', 'Enter a valid price.'); ok = false; }

    const stockQuantity = parseInt($dialog.find('#book-qty').val(), 10);
    if (isNaN(stockQuantity) || stockQuantity < 0) { fieldError($dialog, 'book-qty', 'Enter a valid quantity.'); ok = false; }

    const pages = parseInt($dialog.find('#book-pages').val(), 10);
    if (isNaN(pages) || pages < 1) { fieldError($dialog, 'book-pages', 'Enter a valid page count.'); ok = false; }

    const category = $dialog.find('#book-category').val();
    if (!category) { fieldError($dialog, 'book-category', 'Please select a category.'); ok = false; }

    const bookType = $dialog.find('#book-type').val();
    if (!bookType) { fieldError($dialog, 'book-type', 'Please select a book type.'); ok = false; }

    const publishDate = $dialog.find('#book-publish-date').val();
    if (!publishDate) { fieldError($dialog, 'book-publish-date', 'Publish date is required.'); ok = false; }

    // ── Optional fields ───────────────────────────────────────────────────────

    const description = $dialog.find('#book-description').val().trim();

    const imageFile = $dialog.find('#book-image')[0]?.files?.[0] ?? null;
    if (imageFile) {
        const ALLOWED = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
        const MAX_MB  = 5;
        if (!ALLOWED.includes(imageFile.type)) {
            fieldError($dialog, 'book-image', 'Only JPG, PNG, WEBP or GIF files are allowed.');
            ok = false;
        } else if (imageFile.size > MAX_MB * 1024 * 1024) {
            fieldError($dialog, 'book-image', `File must be smaller than ${MAX_MB} MB.`);
            ok = false;
        }
    }

    // ── Authors ───────────────────────────────────────────────────────────────

    const authors = [];
    $dialog.find('#authors-list .author-row input').each(function () {
        const v = $(this).val().trim();
        if (v) authors.push(v);
    });
    if (authors.length === 0) {
        // Mark the first author input
        const $firstAuthor = $dialog.find('#authors-list .author-row:first-child input');
        $firstAuthor.addClass('is-invalid').attr('aria-invalid', 'true');
        ok = false;
    }

    if (!ok) {
        const $first = $dialog.find('.is-invalid').first()[0];
        if ($first) $first.scrollIntoView({ behavior: 'smooth', block: 'center' });
        return { ok: false, payload: null };
    }

    return {
        ok: true,
        payload: {
            isbn,
            title,
            description:   description || null,
            pages,
            price,
            stockQuantity,
            publishDate,          // "YYYY-MM-DD" — Java LocalDate parses this directly
            imageFile:     imageFile || null,  // File object — caller builds FormData
            bookType,
            category,
            authors,
        }
    };
}

// ── Authors ───────────────────────────────────────────────────────────────────

export function refreshAuthorLabels($dialog) {
    $dialog.find('#authors-list .author-row input').each(function (i) {
        $(this).attr('aria-label', `Author ${i + 1}`)
            .attr('placeholder', `Author ${i + 1} name`);
    });
}

export function resetAuthorRows($dialog) {
    $dialog.find('#authors-list .author-row:not(:first-child)').remove();
    $dialog.find('#authors-list .author-row:first-child input').val('');
    refreshAuthorLabels($dialog);
}

export function bindAuthorControls($dialog) {
    const $list = $dialog.find('#authors-list');

    $dialog.on('click.authors', '#add-author-btn', () => {
        const n   = $list.find('.author-row').length + 1;
        const row = $(`
            <div class="author-row flex items-center gap-2">
                <input type="text" name="authors[]"
                       placeholder="Author ${n} name" aria-label="Author ${n}"
                       class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900
                              placeholder-slate-400 border border-slate-200 rounded-lg
                              bg-white transition-all duration-150" />
                <button type="button" aria-label="Remove author ${n}"
                        class="remove-author shrink-0 p-2 text-slate-400
                               hover:text-red-500 hover:bg-red-50 rounded-lg
                               transition-colors duration-150 focus-visible:outline-none
                               focus-visible:ring-2 focus-visible:ring-red-400">
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <path d="M18 6 6 18"/><path d="m6 6 12 12"/>
                    </svg>
                </button>
            </div>`);
        $list.append(row);
        row.find('input').trigger('focus');
    });

    $list.on('click.authors', '.remove-author', function () {
        $(this).closest('.author-row').remove();
        refreshAuthorLabels($dialog);
    });
}

export function unbindAuthorControls($dialog) {
    $dialog.off('click.authors');
    $dialog.find('#authors-list').off('click.authors');
}

// ── Populate form (edit mode) ─────────────────────────────────────────────────

/**
 * Fills all form fields from a book data object.
 * @param {jQuery} $dialog
 * @param {Object} book  — shape matches BookAddRequestDTO + authors + id
 */
export function populateBookForm($dialog, book) {
    $dialog.find('#book-isbn').val(book.isbn ?? '');
    $dialog.find('#book-title').val(book.title ?? '');
    $dialog.find('#book-description').val(book.description ?? '');
    $dialog.find('#book-price').val(book.price ?? '');
    $dialog.find('#book-qty').val(book.stockQuantity ?? '');
    $dialog.find('#book-pages').val(book.pages ?? '');
    $dialog.find('#book-category').val(book.category ?? '');
    $dialog.find('#book-type').val(book.bookType ?? '');
    $dialog.find('#book-publish-date').val(book.publishDate ?? '');
    $dialog.find('#book-image-url').val(book.imageUrl ?? '');

    if (book.id) $dialog.find('#book-id').val(book.id);

    // Authors
    const authors = Array.isArray(book.authors) ? book.authors : [];
    const $list   = $dialog.find('#authors-list');

    $list.find('.author-row:first-child input').val(authors[0] ?? '');

    authors.slice(1).forEach((name, i) => {
        const n   = i + 2;
        const row = $(`
            <div class="author-row flex items-center gap-2">
                <input type="text" name="authors[]"
                       placeholder="Author ${n} name" aria-label="Author ${n}"
                       value="${$('<div>').text(name).html()}"
                       class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900
                              placeholder-slate-400 border border-slate-200 rounded-lg
                              bg-white transition-all duration-150" />
                <button type="button" aria-label="Remove author ${n}"
                        class="remove-author shrink-0 p-2 text-slate-400
                               hover:text-red-500 hover:bg-red-50 rounded-lg
                               transition-colors duration-150 focus-visible:outline-none
                               focus-visible:ring-2 focus-visible:ring-red-400">
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <path d="M18 6 6 18"/><path d="m6 6 12 12"/>
                    </svg>
                </button>
            </div>`);
        $list.append(row);
    });

    refreshAuthorLabels($dialog);
}

// ── Image upload trigger ─────────────────────────────────────────────────────

/**
 * Wires the styled button to the hidden file input and updates the filename
 * label when a file is chosen. Call once per dialog in bindAuthorControls or
 * a dedicated init step.
 */
export function bindImageUpload($dialog) {
    const $input   = $dialog.find('#book-image');
    const $trigger = $dialog.find('#book-image-trigger');
    const $text    = $dialog.find('#book-image-text');

    $trigger.on('click.imageUpload', () => $input.trigger('click'));

    $input.on('change.imageUpload', function () {
        const file = this.files?.[0];
        if (file) {
            // Truncate long names: "very-long-filename.jpg" → "very-long-filen….jpg"
            const MAX_LEN = 28;
            const name    = file.name;
            const display = name.length > MAX_LEN
                ? name.slice(0, MAX_LEN - 1) + '…' + name.slice(name.lastIndexOf('.'))
                : name;
            $text.text(display).closest('span').removeClass('text-slate-400').addClass('text-slate-700');
        } else {
            $text.text('Choose image…').closest('span').removeClass('text-slate-700').addClass('text-slate-400');
        }
    });
}

export function unbindImageUpload($dialog) {
    $dialog.find('#book-image-trigger').off('click.imageUpload');
    $dialog.find('#book-image').off('change.imageUpload');
}

export function resetImageUpload($dialog) {
    $dialog.find('#book-image').val('');
    $dialog.find('#book-image-text')
        .text('Choose image…')
        .closest('span')
        .removeClass('text-slate-700')
        .addClass('text-slate-400');
}