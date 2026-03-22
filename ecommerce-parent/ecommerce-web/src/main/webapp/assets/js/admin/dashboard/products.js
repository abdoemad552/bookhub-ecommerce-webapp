import {getContextPath} from "../../util.js";

export async function initProducts() {
    console.log("Products Init");

    const $mainContent = $("#main-content");

    if ($mainContent) {
        await fetch(`${getContextPath()}/admin/dashboard/control?tab=products`)
            .then(response => response.text())
            .then(content => $mainContent.html(content))
            .catch(error => {
                // Handle the error...
            });

        const ANIM_MS = 350;
        const dialog      = document.getElementById('book-dialog');
        const panel       = dialog.querySelector('.dialog-panel');
        const form        = document.getElementById('book-form');
        const authorsList = document.getElementById('authors-list');

        // ── Open ────────────────────────────────────────────────────────────

        function openDialog() {
            dialog.showModal();
            // Two rAFs ensure the browser renders the initial (hidden) state first
            requestAnimationFrame(() => requestAnimationFrame(() => {
                dialog.classList.add('is-open');
            }));
            setTimeout(() => {
                const first = dialog.querySelector('input:not([type=hidden]), select');
                if (first) first.focus();
            }, 60);
        }

        // ── Close ────────────────────────────────────────────────────────────

        function closeDialog() {
            if (dialog.classList.contains('is-closing')) return;
            dialog.classList.remove('is-open');
            dialog.classList.add('is-closing');
            setTimeout(() => {
                dialog.classList.remove('is-closing');
                dialog.close();
                resetForm();
            }, ANIM_MS);
        }

        // ── Reset ────────────────────────────────────────────────────────────

        function resetForm() {
            form.reset();
            authorsList.querySelectorAll('.author-row:not(:first-child)').forEach(r => r.remove());
            refreshAuthorLabels();
            clearErrors();
        }

        // ── Authors ──────────────────────────────────────────────────────────

        function refreshAuthorLabels() {
            authorsList.querySelectorAll('.author-row input').forEach((inp, i) => {
                inp.setAttribute('aria-label', `Author ${i + 1}`);
                inp.placeholder = `Author ${i + 1} name`;
            });
        }

        document.getElementById('add-author-btn').addEventListener('click', () => {
            const n = authorsList.querySelectorAll('.author-row').length + 1;
            const row = document.createElement('div');
            row.className = 'author-row flex items-center gap-2';
            row.innerHTML = `
          <input type="text" name="authors[]"
                 placeholder="Author ${n} name" aria-label="Author ${n}"
                 class="field-input flex-1 px-3.5 py-2.5 text-sm text-slate-900
                        placeholder-slate-400 border border-slate-200 rounded-lg bg-white
                        transition-all duration-150" />
          <button type="button" aria-label="Remove author ${n}"
                  class="remove-author shrink-0 p-2 text-slate-400 hover:text-red-500
                         hover:bg-red-50 rounded-lg transition-colors duration-150
                         focus-visible:outline-none focus-visible:ring-2
                         focus-visible:ring-red-400">
            <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                 fill="none" stroke="currentColor" stroke-width="2.5"
                 stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M18 6 6 18"/><path d="m6 6 12 12"/>
            </svg>
          </button>`;
            authorsList.appendChild(row);
            row.querySelector('input').focus();
        });

        authorsList.addEventListener('click', e => {
            const btn = e.target.closest('.remove-author');
            if (!btn) return;
            btn.closest('.author-row').remove();
            refreshAuthorLabels();
        });

        // ── Validation ───────────────────────────────────────────────────────

        function clearErrors() {
            dialog.querySelectorAll('[data-error]').forEach(p => {
                p.textContent = '';
                p.classList.add('hidden');
            });
            dialog.querySelectorAll('.field-input').forEach(el => {
                el.classList.remove('is-invalid');
                el.removeAttribute('aria-invalid');
                el.removeAttribute('aria-describedby');
            });
        }

        function fieldError(inputId, msg) {
            const input = document.getElementById(inputId);
            const errEl = dialog.querySelector(`[data-error="${inputId}"]`);
            if (!input || !errEl) return;
            errEl.textContent = msg;
            errEl.classList.remove('hidden');
            input.classList.add('is-invalid');
            input.setAttribute('aria-invalid', 'true');
            input.setAttribute('aria-describedby', `err-${inputId}`);
            errEl.id = `err-${inputId}`;
        }

        function validate() {
            clearErrors();
            let ok = true;

            const title = document.getElementById('book-title').value.trim();
            if (!title) { fieldError('book-title', 'Book title is required.'); ok = false; }

            const price = parseFloat(document.getElementById('book-price').value);
            if (isNaN(price) || price < 0) { fieldError('book-price', 'Enter a valid price.'); ok = false; }

            const qty = parseInt(document.getElementById('book-qty').value, 10);
            if (isNaN(qty) || qty < 0) { fieldError('book-qty', 'Enter a valid quantity.'); ok = false; }

            const cat = document.getElementById('book-category').value;
            if (!cat) { fieldError('book-category', 'Please select a category.'); ok = false; }

            if (!ok) {
                // Scroll first invalid field into view (mobile bottom-sheet)
                const firstInvalid = dialog.querySelector('.is-invalid');
                if (firstInvalid) firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
            return ok;
        }

        // ── Submit ───────────────────────────────────────────────────────────

        document.getElementById('submit-btn').addEventListener('click', () => {
            if (!validate()) return;

            const authors = [...authorsList.querySelectorAll('input')]
                .map(i => i.value.trim()).filter(Boolean);

            const payload = {
                title:    document.getElementById('book-title').value.trim(),
                authors,
                price:    parseFloat(document.getElementById('book-price').value),
                quantity: parseInt(document.getElementById('book-qty').value, 10),
                category: document.getElementById('book-category').value,
            };

            console.log('📚 Book payload:', payload);

            // TODO: wire up your API
            // fetch('/api/books', {
            //   method: 'POST',
            //   headers: { 'Content-Type': 'application/json' },
            //   body: JSON.stringify(payload)
            // }).then(() => closeDialog());

            closeDialog();
        });

        // ── Backdrop click ───────────────────────────────────────────────────

        dialog.addEventListener('click', e => {
            const rect = panel.getBoundingClientRect();
            const outside =
                e.clientX < rect.left  || e.clientX > rect.right ||
                e.clientY < rect.top   || e.clientY > rect.bottom;
            if (outside) closeDialog();
        });

        // ── Escape key ───────────────────────────────────────────────────────

        dialog.addEventListener('cancel', e => {
            e.preventDefault(); // stop native instant-close
            closeDialog();
        });

        // ── Wire buttons ─────────────────────────────────────────────────────

        document.getElementById('open-add-book-modal-btn').addEventListener('click', openDialog);
        document.getElementById('close-btn').addEventListener('click', closeDialog);
        document.getElementById('cancel-btn').addEventListener('click', closeDialog);
    }
}

export function destroyProducts() {
}

