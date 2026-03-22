import { initUserManagement, destroyUserManagement } from "./user-management.js";
import { initProducts,       destroyProducts       } from "./products.js";
import { initOverview,       destroyOverview       } from "./overview.js";

// ── Tab registry ──────────────────────────────────────────────────────────────
// Each entry pairs an init function with its corresponding destroy function.
// destroy is called on the PREVIOUS tab before the next one is initialized.

const tabRegistry = {
    "overview-ctrl-btn": {
        init:    initOverview,
        destroy: destroyOverview,
    },
    "products-ctrl-btn": {
        init:    initProducts,
        destroy: destroyProducts,
    },
    "user-management-ctrl-btn": {
        init:    initUserManagement,
        destroy: destroyUserManagement,
    },
};

let activeTabId = null; // tracks which tab is currently mounted

// ── Active button styling ─────────────────────────────────────────────────────

function setActiveCtrlButton($btn) {
    $("[id$='-ctrl-btn']")
        .removeClass("text-primary bg-primary/10")
        .addClass("text-muted-foreground hover:text-primary")
        .find(".active-border")
        .remove();

    $btn
        .removeClass("text-muted-foreground hover:text-primary")
        .addClass("text-primary bg-primary/10")
        .append('<span class="active-border absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>');
}

// ── Tab switching ─────────────────────────────────────────────────────────────

function switchTab(id) {
    if (id === activeTabId) return; // already on this tab — do nothing

    // Tear down the current tab before mounting the next one
    if (activeTabId && tabRegistry[activeTabId]?.destroy) {
        tabRegistry[activeTabId].destroy();
    }

    activeTabId = id;

    if (tabRegistry[id]?.init) {
        tabRegistry[id].init();
    }
}

// ── Bootstrap ─────────────────────────────────────────────────────────────────

function initPageControls() {
    $("[id$='-ctrl-btn']").on("click", function () {
        const id = this.id;
        setActiveCtrlButton($(this));
        switchTab(id);
    });
}

function init() {
    initPageControls();

    // Activate the default tab
    const defaultTabId = "overview-ctrl-btn";
    setActiveCtrlButton($(`#${defaultTabId}`));
    switchTab(defaultTabId);
}

// $(document).ready() — works whether the script runs before or after DOMContentLoaded
$(init);
