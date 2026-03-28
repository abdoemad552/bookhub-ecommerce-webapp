/**
 * bookDialog.js
 * Shared low-level controller for a native <dialog> element.
 * Handles: open/close animation, body-scroll lock, backdrop click, Escape key.
 *
 * Usage:
 *   import { BookDialog } from './bookDialog.js';
 *   const myDialog = new BookDialog('#my-dialog');
 *   myDialog.open();
 *   myDialog.close();
 */

const ANIM_MS = 350;

export class BookDialog {
    /**
     * @param {string} selector  — CSS selector for the <dialog> element
     * @param {Object} [hooks]
     * @param {Function} [hooks.onOpen]   — called after dialog opens
     * @param {Function} [hooks.onClose]  — called after dialog fully closes & resets
     */
    constructor(selector, hooks = {}) {
        this.$dialog = $(selector);
        this.dialog  = this.$dialog[0];
        this.$panel  = this.$dialog.find('.dialog-panel');
        this.hooks   = hooks;
        this._isClosing = false;

        this._bindShared();
    }

    // ── Public API ──────────────────────────────────────────────────────────

    open() {
        this.dialog.showModal();
        requestAnimationFrame(() => requestAnimationFrame(() => {
            this.$dialog.addClass('is-open');
        }));
        setTimeout(() => {
            this.$dialog.find('input:not([type=hidden]), select').first().trigger('focus');
        }, 60);
        this.hooks.onOpen?.();
    }

    close() {
        if (this._isClosing) return;
        this._isClosing = true;
        this.$dialog.removeClass('is-open').addClass('is-closing');
        setTimeout(() => {
            this.$dialog.removeClass('is-closing');
            this.dialog.close();
            this._isClosing = false;
            this.hooks.onClose?.();
        }, ANIM_MS);
    }

    // ── Private ─────────────────────────────────────────────────────────────

    _bindShared() {
        // Backdrop click
        this.$dialog.on('click.bookDialog', (e) => {
            const rect = this.$panel[0].getBoundingClientRect();
            const outside =
                e.clientX < rect.left  || e.clientX > rect.right ||
                e.clientY < rect.top   || e.clientY > rect.bottom;
            if (outside) this.close();
        });

        // Escape key — intercept native instant-close
        this.$dialog.on('cancel.bookDialog', (e) => {
            e.preventDefault();
            this.close();
        });

        // Close / cancel buttons (any element inside dialog with these ids)
        this.$dialog.on('click.bookDialog', '#close-btn, #cancel-btn', () => this.close());
    }
}
