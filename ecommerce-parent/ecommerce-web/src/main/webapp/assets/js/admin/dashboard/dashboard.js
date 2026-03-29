import { initUserManagement, destroyUserManagement } from "./user-management.js";
import { initProducts,       destroyProducts       } from "./products.js";
import { initOverview,       destroyOverview       } from "./overview.js";

// ── Tab registry ──────────────────────────────────────────────────────────────
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

let activeTabId   = null;
let isSwitching   = false; // guard against rapid clicks during animation

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

// ── Tab switching with transition ─────────────────────────────────────────────

function switchTab(id) {
    if (id === activeTabId) return;
    if (isSwitching) return;

    const $main = $("#main-content");
    const prevId = activeTabId;
    activeTabId = id;

    // If there's existing content, animate it out first
    if (prevId && $main.children().length) {
        isSwitching = true;

        // Destroy the previous tab immediately (stops any in-flight fetches)
        if (tabRegistry[prevId]?.destroy) {
            tabRegistry[prevId].destroy();
        }

        // Animate exit
        $main.addClass("tab-leaving");

        setTimeout(() => {
            $main.removeClass("tab-leaving");
            $main.empty();
            isSwitching = false;
            _mountTab(id, $main);
        }, 150); // matches tab-leaving transition duration

    } else {
        // First load — no exit animation needed
        if (prevId && tabRegistry[prevId]?.destroy) {
            tabRegistry[prevId].destroy();
        }
        _mountTab(id, $main);
    }
}

function _mountTab(id, $main) {
    // Add enter class — children will stagger in via CSS
    $main.addClass("tab-entering");

    // Remove the class after animations finish so it can re-trigger next time
    const longestDelay = 280 + 260; // last child delay + animation duration
    setTimeout(() => $main.removeClass("tab-entering"), longestDelay);

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

    const defaultTabId = "overview-ctrl-btn";
    setActiveCtrlButton($(`#${defaultTabId}`));
    switchTab(defaultTabId);
}

$(init);