/**
 * bookFormUtils.js
 * Reusable form helpers shared by both Add and Edit dialogs.
 * All functions receive a jQuery dialog context ($dialog) so they
 * are completely scoped and never touch the wrong dialog.
 */

// ── Validation ────────────────────────────────────────────────────────────────

// ── Validation constants ──────────────────────────────────────────────────────

import {getContextPath} from "../../util.js";

/** Earliest sensible publish date (Gutenberg Bible era). */
const PUBLISH_DATE_MIN = new Date('1450-01-01');

/** Latest sensible publish date: two years into the future (pre-orders / forthcoming). */
const PUBLISH_DATE_MAX_OFFSET_YEARS = 2;

/** Title length ceiling — generous but keeps garbage out. */
const TITLE_MAX_LENGTH = 500;

/** Description length ceiling. */
const DESCRIPTION_MAX_LENGTH = 2000;

/** Maximum number of authors per book. */
const AUTHORS_MAX = 20;

/** Allowed cover-image MIME types. */
const IMAGE_ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp'];

/** Cover-image size ceiling in megabytes. */
const IMAGE_MAX_MB = 5;

// ── Validation helpers ────────────────────────────────────────────────────────

/**
 * Validates an ISBN-10 or ISBN-13 string (digits + optional hyphens/spaces).
 * Strips separators, then checks the appropriate check-digit algorithm.
 *
 * ISBN-10: 9 digits + check digit (0–9 or X).
 * ISBN-13: 12 digits + check digit (0–9), must start with 978 or 979.
 *
 * @param {string} raw
 * @returns {{ ok: boolean, normalized: string, reason?: string }}
 */
function validateISBN(raw) {
    // Strip hyphens and spaces (both are legal separators per ISO 2108)
    const digits = raw.replace(/[\s-]/g, '');

    if (digits.length === 10) {
        // ISBN-10 check digit
        const upper = digits.toUpperCase();
        if (!/^\d{9}[\dX]$/.test(upper)) {
            return { ok: false, reason: 'ISBN-10 must be 9 digits followed by a digit or X.' };
        }
        let sum = 0;
        for (let i = 0; i < 9; i++) sum += (10 - i) * parseInt(upper[i], 10);
        const check = upper[9] === 'X' ? 10 : parseInt(upper[9], 10);
        sum += check;
        if (sum % 11 !== 0) return { ok: false, reason: 'ISBN-10 check digit is incorrect.' };
        return { ok: true, normalized: upper };
    }

    if (digits.length === 13) {
        // ISBN-13 must start with 978 or 979
        if (!/^97[89]\d{10}$/.test(digits)) {
            return { ok: false, reason: 'ISBN-13 must start with 978 or 979 and contain 13 digits.' };
        }
        // ISBN-13 check digit (EAN-13 Luhn variant)
        let sum = 0;
        for (let i = 0; i < 12; i++) {
            sum += parseInt(digits[i], 10) * (i % 2 === 0 ? 1 : 3);
        }
        const check = (10 - (sum % 10)) % 10;
        if (check !== parseInt(digits[12], 10)) {
            return { ok: false, reason: 'ISBN-13 check digit is incorrect.' };
        }
        return { ok: true, normalized: digits };
    }

    return { ok: false, reason: 'ISBN must be 10 or 13 digits (hyphens are allowed).' };
}

/**
 * Returns true when a string looks like a plausible human name.
 *
 * Rules (permissive enough for international names):
 *  - 2–100 characters after trimming.
 *  - At least two alphabetic characters (catches "A B" single-letter tokens).
 *  - May contain letters (any script via Unicode property), hyphens, apostrophes,
 *    periods (initials), and spaces.
 *  - Must not be all punctuation / numbers / whitespace.
 *
 * @param {string} name
 * @returns {boolean}
 */
function isPlausibleHumanName(name) {
    const trimmed = name.trim();
    if (trimmed.length < 2 || trimmed.length > 100) return false;
    // At least two Unicode letters
    const letterMatches = trimmed.match(/\p{L}/gu);
    if (!letterMatches || letterMatches.length < 2) return false;
    // Only letters, spaces, hyphens, apostrophes, periods allowed
    return !/[^\p{L}\p{M}\s\-'.]/u.test(trimmed);
}

/**
 * Validates a non-negative integer string (no decimals, no negative).
 * Returns the parsed integer or NaN.
 *
 * @param {string} raw
 * @returns {number}
 */
function parseNonNegativeInteger(raw) {
    // Must look like a plain integer — reject "1.5", "-1", "1e3", etc.
    if (!/^\d+$/.test(raw.trim())) return NaN;
    return parseInt(raw.trim(), 10);
}

/**
 * Validates a publish date string (YYYY-MM-DD).
 * Returns { ok, date?, reason? }.
 *
 * Rules:
 *  - Required — must not be empty.
 *  - Must be a real calendar date (no Feb 30, etc.).
 *  - Must be ≥ 1450-01-01 (first printed books).
 *  - Must be ≤ today + PUBLISH_DATE_MAX_OFFSET_YEARS (allows pre-announced titles).
 *
 * @param {string} raw
 * @returns {{ ok: boolean, date?: Date, reason?: string }}
 */
function validatePublishDate(raw) {
    if (!raw) return { ok: false, reason: 'Publish date is required.' };

    // new Date('YYYY-MM-DD') is parsed as UTC; compare dates in UTC to avoid
    // timezone-shift surprises (e.g. Dec 31 becoming the previous year locally).
    const date = new Date(raw);
    if (isNaN(date.getTime())) return { ok: false, reason: 'Publish date is not a valid date.' };

    // Verify the calendar date round-trips (catches Feb 30, Apr 31, etc.)
    const [y, m, d] = raw.split('-').map(Number);
    if (
        date.getUTCFullYear() !== y ||
        date.getUTCMonth() + 1 !== m ||
        date.getUTCDate()      !== d
    ) {
        return { ok: false, reason: 'Publish date is not a valid calendar date.' };
    }

    if (date < PUBLISH_DATE_MIN) {
        return { ok: false, reason: 'Publish date seems too far in the past (before 1450).' };
    }

    const maxDate = new Date();
    maxDate.setFullYear(maxDate.getFullYear() + PUBLISH_DATE_MAX_OFFSET_YEARS);
    if (date > maxDate) {
        return {
            ok: false,
            reason: `Publish date cannot be more than ${PUBLISH_DATE_MAX_OFFSET_YEARS} years in the future.`,
        };
    }

    return { ok: true, date };
}

export function loadCategories($dialog) {
    const $select = $dialog.find('#book-category');
    if (!$select.length) return Promise.resolve();

    $select.empty().prop('disabled', true).append(
        $('<option>', { value: '', text: 'Loading categories...', disabled: true, selected: true }),
    );

    return $.ajax({
        url:      `${getContextPath()}/explore/categories?json`,
        method:   'GET',
        dataType: 'json',
    })
        .then((categories) => {
            $select.empty().prop('disabled', false);
            $select.append($('<option>', { value: '', text: 'Select a category...' }));
            (Array.isArray(categories) ? categories : []).forEach(({ id, name }) => {
                $select.append($('<option>', { value: name, text: name }));
            });
        })
        .catch(() => {
            $select.empty().prop('disabled', false);
            $select.append(
                $('<option>', { value: '', text: 'Select a category…' }),
                $('<option>', { value: '', text: '⚠ Failed to load categories', disabled: true }),
            );
        });
}

// ── Public: error display ─────────────────────────────────────────────────────

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
export function validateAddBookForm($dialog) {
    clearErrors($dialog);
    let ok = true;

    // ── ISBN ──────────────────────────────────────────────────────────────────
    // Required. Accepts ISBN-10 or ISBN-13, with or without hyphens/spaces.
    // The check digit is mathematically verified.

    const isbnRaw    = $dialog.find('#book-isbn').val().trim();
    let   isbnNorm   = '';

    if (!isbnRaw) {
        fieldError($dialog, 'book-isbn', 'ISBN is required.');
        ok = false;
    } else {
        const isbnResult = validateISBN(isbnRaw);
        if (!isbnResult.ok) {
            fieldError($dialog, 'book-isbn', isbnResult.reason);
            ok = false;
        } else {
            isbnNorm = isbnResult.normalized;
        }
    }

    // ── Title ─────────────────────────────────────────────────────────────────
    // Required. 1–500 characters. Leading/trailing whitespace is stripped.
    // Must not be entirely whitespace or punctuation.

    const title = $dialog.find('#book-title').val().trim();

    if (!title) {
        fieldError($dialog, 'book-title', 'Title is required.');
        ok = false;
    } else if (title.length > TITLE_MAX_LENGTH) {
        fieldError($dialog, 'book-title', `Title must be ${TITLE_MAX_LENGTH} characters or fewer.`);
        ok = false;
    }

    // ── Price ─────────────────────────────────────────────────────────────────
    // Required. Non-negative integer (whole currency units — no decimals).

    const priceRaw = $dialog.find('#book-price').val().trim();
    const price    = /^\d+(\.\d{1,2})?$/.test(priceRaw) ? parseFloat(priceRaw) : NaN;

    if (priceRaw === '') {
        fieldError($dialog, 'book-price', 'Price is required.');
        ok = false;
    } else if (isNaN(price) || price < 0) {
        fieldError($dialog, 'book-price', 'Price must be a positive number (e.g. 9.99 or 25).');
        ok = false;
    } else if (price === 0) {
        fieldError($dialog, 'book-price', 'Price must be greater than zero.');
        ok = false;
    } else if (price > 999_999) {
        fieldError($dialog, 'book-price', 'Price seems unrealistically high.');
        ok = false;
    }

    // ── Stock quantity ────────────────────────────────────────────────────────
    // Required. Non-negative integer. Zero is valid (out-of-stock).

    const stockRaw      = $dialog.find('#book-qty').val().trim();
    const stockQuantity = parseNonNegativeInteger(stockRaw);

    if (stockRaw === '') {
        fieldError($dialog, 'book-qty', 'Stock quantity is required.');
        ok = false;
    } else if (isNaN(stockQuantity)) {
        fieldError($dialog, 'book-qty', 'Stock quantity must be a whole non-negative number.');
        ok = false;
    } else if (stockQuantity > 999_999) {
        fieldError($dialog, 'book-qty', 'Stock quantity seems unrealistically high.');
        ok = false;
    }

    // ── Pages ─────────────────────────────────────────────────────────────────
    // Required. Positive integer (a book must have at least 1 page).
    // Upper ceiling: 20 000 — longer than any known single-volume book.

    const pagesRaw = $dialog.find('#book-pages').val().trim();
    const pages    = parseNonNegativeInteger(pagesRaw);

    if (pagesRaw === '') {
        fieldError($dialog, 'book-pages', 'Page count is required.');
        ok = false;
    } else if (isNaN(pages) || pages < 1) {
        fieldError($dialog, 'book-pages', 'Page count must be a whole number of at least 1.');
        ok = false;
    } else if (pages > 20_000) {
        fieldError($dialog, 'book-pages', 'Page count seems unrealistically high (max 20 000).');
        ok = false;
    }

    // ── Category ──────────────────────────────────────────────────────────────
    // Required. Must be a non-empty option value (the empty/placeholder option
    // has an empty string value by convention).

    const category = $dialog.find('#book-category').val() ?? '';

    if (!category.trim()) {
        fieldError($dialog, 'book-category', 'Please select a category.');
        ok = false;
    }

    // ── Book type ─────────────────────────────────────────────────────────────
    // Required. Same convention as category.

    const bookType = $dialog.find('#book-type').val() ?? '';

    if (!bookType.trim()) {
        fieldError($dialog, 'book-type', 'Please select a book type.');
        ok = false;
    }

    // ── Publish date ──────────────────────────────────────────────────────────
    // Required. Real calendar date. Must be between 1450 and today + 2 years.

    const publishDateRaw    = $dialog.find('#book-publish-date').val();
    const publishDateResult = validatePublishDate(publishDateRaw);
    let   publishDate       = '';

    if (!publishDateResult.ok) {
        fieldError($dialog, 'book-publish-date', publishDateResult.reason);
        ok = false;
    } else {
        publishDate = publishDateRaw; // keep original "YYYY-MM-DD"
    }

    // ── Description (optional) ────────────────────────────────────────────────
    // Optional free-text field. If provided:
    //  - stripped of leading/trailing whitespace
    //  - must not exceed DESCRIPTION_MAX_LENGTH characters

    const descriptionRaw = $dialog.find('#book-description').val().trim();
    let   description    = null;

    if (descriptionRaw) {
        if (descriptionRaw.length > DESCRIPTION_MAX_LENGTH) {
            fieldError(
                $dialog,
                'book-description',
                `Description must be ${DESCRIPTION_MAX_LENGTH} characters or fewer ` +
                `(currently ${descriptionRaw.length}).`,
            );
            ok = false;
        } else {
            description = descriptionRaw;
        }
    }

    // ── Cover image (optional) ────────────────────────────────────────────────
    // Optional. If provided:
    //  - MIME type must be JPEG, PNG, WEBP, or GIF
    //  - File size must be ≤ IMAGE_MAX_MB
    //  - Filename extension must agree with the MIME type (catches renamed files)

    const imageFile = $dialog.find('#book-image')[0]?.files?.[0] ?? null;

    if (imageFile) {
        const ext = imageFile.name.split('.').pop().toLowerCase();
        const extToMime = { jpg: 'image/jpeg', jpeg: 'image/jpeg', png: 'image/png', webp: 'image/webp'};
        const expectedMime = extToMime[ext];

        if (!IMAGE_ALLOWED_TYPES.includes(imageFile.type)) {
            fieldError($dialog, 'book-image', 'Only JPG, PNG, or WEBP images are allowed.');
            ok = false;
        } else if (expectedMime && expectedMime !== imageFile.type) {
            // e.g. a PNG renamed to .jpg — the browser will still report the real MIME
            fieldError($dialog, 'book-image', 'File extension does not match the image type.');
            ok = false;
        } else if (imageFile.size === 0) {
            fieldError($dialog, 'book-image', 'The selected image file is empty.');
            ok = false;
        } else if (imageFile.size > IMAGE_MAX_MB * 1024 * 1024) {
            fieldError($dialog, 'book-image', `Image must be smaller than ${IMAGE_MAX_MB} MB.`);
            ok = false;
        }
    }

    // ── Authors ───────────────────────────────────────────────────────────────
    // At least one author required.
    // Each non-empty entry is validated as a plausible human name.
    // Completely blank rows are silently ignored (user added an extra row then left it empty).
    // Duplicate names (case-insensitive) are rejected.

    const authors        = [];
    const seenAuthorKeys = new Set();          // for duplicate detection
    let   authorErrors   = false;

    $dialog.find('#authors-list .author-row').each(function (rowIndex) {
        const $input = $(this).find('input');
        const raw    = $input.val();
        const name   = raw.trim();

        // Silently skip rows the user left blank
        if (!name) return;

        if (!isPlausibleHumanName(name)) {
            // Inline error: mark the specific row's input rather than a shared error element.
            // Falls back to the shared fieldError for the first row where data-error exists.
            $input.addClass('is-invalid').attr('aria-invalid', 'true');
            // Use a data-error on the row itself if one exists, otherwise a generic message
            const $rowErr = $(this).find('[data-error]');
            if ($rowErr.length) {
                $rowErr.text(`"${name}" does not look like a valid author name.`).removeClass('hidden');
            }
            authorErrors = true;
            ok = false;
            return; // skip pushing into authors array
        }

        const key = name.toLowerCase().replace(/\s+/g, ' ');
        if (seenAuthorKeys.has(key)) {
            $input.addClass('is-invalid').attr('aria-invalid', 'true');
            authorErrors = true;
            ok = false;
            return;
        }

        seenAuthorKeys.add(key);
        authors.push(name);
    });

    if (authors.length === 0 && !authorErrors) {
        // No valid authors were entered at all — flag the first row
        const $firstAuthorInput = $dialog.find('#authors-list .author-row:first-child input');
        $firstAuthorInput.addClass('is-invalid').attr('aria-invalid', 'true');
        // Try to surface an error message via the standard fieldError path
        fieldError($dialog, 'book-author-1', 'At least one author is required.');
        ok = false;
    } else if (authors.length === 0 && authorErrors) {
        // Only invalid names present — do nothing extra; rows are already marked.
    } else if (authorErrors) {
        // Mix of valid and invalid names — rows are already marked individually.
    }

    if (authors.length > AUTHORS_MAX) {
        ok = false;
        // Mark the last (excess) input as invalid
        $dialog.find('#authors-list .author-row').last().find('input')
            .addClass('is-invalid').attr('aria-invalid', 'true');
    }

    // ── Scroll to first error & return ────────────────────────────────────────

    if (!ok) {
        const $first = $dialog.find('.is-invalid').first()[0];
        if ($first) $first.scrollIntoView({ behavior: 'smooth', block: 'center' });
        return { ok: false, payload: null };
    }

    return {
        ok: true,
        payload: {
            isbn: isbnNorm,
            title,
            description,
            pages,
            price,
            stockQuantity,
            publishDate,
            imageFile,
            bookType,
            category,
            authors,
        },
    };
}

export function validateEditBookForm($dialog) {
    clearErrors($dialog);
    let ok = true;

    // ── ISBN ──────────────────────────────────────────────────────────────────
    // Required. Accepts ISBN-10 or ISBN-13, with or without hyphens/spaces.
    // The check digit is mathematically verified.

    const isbnRaw    = $dialog.find('#book-isbn').val().trim();
    let   isbnNorm   = '';

    if (!isbnRaw) {
        fieldError($dialog, 'book-isbn', 'ISBN is required.');
        ok = false;
    } else {
        const isbnResult = validateISBN(isbnRaw);
        if (!isbnResult.ok) {
            fieldError($dialog, 'book-isbn', isbnResult.reason);
            ok = false;
        } else {
            isbnNorm = isbnResult.normalized;
        }
    }

    // ── Title ─────────────────────────────────────────────────────────────────

    const title = $dialog.find('#book-title').val().trim();

    if (!title) {
        fieldError($dialog, 'book-title', 'Title is required.');
        ok = false;
    } else if (title.length > TITLE_MAX_LENGTH) {
        fieldError($dialog, 'book-title', `Title must be ${TITLE_MAX_LENGTH} characters or fewer.`);
        ok = false;
    }

    // ── Price ─────────────────────────────────────────────────────────────────

    const priceRaw = $dialog.find('#book-price').val().trim();
    const price    = /^\d+(\.\d{1,2})?$/.test(priceRaw) ? parseFloat(priceRaw) : NaN;

    if (priceRaw === '') {
        fieldError($dialog, 'book-price', 'Price is required.');
        ok = false;
    } else if (isNaN(price) || price < 0) {
        fieldError($dialog, 'book-price', 'Price must be a positive number (e.g. 9.99 or 25).');
        ok = false;
    } else if (price === 0) {
        fieldError($dialog, 'book-price', 'Price must be greater than zero.');
        ok = false;
    } else if (price > 999_999) {
        fieldError($dialog, 'book-price', 'Price seems unrealistically high.');
        ok = false;
    }

    // ── Stock quantity ────────────────────────────────────────────────────────

    const stockRaw      = $dialog.find('#book-qty').val().trim();
    const stockQuantity = parseNonNegativeInteger(stockRaw);

    if (stockRaw === '') {
        fieldError($dialog, 'book-qty', 'Stock quantity is required.');
        ok = false;
    } else if (isNaN(stockQuantity)) {
        fieldError($dialog, 'book-qty', 'Stock quantity must be a whole non-negative number.');
        ok = false;
    } else if (stockQuantity > 999_999) {
        fieldError($dialog, 'book-qty', 'Stock quantity seems unrealistically high.');
        ok = false;
    }

    // ── Pages ─────────────────────────────────────────────────────────────────

    const pagesRaw = $dialog.find('#book-pages').val().trim();
    const pages    = parseNonNegativeInteger(pagesRaw);

    if (pagesRaw === '') {
        fieldError($dialog, 'book-pages', 'Page count is required.');
        ok = false;
    } else if (isNaN(pages) || pages < 1) {
        fieldError($dialog, 'book-pages', 'Page count must be a whole number of at least 1.');
        ok = false;
    } else if (pages > 20_000) {
        fieldError($dialog, 'book-pages', 'Page count seems unrealistically high (max 20 000).');
        ok = false;
    }

    // ── Category ──────────────────────────────────────────────────────────────

    const category = $dialog.find('#book-category').val() ?? '';

    if (!category.trim()) {
        fieldError($dialog, 'book-category', 'Please select a category.');
        ok = false;
    }

    // ── Book type ─────────────────────────────────────────────────────────────

    const bookType = $dialog.find('#book-type').val() ?? '';

    if (!bookType.trim()) {
        fieldError($dialog, 'book-type', 'Please select a book type.');
        ok = false;
    }

    // ── Publish date ──────────────────────────────────────────────────────────

    const publishDateRaw    = $dialog.find('#book-publish-date').val();
    const publishDateResult = validatePublishDate(publishDateRaw);
    let   publishDate       = '';

    if (!publishDateResult.ok) {
        fieldError($dialog, 'book-publish-date', publishDateResult.reason);
        ok = false;
    } else {
        publishDate = publishDateRaw;
    }

    // ── Description (optional) ────────────────────────────────────────────────

    const descriptionRaw = $dialog.find('#book-description').val().trim();
    let   description    = null;

    if (descriptionRaw) {
        if (descriptionRaw.length > DESCRIPTION_MAX_LENGTH) {
            fieldError(
                $dialog,
                'book-description',
                `Description must be ${DESCRIPTION_MAX_LENGTH} characters or fewer ` +
                `(currently ${descriptionRaw.length}).`,
            );
            ok = false;
        } else {
            description = descriptionRaw;
        }
    }

    // ── Authors ───────────────────────────────────────────────────────────────

    const authors        = [];
    const seenAuthorKeys = new Set();
    let   authorErrors   = false;

    $dialog.find('#authors-list .author-row').each(function () {
        const $input = $(this).find('input');
        const name   = $input.val().trim();

        if (!name) return; // silently skip blank rows

        if (!isPlausibleHumanName(name)) {
            $input.addClass('is-invalid').attr('aria-invalid', 'true');
            const $rowErr = $(this).find('[data-error]');
            if ($rowErr.length) {
                $rowErr.text(`"${name}" does not look like a valid author name.`).removeClass('hidden');
            }
            authorErrors = true;
            ok = false;
            return;
        }

        const key = name.toLowerCase().replace(/\s+/g, ' ');
        if (seenAuthorKeys.has(key)) {
            $input.addClass('is-invalid').attr('aria-invalid', 'true');
            authorErrors = true;
            ok = false;
            return;
        }

        seenAuthorKeys.add(key);
        authors.push(name);
    });

    if (authors.length === 0 && !authorErrors) {
        const $firstAuthorInput = $dialog.find('#authors-list .author-row:first-child input');
        $firstAuthorInput.addClass('is-invalid').attr('aria-invalid', 'true');
        fieldError($dialog, 'book-author-1', 'At least one author is required.');
        ok = false;
    }

    if (authors.length > AUTHORS_MAX) {
        ok = false;
        $dialog.find('#authors-list .author-row').last().find('input')
            .addClass('is-invalid').attr('aria-invalid', 'true');
    }

    // ── Scroll to first error & return ────────────────────────────────────────

    if (!ok) {
        const $first = $dialog.find('.is-invalid').first()[0];
        if ($first) $first.scrollIntoView({ behavior: 'smooth', block: 'center' });
        return { ok: false, payload: null };
    }

    return {
        ok: true,
        payload: {
            isbn: isbnNorm,
            title,
            description,
            pages,
            price,
            stockQuantity,
            publishDate,
            bookType,
            category,
            authors,
            // imageUrl is passed through from the hidden #book-image-url field by the
            // caller (edit-book-dialog.js) — it is not validated here because the
            // edit form never touches it; cover changes go through the table thumbnail.
        },
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
                       class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 border border-slate-200 rounded-lg bg-white transition-all duration-150" />
                <button type="button" aria-label="Remove author ${n}"
                        class="remove-author shrink-0 p-2 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors duration-150 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-400">
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
    console.log(book);

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

    $list.find('.author-row:first-child input').val(authors[0].name ?? '');

    authors.slice(1).forEach((author, i) => {
        const n   = i + 2;
        const row = $(`
            <div class="author-row flex items-center gap-2">
                <input type="text" name="authors[]"
                       placeholder="Author ${n} name" aria-label="Author ${n}"
                       value="${$('<div>').text(author.name).html()}"
                       class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-400 border border-slate-200 rounded-lg bg-white transition-all duration-150" />
                <button type="button" aria-label="Remove author ${n}"
                        class="remove-author shrink-0 p-2 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors duration-150 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-red-400">
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
 * label when a file is chosen.
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