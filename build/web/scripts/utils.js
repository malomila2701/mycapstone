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

    }, 300); // match CSS transition duration

    // keep your tab logic
    setActiveTab(element);
}

//Highlight element in sidebar
function setActiveTab(element) {
    // Remove active from all
    document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("active"));
    // Add active to the chosen one
    element.classList.add("active");
}

//Load jsp pages into Main frame
document.getElementById("contentFrame").addEventListener("load", function () {
    let currentSrc = this.contentWindow.location.pathname; // e.g. "/project/home.jsp"

    document.querySelectorAll(".tab").forEach(tab => {
        let url = tab.getAttribute("data-url");
        if (currentSrc.endsWith(url)) {
            setActiveTab(tab);
        }
    });
});

dropdownBtn.addEventListener("click", function () {
    // deactivate all tabs
    document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("active"));
    setActiveTab(dropdownBtn);

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

