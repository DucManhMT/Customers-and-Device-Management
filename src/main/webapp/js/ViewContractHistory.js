function viewDetails(contractId) {
    let imagePath = contextPath + "/assets/" + contractId + ".jpg";
    let contractImage = document.getElementById("contractImage");
    let noImageNotice = document.getElementById("noImageNotice");
    let downloadBtn = document.getElementById("downloadContractBtn");

    contractImage.style.display = "none";
    noImageNotice.style.display = "none";
    downloadBtn.style.display = "none";

    const testImg = new Image();
    testImg.onload = function() {
        contractImage.src = imagePath;
        contractImage.style.display = "block";
        downloadBtn.href = imagePath;
        downloadBtn.setAttribute("download", contractId + ".jpg");
        downloadBtn.style.display = "inline-block";
        noImageNotice.style.display = "none";
    };
    testImg.onerror = function() {
        contractImage.style.display = "none";
        downloadBtn.style.display = "none";
        noImageNotice.style.display = "block";
    };
    testImg.src = imagePath;

    let modal = new bootstrap.Modal(document.getElementById("contractModal"));
    modal.show();
}