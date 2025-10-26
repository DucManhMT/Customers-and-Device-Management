document.addEventListener("DOMContentLoaded", function () {

    window.viewDetails = function (contractCode, contractImageName) {
        let contractPDF = document.getElementById("contractPDF");
        let noPDFNotice = document.getElementById("noPDFNotice");
        let downloadBtn = document.getElementById("downloadContractBtn");


        if (!contractPDF || !noPDFNotice || !downloadBtn) {
            return;
        }

        // Ẩn trước
        contractPDF.style.display = "none";
        noPDFNotice.style.display = "none";
        downloadBtn.style.display = "none";

        let pdfPath = contextPath + "/assets/" + contractImageName;

        fetch(pdfPath, { method: 'HEAD' })
            .then(response => {
                if (response.ok) {
                    contractPDF.src = pdfPath;
                    contractPDF.style.display = "block";
                    downloadBtn.href = pdfPath;
                    downloadBtn.setAttribute("download", contractImageName);
                    downloadBtn.style.display = "inline-block";
                } else {
                    noPDFNotice.style.display = "block";
                }
            })
            .catch(() => noPDFNotice.style.display = "block");

        let modalEl = document.getElementById("contractModal");
        if (!modalEl) {
            console.error(" Modal container not found!");
            return;
        }
        let modal = new bootstrap.Modal(modalEl);
        modal.show();
    };
});
