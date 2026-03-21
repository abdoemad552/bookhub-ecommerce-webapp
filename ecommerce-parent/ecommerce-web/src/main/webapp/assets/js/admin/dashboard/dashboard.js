import {initUserManagement} from "./user-management.js";
import {initProducts} from "./products.js";
import {initOverview} from "./overview.js";

const controlMap = {
    "overview-ctrl-btn": initOverview,
    "products-ctrl-btn": initProducts,
    "user-management-ctrl-btn": initUserManagement
};

function setActiveCtrlButton($btn) {
    const $buttons = $("[id$='-ctrl-btn']");

    $buttons.removeClass("text-primary bg-primary/10")
        .addClass("text-muted-foreground hover:text-primary")
        .find(".active-border")
        .remove();

    $btn.removeClass("text-muted-foreground hover:text-primary")
        .addClass("text-primary bg-primary/10")
        .append('<span class="active-border absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></span>');
}

function initPageControls() {
    $("[id$='-ctrl-btn']").on("click", function () {
        const id = this.id;
        const btn = $(this);

        setActiveCtrlButton(btn);

        if (controlMap[id]) {
            controlMap[id]();
        }
    });
}

function init() {
    initPageControls();

    const $defaultBtn = $("#overview-ctrl-btn");
    setActiveCtrlButton($defaultBtn);
    initOverview();
}

$(document).on('DOMContentLoaded', () => init());
