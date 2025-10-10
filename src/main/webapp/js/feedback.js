// Customer Feedback Form JavaScript

document.addEventListener('DOMContentLoaded', function() {
    
    // Initialize form components
    initializeStarRating();
    initializeCharacterCounter();
    initializeFormValidation();
    initializeToasts();
    
    // Star Rating System
    function initializeStarRating() {
        const starInputs = document.querySelectorAll('input[name="rating"]');
        const ratingText = document.getElementById('ratingText');
        const ratingContainer = document.querySelector('.rating-container');
        
        const ratingTexts = {
            5: { text: 'Xuất sắc - Dịch vụ hoàn hảo!', class: 'rating-excellent' },
            4: { text: 'Tốt - Dịch vụ chất lượng', class: 'rating-good' },
            3: { text: 'Bình thường - Dịch vụ ổn', class: 'rating-average' },
            2: { text: 'Kém - Cần cải thiện', class: 'rating-poor' },
            1: { text: 'Rất kém - Không hài lòng', class: 'rating-very-poor' }
        };
        
        starInputs.forEach(input => {
            input.addEventListener('change', function() {
                const rating = parseInt(this.value);
                const ratingInfo = ratingTexts[rating];
                
                // Update rating text and styling
                ratingText.textContent = ratingInfo.text;
                ratingText.className = `text-muted ${ratingInfo.class}`;
                
                // Add glow effect to container
                ratingContainer.style.borderColor = getRatingColor(rating);
                ratingContainer.style.backgroundColor = getRatingBackground(rating);
                
                // Trigger form validation
                validateForm();
            });
        });
    }
    
    function getRatingColor(rating) {
        const colors = {
            5: '#198754',
            4: '#20c997', 
            3: '#ffc107',
            2: '#fd7e14',
            1: '#dc3545'
        };
        return colors[rating] || '#e9ecef';
    }
    
    function getRatingBackground(rating) {
        const backgrounds = {
            5: 'rgba(25, 135, 84, 0.1)',
            4: 'rgba(32, 201, 151, 0.1)',
            3: 'rgba(255, 193, 7, 0.1)', 
            2: 'rgba(253, 126, 20, 0.1)',
            1: 'rgba(220, 53, 69, 0.1)'
        };
        return backgrounds[rating] || '#f8f9fa';
    }
    
    // Character Counter for Textarea
    function initializeCharacterCounter() {
        const textarea = document.getElementById('feedbackContent');
        const charCount = document.getElementById('charCount');
        const maxLength = 500;
        
        if (textarea && charCount) {
            textarea.addEventListener('input', function() {
                const currentLength = this.value.length;
                charCount.textContent = currentLength;
                
                // Update counter styling based on length
                charCount.className = '';
                if (currentLength > maxLength * 0.8) {
                    charCount.classList.add('char-warning');
                }
                if (currentLength > maxLength * 0.95) {
                    charCount.classList.add('char-danger');
                }
                
                // Prevent exceeding max length
                if (currentLength > maxLength) {
                    this.value = this.value.substring(0, maxLength);
                    charCount.textContent = maxLength;
                    charCount.classList.add('char-danger');
                }
                
                validateForm();
            });
        }
    }
    
    // Form Validation
    function initializeFormValidation() {
        const form = document.getElementById('feedbackForm');
        const submitButton = form.querySelector('button[type="submit"]');
        
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (validateForm()) {
                showLoadingState(submitButton);
                submitForm();
            }
        });
        
        // Real-time validation
        const requiredFields = form.querySelectorAll('[required]');
        requiredFields.forEach(field => {
            field.addEventListener('blur', validateField);
            field.addEventListener('input', validateField);
        });
    }
    
    function validateForm() {
        const form = document.getElementById('feedbackForm');
        const requiredFields = form.querySelectorAll('[required]');
        let isValid = true;
        
        requiredFields.forEach(field => {
            if (!validateField.call(field)) {
                isValid = false;
            }
        });
        
        // Enable/disable submit button
        const submitButton = form.querySelector('button[type="submit"]');
        submitButton.disabled = !isValid;
        
        return isValid;
    }
    
    function validateField() {
        const field = this;
        let isValid = true;
        let errorMessage = '';
        
        // Remove existing validation classes
        field.classList.remove('is-valid', 'is-invalid');
        
        // Check if field is empty
        if (field.hasAttribute('required') && !field.value.trim()) {
            isValid = false;
            errorMessage = 'Trường này là bắt buộc';
        }
        
        // Specific validation for different field types
        switch(field.type) {
            case 'email':
                if (field.value && !isValidEmail(field.value)) {
                    isValid = false;
                    errorMessage = 'Email không hợp lệ';
                }
                break;
                
            case 'radio':
                if (field.name === 'rating') {
                    const checkedRating = document.querySelector('input[name="rating"]:checked');
                    isValid = !!checkedRating;
                    if (!isValid) errorMessage = 'Vui lòng chọn đánh giá';
                }
                break;
                
            case 'select-one':
                if (field.name === 'requestId' && field.value === '') {
                    isValid = false;
                    errorMessage = 'Vui lòng chọn yêu cầu dịch vụ';
                }
                break;
        }
        
        // Apply validation styling
        field.classList.add(isValid ? 'is-valid' : 'is-invalid');
        
        // Show/hide error message
        showFieldError(field, isValid ? '' : errorMessage);
        
        return isValid;
    }
    
    function showFieldError(field, message) {
        // Remove existing error message
        const existingError = field.parentNode.querySelector('.invalid-feedback');
        if (existingError) {
            existingError.remove();
        }
        
        // Add new error message if needed
        if (message) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'invalid-feedback';
            errorDiv.textContent = message;
            field.parentNode.appendChild(errorDiv);
        }
    }
    
    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    // Form Submission
    function submitForm() {
        const form = document.getElementById('feedbackForm');
        const formData = new FormData(form);
        
        // You can customize this to use AJAX instead of regular form submission
        fetch(form.action, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (response.ok) {
                showSuccessMessage('Đánh giá của bạn đã được gửi thành công!');
                form.reset();
                resetForm();
            } else {
                throw new Error('Network response was not ok');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showErrorMessage('Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại!');
        })
        .finally(() => {
            hideLoadingState();
        });
    }
    
    function showLoadingState(button) {
        button.disabled = true;
        button.innerHTML = '<i class="bi bi-arrow-clockwise spin me-2"></i>Đang gửi...';
        button.classList.add('loading');
    }
    
    function hideLoadingState() {
        const submitButton = document.querySelector('button[type="submit"]');
        submitButton.disabled = false;
        submitButton.innerHTML = '<i class="bi bi-send me-2"></i>Gửi đánh giá';
        submitButton.classList.remove('loading');
    }
    
    function resetForm() {
        // Reset star rating
        const ratingText = document.getElementById('ratingText');
        const ratingContainer = document.querySelector('.rating-container');
        ratingText.textContent = 'Vui lòng chọn đánh giá';
        ratingText.className = 'text-muted';
        ratingContainer.style.borderColor = '#e9ecef';
        ratingContainer.style.backgroundColor = '#f8f9fa';
        
        // Reset character counter
        const charCount = document.getElementById('charCount');
        charCount.textContent = '0';
        charCount.className = '';
        
        // Remove validation classes
        const validatedFields = document.querySelectorAll('.is-valid, .is-invalid');
        validatedFields.forEach(field => {
            field.classList.remove('is-valid', 'is-invalid');
        });
        
        // Remove error messages
        const errorMessages = document.querySelectorAll('.invalid-feedback');
        errorMessages.forEach(error => error.remove());
    }
    
    // Toast Messages
    function initializeToasts() {
        const toasts = document.querySelectorAll('.toast');
        toasts.forEach(toast => {
            setTimeout(() => {
                toast.classList.remove('show');
            }, 5000);
        });
    }
    
    function showSuccessMessage(message) {
        showToast(message, 'success');
    }
    
    function showErrorMessage(message) {
        showToast(message, 'error');
    }
    
    function showToast(message, type) {
        // Remove existing toasts
        const existingToasts = document.querySelectorAll('.toast');
        existingToasts.forEach(toast => toast.remove());
        
        // Create new toast
        const toastContainer = document.querySelector('.toast-container') || createToastContainer();
        const toast = document.createElement('div');
        toast.className = 'toast show';
        toast.setAttribute('role', 'alert');
        
        const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
        const icon = type === 'success' ? 'bi-check-circle' : 'bi-exclamation-triangle';
        const title = type === 'success' ? 'Thành công' : 'Lỗi';
        
        toast.innerHTML = `
            <div class="toast-header ${bgClass} text-white">
                <i class="bi ${icon} me-2"></i>
                <strong class="me-auto">${title}</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        `;
        
        toastContainer.appendChild(toast);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 5000);
    }
    
    function createToastContainer() {
        const container = document.createElement('div');
        container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
        document.body.appendChild(container);
        return container;
    }
    
    // Request Selection Enhancement
    const requestSelect = document.getElementById('requestSelect');
    if (requestSelect) {
        requestSelect.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            if (selectedOption.value) {
                const status = selectedOption.getAttribute('data-status');
                const date = selectedOption.getAttribute('data-date');
                
                // You can add additional UI feedback here
                console.log(`Selected request: ${selectedOption.value}, Status: ${status}, Date: ${date}`);
            }
        });
    }
    
    // Smooth animations for form interactions
    const animatedElements = document.querySelectorAll('.feedback-card, .customer-info-card, .feedback-item');
    
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});

// CSS for loading spinner
const style = document.createElement('style');
style.textContent = `
    .spin {
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
`;
document.head.appendChild(style);