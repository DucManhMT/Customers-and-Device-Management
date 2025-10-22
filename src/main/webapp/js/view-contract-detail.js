function viewDetails(contractId, contractImageName) {
    let imagePath = contextPath + "/assets/" + contractImageName;
    let contractImage = document.getElementById("contractImage");
    let noImageNotice = document.getElementById("noImageNotice");
    let downloadBtn = document.getElementById("downloadContractBtn");

    // Ẩn tạm thời các phần tử
    contractImage.style.display = "none";
    noImageNotice.style.display = "none";
    downloadBtn.style.display = "none";

    // Kiểm tra xem ảnh có tồn tại hay không
    const testImg = new Image();
    testImg.onload = function() {
        // Hiển thị ảnh khi load thành công
        contractImage.src = imagePath;
        contractImage.style.display = "block";

        // Cấu hình nút tải xuống
        downloadBtn.href = imagePath;
        downloadBtn.setAttribute("download", contractImageName);
        downloadBtn.style.display = "inline-block";
        noImageNotice.style.display = "none";
    };
    testImg.onerror = function() {
        // Ẩn ảnh và nút tải khi ảnh không tồn tại
        contractImage.style.display = "none";
        downloadBtn.style.display = "none";
        noImageNotice.style.display = "block";
    };

    testImg.src = imagePath;

    // Mở modal hiển thị hợp đồng
    let modal = new bootstrap.Modal(document.getElementById("contractModal"));
    modal.show();
}
