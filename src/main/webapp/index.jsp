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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --accent-color: #e74c3c;
            --light-bg: #ecf0f1;
            --dark-bg: #34495e;
            --navbar-bg: #0e4274;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --white: #ffffff;
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--text-dark);
            background: var(--light-bg);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Navigation */
        .navbar {
            background-image: url("${pageContext.request.contextPath}/assets/images/header-background.jpg");
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            padding: 1rem 2rem;
        }

        .navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-left {
            display: flex;
            align-items: center;
            gap: 3rem;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: bold;
        }

        .logo a {
            color: #faebef;
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logo a:hover {
            color: #667eea;
            transform: scale(1.05);
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-menu a {
            color: #faebef;
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-menu a:hover {
            color: #667eea;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .auth-buttons {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .btn-small {
            padding: 8px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9rem;
            transition: var(--transition);
            display: inline-block;
        }

        .btn-staff {
            background: transparent;
            color: #faebef;
            border: 2px solid #667eea;
        }

        .btn-staff:hover {
            background: #667eea;
            color: var(--white);
            transform: translateY(-2px);
        }

        .btn-customer {
            background: transparent;
            color: #faebef;
            border: 2px solid #667eea;
        }

        .btn-customer:hover {
            background: #667eea;
            color: var(--white);
            transform: translateY(-2px);
        }

        .btn-register {
            background: #667eea;
            color: var(--white);
            border: 2px solid #667eea;
        }

        .btn-register:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .hamburger {
            display: none;
            flex-direction: column;
            cursor: pointer;
        }

        .hamburger span {
            width: 25px;
            height: 3px;
            background: #faebef;
            margin: 3px 0;
            transition: var(--transition);
        }

        /* Hero Section - Redesigned */
        .hero {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            color: var(--text-dark);
            padding: 120px 0 80px;
            margin-top: 70px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .hero::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            right: 0;
            height: 10px;
            background: linear-gradient(to bottom, rgba(0, 0, 0, 0.05), transparent);
        }

        .hero .container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: center;
        }

        .hero-text {
            text-align: left;
        }

        .hero-text h1 {
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
            line-height: 1.2;
        }

        .hero-text p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            color: var(--text-light);
            line-height: 1.8;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
        }

        .hero-image {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-image-placeholder {
            width: 100%;
            max-width: 500px;
            height: 400px;
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.1), rgba(102, 126, 234, 0.1));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            transition: var(--transition);
        }

        .hero-image-placeholder:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        }

        .hero-image-placeholder i {
            font-size: 8rem;
            color: var(--primary-color);
            opacity: 0.3;
        }

        /* You can replace the placeholder with an actual image */
        .hero-image img {
            width: 100%;
            max-width: 500px;
            height: auto;
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            transition: var(--transition);
        }

        .hero-image img:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        }

        .btn {
            padding: 12px 30px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
            display: inline-block;
        }

        .btn-primary {
            background: var(--primary-color);
            color: var(--white);
            border: 2px solid var(--primary-color);
        }

        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }

        .btn-secondary {
            background: transparent;
            color: var(--text-dark);
            border: 2px solid var(--text-dark);
        }

        .btn-secondary:hover {
            background: var(--text-dark);
            color: var(--white);
            transform: translateY(-2px);
        }

        /* Section Header */
        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }

        .section-header h2 {
            font-size: 2.5rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .section-header p {
            font-size: 1.1rem;
            color: var(--text-light);
        }

        /* Features Section */
        .features {
            padding: 80px 0;
            background: var(--white);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            text-align: center;
            padding: 2rem;
            border-radius: 10px;
            transition: var(--transition);
            background: var(--white);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .feature-card .icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        .feature-card p {
            color: var(--text-light);
        }

        /* Services Section */
        .services {
            padding: 80px 0;
            background: var(--light-bg);
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .service-card {
            background: var(--white);
            padding: 2.5rem;
            border-radius: 10px;
            text-align: center;
            transition: var(--transition);
        }

        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .service-card i {
            font-size: 3.5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }

        .service-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        .service-card p {
            color: var(--text-light);
        }

        /* About Section */
        .about {
            padding: 80px 0;
            background: var(--white);
        }

        .about-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: center;
        }

        .about-text h2 {
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
        }

        .about-text p {
            margin-bottom: 1rem;
            color: var(--text-light);
            line-height: 1.8;
        }

        .about-text .btn {
            margin-top: 1.5rem;
        }

        .about-image .image-placeholder {
            background: var(--light-bg);
            height: 400px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .about-image .image-placeholder i {
            font-size: 5rem;
            color: var(--primary-color);
        }

        /* Contact Section */
        .contact {
            padding: 80px 0;
            background: var(--light-bg);
        }

        .contact-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
        }

        .contact-form {
            background: var(--white);
            padding: 2rem;
            border-radius: 10px;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .contact-form .btn {
            width: 100%;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .info-item {
            display: flex;
            gap: 1.5rem;
            align-items: flex-start;
        }

        .info-item i {
            font-size: 2rem;
            color: var(--primary-color);
            min-width: 40px;
        }

        .info-item h4 {
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        .info-item p {
            color: var(--text-light);
        }

        /* Footer */
        .footer {
            background: var(--dark-bg);
            color: var(--white);
            padding: 3rem 0 1rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3,
        .footer-section h4 {
            margin-bottom: 1rem;
        }

        .footer-section p {
            color: rgba(255,255,255,0.8);
            margin-bottom: 1rem;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 0.5rem;
        }

        .footer-section ul li a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: var(--transition);
        }

        .footer-section ul li a:hover {
            color: var(--primary-color);
        }

        .social-links {
            display: flex;
            gap: 1rem;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            color: var(--white);
            text-decoration: none;
            transition: var(--transition);
        }

        .social-links a:hover {
            background: var(--primary-color);
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.8);
        }

        /* Responsive Design */
        @media (max-width: 968px) {
            .nav-left {
                gap: 2rem;
            }

            .nav-menu {
                gap: 1rem;
            }

            .hero .container {
                grid-template-columns: 1fr;
            }

            .hero-text {
                text-align: center;
            }

            .hero-buttons {
                justify-content: center;
            }

            .hero-image {
                order: -1;
            }
        }

        @media (max-width: 768px) {
            .hamburger {
                display: flex;
            }

            .nav-menu {
                display: none;
                position: absolute;
                top: 70px;
                left: 0;
                width: 100%;
                background: var(--navbar-bg);
                flex-direction: column;
                padding: 1rem 0;
                box-shadow: 0 5px 10px rgba(0,0,0,0.1);
            }

            .nav-menu li {
                text-align: center;
                padding: 0.5rem 0;
            }

            .auth-buttons {
                flex-direction: column;
                width: 100%;
            }

            .btn-small {
                width: 100%;
                text-align: center;
            }

            .hero-text h1 {
                font-size: 2rem;
            }

            .hero-text p {
                font-size: 1rem;
            }

            .hero-buttons {
                flex-direction: column;
                align-items: stretch;
            }

            .about-content,
            .contact-content {
                grid-template-columns: 1fr;
            }

            .section-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar">
    <div class="container">
        <div class="nav-left">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">
                    <span>🔧 DWMS</span>
                </a>
            </div>
            <ul class="nav-menu">
                <li><a href="#home">Home</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
        </div>
        <div class="nav-right">
            <div class="auth-buttons">
                <a href="${pageContext.request.contextPath}/auth/staff_login" class="btn-small btn-staff">
                    <i class="fas fa-user-tie"></i> Staff Login
                </a>
                <a href="${pageContext.request.contextPath}/auth/customer_login" class="btn-small btn-customer">
                    <i class="fas fa-user"></i> Customer Login
                </a>
                <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn-small btn-register">
                    <i class="fas fa-user-plus"></i> Register
                </a>
            </div>
            <div class="hamburger">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section - Redesigned -->
<section id="home" class="hero">
    <div class="container">
        <div class="hero-text">
            <h1>Welcome to Device Warranty Management System</h1>
            <p>Protect your devices with confidence using our smart and reliable warranty system. Experience seamless service, efficient management, and trusted support — all in one platform built for your peace of mind.</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn btn-primary">Create Warranty Contract</a>
                <a href="#features" class="btn btn-secondary">Learn More</a>
            </div>
        </div>
        <div class="hero-image">
            <img src="${pageContext.request.contextPath}/assets/images/hero-image.jpg" alt="Device Warranty Management" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="hero-image-placeholder" style="display: none;">
                <i class="fas fa-shield-alt"></i>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section id="features" class="features">
    <div class="container">
        <div class="section-header">
            <h2>Why Choose Our Warranty System</h2>
            <p>Comprehensive protection and exceptional service for all your devices</p>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="icon">
                    <i class="fas fa-file-contract"></i>
                </div>
                <h3>Easy Contract Creation</h3>
                <p>Customers can quickly create warranty contracts online with a simple and intuitive process</p>
            </div>
            <div class="feature-card">
                <div class="icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3>Comprehensive Coverage</h3>
                <p>Full protection for your devices including repairs, replacements, and technical support</p>
            </div>
            <div class="feature-card">
                <div class="icon">
                    <i class="fas fa-tools"></i>
                </div>
                <h3>Professional Service</h3>
                <p>Expert technicians ready to diagnose and repair your devices efficiently</p>
            </div>
            <div class="feature-card">
                <div class="icon">
                    <i class="fas fa-clock"></i>
                </div>
                <h3>Real-Time Tracking</h3>
                <p>Monitor your service requests and warranty status anytime, anywhere</p>
            </div>
        </div>
    </div>
</section>

<!-- Services Section -->
<section id="services" class="services">
    <div class="container">
        <div class="section-header">
            <h2>Our Services</h2>
            <p>Complete warranty solutions for customers and staff</p>
        </div>
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
<section id="about" class="about">
    <div class="container">
        <div class="about-content">
            <div class="about-text">
                <h2>About DWMS</h2>
                <p>Device Warranty Management System (DWMS) is a comprehensive platform designed to streamline warranty management for both customers and service providers. We connect device owners with professional repair services through an efficient, transparent, and user-friendly system.</p>
                <p>Our mission is to make warranty management simple and accessible, ensuring your devices are always protected and serviced by qualified professionals. With advanced tracking, automated workflows, and dedicated support, we're revolutionizing how warranties are managed.</p>
                <a href="${pageContext.request.contextPath}/auth/customer_register" class="btn btn-primary">Get Started Today</a>
            </div>
            <div class="about-image">
                <div class="image-placeholder">
                    <i class="fas fa-laptop-medical"></i>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Contact Section -->
<section id="contact" class="contact">
    <div class="container">
        <div class="section-header">
            <h2>Get In Touch</h2>
            <p>Have questions about our warranty services? We're here to help</p>
        </div>
        <div class="contact-content">
            <form class="contact-form">
                <div class="form-group">
                    <input type="text" placeholder="Your Name" required>
                </div>
                <div class="form-group">
                    <input type="email" placeholder="Your Email" required>
                </div>
                <div class="form-group">
                    <input type="text" placeholder="Subject (e.g., Warranty Inquiry)">
                </div>
                <div class="form-group">
                    <textarea placeholder="Your Message" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Send Message</button>
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
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3>🔧 DWMS</h3>
                <p>Your trusted partner for device warranty management and professional repair services.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook"></i></a>
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

<script>
    // Mobile Navigation Toggle
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');

    hamburger.addEventListener('click', () => {
        if (navMenu.style.display === 'flex') {
            navMenu.style.display = 'none';
        } else {
            navMenu.style.display = 'flex';
        }
    });

    // Smooth Scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
                // Close mobile menu if open
                if (window.innerWidth <= 768) {
                    navMenu.style.display = 'none';
                }
            }
        });
    });

    // Navbar Background on Scroll
    window.addEventListener('scroll', () => {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.style.boxShadow = '0 2px 20px rgba(0,0,0,0.15)';
        } else {
            navbar.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
        }
    });

    // Form Submission Handler
    const contactForm = document.querySelector('.contact-form');
    contactForm.addEventListener('submit', (e) => {
        e.preventDefault();
        alert('Thank you for contacting DWMS! Our support team will respond within 24 hours.');
        contactForm.reset();
    });

    // Responsive Navigation
    window.addEventListener('resize', () => {
        if (window.innerWidth > 768) {
            navMenu.style.display = 'flex';
        } else {
            navMenu.style.display = 'none';
        }
    });
</script>
</body>
</html>