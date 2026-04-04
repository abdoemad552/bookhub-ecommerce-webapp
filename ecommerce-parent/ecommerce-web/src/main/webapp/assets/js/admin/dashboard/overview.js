import {getContextPath} from "../../util.js";

export function initOverview() {
    console.log("Overview Init");

    const $mainContent = $("#main-content");
    if (!$mainContent) return;

    fetch(`${getContextPath()}/admin/dashboard/control?tab=overview`)
        .then(response => response.text())
        .then(content => {
            $mainContent.html(content);

            // Stagger-animate the stat cards (first grid row)
            $mainContent.find("[data-slot='card']").each(function (i) {
                $(this).addClass("tab-card-animate");
            });
        })
        .catch(error => {
            console.error("Overview load error:", error);
        });
}

export function destroyOverview() {
}