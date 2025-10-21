    function validateDateFormat(inputElement) {
        const datePattern = /^\d{2}-\d{2}-\d{4}$/;
        const value = inputElement.value.trim();

        if (value && !datePattern.test(value)) {
            inputElement.style.borderColor = '#dc3545';
            inputElement.title = 'Định dạng ngày phải là: dd-MM-yyyy (VD: 06-10-2025)';
            return false;
        } else {
            inputElement.style.borderColor = '#ccc';
            inputElement.title = '';
            return true;
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const fromDateInput = document.querySelector('input[name="fromDate"]');
        const toDateInput = document.querySelector('input[name="toDate"]');

        if (fromDateInput) {
            fromDateInput.addEventListener('blur', function () {
                validateDateFormat(this);
            });
        }

        if (toDateInput) {
            toDateInput.addEventListener('blur', function () {
                validateDateFormat(this);
            });
        }

        const filterForm = document.querySelector('form[action*="viewAssignedTasks"]');
        if (filterForm) {
            filterForm.addEventListener('submit', function (e) {
                let isValid = true;

                if (fromDateInput && fromDateInput.value) {
                    isValid &= validateDateFormat(fromDateInput);
                }

                if (toDateInput && toDateInput.value) {
                    isValid &= validateDateFormat(toDateInput);
                }

                if (!isValid) {
                    e.preventDefault();
                    alert('Vui lòng nhập đúng định dạng ngày: dd-MM-yyyy (VD: 06-10-2025)');
                }
            });
        }
    });