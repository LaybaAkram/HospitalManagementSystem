
<?php
// Database Configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'hospital_management');

// Application Settings
define('APP_NAME', 'Hospital Management System');
define('APP_VERSION', '1.0.0');
define('ENCRYPTION_KEY', 'Hospital2025Key!');

// Create Database Connection
function getDBConnection() {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    $conn->set_charset("utf8");
    return $conn;
}

// Start Session
session_start();

// Check if user is logged in
function checkLogin() {
    if (!isset($_SESSION['user'])) {
        header('Location: index.php');
        exit;
    }
}

// Check user role
function checkRole($required_role) {
    checkLogin();
    if ($_SESSION['role'] != $required_role && $_SESSION['role'] != 'Admin') {
        header('Location: dashboard.php');
        exit;
    }
}

// Sanitize input
function clean($data) {
    return htmlspecialchars(strip_tags(trim($data)));
}

// Format currency
function formatCurrency($amount) {
    return 'PKR ' . number_format($amount, 2);
}

// Format date
function formatDate($date) {
    return date('d M Y', strtotime($date));
}

// Format datetime
function formatDateTime($datetime) {
    return date('d M Y, h:i A', strtotime($datetime));
}
?>

