<%--
  Created by IntelliJ IDEA.
  User: MasterLong
  Date: 11/2/2025
  Time: 5:49 PM
  Admin Account Creation Page
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Staff Account</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <script>
        let contextPath = "${pageContext.request.contextPath}";
    </script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: white;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .registration-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .registration-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .registration-header h2 {
            margin: 0 0 10px 0;
            font-weight: 600;
            font-size: 1.8rem;
        }

        .registration-header p {
            margin: 0;
            opacity: 0.95;
            font-size: 0.95rem;
        }

        .registration-body {
            padding: 40px;
        }

        .section-title {
            color: #2c3e50;
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #667eea;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        .required-indicator {
            color: #dc3545;
        }

        .optional-indicator {
            color: #6c757d;
            font-size: 0.85rem;
            font-weight: 400;
        }

        .form-control, .form-select {
            border: 2px solid #e0e0e0;
            padding: 10px 15px;
            border-radius: 8px;
            font-size: 0.95rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
        }

        .input-group-text {
            background-color: #f8f9fa;
            border: 2px solid #e0e0e0;
            border-right: none;
        }

        .input-group .form-control {
            border-left: none;
        }

        .input-group:focus-within .input-group-text {
            border-color: #667eea;
        }

        /* Image Upload Styles */
        .image-upload-section {
            text-align: center;
            margin-bottom: 25px;
        }

        .image-preview-container {
            width: 150px;
            height: 150px;
            margin: 0 auto 15px;
            border: 3px dashed #667eea;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background-color: #f8f9fc;
            cursor: pointer;
        }

        .image-preview-container:hover {
            border-color: #764ba2;
            background-color: #f0f0ff;
        }

        .image-preview-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-placeholder {
            text-align: center;
            color: #6c757d;
        }

        .image-placeholder i {
            font-size: 2.5rem;
            margin-bottom: 8px;
            opacity: 0.5;
        }

        .image-placeholder p {
            margin: 0;
            font-size: 0.85rem;
        }

        .btn-upload {
            background: #667eea;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .btn-upload:hover {
            background: #764ba2;
            color: white;
        }

        #imageInput {
            display: none;
        }

        .validation-text {
            font-size: 0.85rem;
            margin-top: 5px;
            min-height: 18px;
        }

        .validation-text.valid {
            color: #28a745;
        }

        .validation-text.invalid {
            color: #dc3545;
        }

        /* Password Toggle */
        .password-toggle-btn {
            border: 2px solid #e0e0e0;
            border-left: none;
            background-color: #f8f9fa;
        }

        .password-toggle-btn:hover {
            background-color: #e9ecef;
        }

        /* Submit Button */
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            width: 100%;
            margin-top: 20px;
        }

        .btn-submit:hover {
            opacity: 0.9;
            color: white;
        }

        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .back-link a:hover {
            color: #764ba2;
        }

        /* Section Spacing */
        .form-section {
            margin-bottom: 35px;
            padding: 25px;
            background-color: #f8f9fc;
            border-radius: 10px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .registration-body {
                padding: 25px;
            }

            .registration-header h2 {
                font-size: 1.5rem;
            }

            .form-section {
                padding: 20px;
            }
        }

        /* Helper Text */
        .helper-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 5px;
        }

        .helper-text i {
            margin-right: 3px;
        }

        /* Age Display */
        .age-display {
            font-size: 0.85rem;
            color: #667eea;
            font-weight: 600;
            margin-top: 5px;
        }
    </style>
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
        session.removeAttribute("registerMessage");
        session.removeAttribute("registerStatus");
    }
%>

<jsp:include page="../components/header.jsp"/>
<div class="registration-container">
    <div class="registration-header">
        <h2><i class="bi bi-person-plus-fill"></i> Create Staff Account</h2>
        <p>Complete the form below to create a new staff account</p>
    </div>

    <div class="registration-body">
        <form id="registrationForm" action="${pageContext.request.contextPath}/admin/create_account_controller" method="post" enctype="multipart/form-data">
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success" role="alert">
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <!-- Personal Information Section -->
            <div class="form-section">
                <div class="section-title">
                    <i class="bi bi-person-circle"></i>
                    <span>Personal Information & Address</span>
                </div>

                <!-- Image Upload -->
                <div class="image-upload-section">
                    <label class="form-label">
                        Profile Picture <span class="optional-indicator">(Optional)</span>
                    </label>
                    <div class="image-preview-container" id="imagePreview" onclick="document.getElementById('imageInput').click()">
                        <div class="image-placeholder">
                            <i class="bi bi-camera-fill"></i>
                            <p>Upload Photo</p>
                        </div>
                    </div>
                    <input type="file" id="imageInput" name="profileImage" accept="image/*">
                    <button type="button" class="btn btn-upload" onclick="document.getElementById('imageInput').click()">
                        <i class="bi bi-image"></i> Choose Image
                    </button>
                    <div id="imageValidation" class="validation-text"></div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="firstName" class="form-label">
                            First Name <span class="required-indicator">*</span>
                        </label>
                        <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter first name" required>
                        <div id="firstNameValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="lastName" class="form-label">
                            Last Name <span class="required-indicator">*</span>
                        </label>
                        <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter last name" required>
                        <div id="lastNameValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="dateOfBirth" class="form-label">
                            Date of Birth <span class="required-indicator">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                        </div>
                        <div id="dateOfBirthValidation" class="validation-text"></div>
                        <div id="ageDisplay" class="age-display"></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="phone" class="form-label">
                            Phone Number <span class="required-indicator">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-telephone-fill"></i></span>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="0123456789" required>
                        </div>
                        <div id="phoneValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">
                        Email Address <span class="required-indicator">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter email address" required>
                    </div>
                    <div id="emailValidation" class="validation-text"></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="province" class="form-label">
                            Province <span class="required-indicator">*</span>
                        </label>
                        <select class="form-select" id="province" name="province" required>
                            <option value="">Select Province</option>
                            <c:forEach var="province" items="${requestScope.provinces}">
                                <option value="${province.provinceID}">${province.provinceName}</option>
                            </c:forEach>
                        </select>
                        <div id="provinceValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-6">
                        <label for="village" class="form-label">
                            Village <span class="required-indicator">*</span>
                        </label>
                        <select class="form-select" id="village" name="village" required>
                            <option value="">Select Village</option>
                        </select>
                        <div id="villageValidation" class="validation-text"></div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">
                        Detailed Address <span class="required-indicator">*</span>
                    </label>
                    <textarea class="form-control" id="address" name="address" rows="3" placeholder="Street, building number, etc." required></textarea>
                    <div id="addressValidation" class="validation-text"></div>
                </div>
            </div>

            <!-- Account Information Section -->
            <div class="form-section">
                <div class="section-title">
                    <i class="bi bi-shield-lock-fill"></i>
                    <span>Account Information</span>
                </div>

                <div class="mb-3">
                    <label for="username" class="form-label">
                        Username <span class="required-indicator">*</span>
                    </label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <input type="text" class="form-control" id="username" name="username" placeholder="Choose a username" required>
                    </div>
                    <div id="usernameValidation" class="validation-text"></div>
                    <div class="helper-text">
                        <i class="bi bi-info-circle"></i> 3-20 characters, alphanumeric only
                    </div>
                </div>

                <div class="mb-3">
                    <label for="role" class="form-label">
                        Role <span class="required-indicator">*</span>
                    </label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="">Select Role</option>
                        <c:forEach var="role" items="${requestScope.roles}">
                            <c:if test="${role.roleName != 'Admin' && role.roleName != 'Customer'}">
                                <option value="${role.roleID}">${role.roleName}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <div id="roleValidation" class="validation-text"></div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="password" class="form-label">
                            Password <span class="required-indicator">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                            <button class="btn password-toggle-btn" type="button" id="togglePassword">
                                <i class="bi bi-eye" id="togglePasswordIcon"></i>
                            </button>
                        </div>
                        <div id="passwordValidation" class="validation-text"></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="confirmPassword" class="form-label">
                            Confirm Password <span class="required-indicator">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
                            <button class="btn password-toggle-btn" type="button" id="toggleConfirmPassword">
                                <i class="bi bi-eye" id="toggleConfirmPasswordIcon"></i>
                            </button>
                        </div>
                        <div id="confirmPasswordValidation" class="validation-text"></div>
                    </div>
                </div>
                <div class="helper-text">
                    <i class="bi bi-info-circle"></i> At least 6 characters with letters, numbers, and special characters
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-submit" id="submitForm">
                <i class="bi bi-check-circle-fill"></i> Create Staff Account
            </button>

            <!-- Back to Login Link -->
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/admin/admin_actioncenter">
                    <i class="bi bi-arrow-left-circle-fill"></i> Back to Admin Action Center
                </a>
            </div>
        </form>

    </div>
</div>
<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Set max and min dates for date of birth
    document.addEventListener('DOMContentLoaded', function() {
        const dateOfBirthInput = document.getElementById('dateOfBirth');
        const today = new Date();

        // Set max date (18 years ago from today)
        const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
        dateOfBirthInput.max = maxDate.toISOString().split('T')[0];

        // Set min date (65 years ago from today)
        const minDate = new Date(today.getFullYear() - 65, today.getMonth(), today.getDate());
        dateOfBirthInput.min = minDate.toISOString().split('T')[0];
    });

    // Validation functions
    function validateName(name) {
        // Updated regex to support Vietnamese characters
        const nameRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]{2,50}$/;
        return nameRegex.test(name.trim());
    }

    function calculateAge(birthDate) {
        const today = new Date();
        const birth = new Date(birthDate);
        let age = today.getFullYear() - birth.getFullYear();
        const monthDiff = today.getMonth() - birth.getMonth();

        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
            age--;
        }

        return age;
    }

    function validateDateOfBirth(dateOfBirth) {
        if (!dateOfBirth) return false;

        const age = calculateAge(dateOfBirth);
        return age >= 18 && age <= 65;
    }

    function validatePhone(phone) {
        const phoneRegex = /^0\d{9}$/;
        return phoneRegex.test(phone.replace(/[\s\-\(\)]/g, ''));
    }

    function validateUsername(username) {
        const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
        return usernameRegex.test(username);
    }

    function validatePassword(password) {
        const passwordRegex = /^[A-Za-z\d@$!%*#?&]{6,}$/;
        return passwordRegex.test(password);
    }

    function validateEmail(email) {
        // Enhanced email regex to support Vietnamese characters
        const emailRegex = /^[a-zA-Z0-9._\-+àáâãèéêìíòóôõùúăđĩũơưăạảấầẩẫậắằẳẵặẹẻẽềềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỲỴÝỶỸ]+@[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]*\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email.trim());
    }

    function validateAddress(address) {
        return address.trim().length >= 10 && address.trim().length <= 200;
    }

    // Show validation message
    function showValidation(elementId, isValid, validMessage, invalidMessage) {
        const element = document.getElementById(elementId);
        if (element) {
            if (isValid) {
                element.textContent = validMessage;
                element.className = 'validation-text valid';
            } else {
                element.textContent = invalidMessage;
                element.className = 'validation-text invalid';
            }
        }
    }

    // Image upload preview (optional)
    document.getElementById('imageInput').addEventListener('change', function(e) {
        const file = e.target.files[0];
        const imagePreview = document.getElementById('imagePreview');
        const imageValidation = document.getElementById('imageValidation');

        if (file) {
            if (file.size > 5 * 1024 * 1024) {
                imageValidation.textContent = '❌ Image size must be less than 5MB';
                imageValidation.className = 'validation-text invalid';
                this.value = '';
                return;
            }

            if (!file.type.match('image.*')) {
                imageValidation.textContent = '❌ Please select a valid image file';
                imageValidation.className = 'validation-text invalid';
                this.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(e) {
                imagePreview.innerHTML = '<img src="' + e.target.result + '" alt="Profile Preview">';
                imageValidation.textContent = '✓ Image uploaded successfully';
                imageValidation.className = 'validation-text valid';
            };
            reader.readAsDataURL(file);
        }
    });

    // Password toggle functionality
    document.getElementById('togglePassword').addEventListener('click', function() {
        const passwordInput = document.getElementById('password');
        const icon = document.getElementById('togglePasswordIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    });

    document.getElementById('toggleConfirmPassword').addEventListener('click', function() {
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const icon = document.getElementById('toggleConfirmPasswordIcon');

        if (confirmPasswordInput.type === 'password') {
            confirmPasswordInput.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            confirmPasswordInput.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    });

    // Real-time validation - First Name (Vietnamese support)
    document.getElementById('firstName').addEventListener('input', function() {
        const isValid = validateName(this.value);
        showValidation('firstNameValidation', isValid,
            '✓ First name looks good!',
            '✗ First name must be 2-50 characters (letters only, Vietnamese supported)');
    });

    // Real-time validation - Last Name (Vietnamese support)
    document.getElementById('lastName').addEventListener('input', function() {
        const isValid = validateName(this.value);
        showValidation('lastNameValidation', isValid,
            '✓ Last name looks good!',
            '✗ Last name must be 2-50 characters (letters only, Vietnamese supported)');
    });

    // Real-time validation - Date of Birth
    document.getElementById('dateOfBirth').addEventListener('change', function() {
        const dateOfBirth = this.value;
        const isValid = validateDateOfBirth(dateOfBirth);
        const ageDisplay = document.getElementById('ageDisplay');

        if (dateOfBirth) {
            const age = calculateAge(dateOfBirth);
            ageDisplay.textContent = `Age: ${age} years old`;

            if (isValid) {
                showValidation('dateOfBirthValidation', true,
                    '✓ Valid age for employment',
                    '');
            } else {
                showValidation('dateOfBirthValidation', false,
                    '',
                    '✗ Staff must be between 18 and 65 years old');
                ageDisplay.style.color = '#dc3545';
            }
        } else {
            ageDisplay.textContent = '';
            showValidation('dateOfBirthValidation', false,
                '',
                '✗ Please select date of birth');
        }
    });

    // Real-time validation - Phone (with database check)
    document.getElementById('phone').addEventListener('input', function() {
        const phone = this.value;
        const phoneRegex = /^0\d{9}$/;

        if (!phoneRegex.test(phone.replace(/[\s\-\(\)]/g, ''))) {
            showValidation('phoneValidation', false, '', '✗ Enter a valid 10-digit phone number');
            return;
        }

        fetch(contextPath + "/api/check_phonenumber?phoneNumber=" + encodeURIComponent(phone))
            .then(res => res.json())
            .then(data => {
                if (data.exists) {
                    showValidation('phoneValidation', false, '', '✗ Phone number is already taken');
                } else {
                    showValidation('phoneValidation', true, '✓ Phone number is valid!', '');
                }
            })
            .catch(error => {
                console.log('Error:', error);
            });
    });

    // Real-time validation - Email (with database check)
    document.getElementById('email').addEventListener('input', function() {
        const email = this.value.trim();

        if (!validateEmail(email)) {
            showValidation('emailValidation', false, '', '✗ Please enter a valid email address');
            return;
        }

        fetch(contextPath + "/api/check_email?email=" + encodeURIComponent(email))
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    showValidation('emailValidation', false, '', '✗ Email is already registered');
                } else {
                    showValidation('emailValidation', true, '✓ Email format is correct!', '');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    });

    // Real-time validation - Username (with database check)
    document.getElementById('username').addEventListener('input', function() {
        const username = this.value;
        const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;

        if (!usernameRegex.test(username)) {
            showValidation('usernameValidation', false, '',
                '✗ Username must be 3-20 characters (letters, numbers, underscore only)');
            return;
        }

        fetch(contextPath + "/api/check_username?username=" + encodeURIComponent(username))
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    showValidation('usernameValidation', false, '', '✗ Username is already taken');
                } else {
                    showValidation('usernameValidation', true, '✓ Username is available!', '');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    });

    // Real-time validation - Role
    document.getElementById('role').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('roleValidation', isValid,
            '✓ Role selected!',
            '✗ Please select a role');
    });

    // Real-time validation - Password
    document.getElementById('password').addEventListener('input', function() {
        const isValid = validatePassword(this.value);
        showValidation('passwordValidation', isValid,
            '✓ Password is strong!',
            '✗ Password must be 6+ characters with letters, numbers, special characters');

        const confirmPassword = document.getElementById('confirmPassword').value;
        if (confirmPassword) {
            validateConfirmPassword();
        }
    });

    // Real-time validation - Confirm Password
    function validateConfirmPassword() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const isValid = password === confirmPassword && password.length > 0;
        showValidation('confirmPasswordValidation', isValid,
            '✓ Passwords match!',
            '✗ Passwords do not match');
    }

    document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);

    // Province change - Load villages
    document.getElementById('province').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('provinceValidation', isValid,
            '✓ Province selected!',
            '✗ Please select a province');

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

    // Village change validation
    document.getElementById('village').addEventListener('change', function() {
        const isValid = this.value !== '';
        showValidation('villageValidation', isValid,
            '✓ Village selected!',
            '✗ Please select a village');
    });

    // Real-time validation - Address
    document.getElementById('address').addEventListener('input', function() {
        const isValid = validateAddress(this.value);
        showValidation('addressValidation', isValid,
            '✓ Address is valid!',
            '✗ Address must be 10-200 characters long');
    });

    // Form submission validation
    document.getElementById('registrationForm').addEventListener('submit', function(e) {
        const firstName = document.getElementById('firstName').value;
        const lastName = document.getElementById('lastName').value;
        const dateOfBirth = document.getElementById('dateOfBirth').value;
        const phone = document.getElementById('phone').value;
        const email = document.getElementById('email').value;
        const username = document.getElementById('username').value;
        const role = document.getElementById('role').value;
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const province = document.getElementById('province').value;
        const village = document.getElementById('village').value;
        const address = document.getElementById('address').value;

        let isValid = true;

        if (!validateName(firstName) || !validateName(lastName)) {
            isValid = false;
        }

        if (!validateDateOfBirth(dateOfBirth)) {
            isValid = false;
            alert('Staff must be between 18 and 65 years old.');
        }

        if (!validatePhone(phone)) {
            isValid = false;
        }

        if (!validateEmail(email)) {
            isValid = false;
        }

        if (!validateUsername(username) || !validatePassword(password) || password !== confirmPassword) {
            isValid = false;
        }

        if (!role || !province || !village || !validateAddress(address)) {
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            alert('Please fill in all required fields correctly.');
        }
    });
</script>
</body>
</html>