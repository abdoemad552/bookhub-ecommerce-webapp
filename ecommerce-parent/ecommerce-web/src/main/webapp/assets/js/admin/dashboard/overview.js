import {getContextPath} from "../../util.js";

export function initOverview() {
    console.log("Overview Init");

    const $mainContent = $("#main-content");

    if ($mainContent) {
        fetch(`${getContextPath()}/admin/dashboard/control?tab=overview`)
            .then(response => response.text())
            .then(content => $mainContent.html(content))
            .catch(error => {
                // Handle the error
            });
    }
}

export function destroyOverview() {
}
