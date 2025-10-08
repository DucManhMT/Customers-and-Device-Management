<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 10/7/2025
  Time: 4:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration - Multi Step</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .validation-text {
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        .valid-text {
            color: #28a745;
        }
        .invalid-text {
            color: #dc3545;
        }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            background-color: #fff;
        }
        body {
            background-color: #f8f9fa;
        }
        .form-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        .step {
            display: none;
        }
        .step.active {
            display: block;
        }
        .progress-container {
            margin-bottom: 30px;
        }
        .step-header {
            text-align: center;
            margin-bottom: 25px;
        }
        .step-title {
            color: #495057;
            font-size: 1.5rem;
            margin-bottom: 10px;
        }
        .step-description {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .navigation-buttons {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
        .btn-nav {
            min-width: 120px;
        }
        .verification-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 15px 0;
        }
        .code-sent-message {
            color: #28a745;
            font-size: 0.9rem;
            margin-top: 10px;
        }
        .verification-code-container {
            position: relative;
        }
        .countdown-timer {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
        }
        .countdown-active {
            color: #dc3545;
            font-weight: bold;
        }
        .input-group-verification {
            display: flex;
            gap: 10px;
            align-items: flex-start;
        }
        .verification-code-input {
            flex: 1;
        }
        .check-code-btn {
            min-width: 80px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <h2 class="form-title">Create Your Account</h2>

        <!-- Progress Bar -->
        <div class="progress-container">
            <div class="progress" style="height: 8px;">
                <div class="progress-bar bg-primary" id="progressBar" role="progressbar" style="width: 25%"></div>
            </div>
            <div class="d-flex justify-content-between mt-2">
                <small class="text-muted">Step <span id="currentStep">1</span> of 4</small>
                <small class="text-muted"><span id="progressPercent">25</span>% Complete</small>
            </div>
        </div>

        <form id="registrationForm" novalidate>

            <!-- Step 1: Personal Information -->
            <div class="step active" id="step1">
                <div class="step-header">
                    <h3 class="step-title">Personal Information</h3>
                    <p class="step-description">Let's start with your basic information</p>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="firstName" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="firstName" placeholder="Enter your first name" required>
                        <div id="firstNameValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="lastName" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="lastName" placeholder="Enter your last name" required>
                        <div id="lastNameValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="tel" class="form-control" id="phone" placeholder="Enter your phone number (e.g., +1234567890)" required>
                    <div id="phoneValidation" class="validation-text"></div>
                </div>

                <div class="navigation-buttons">
                    <div></div>
                    <button type="button" class="btn btn-primary btn-nav" id="nextStep1">
                        Next <i class="bi bi-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Step 2: Account Information -->
            <div class="step" id="step2">
                <div class="step-header">
                    <h3 class="step-title">Account Information</h3>
                    <p class="step-description">Create your login credentials</p>
                </div>

                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" placeholder="Choose a username (3-20 characters, alphanumeric)" required>
                    <div id="usernameValidation" class="validation-text"></div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" placeholder="Create a strong password" required>
                    <div id="passwordValidation" class="validation-text"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Re-enter Password</label>
                    <input type="password" class="form-control" id="confirmPassword" placeholder="Confirm your password" required>
                    <div id="confirmPasswordValidation" class="validation-text"></div>
                </div>

                <div class="navigation-buttons">
                    <button type="button" class="btn btn-outline-secondary btn-nav" id="prevStep2">
                        <i class="bi bi-arrow-left"></i> Previous
                    </button>
                    <button type="button" class="btn btn-primary btn-nav" id="nextStep2">
                        Next <i class="bi bi-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Step 3: Address Information -->
            <div class="step" id="step3">
                <div class="step-header">
                    <h3 class="step-title">Address Information</h3>
                    <p class="step-description">Where can we reach you?</p>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="country" class="form-label">Country</label>
                        <select class="form-select" id="country" required>
                            <option value="">Select Country</option>
                            <option value="US">United States</option>
                            <option value="CA">Canada</option>
                            <option value="UK">United Kingdom</option>
                            <option value="AU">Australia</option>
                            <option value="VN">Vietnam</option>
                            <option value="JP">Japan</option>
                            <option value="KR">South Korea</option>
                            <option value="CN">China</option>
                        </select>
                        <div id="countryValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-4">
                        <label for="province" class="form-label">Province/State</label>
                        <select class="form-select" id="province" required>
                            <option value="">Select Province/State</option>
                        </select>
                        <div id="provinceValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-4">
                        <label for="district" class="form-label">District/City</label>
                        <select class="form-select" id="district" required>
                            <option value="">Select District/City</option>
                        </select>
                        <div id="districtValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Detailed Address</label>
                    <textarea class="form-control" id="address" rows="3" placeholder="Enter your detailed address (street, building number, etc.)" required></textarea>
                    <div id="addressValidation" class="validation-text"></div>
                </div>

                <div class="navigation-buttons">
                    <button type="button" class="btn btn-outline-secondary btn-nav" id="prevStep3">
                        <i class="bi bi-arrow-left"></i> Previous
                    </button>
                    <button type="button" class="btn btn-primary btn-nav" id="nextStep3">
                        Next <i class="bi bi-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Step 4: Email Verification -->
            <div class="step" id="step4">
                <div class="step-header">
                    <h3 class="step-title">Email Verification</h3>
                    <p class="step-description">Verify your email address to complete registration</p>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" placeholder="Enter your email address" required>
                    <div id="emailValidation" class="validation-text"></div>
                </div>

                <div class="verification-section">
                    <h5>Email Verification</h5>
                    <p class="text-muted mb-3">We'll send a verification code to your email address</p>

                    <div class="mb-3">
                        <button type="button" class="btn btn-outline-primary" id="sendCodeBtn">
                            <i class="bi bi-envelope"></i> Send Verification Code
                        </button>
                        <div id="codeSentMessage" class="code-sent-message"></div>
                        <div id="countdownTimer" class="countdown-timer"></div>
                    </div>

                    <div class="mb-3" id="verificationCodeSection" style="display: none;">
                        <label for="verificationCode" class="form-label">Verification Code</label>
                        <div class="input-group-verification">
                            <div class="verification-code-input">
                                <input type="text" class="form-control" id="verificationCode" placeholder="Enter the 6-digit code" maxlength="6">
                            </div>
                            <button type="button" class="btn btn-outline-success check-code-btn" id="checkCodeBtn">
                                <i class="bi bi-check-circle"></i> Check
                            </button>
                        </div>
                        <div id="verificationCodeValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="navigation-buttons">
                    <button type="button" class="btn btn-outline-secondary btn-nav" id="prevStep4">
                        <i class="bi bi-arrow-left"></i> Previous
                    </button>
                    <button type="submit" class="btn btn-success btn-nav" id="submitForm" disabled>
                        <i class="bi bi-check-circle"></i> Complete Registration
                    </button>
                </div>
            </div>

            <!-- Back to Login Link -->
            <div class="text-center mt-4">
                <a href="login.jsp" class="text-decoration-none">
                    <i class="bi bi-arrow-left-circle"></i> Back to Login
                </a>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let currentStepNumber = 1;
    let verificationCodeSent = false;
    let generatedCode = '';
    let codeVerified = false;
    let countdownTimer = null;
    let countdownSeconds = 0;

    // Location data (simplified)
    const locationData = {
        'US': ['California', 'New York', 'Texas', 'Florida'],
        'CA': ['Ontario', 'Quebec', 'British Columbia', 'Alberta'],
        'UK': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
        'VN': ['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho'],
        'JP': ['Tokyo', 'Osaka', 'Kyoto', 'Yokohama'],
        'KR': ['Seoul', 'Busan', 'Incheon', 'Daegu'],
        'CN': ['Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen']
    };

    const districtData = {
        'California': ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento'],
        'New York': ['New York City', 'Buffalo', 'Rochester', 'Albany'],
        'Ho Chi Minh City': ['District 1', 'District 3', 'District 7', 'Binh Thanh'],
        'Hanoi': ['Ba Dinh', 'Hoan Kiem', 'Hai Ba Trung', 'Dong Da']
    };

    // Validation functions
    function validateName(name) {
        return name.trim().length >= 2 && name.trim().length <= 30;
    }

    function validatePhone(phone) {
        const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
        return phoneRegex.test(phone.replace(/[\s\-\(\)]/g, ''));
    }

    function validateUsername(username) {
        const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
        return usernameRegex.test(username);
    }

    function validatePassword(password) {
        const minLength = password.length >= 8;
        const hasNumber = /\d/.test(password);
        const hasLetter = /[a-zA-Z]/.test(password);
        const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
        return minLength && hasNumber && hasLetter && hasSpecial;
    }

    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function validateAddress(address) {
        return address.trim().length >= 10 && address.trim().length <= 200;
    }

    function validateVerificationCode(code) {
        return code.length === 6 && /^\d+$/.test(code);
    }

    // Show validation message
    function showValidation(elementId, isValid, validMessage, invalidMessage) {
        const element = document.getElementById(elementId);
        if (element) {
            if (isValid) {
                element.textContent = validMessage;
                element.className = 'validation-text valid-text';
            } else {
                element.textContent = invalidMessage;
                element.className = 'validation-text invalid-text';
            }
        }
    }

    // Step navigation functions
    function showStep(stepNumber) {
        // Hide all steps
        for (let i = 1; i <= 4; i++) {
            const stepEl = document.getElementById(`step`+ i );
            if (stepEl) {
                stepEl.classList.remove('active');
            }
        }

        // Show current step
        const currentStepEl = document.getElementById(`step` + stepNumber);
        if (currentStepEl) {
            currentStepEl.classList.add('active');
        }

        // Update progress
        updateProgress(stepNumber);
        currentStepNumber = stepNumber;
    }

    function updateProgress(stepNumber) {
        const progress = (stepNumber / 4) * 100;
        document.getElementById('progressBar').style.width = progress + '%';
        document.getElementById('currentStep').textContent = stepNumber;
        document.getElementById('progressPercent').textContent = progress;
    }

    function validateStep(stepNumber) {
        switch (stepNumber) {
            case 1:
                const firstName = document.getElementById('firstName').value;
                const lastName = document.getElementById('lastName').value;
                const phone = document.getElementById('phone').value;
                return validateName(firstName) && validateName(lastName) && validatePhone(phone);

            case 2:
                const username = document.getElementById('username').value;
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                return validateUsername(username) && validatePassword(password) && password === confirmPassword;

            case 3:
                const country = document.getElementById('country').value;
                const province = document.getElementById('province').value;
                const district = document.getElementById('district').value;
                const address = document.getElementById('address').value;
                return country && province && district && validateAddress(address);

            case 4:
                const email = document.getElementById('email').value;
                return validateEmail(email) && verificationCodeSent && codeVerified;
        }
        return false;
    }

    // Countdown timer functions
    function startCountdown(seconds) {
        countdownSeconds = seconds;
        const timerElement = document.getElementById('countdownTimer');
        const sendBtn = document.getElementById('sendCodeBtn');

        countdownTimer = setInterval(() => {
            if (countdownSeconds > 0) {
                const secs = countdownSeconds;
                timerElement.innerHTML = `<span class="countdown-active">Resend code in: `+ secs.toString().padStart(2, '0') + `</span>`;
                sendBtn.disabled = true;
                countdownSeconds--;
            } else {
                clearInterval(countdownTimer);
                timerElement.innerHTML = '<span class="text-success">You can now resend the code</span>';
                sendBtn.disabled = false;
                sendBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Resend Code';
            }
        }, 1000);
    }

    function stopCountdown() {
        if (countdownTimer) {
            clearInterval(countdownTimer);
            countdownTimer = null;
        }
        document.getElementById('countdownTimer').innerHTML = '';
    }

    // Check verification code function
    function checkVerificationCode() {
        const enteredCode = document.getElementById('verificationCode').value;
        const checkBtn = document.getElementById('checkCodeBtn');

        if (!validateVerificationCode(enteredCode)) {
            showValidation('verificationCodeValidation', false, '',
                '✗ Please enter a valid 6-digit verification code');
            return;
        }

        // Simulate checking code (you can replace this with actual server verification)
        checkBtn.disabled = true;
        checkBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Checking...';

        setTimeout(() => {
            if (enteredCode === generatedCode) {
                codeVerified = true;
                showValidation('verificationCodeValidation', true,
                    '✓ Verification code is correct!', '');
                checkBtn.innerHTML = '<i class="bi bi-check-circle-fill text-success"></i> Verified';
                checkBtn.classList.remove('btn-outline-success');
                checkBtn.classList.add('btn-success');

                // Enable submit button
                document.getElementById('submitForm').disabled = false;

                // Stop countdown since verification is complete
                stopCountdown();
            } else {
                codeVerified = false;
                showValidation('verificationCodeValidation', false, '',
                    '✗ Incorrect verification code. Please try again.');
                checkBtn.disabled = false;
                checkBtn.innerHTML = '<i class="bi bi-check-circle"></i> Check';

                // Keep submit button disabled
                document.getElementById('submitForm').disabled = true;
            }
        }, 1500);
    }

    // Real-time validation for Step 1
    document.getElementById('firstName').addEventListener('input', function() {
        const isValid = validateName(this.value);
        showValidation('firstNameValidation', isValid,
            '✓ First name looks good!',
            '✗ First name must be 2-30 characters long');
    });

    document.getElementById('lastName').addEventListener('input', function() {
        const isValid = validateName(this.value);
        showValidation('lastNameValidation', isValid,
            '✓ Last name looks good!',
            '✗ Last name must be 2-30 characters long');
    });

    document.getElementById('phone').addEventListener('input', function() {
        const isValid = validatePhone(this.value);
        showValidation('phoneValidation', isValid,
            '✓ Phone number is valid!',
            '✗ Please enter a valid phone number');
    });

    // Real-time validation for Step 2
    document.getElementById('username').addEventListener('input', function() {
        const isValid = validateUsername(this.value);
        showValidation('usernameValidation', isValid,
            '✓ Username is available!',
            '✗ Username must be 3-20 characters (letters, numbers, underscore only)');
    });

    document.getElementById('password').addEventListener('input', function() {
        const isValid = validatePassword(this.value);
        showValidation('passwordValidation', isValid,
            '✓ Password is strong!',
            '✗ Password must be 8+ characters with letters, numbers, and special characters');

        // Also validate confirm password if it has a value
        const confirmPassword = document.getElementById('confirmPassword').value;
        if (confirmPassword) {
            validateConfirmPassword();
        }
    });

    function validateConfirmPassword() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const isValid = password === confirmPassword && password.length > 0;
        showValidation('confirmPasswordValidation', isValid,
            '✓ Passwords match!',
            '✗ Passwords do not match');
    }

    document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);

    // Real-time validation for Step 3
    document.getElementById('country').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('countryValidation', isValid,
            '✓ Country selected!',
            '✗ Please select a country');

        // Populate provinces
        const provinceSelect = document.getElementById('province');
        provinceSelect.innerHTML = '<option value="">Select Province/State</option>';

        if (this.value && locationData[this.value]) {
            locationData[this.value].forEach(province => {
                const option = document.createElement('option');
                option.value = province;
                option.textContent = province;
                provinceSelect.appendChild(option);
            });
        }

        // Reset district
        document.getElementById('district').innerHTML = '<option value="">Select District/City</option>';
    });

    document.getElementById('province').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('provinceValidation', isValid,
            '✓ Province/State selected!',
            '✗ Please select a province/state');

        // Populate districts
        const districtSelect = document.getElementById('district');
        districtSelect.innerHTML = '<option value="">Select District/City</option>';

        if (this.value && districtData[this.value]) {
            districtData[this.value].forEach(district => {
                const option = document.createElement('option');
                option.value = district;
                option.textContent = district;
                districtSelect.appendChild(option);
            });
        }
    });

    document.getElementById('district').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('districtValidation', isValid,
            '✓ District/City selected!',
            '✗ Please select a district/city');
    });

    document.getElementById('address').addEventListener('input', function() {
        const isValid = validateAddress(this.value);
        showValidation('addressValidation', isValid,
            '✓ Address is valid!',
            '✗ Address must be 10-200 characters long');
    });

    // Real-time validation for Step 4
    document.getElementById('email').addEventListener('input', function() {
        const isValid = validateEmail(this.value);
        showValidation('emailValidation', isValid,
            '✓ Email format is correct!',
            '✗ Please enter a valid email address');
    });

    // Send verification code
    document.getElementById('sendCodeBtn').addEventListener('click', function() {
        const email = document.getElementById('email').value;
        if (!validateEmail(email)) {
            alert('Please enter a valid email address first.');
            return;
        }

        // Generate random 6-digit code
        generatedCode = Math.floor(100000 + Math.random() * 900000).toString();

        // Reset verification status
        codeVerified = false;
        document.getElementById('submitForm').disabled = true;

        // Reset check button
        const checkBtn = document.getElementById('checkCodeBtn');
        checkBtn.disabled = false;
        checkBtn.innerHTML = '<i class="bi bi-check-circle"></i> Check';
        checkBtn.classList.remove('btn-success');
        checkBtn.classList.add('btn-outline-success');

        // Simulate sending code
        this.disabled = true;
        this.innerHTML = '<i class="bi bi-hourglass-split"></i> Sending...';

        setTimeout(() => {
            document.getElementById('codeSentMessage').innerHTML =
                `✓ Verification code sent to ${email}. (Code: ${generatedCode} - for demo purposes)`;
            document.getElementById('verificationCodeSection').style.display = 'block';
            verificationCodeSent = true;

            // Start 30s countdown
            startCountdown(30);

            this.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Resend Code';
        }, 2000);
    });

    // Check verification code button
    document.getElementById('checkCodeBtn').addEventListener('click', checkVerificationCode);

    // Allow checking code with Enter key
    document.getElementById('verificationCode').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            checkVerificationCode();
        }
    });

    // Real-time validation for verification code (visual feedback only)
    document.getElementById('verificationCode').addEventListener('input', function() {
        if (codeVerified) {
            // Reset verification status when user changes the code
            codeVerified = false;
            document.getElementById('submitForm').disabled = true;
            const checkBtn = document.getElementById('checkCodeBtn');
            checkBtn.disabled = false;
            checkBtn.innerHTML = '<i class="bi bi-check-circle"></i> Check';
            checkBtn.classList.remove('btn-success');
            checkBtn.classList.add('btn-outline-success');
        }

        const isValidFormat = validateVerificationCode(this.value);
        if (this.value.length > 0) {
            showValidation('verificationCodeValidation', isValidFormat,
                '✓ Code format is valid - click Check to verify',
                '✗ Please enter a valid 6-digit verification code');
        }
    });

    // Navigation event listeners
    document.getElementById('nextStep1').addEventListener('click', function() {
        if (validateStep(1)) {
            showStep(2);
        } else {
            alert('Please fill all fields correctly before proceeding.');
        }
    });

    document.getElementById('nextStep2').addEventListener('click', function() {
        if (validateStep(2)) {
            showStep(3);
        } else {
            alert('Please fill all fields correctly before proceeding.');
        }
    });

    document.getElementById('nextStep3').addEventListener('click', function() {
        if (validateStep(3)) {
            showStep(4);
        } else {
            alert('Please fill all fields correctly before proceeding.');
        }
    });

    document.getElementById('prevStep2').addEventListener('click', function() {
        showStep(1);
    });

    document.getElementById('prevStep3').addEventListener('click', function() {
        showStep(2);
    });

    document.getElementById('prevStep4').addEventListener('click', function() {
        showStep(3);
    });

    // Form submission
    document.getElementById('registrationForm').addEventListener('submit', function(e) {
        e.preventDefault();

        if (validateStep(4)) {
            alert('Registration completed successfully! Welcome aboard!');
            // Here you would normally submit the form data to your server
            // window.location.href = 'login.jsp';
        } else {
            alert('Please complete all verification steps before submitting.');
        }
    });

    // Initialize validation messages on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize Step 1 validations
        showValidation('firstNameValidation', false, '', 'First name is required (2-30 characters)');
        showValidation('lastNameValidation', false, '', 'Last name is required (2-30 characters)');
        showValidation('phoneValidation', false, '', 'Valid phone number is required');

        // Initialize other validations as needed
        showValidation('usernameValidation', false, '', 'Username is required (3-20 characters, alphanumeric)');
        showValidation('passwordValidation', false, '', 'Strong password is required (8+ chars, letters, numbers, symbols)');
        showValidation('confirmPasswordValidation', false, '', 'Please confirm your password');

        showValidation('countryValidation', false, '', 'Please select your country');
        showValidation('provinceValidation', false, '', 'Please select your province/state');
        showValidation('districtValidation', false, '', 'Please select your district/city');
        showValidation('addressValidation', false, '', 'Detailed address is required (10-200 characters)');

        showValidation('emailValidation', false, '', 'Valid email address is required');
    });
</script>
</body>
</html>