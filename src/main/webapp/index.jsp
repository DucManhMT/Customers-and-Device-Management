<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Device Warranty Management System - Protect your devices with comprehensive warranty coverage">
    <title>DWMS - Device Warranty Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* OVERRIDE sidebar.jsp body styles to prevent double margin */
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif !important;
            line-height: 1.6;
            color: #333;
            background: #f0f2f5 !important;
            padding-top: 0 !important;
            margin-left: 0 !important; /* Override sidebar.jsp margin */
            transition: none;
        }

        /* Main content wrapper that adjusts when sidebar is hidden/visible */
        .main-wrapper {
            margin-left: 0; /* Start with no margin */
            transition: margin-left 0.3s ease;
        }

        /* When sidebar is visible, push content */
        body.sidebar-visible .main-wrapper {
            margin-left: 280px;
        }

        #sidebar.sidebar-hidden {
            transform: translateX(-280px);
        }

        .page-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* Simple Navbar for non-logged in users */
        .main-navbar {
            background: #fff;
            border-bottom: 1px solid #e4e6eb;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 999;
            padding: 16px 24px;
        }

        .main-navbar .page-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            font-size: 24px;
            font-weight: 700;
            color: #1877f2;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 32px;
            align-items: center;
        }

        .nav-links a {
            color: #65676b;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            transition: color 0.2s;
        }

        .nav-links a:hover {
            color: #1877f2;
        }

        .nav-actions {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
        }

        .btn-outline {
            background: transparent;
            color: #1877f2;
            border: 1px solid #1877f2;
        }

        .btn-outline:hover {
            background: #e7f3ff;
        }

        .btn-primary {
            background: #1877f2;
            color: white;
        }

        .btn-primary:hover {
            background: #166fe5;
        }

        /* Hero Section - Simple and Clean */
        .hero-section {
            background: white;
            padding: 120px 0 80px;
            margin-top: 68px;
        }

        .hero-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .hero-text h1 {
            font-size: 48px;
            font-weight: 700;
            color: #1c1e21;
            margin-bottom: 24px;
            line-height: 1.2;
        }

        .hero-text p {
            font-size: 18px;
            color: #65676b;
            margin-bottom: 32px;
            line-height: 1.6;
        }

        .hero-buttons {
            display: flex;
            gap: 16px;
        }

        .hero-image {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-image img {
            max-width: 100%;
            height: auto;
            border-radius: 12px;
        }

        .hero-placeholder {
            width: 100%;
            max-width: 600px;
            height: 400px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-placeholder i {
            font-size: 120px;
            color: rgba(255, 255, 255, 0.5);
        }

        /* Features Section */
        .features-section {
            padding: 80px 0;
            background: #f0f2f5;
        }

        .section-title {
            text-align: center;
            font-size: 36px;
            font-weight: 700;
            color: #1c1e21;
            margin-bottom: 16px;
        }

        .section-subtitle {
            text-align: center;
            font-size: 18px;
            color: #65676b;
            margin-bottom: 60px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 32px;
        }

        .feature-card {
            background: white;
            padding: 32px;
            border-radius: 12px;
            border: 1px solid #e4e6eb;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            font-size: 48px;
            color: #1877f2;
            margin-bottom: 20px;
        }

        .feature-card h3 {
            font-size: 20px;
            font-weight: 600;
            color: #1c1e21;
            margin-bottom: 12px;
        }

        .feature-card p {
            font-size: 15px;
            color: #65676b;
            line-height: 1.6;
        }

        /* Services Section */
        .services-section {
            padding: 80px 0;
            background: white;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 32px;
        }

        .service-card {
            background: #f0f2f5;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
        }

        .service-card i {
            font-size: 64px;
            color: #1877f2;
            margin-bottom: 24px;
        }

        .service-card h3 {
            font-size: 24px;
            font-weight: 600;
            color: #1c1e21;
            margin-bottom: 16px;
        }

        .service-card p {
            font-size: 16px;
            color: #65676b;
            line-height: 1.6;
        }

        /* About Section */
        .about-section {
            padding: 80px 0;
            background: #f0f2f5;
        }

        .about-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .about-text h2 {
            font-size: 36px;
            font-weight: 700;
            color: #1c1e21;
            margin-bottom: 24px;
        }

        .about-text p {
            font-size: 16px;
            color: #65676b;
            margin-bottom: 16px;
            line-height: 1.6;
        }

        .about-image {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 400px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .about-image i {
            font-size: 120px;
            color: rgba(255, 255, 255, 0.5);
        }

        /* Contact Section */
        .contact-section {
            padding: 80px 0;
            background: white;
        }

        .contact-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
        }

        .contact-form {
            background: #f0f2f5;
            padding: 40px;
            border-radius: 12px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #1c1e21;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ccd0d5;
            border-radius: 6px;
            font-size: 15px;
            font-family: inherit;
            transition: border-color 0.2s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1877f2;
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }

        .info-item {
            display: flex;
            gap: 20px;
        }

        .info-item i {
            font-size: 32px;
            color: #1877f2;
        }

        .info-item h4 {
            font-size: 18px;
            font-weight: 600;
            color: #1c1e21;
            margin-bottom: 8px;
        }

        .info-item p {
            font-size: 15px;
            color: #65676b;
        }

        /* Footer */
        .footer {
            background: #242526;
            color: #b0b3b8;
            padding: 60px 0 30px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-section h3,
        .footer-section h4 {
            color: #e4e6eb;
            margin-bottom: 20px;
            font-size: 18px;
        }

        .footer-section p {
            line-height: 1.6;
            margin-bottom: 16px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 12px;
        }

        .footer-section ul li a {
            color: #b0b3b8;
            text-decoration: none;
            transition: color 0.2s;
        }

        .footer-section ul li a:hover {
            color: #e4e6eb;
        }

        .social-links {
            display: flex;
            gap: 12px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: #3a3b3c;
            border-radius: 50%;
            color: #e4e6eb;
            text-decoration: none;
            transition: background 0.2s;
        }

        .social-links a:hover {
            background: #1877f2;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid #3a3b3c;
            color: #8a8d91;
        }

        /* Mobile Menu */
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            font-size: 24px;
            color: #1c1e21;
            cursor: pointer;
        }

        /* Responsive */
        @media (max-width: 968px) {
            .hero-content,
            .about-content,
            .contact-content {
                grid-template-columns: 1fr;
            }

            .hero-text h1 {
                font-size: 36px;
            }

            .hero-image {
                order: -1;
            }
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .mobile-menu-btn {
                display: block;
            }

            .nav-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .hero-text h1 {
                font-size: 32px;
            }

            .section-title {
                font-size: 28px;
            }

            body.sidebar-visible .main-wrapper {
                margin-left: 0;
            }

            .main-wrapper {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

<!-- Include sidebar when logged in -->
<c:if test="${not empty sessionScope.account}">
    <jsp:include page="./components/sidebar.jsp"/>
</c:if>

<!-- Main wrapper that adjusts with sidebar -->
<div class="main-wrapper">

    <!-- Navigation -->
    <c:choose>
        <c:when test="${not empty sessionScope.account}">
            <!-- Include header when logged in -->
            <jsp:include page="./components/header.jsp" />
        </c:when>
        <c:otherwise>
            <!-- Show main navbar when not logged in -->
            <nav class="main-navbar">
                <div class="page-container">
                    <a href="${pageContext.request.contextPath}/" class="nav-brand">
                        🔧 DWMS
                    </a>
                    <ul class="nav-links">
                        <li><a href="#home">Home</a></li>
                        <li><a href="#features">Features</a></li>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#about">About</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                    <div class="nav-actions">
                        <a href="${pageContext.request.contextPath}/auth/staff_login" class="btn btn-outline">
                            <i class="fas fa-user-tie"></i> Staff Login
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/customer_login" class="btn btn-outline">
                            <i class="fas fa-user"></i> Customer Login
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn btn-primary">
                            <i class="fas fa-user-plus"></i> Register
                        </a>
                    </div>
                    <button class="mobile-menu-btn">
                        <i class="fas fa-bars"></i>
                    </button>
                </div>
            </nav>
        </c:otherwise>
    </c:choose>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div class="page-container">
            <div class="hero-content">
                <div class="hero-text">
                    <h1>Welcome to Device Warranty Management System</h1>
                    <p>Protect your devices with confidence using our smart and reliable warranty system. Experience seamless service, efficient management, and trusted support — all in one platform built for your peace of mind.</p>
                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn btn-primary">
                            Create Warranty Contract <i class="fas fa-arrow-right"></i>
                        </a>
                        <a href="#features" class="btn btn-outline">
                            Learn More <i class="fas fa-chevron-down"></i>
                        </a>
                    </div>
                </div>
                <div class="hero-image">
                    <img src="${pageContext.request.contextPath}/assets/images/hero-image.jpg" alt="Device Warranty Management" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <div class="hero-placeholder" style="display: none;">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features-section">
        <div class="page-container">
            <h2 class="section-title">Why Choose Our Warranty System</h2>
            <p class="section-subtitle">Comprehensive protection and exceptional service for all your devices</p>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-file-contract"></i>
                    </div>
                    <h3>Easy Contract Creation</h3>
                    <p>Customers can quickly create warranty contracts online with a simple and intuitive process</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Comprehensive Coverage</h3>
                    <p>Full protection for your devices including repairs, replacements, and technical support</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-tools"></i>
                    </div>
                    <h3>Professional Service</h3>
                    <p>Expert technicians ready to diagnose and repair your devices efficiently</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Real-Time Tracking</h3>
                    <p>Monitor your service requests and warranty status anytime, anywhere</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="services-section">
        <div class="page-container">
            <h2 class="section-title">Our Services</h2>
            <p class="section-subtitle">Complete warranty solutions for customers and staff</p>
            <div class="services-grid">
                <div class="service-card">
                    <i class="fas fa-user-check"></i>
                    <h3>Customer Services</h3>
                    <p>Register devices, create warranty contracts, submit service requests, and track repair status in real-time</p>
                </div>
                <div class="service-card">
                    <i class="fas fa-user-cog"></i>
                    <h3>Staff Operations</h3>
                    <p>Process warranty claims, manage repair workflows, update service status, and maintain customer records</p>
                </div>
                <div class="service-card">
                    <i class="fas fa-headset"></i>
                    <h3>Support Center</h3>
                    <p>24/7 customer support for warranty inquiries, technical assistance, and service coordination</p>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="about-section">
        <div class="page-container">
            <div class="about-content">
                <div class="about-text">
                    <h2>About DWMS</h2>
                    <p>Device Warranty Management System (DWMS) is a comprehensive platform designed to streamline warranty management for both customers and service providers. We connect device owners with professional repair services through an efficient, transparent, and user-friendly system.</p>
                    <p>Our mission is to make warranty management simple and accessible, ensuring your devices are always protected and serviced by qualified professionals. With advanced tracking, automated workflows, and dedicated support, we're revolutionizing how warranties are managed.</p>
                    <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn btn-primary">
                        Get Started Today <i class="fas fa-rocket"></i>
                    </a>
                </div>
                <div class="about-image">
                    <i class="fas fa-laptop-medical"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="contact-section">
        <div class="page-container">
            <h2 class="section-title">Get In Touch</h2>
            <p class="section-subtitle">Have questions about our warranty services? We're here to help</p>
            <div class="contact-content">
                <form class="contact-form">
                    <div class="form-group">
                        <label>Your Name</label>
                        <input type="text" placeholder="Enter your name" required>
                    </div>
                    <div class="form-group">
                        <label>Your Email</label>
                        <input type="email" placeholder="Enter your email" required>
                    </div>
                    <div class="form-group">
                        <label>Subject</label>
                        <input type="text" placeholder="e.g., Warranty Inquiry">
                    </div>
                    <div class="form-group">
                        <label>Message</label>
                        <textarea placeholder="Your message" rows="5" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        Send Message <i class="fas fa-paper-plane"></i>
                    </button>
                </form>
                <div class="contact-info">
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <h4>Service Center Address</h4>
                            <p>123 Tech Avenue, Innovation District, City 10000</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <div>
                            <h4>Support Hotline</h4>
                            <p>+1 (800) 123-DWMS (3967)</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <h4>Email Support</h4>
                            <p>support@dwms-warranty.com</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="page-container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>🔧 DWMS</h3>
                    <p>Your trusted partner for device warranty management and professional repair services.</p>
                    <div class="social-links">
                        <a href="https://hunterskg.itch.io/spending-challenge-ssg"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="#home">Home</a></li>
                        <li><a href="#features">Features</a></li>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#about">About Us</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Support</h4>
                    <ul>
                        <li><a href="#">Warranty FAQ</a></li>
                        <li><a href="#">Service Policy</a></li>
                        <li><a href="#">Terms & Conditions</a></li>
                        <li><a href="#contact">Contact Support</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 DWMS - Device Warranty Management System. All rights reserved.</p>
            </div>
        </div>
    </footer>

</div>
<!-- End main-wrapper -->

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebar = document.getElementById('sidebar');
        const body = document.body;

        // Sidebar toggle functionality
        if (sidebar) {
            // Start with sidebar visible on load (default state)
            body.classList.add('sidebar-visible');

            // Get all clickable logo elements
            const logoElements = document.querySelectorAll('.logo, .navbar-logo, .logo a, .navbar-logo span, .navbar-logo div, .navbar-brand');

            logoElements.forEach(function(logo) {
                logo.style.cursor = 'pointer';
                logo.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    // Toggle sidebar
                    sidebar.classList.toggle('sidebar-hidden');
                    body.classList.toggle('sidebar-visible');

                    // Store state
                    localStorage.setItem('sidebarHidden', sidebar.classList.contains('sidebar-hidden') ? 'true' : 'false');
                });
            });

            // Restore state from localStorage
            const sidebarHidden = localStorage.getItem('sidebarHidden');
            if (sidebarHidden === 'true') {
                sidebar.classList.add('sidebar-hidden');
                body.classList.remove('sidebar-visible');
            }
        }

        // Smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                if (href && href !== '#') {
                    e.preventDefault();
                    const target = document.querySelector(href);
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                }
            });
        });

        // Form submission
        const contactForm = document.querySelector('.contact-form');
        if (contactForm) {
            contactForm.addEventListener('submit', (e) => {
                e.preventDefault();
                alert('Thank you for contacting DWMS! Our support team will respond within 24 hours.');
                contactForm.reset();
            });
        }
    });
</script>

</body>
</html>