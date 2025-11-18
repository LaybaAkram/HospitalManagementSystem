# HospitalManagementSystem
This project mainly focuses of Database Management and this was created by using MySQL and PHP 
# Hospital Management Database System

> A comprehensive database management system for modern healthcare facilities built with MySQL and PHP

[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)
[![PHP](https://img.shields.io/badge/PHP-8.0-purple.svg)](https://www.php.net/)
[![Status](https://img.shields.io/badge/status-active-success.svg)]()

## Overview

The Hospital Management Database System is a full-featured healthcare management solution designed to streamline hospital operations through efficient database management. Built with MySQL and PHP, it provides comprehensive functionality for patient management, appointment scheduling, billing, and staff administration.

**Project Details:**
- **Course:** BS-AI Database & Management System
- **Semester:** Fall 2025 - 4th Semester BSAI
- **Institution:** BBSUL University, Karachi
- **Supervisor:** Mr. Anwar Ali
- **Group:** 1 (Layba, Marwa)

## Features

### Core Functionality

#### Patient Management
- Patient registration with CNIC-based identification
- Complete demographic information storage
- Medical history tracking
- Emergency contact management
- Search and filter capabilities

#### Appointment System
- Easy appointment scheduling
- Doctor availability tracking
- Department-wise appointment management
- Status updates (Scheduled, Completed, Cancelled)
- Calendar view interface

####  Medical Records
- Digital diagnosis and treatment records
- Prescription management
- Lab test result storage
- Follow-up scheduling
- Complete patient history access

#### Billing Module
- Itemized billing (consultation, lab, medicine, room)
- Auto-calculated totals
- Multiple payment methods (Cash, Card, Online, Insurance)
- Payment status tracking
- Printable invoices

#### Staff Management
- Employee registration and management
- Role assignment (Doctor, Nurse, Admin, Technician)
- Department allocation
- Encrypted salary information
- Performance tracking

#### Reports & Analytics
- Real-time dashboard statistics
- Revenue analysis by department
- Patient demographics
- Monthly trends
- Top doctors by appointments
- Payment method distribution

### Database Features

#### Security
- **Role-Based Access Control (RBAC):** 4 user roles with specific permissions
- **Data Encryption:** AES-256 encryption for salary information
- **SQL Injection Protection:** Prepared statements throughout
- **Session Management:** Secure user sessions
- **Password Security:** Hashed password storage

#### Performance
- **Indexing:** 10+ strategic indexes for fast queries
- **Query Optimization:** Optimized SELECT, JOIN, and aggregate queries
- **Table Partitioning:** Partitioned tables for scalability
- **Stored Procedures:** 7+ procedures for complex operations
- **Triggers:** 4 automated triggers for data consistency

#### Database Design
- **Normalization:** 3NF/BCNF compliance
- **Referential Integrity:** Foreign key constraints
- **ACID Transactions:** Transaction management for critical operations
- **Generated Columns:** Automated calculations
- **Cascading Actions:** Proper CASCADE/SET NULL behaviors

## Technology Stack

### Backend
- **Database:** MySQL 8.0+
- **Server-side:** PHP 8.0+
- **Web Server:** Apache 2.4 (XAMPP)

### Frontend
- **HTML5** - Structure
- **CSS3** - Styling with gradients and animations
- **JavaScript** - Client-side interactivity
- **Font Awesome 6.4** - Icons
- **Google Fonts (Poppins)** - Typography

### Tools & Libraries
- **phpMyAdmin** - Database management
- **XAMPP** - Local development environment

## Database Architecture

### Tables Overview

| Table | Purpose | Records |
|-------|---------|---------|
| Departments | Hospital departments | 5 |
| Staff | Doctors, nurses, staff | 8 |
| Patients | Patient information | 8+ |
| Medical_Records | Diagnoses & treatments | Variable |
| Appointments | Appointment scheduling | Variable |
| Billing | Financial transactions | Variable |
| Rooms | Hospital rooms & beds | 6 |
| Admissions | Patient admissions | Variable |
| Lab_Tests | Laboratory tests | Variable |
| Medicines | Pharmacy inventory | 6 |
| System_Alerts | System notifications | Variable |

### Key Relationships

```
Departments (1:M) Staff
Staff (1:M) Appointments (M:1) Patients
Patients (1:M) Medical_Records
Patients (1:M) Billing
Patients (1:M) Admissions (M:1) Rooms
```

### Database Statistics
- **Total Tables:** 11
- **Total Indexes:** 10+
- **Stored Procedures:** 7
- **Triggers:** 4
- **Views:** 1 (encrypted salary decryption)
- **Partitioned Tables:** 2

## Installation

### Prerequisites

- XAMPP (Apache + MySQL + PHP) or equivalent
- Web browser (Chrome, Firefox, Edge)
- Minimum 2GB RAM
- 500MB free disk space

### Step-by-Step Installation

#### 1. Install XAMPP

```bash
# Download from https://www.apachefriends.org
# Install to C:\xampp (Windows) or /opt/lampp (Linux)
```

#### 2. Start Services

```bash
# Open XAMPP Control Panel
# Start Apache
# Start MySQL
```

#### 3. Create Database

```bash
# Open browser: http://localhost/phpmyadmin
# Create database: hospital_management
# Import SQL file: hospital_management.sql
```

#### 4. Setup Project Files

```bash
# Create directory
mkdir C:\xampp\htdocs\hospital_management

# Copy all PHP files to this directory
# Ensure folder structure:
hospital_management/
├── config.php
├── index.php
├── dashboard.php
├── logout.php
├── includes/
│   ├── header.php
│   └── footer.php
├── patients/
├── appointments/
├── billing/
├── staff/
├── medical_records/
└── reports/
```

#### 5. Configure Database Connection

Edit `config.php`:

```php
<?php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', ''); // Your MySQL password
define('DB_NAME', 'hospital_management');

// Create connection
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
```

#### 6. Access the System

```
http://localhost/hospital_management/
```

### Default Login Credentials

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | Admin@2025 |
| Manager | manager | Manager@2025 |
| Doctor | doctor | Doctor@2025 |
| Reception | reception | Reception@2025 |

 **Important:** Change these default passwords after first login!

## Usage

### For Administrators

1. **Login** with admin credentials
2. **Dashboard** - View system statistics and analytics
3. **Manage Users** - Create/edit/delete user accounts
4. **Department Management** - Add/modify hospital departments
5. **System Configuration** - Configure system settings
6. **View Reports** - Access comprehensive reports
7. **Audit Logs** - Review system activity

### For Doctors

1. **Login** with doctor credentials
2. **View Schedule** - Check daily appointments
3. **Patient Records** - Access patient medical history
4. **Create Medical Records** - Document diagnoses and treatments
5. **Write Prescriptions** - Issue medication prescriptions
6. **Order Lab Tests** - Request laboratory tests
7. **View Reports** - Access personal performance reports

### For Reception Staff

1. **Login** with reception credentials
2. **Register Patients** - Add new patient records
3. **Schedule Appointments** - Book appointments with doctors
4. **Check-in Patients** - Process patient arrivals
5. **Generate Bills** - Create billing invoices
6. **Process Payments** - Record payment transactions
7. **Print Reports** - Generate patient reports

### For Managers

1. **Login** with manager credentials
2. **Staff Oversight** - Monitor staff performance
3. **Financial Reports** - Review revenue and expenses
4. **Department Analytics** - Analyze department performance
5. **Inventory Management** - Track medicine and supplies
6. **Capacity Planning** - Monitor room occupancy


## API Documentation

### Authentication Endpoints

#### POST /login
Login to the system

**Request:**
```json
{
    "username": "admin",
    "password": "Admin@2025"
}
```

**Response:**
```json
{
    "status": "success",
    "user_id": 1,
    "role": "Admin",
    "message": "Login successful"
}
```

### Patient Endpoints

#### GET /api/patients
Get all patients (with pagination)

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Records per page (default: 20)
- `search` (optional): Search term

**Response:**
```json
{
    "status": "success",
    "data": [
        {
            "patient_id": 1,
            "first_name": "Ahmed",
            "last_name": "Khan",
            "cnic": "42101-1234567-1",
            "phone": "0321-1234567",
            "registration_date": "2025-01-15"
        }
    ],
    "pagination": {
        "current_page": 1,
        "total_pages": 5,
        "total_records": 87
    }
}
```

#### POST /api/patients
Create new patient

**Request:**
```json
{
    "first_name": "Ahmed",
    "last_name": "Khan",
    "cnic": "42101-1234567-1",
    "date_of_birth": "1990-05-15",
    "gender": "Male",
    "phone": "0321-1234567",
    "email": "ahmed@email.com",
    "address": "House 123, Street 5, Karachi",
    "city": "Karachi",
    "blood_group": "O+",
    "emergency_contact": "0321-7654321"
}
```

### Appointment Endpoints

#### POST /api/appointments
Book new appointment

**Request:**
```json
{
    "patient_id": 1,
    "doctor_id": 3,
    "appointment_date": "2025-11-01",
    "appointment_time": "10:00:00",
    "reason": "Regular checkup"
}
```

#### GET /api/appointments/doctor/{doctor_id}
Get appointments for specific doctor

**Query Parameters:**
- `date` (optional): Filter by date (YYYY-MM-DD)
- `status` (optional): Filter by status

### Billing Endpoints

#### GET /api/billing/{patient_id}
Get billing history for patient

#### POST /api/billing/payment
Record payment

**Request:**
```json
{
    "bill_id": 15,
    "payment_method": "Card",
    "amount_paid": 5000,
    "payment_status": "Paid"
}
```

## Testing

### Test Coverage

- **Unit Tests:** 45+ test cases
- **Integration Tests:** 20+ test cases
- **Security Tests:** 15+ test cases
- **Performance Tests:** 10+ test cases

### Running Tests

#### Database Tests
```sql
-- Test patient registration
CALL TestPatientRegistration();

-- Test appointment booking
CALL TestAppointmentBooking();

-- Test billing calculation
CALL TestBillingCalculation();
```

#### Performance Tests
```sql
-- Test query performance
EXPLAIN SELECT * FROM Patients WHERE cnic = '42101-1234567-1';

-- Test with large dataset
SELECT COUNT(*) FROM Appointments WHERE appointment_date BETWEEN '2025-01-01' AND '2025-12-31';
```

### Test Results

| Test Category | Pass | Fail | Success Rate |
|---------------|------|------|--------------|
| Unit Tests | 43 | 2 | 95.6% |
| Integration | 19 | 1 | 95.0% |
| Security | 15 | 0 | 100% |
| Performance | 10 | 0 | 100% |
| **Total** | **87** | **3** | **96.7%** |


### Code Style Guidelines

#### PHP
```php
// Use camelCase for variables
$patientName = "Ahmed Khan";

// Use PascalCase for classes
class PatientManager {
    // Class implementation
}

// Use clear function names
function getPatientById($id) {
    // Function implementation
}
```

#### SQL
```sql
-- Use uppercase for SQL keywords
SELECT patient_id, first_name, last_name
FROM Patients
WHERE status = 'Active'
ORDER BY last_name ASC;

-- Use meaningful table and column names
-- Use indexes on foreign keys
```

### Commit Message Format
```
Type: Brief description

- Detailed point 1
- Detailed point 2

Closes #issue_number
```

**Types:** Add, Update, Fix, Remove, Refactor, Docs

## Team

### Project Team - Group 1

| Name | Role | Responsibilities |
|------|------|------------------|
| **Layba** | Lead Developer | Database Design, Backend Development, Frontend Development, Documentation, Testing |
| **Marwa** | Supporter | - |

### Supervision

- **Supervisor:** Mr. Anwar Ali
- **Department:** Computer Science
- **Institution:** BBSUL University, Chakiwara Campus
- **Course:** BS-AI DBMS
- **Semester:** Fall 2025 - 4th Semester BSAI

### Contact

- **Email:** laybaakrem@gmail.com


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Layba, Marwa - BBSUL University

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify the software and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Acknowledgments

- **Mr. Anwar Ali** - Professor
- **MySQL Community** - For excellent database documentation
- **PHP Community** - For helpful resources and libraries
- **Stack Overflow** - For troubleshooting assistance
- **GitHub** - For collaboration platform

## Project Statistics

- **Development Time:** 3 days
- **Total Code Lines:** 5,000+ lines
- **Database Tables:** 11
- **API Endpoints:** 25+
- **Test Cases:** 90+
- **Documentation Pages:** 42

## Support

If you encounter any issues or have questions:

**Email Support:** laybaakrem@gmail.com

## Disclaimer

This system is developed as an academic project for learning purposes. While it implements industry-standard security practices and database design principles, it should undergo thorough security auditing and testing before deployment in a real healthcare environment. The developers and Bahria University are not responsible for any data loss or security breaches if deployed in production without proper security review.

---

<div align="center">

** Made with ❤️ by Layba **

**BBSUL University, Chakiwara Campus**

© 2025 All Rights Reserved

[⬆ Back to Top](#-hospital-management-database-system)

</div>
