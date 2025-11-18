#  Installation Guide
## Hospital Management Database System

**Version:** 1.0  
**Last Updated:** October 26, 2025  
**Authors:** Layba & Marwa

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [System Requirements](#system-requirements)
3. [Installation Steps](#installation-steps)
4. [Database Setup](#database-setup)
5. [Configuration](#configuration)
6. [Testing Installation](#testing-installation)
7. [Troubleshooting](#troubleshooting)
8. [Post-Installation](#post-installation)

---

##  Prerequisites

Before installing the Hospital Management Database System, ensure you have:

### Required Software

- **XAMPP** (Apache + MySQL + PHP) or equivalent
  - Download: [https://www.apachefriends.org](https://www.apachefriends.org)
  - Version: 8.0 or higher

- **Web Browser**
  - Chrome (recommended)
  - Firefox
  - Edge

### Optional Tools

- **MySQL Workbench** - Database design and management
- **Visual Studio Code** - Code editing
- **Git** - Version control

---

## System Requirements

### Server Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **Processor** | Dual Core 2.0 GHz | Quad Core 3.0 GHz |
| **RAM** | 4 GB | 16 GB or more |
| **Storage** | 100 GB HDD | 500 GB SSD |
| **Network** | 100 Mbps | 1 Gbps |
| **OS** | Windows 10, Linux, macOS | Windows 11, Ubuntu 22.04 |

### Client Requirements

- Any modern computer or laptop
- Minimum 2 GB RAM
- Web browser (Chrome 90+, Firefox 88+, Edge 90+)
- Internet/Network connection
- Screen resolution: 1366x768 minimum (1920x1080 recommended)

---

## Installation Steps

### Step 1: Install XAMPP

#### Windows

1. **Download XAMPP:**
   ```
   https://www.apachefriends.org/download.html
   ```

2. **Run Installer:**
   - Double-click `xampp-windows-x64-8.x.x-installer.exe`
   - Choose installation directory: `C:\xampp`
   - Select components:
     - ✅ Apache
     - ✅ MySQL
     - ✅ PHP
     - ✅ phpMyAdmin

3. **Complete Installation:**
   - Click "Next" through the wizard
   - Wait for installation to complete
   - Click "Finish"

#### Linux (Ubuntu/Debian)

```bash
# Download XAMPP
wget https://www.apachefriends.org/xampp-files/8.0.x/xampp-linux-x64-8.0.x-installer.run

# Make executable
chmod +x xampp-linux-x64-8.0.x-installer.run

# Run installer
sudo ./xampp-linux-x64-8.0.x-installer.run

# Installation directory: /opt/lampp
```

#### macOS

```bash
# Download from website
# https://www.apachefriends.org/download.html

# Open the .dmg file
# Drag XAMPP to Applications folder
# Run XAMPP from Applications
```

---

### Step 2: Start XAMPP Services

#### Windows

1. **Open XAMPP Control Panel:**
   - Start Menu → XAMPP → XAMPP Control Panel
   - Or run `C:\xampp\xampp-control.exe`

2. **Start Services:**
   - Click **"Start"** next to Apache
   - Click **"Start"** next to MySQL
   - Both should show green status

#### Linux

```bash
# Start XAMPP
sudo /opt/lampp/lampp start

# Check status
sudo /opt/lampp/lampp status

# Start only Apache
sudo /opt/lampp/lampp startapache

# Start only MySQL
sudo /opt/lampp/lampp startmysql
```

#### macOS

```bash
# Open XAMPP application
# Click "Start" for Apache and MySQL
# Or use terminal:
sudo /Applications/XAMPP/xamppfiles/xampp start
```

---

### Step 3: Download Project Files

#### Option A: Git Clone 

```bash
# Navigate to htdocs
cd C:\xampp\htdocs  # Windows
cd /opt/lampp/htdocs  # Linux
cd /Applications/XAMPP/htdocs  # macOS

# Clone repository
git clone https://github.com/yourusername/hospital-management-db.git

# Navigate to project
cd hospital-management-db
```

#### Option B: Manual Download

1. Download ZIP from GitHub
2. Extract to:
   - **Windows:** `C:\xampp\htdocs\hospital-management-db`
   - **Linux:** `/opt/lampp/htdocs/hospital-management-db`
   - **macOS:** `/Applications/XAMPP/htdocs/hospital-management-db`

---

### Step 4: Project Structure

Ensure your directory structure looks like this:

```
C:\xampp\htdocs\hospital-management-db\
├── config.php
├── index.php
├── login.php
├── dashboard.php
├── logout.php
├── README.md
├── hospital_management.sql
├── includes/
│   ├── header.php
│   ├── footer.php
│   └── functions.php
├── patients/
│   ├── list.php
│   ├── add.php
│   ├── edit.php
│   └── view.php
├── appointments/
│   ├── schedule.php
│   ├── manage.php
│   └── calendar.php
├── billing/
│   ├── create.php
│   ├── history.php
│   └── invoice.php
├── staff/
│   ├── list.php
│   ├── add.php
│   └── manage.php
├── medical_records/
│   ├── view.php
│   ├── create.php
│   └── history.php
├── reports/
│   ├── dashboard.php
│   └── analytics.php
├── assets/
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── script.js
│   └── images/
│       └── logo.png
└── docs/
    ├── installation.md
    ├── api-documentation.md
    └── user-guide.md
```

---

##  Database Setup

### Step 1: Access phpMyAdmin

1. Open web browser
2. Navigate to: `http://localhost/phpmyadmin`
3. Login (default):
   - **Username:** `root`
   - **Password:** (leave empty)

### Step 2: Create Database

#### Method A: Using phpMyAdmin Interface

1. Click **"New"** in left sidebar
2. **Database name:** `hospital_management`
3. **Collation:** `utf8mb4_unicode_ci`
4. Click **"Create"**

#### Method B: Using SQL Command

```sql
CREATE DATABASE hospital_management
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

### Step 3: Import Database Structure

1. **Select database:**
   - Click `hospital_management` in left sidebar

2. **Import SQL file:**
   - Click **"Import"** tab
   - Click **"Choose File"**
   - Select `hospital_management.sql` from project folder
   - Click **"Go"** at bottom

3. **Verify import:**
   - Check for success message
   - Click **"Structure"** tab
   - You should see 11 tables

### Step 4: Verify Tables

Expected tables:

```
✓ Departments (5 records)
✓ Staff (8 records)
✓ Patients (8+ records)
✓ Medical_Records
✓ Appointments
✓ Billing
✓ Rooms (6 records)
✓ Admissions
✓ Lab_Tests
✓ Medicines (6 records)
✓ System_Alerts
```

---

##  Configuration

### Step 1: Configure Database Connection

Edit `config.php`:

```php
<?php
// Database Configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', ''); // Your MySQL password (empty for XAMPP default)
define('DB_NAME', 'hospital_management');
define('DB_CHARSET', 'utf8mb4');

// Create database connection
try {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    // Check connection
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    
    // Set charset
    $conn->set_charset(DB_CHARSET);
    
} catch (Exception $e) {
    die("Database Error: " . $e->getMessage());
}

// Application Settings
define('APP_NAME', 'Hospital Management System');
define('APP_VERSION', '1.0');
define('APP_URL', 'http://localhost/hospital-management-db');

// Security Settings
define('SESSION_TIMEOUT', 1800); // 30 minutes
define('PASSWORD_MIN_LENGTH', 8);
define('ENCRYPTION_KEY', 'HospitalSecureKey2025'); // Change this!

// Timezone
date_default_timezone_set('Asia/Karachi');

// Error Reporting (disable in production)
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
```

### Step 2: Configure PHP Settings (Optional)

Edit `php.ini` (in XAMPP control panel → Apache → Config → PHP.ini):

```ini
# Increase upload limits
upload_max_filesize = 50M
post_max_size = 50M

# Session settings
session.gc_maxlifetime = 1800
session.cookie_lifetime = 0
session.cookie_httponly = 1

# Timezone
date.timezone = Asia/Karachi

# Error reporting (disable in production)
display_errors = On
error_reporting = E_ALL
```

### Step 3: Set File Permissions (Linux/macOS)

```bash
# Navigate to project directory
cd /opt/lampp/htdocs/hospital-management-db

# Set directory permissions
chmod 755 -R .

# Set file permissions
find . -type f -exec chmod 644 {} \;

# Make specific directories writable
chmod 777 uploads/
chmod 777 logs/
```

---

##  Testing Installation

### Step 1: Access the Application

1. **Open browser**
2. **Navigate to:**
   ```
   http://localhost/hospital-management-db
   ```

### Step 2: Test Login

Use default credentials:

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | Admin@2025 |
| Manager | manager | Manager@2025 |
| Doctor | doctor | Doctor@2025 |
| Reception | reception | Reception@2025 |

### Step 3: Verify Functionality

 **Test Checklist:**

- [ ] Login page loads correctly
- [ ] Can login with admin credentials
- [ ] Dashboard displays statistics
- [ ] Can view patient list
- [ ] Can add new patient
- [ ] Can schedule appointment
- [ ] Can view medical records
- [ ] Can create billing invoice
- [ ] Reports page loads
- [ ] Can logout successfully

### Step 4: Database Connection Test

Create `test_connection.php` in project root:

```php
<?php
require_once 'config.php';

echo "<h2>Database Connection Test</h2>";

if ($conn) {
    echo "<p style='color: green;'>✓ Connected to database successfully!</p>";
    
    // Test query
    $result = $conn->query("SELECT COUNT(*) as count FROM Patients");
    if ($result) {
        $row = $result->fetch_assoc();
        echo "<p>✓ Found {$row['count']} patients in database</p>";
    }
    
    // Check all tables
    $tables = ['Departments', 'Staff', 'Patients', 'Appointments', 
               'Medical_Records', 'Billing', 'Rooms'];
    
    echo "<h3>Table Check:</h3><ul>";
    foreach ($tables as $table) {
        $result = $conn->query("SELECT COUNT(*) as count FROM $table");
        if ($result) {
            $row = $result->fetch_assoc();
            echo "<li>✓ $table: {$row['count']} records</li>";
        }
    }
    echo "</ul>";
    
} else {
    echo "<p style='color: red;'>✗ Database connection failed!</p>";
}
?>
```

Access: `http://localhost/hospital-management-db/test_connection.php`

---
##  Troubleshooting

### Problem: Apache won't start

**Error:** Port 80 already in use

**Solution:**

1. **Check what's using port 80:**
   ```bash
   # Windows
   netstat -ano | findstr :80
   
   # Linux/macOS
   sudo lsof -i :80
   ```

2. **Change Apache port:**
   - XAMPP Control Panel → Apache → Config → httpd.conf
   - Find: `Listen 80`
   - Change to: `Listen 8080`
   - Access: `http://localhost:8080/hospital-management-db`

3. **Stop conflicting services:**
   - Windows: Stop IIS, Skype
   - macOS: Stop built-in Apache

### Problem: MySQL won't start

**Error:** Port 3306 already in use

**Solution:**

1. **Change MySQL port:**
   - XAMPP Control Panel → MySQL → Config → my.ini
   - Find: `port=3306`
   - Change to: `port=3307`
   - Update `config.php`: `define('DB_HOST', 'localhost:3307');`

2. **Stop other MySQL services:**
   - Windows Services → Stop "MySQL" service
   - Or uninstall conflicting MySQL installation

### Problem: Database import fails

**Error:** File too large or timeout

**Solution:**

1. **Edit php.ini:**
   ```ini
   upload_max_filesize = 128M
   post_max_size = 128M
   max_execution_time = 300
   max_input_time = 300
   ```

2. **Restart Apache**

3. **Alternative: Import via command line:**
   ```bash
   # Windows
   C:\xampp\mysql\bin\mysql -u root hospital_management < hospital_management.sql
   
   # Linux/macOS
   /opt/lampp/bin/mysql -u root hospital_management < hospital_management.sql
   ```

### Problem: Permission denied errors (Linux/macOS)

**Solution:**

```bash
# Give Apache user ownership
sudo chown -R daemon:daemon /opt/lampp/htdocs/hospital-management-db

# Or give write permissions
sudo chmod -R 777 /opt/lampp/htdocs/hospital-management-db
```

### Problem: Blank page or 500 error

**Solution:**

1. **Enable error reporting in config.php:**
   ```php
   error_reporting(E_ALL);
   ini_set('display_errors', 1);
   ```

2. **Check Apache error log:**
   - Windows: `C:\xampp\apache\logs\error.log`
   - Linux: `/opt/lampp/logs/error_log`

3. **Check PHP syntax:**
   ```bash
   php -l config.php
   ```

### Problem: CSS/JS not loading

**Solution:**

1. **Check file paths in HTML:**
   ```html
   <!-- Use absolute paths -->
   <link rel="stylesheet" href="/hospital-management-db/assets/css/style.css">
   ```

2. **Verify .htaccess allows file access**

3. **Clear browser cache:** Ctrl+F5

---

##  Post-Installation

### Step 1: Change Default Passwords

**IMPORTANT:** Change all default passwords immediately!

1. **Login as admin**
2. **Go to:** Settings → User Management
3. **Change passwords** for all default accounts
4. **Update encryption key** in `config.php`

### Step 2: Configure Backups

Create backup script `backup.php`:

```php
<?php
$backup_file = 'backup_' . date('Y-m-d_H-i-s') . '.sql';
$command = "mysqldump -u root hospital_management > backups/$backup_file";
exec($command);
echo "Backup created: $backup_file";
?>
```

Schedule daily backups (Linux cron):

```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * php /opt/lampp/htdocs/hospital-management-db/backup.php
```

### Step 3: Security Hardening

1. **Create .htaccess** in project root:
   ```apache
   # Disable directory browsing
   Options -Indexes
   
   # Protect config file
   <Files config.php>
       Order allow,deny
       Deny from all
   </Files>
   
   # Enable HTTPS redirect (if SSL configured)
   # RewriteEngine On
   # RewriteCond %{HTTPS} off
   # RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
   ```

2. **Remove test files:**
   ```bash
   rm test_connection.php
   ```

3. **Disable error display** in production:
   ```php
   // config.php
   error_reporting(0);
   ini_set('display_errors', 0);
   ```

### Step 4: Configure Email (Optional)

For appointment reminders and notifications:

```php
// config.php - Add email settings
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USER', 'your-email@gmail.com');
define('SMTP_PASS', 'your-password');
define('FROM_EMAIL', 'noreply@hospital.com');
define('FROM_NAME', 'Hospital Management System');
```

---

##  Installation Complete!

Your Hospital Management Database System is now installed and ready to use!

### Next Steps:

1.  Read the [User Guide](user-guide.md)
2.  Check [API Documentation](api-documentation.md)
3.  Add your staff members
4.  Start managing your hospital!

### Support:

- **Documentation:** [Full Docs](../README.md)


---

**Made with ❤️ by Layba & Marwa**  
**BBSUL University, Karachi**  
© 2025 All Rights Reserved