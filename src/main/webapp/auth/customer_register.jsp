<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customer_register.css">
    <script>
        let contextPath = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
<%
    String registerMessage = (String) session.getAttribute("registerMessage");
    String registerStatus = (String) session.getAttribute("registerStatus");

    if (registerMessage != null) {
%>
<script>
    <% if ("success".equals(registerStatus)) { %>
    alert("<%= registerMessage.replace("\"", "\\\"") %>");
    <% } else { %>
    alert("<%= registerMessage.replace("\"", "\\\"") %>");
    <% } %>
</script>
<%
        // ✅ Clear the session attributes so the alert only shows once
        session.removeAttribute("registerMessage");
        session.removeAttribute("registerStatus");
    }
%>

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

        <form id="registrationForm" action="${pageContext.request.contextPath}/auth/customer_register_controller" method="post" novalidate>

            <!-- Step 1: Personal Information -->
            <div class="step active" id="step1">
                <div class="step-header">
                    <h3 class="step-title">Personal Information</h3>
                    <p class="step-description">Let's start with your basic information</p>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="firstName" class="form-label">First Name</label>
                        <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter your first name" required>
                        <div id="firstNameValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="lastName" class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter your last name" required>
                        <div id="lastNameValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="Enter your phone number (e.g., 0123456789)" required>
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
                    <input type="text" class="form-control" id="username" name="username" placeholder="Choose a username (3-20 characters, alphanumeric)" required>
                    <div id="usernameValidation" class="validation-text"></div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Create a strong password" required>
                    <div id="passwordValidation" class="validation-text"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Re-enter Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
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
                    <div class="col-md-6">
                        <label for="province" class="form-label">Province</label>
                        <select class="form-select" id="province" name="province" required>
                            <option value="">Select Province</option>
                            <c:forEach var="province" items="${requestScope.provinces}">
                                <option value="${province.provinceID}">${province.provinceName}</option>
                            </c:forEach>
                        </select>
                        <div id="provinceValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-6">
                        <label for="village" class="form-label">Village</label>
                        <select class="form-select" id="village" name="village" required>
                            <option value="">Select Village</option>
                        </select>
                        <div id="villageValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Detailed Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3" placeholder="Enter your detailed address (street, building number, etc.)" required></textarea>
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
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email address" required>
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
                                <input type="text" class="form-control" id="verificationCode" name="verificationCode" placeholder="Enter the 6-digit code" maxlength="6">
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
                <a href="${pageContext.request.contextPath}/auth/customer_login" class="text-decoration-none">
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



    // Validation functions
    function validateName(name) {
        const nameRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]{2,50}$/;
        return nameRegex.test(name.trim());
    }

    function validatePhone(phone) {
        const phoneRegex = /^0\d{9}$/;

        let phoneNumberExisted;
        fetch(contextPath + "/api/check_phonenumber?phoneNumber="+ encodeURIComponent(phone))
            .then(res => res.json())
            .then(data => {
                phoneNumberExisted = data.exists;
                if (phoneNumberExisted){
                    showValidation('phoneValidation', false, '','✗ Phone number is already taken' )
                }
            })
            .catch(error => {
                console.log('Error', error);
            });
        return phoneRegex.test(phone.replace(/[\s\-\(\)]/g, '')) && !phoneNumberExisted;

    }

    function validateUsername(username) {
        const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
        let userNameExists;
        fetch(contextPath + "/api/check_username?username=" + encodeURIComponent(username))
            .then(response => response.json())
            .then(data => {
                userNameExists = data.exists;
                if (userNameExists) {
                    showValidation('usernameValidation', false, '', '✗ Username is already taken');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });

        return usernameRegex.test(username) && !userNameExists;
    }

    function validatePassword(password) {
        // Password must be at least 6 characters, contain letters, numbers, and special characters
        const passwordRegex = /^[A-Za-z\d@$!%*#?&]{6,}$/;
        return passwordRegex.test(password);
    }

    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        let emailExists;
        fetch(contextPath + "/api/check_email?email=" + encodeURIComponent(email))
            .then(response => response.json())
            .then(data => {
                emailExists = data.exists;
                if (emailExists) {
                    showValidation('emailValidation', false, '', '✗ Email is already registered');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        return emailRegex.test(email) && !emailExists;
    }

    function validateAddress(address) {
        const addressRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]{2,255}$/;
        return addressRegex.test(address.trim());
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
                const province = document.getElementById('province').value;
                const village = document.getElementById('village').value;
                const address = document.getElementById('address').value;
                return province && village;

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
            '✗ First name must be 2-30 characters long, letters only');
    });

    document.getElementById('lastName').addEventListener('input', function() {
        const isValid = validateName(this.value);
        showValidation('lastNameValidation', isValid,
            '✓ Last name looks good!',
            '✗ Last name must be 2-30 characters long, letters only');
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
            '✗ Password must be 6+ characters, letters, numbers, special characters');

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
    document.getElementById('province').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('provinceValidation', isValid,
            '✓ Province selected!',
            '✗ Please select a province');

        // Populate villages
        const villageSelect = document.getElementById('village');
        villageSelect.innerHTML = '<option value="">Select Village</option>';

        if (this.value) {
            fetch(contextPath + "/api/get_villages?provinceID=" + encodeURIComponent(this.value))
                .then(response => response.json())
                .then(data => {
                    data.forEach(village => {
                        const option = document.createElement('option');
                        option.value = village.villageID;
                        option.textContent = village.villageName;
                        villageSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error fetching villages:', error);
                });
        }

    });

    document.getElementById('village').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('villageValidation', isValid,
            '✓ Village selected!',
            '✗ Please select a village/state');

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
        async function sendCode() {
            console.log(contextPath + "/api/verify_email");
            await fetch(contextPath + "/api/verify_email", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ email: email, action: "send"})
            })

        }
        sendCode();

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
                `✓ Verification code sent to ` + email + `. Please check your inbox.`;
            document.getElementById('verificationCodeSection').style.display = 'block';
            verificationCodeSent = true;

            // Start 30s countdown
            startCountdown(30);

            this.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Resend Code';
        }, 2000);
    });

    // Check verification code button
    document.getElementById('checkCodeBtn').addEventListener('click', () => {
        fetch (contextPath + "/api/verify_email", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                email: document.getElementById('email').value,
                otp: document.getElementById('verificationCode').value,
                action: "verify"
            })
        }).then(response => response.json())
            .then(data => {
                if (data.success) {
                    codeVerified = true;
                    showValidation('verificationCodeValidation', true,
                        '✓ Verification code is correct!', '');
                    const checkBtn = document.getElementById('checkCodeBtn');
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
                    const checkBtn = document.getElementById('checkCodeBtn');
                    checkBtn.disabled = false;
                    checkBtn.innerHTML = '<i class="bi bi-check-circle"></i> Check';

                    // Keep submit button disabled
                    document.getElementById('submitForm').disabled = true;
                }
            }).catch(error => {
                console.error('Error:', error);
                alert('An error occurred while verifying the code. Please try again later.');
            });
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
        if (!validateStep(4)) {
            e.preventDefault();
            alert('Please complete all verification steps before submitting.');
        }
        // If validation passes, form submits normally to controller
    });

    // Initialize validation messages on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize Step 1 validations
        showValidation('firstNameValidation', false, '', 'First name is required (2-30 characters)');
        showValidation('lastNameValidation', false, '', 'Last name is required (2-30 characters)');
        showValidation('phoneValidation', false, '', 'Valid phone number is required');

        // Initialize other validations as needed
        showValidation('usernameValidation', false, '', 'Username is required (3-20 characters, alphanumeric)');
        showValidation('passwordValidation', false, '', 'Strong password is required (6+ chars, letters, numbers, symbols)');
        showValidation('confirmPasswordValidation', false, '', 'Please confirm your password');

        showValidation('provinceValidation', false, '', 'Please select your province');
        showValidation('villageValidation', false, '', 'Please select your Village');
        showValidation('addressValidation', false, '', 'Detailed address is required (10-200 characters)');

        showValidation('emailValidation', false, '', 'Valid email address is required');
    });
</script>
</body>
</html>

