//utils.js

const dropdownBtn = document.querySelector(".tab2");
const tabs = document.querySelectorAll(".tab");
const dropdownContent = document.querySelector(".content");
const ovrview_Btn1 = document.getElementById("askLeave_btn");
const ovrview_Btn2 = document.getElementById("askPermission_btn");


//Load page in iFrame
function loadPage(page, element) {
    const iframe = document.getElementById("contentFrame");
    const container = iframe.parentElement; // wrapper div

    // start fade OUT
    container.classList.add("fade-out");

    setTimeout(() => {
        // change iframe source after fade out
        iframe.src = page;

        // when new page is loaded → fade back IN
        iframe.onload = function () {
            container.classList.remove("fade-out");
        };

    }, 100); // match CSS transition duration

}

// create it if it doesn't exist
function goToHistory(id, type) {
    
    //Highlight sidebar tab
    sessionStorage.setItem('activeTab', 'historyTab');

    var overlay = document.getElementById('page-transition');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'page-transition';
        overlay.style.cssText = 'position:fixed;inset:0;background-image:linear-gradient(to top,#cfd9df 0%,#e2ebf0 100%);opacity:0;pointer-events:none;transition:opacity 0.25s ease;z-index:9999;display:flex;align-items:center;justify-content:center;';

        var loader = document.createElement('div');
        loader.id = 'page-transition-loader';
        loader.style.cssText = 'width:40px;height:10px;color:#766DF4;background:radial-gradient(farthest-side,currentColor 90%,#0000) left/10px 10px,radial-gradient(farthest-side,currentColor 90%,#0000) center/10px 10px,radial-gradient(farthest-side,currentColor 90%,#0000) right/10px 10px,linear-gradient(currentColor 0 0) center/100% 4px;background-repeat:no-repeat;position:relative;animation:pt-s6 2s infinite linear;opacity:0;transition:opacity 0.2s ease;';
        loader.style.marginLeft = "16%";
        overlay.appendChild(loader);

        var style = document.createElement('style');
        style.textContent = [
            '@keyframes pt-s6{0%{transform:translate(var(--pt-s,0)) rotate(0)}100%{transform:translate(var(--pt-s,0)) rotate(1turn)}}',
            '#page-transition-loader:before,#page-transition-loader:after{content:"";position:absolute;inset:0;background:inherit;animation:pt-s6 2s infinite linear;}',
            '#page-transition-loader:before{--pt-s:calc(50% - 5px);animation-direction:reverse;}',
            '#page-transition-loader:after{--pt-s:calc(5px - 50%);}'
        ].join('');
        document.head.appendChild(style);

        document.body.appendChild(overlay);
    }

    requestAnimationFrame(function () {
        overlay.style.opacity = '1';
        overlay.style.pointerEvents = 'all';
        var loader = document.getElementById('page-transition-loader');
        if (loader)
            loader.style.opacity = '1';
    });

    setTimeout(function () {
        window.location.href = 'main_history.jsp?id=' + id + '&type=' + type;
    }, 250);
}



dropdownBtn.addEventListener("click", function () {
    // deactivate all tabs
    document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("active"));

    if (dropdownContent.classList.contains("show")) {
        // fade out
        dropdownContent.classList.remove("show");

        dropdownContent.addEventListener("transitionend", function handler() {
            dropdownContent.style.display = "none";
            dropdownContent.removeEventListener("transitionend", handler);
        });

    } else {
        dropdownContent.style.display = "flex";
        requestAnimationFrame(() => {
            dropdownContent.classList.add("show");
        });
    }
});

// Remove highlight from element when clicking ANY other tab
tabs.forEach(tab => {
    tab.addEventListener("click", function () {
        // reset dropdown completely
        dropdownContent.classList.remove("show");
        dropdownContent.style.display = "none";
        // Remove highlight from ALL tabs
        tabs.forEach(t => t.classList.remove("active"));
        // Add highlight ONLY to the clicked tab
        tab.classList.add("active");
        // If the clicked tab is NOT the dropdown button,
        // remove highlight from the dropdown button
        if (tab !== dropdownBtn) {
            dropdownBtn.classList.remove("active");
            dropdownContent.style.display = "none";
        }
    });
});




/*
 * 
 * 
 * ADMIN SECTION
 */

function sortTable(columnIndex) {
    const table = [document.getElementById("pendingTable"),
        document.getElementById("allTable")];
    const tbody = table.querySelector("tbody");
    const rows = Array.from(tbody.querySelectorAll("tr"));
    const ths = table.querySelectorAll("thead th");

    // Déterminer la direction actuelle
    const currentDir = ths[columnIndex].getAttribute("data-sort-dir");
    const newDir = currentDir === "asc" ? "desc" : "asc";

    // Réinitialiser les indicateurs sur tous les th
    ths.forEach(th => {
        th.setAttribute("data-sort-dir", "");
        th.querySelector(".sort-indicator").textContent = "";
    });

    // Appliquer la nouvelle direction sur le th cliqué
    ths[columnIndex].setAttribute("data-sort-dir", newDir);
    ths[columnIndex].querySelector(".sort-indicator").textContent = newDir === "asc" ? "▲" : "▼";

    // Trier les lignes
    rows.sort((a, b) => {
        const aText = a.children[columnIndex].textContent.trim();
        const bText = b.children[columnIndex].textContent.trim();

        const aVal = isNaN(aText) ? aText.toLowerCase() : Number(aText);
        const bVal = isNaN(bText) ? bText.toLowerCase() : Number(bText);

        if (aVal < bVal)
            return newDir === "asc" ? -1 : 1;
        if (aVal > bVal)
            return newDir === "asc" ? 1 : -1;
        return 0;
    });

    // Réinjecter les lignes triées
    rows.forEach(row => tbody.appendChild(row));
}

