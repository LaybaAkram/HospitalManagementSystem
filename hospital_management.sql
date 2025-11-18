DROP DATABASE IF EXISTS hospital_management;
CREATE DATABASE hospital_management;
USE hospital_management;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    phone_number VARCHAR(15),
    budget DECIMAL(12,2)
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    cnic VARCHAR(15) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role ENUM('Doctor', 'Nurse', 'Admin', 'Technician') NOT NULL,
    specialization VARCHAR(100),
    dept_id INT,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    salary VARBINARY(256), -- Encrypted for security
    hire_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE SET NULL
);

-- Patients Table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    cnic VARCHAR(15) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    blood_group VARCHAR(5),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    emergency_contact VARCHAR(15),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Medical_Records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    staff_id INT,
    visit_date DATETIME NOT NULL,
    diagnosis TEXT,
    symptoms TEXT,
    treatment TEXT,
    prescription TEXT,
    follow_up_date DATE,
    record_status ENUM('Active', 'Completed', 'Follow-up Required') DEFAULT 'Active',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    staff_id INT NOT NULL,
    dept_id INT,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    reason VARCHAR(200),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE SET NULL
);

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    appointment_id INT,
    bill_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    consultation_fee DECIMAL(10,2) DEFAULT 0,
    lab_charges DECIMAL(10,2) DEFAULT 0,
    medicine_charges DECIMAL(10,2) DEFAULT 0,
    room_charges DECIMAL(10,2) DEFAULT 0,
    other_charges DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS 
        (consultation_fee + lab_charges + medicine_charges + room_charges + other_charges) STORED,
    payment_status ENUM('Pending', 'Paid', 'Partially Paid') DEFAULT 'Pending',
    payment_method VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE SET NULL
);

CREATE TABLE Rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type ENUM('General', 'Private', 'ICU', 'Emergency') NOT NULL,
    dept_id INT,
    bed_capacity INT DEFAULT 1,
    available_beds INT DEFAULT 1,
    rate_per_day DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE SET NULL
);

CREATE TABLE Admissions (
    admission_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    room_id INT NOT NULL,
    admission_date DATETIME NOT NULL,
    discharge_date DATETIME,
    admitted_by INT,
    admission_reason TEXT,
    status ENUM('Admitted', 'Discharged') DEFAULT 'Admitted',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE RESTRICT,
    FOREIGN KEY (admitted_by) REFERENCES Staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE Lab_Tests (
    test_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    test_name VARCHAR(100) NOT NULL,
    test_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    result TEXT,
    conducted_by INT,
    test_cost DECIMAL(10,2),
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (conducted_by) REFERENCES Staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    expiry_date DATE,
    reorder_level INT DEFAULT 10
);

-- PART 3: SAMPLE DATA INSERTION 
INSERT INTO Departments (dept_name, location, phone_number, budget) VALUES
('Cardiology', 'Building A - Floor 3', '051-1234567', 5000000.00),
('Orthopedics', 'Building B - Floor 2', '051-1234568', 4000000.00),
('Pediatrics', 'Building A - Floor 1', '051-1234569', 3500000.00),
('Emergency', 'Building C - Ground Floor', '051-1234570', 6000000.00),
('Radiology', 'Building B - Floor 1', '051-1234571', 3000000.00);

INSERT INTO Staff (cnic, first_name, last_name, role, specialization, dept_id, phone_number, email, salary, hire_date) VALUES
('42101-1234567-1', 'Dr. Ahmed', 'Khan', 'Doctor', 'Cardiologist', 1, '0300-1234567', 'ahmed.khan@hospital.pk', NULL, '2020-01-15'),
('42101-2345678-2', 'Dr. Fatima', 'Ali', 'Doctor', 'Orthopedic Surgeon', 2, '0301-2345678', 'fatima.ali@hospital.pk', NULL, '2019-05-20'),
('42101-3456789-3', 'Dr. Hassan', 'Malik', 'Doctor', 'Pediatrician', 3, '0302-3456789', 'hassan.malik@hospital.pk', NULL, '2021-03-10'),
('42101-4567890-4', 'Dr. Ayesha', 'Siddiqui', 'Doctor', 'Emergency Medicine', 4, '0303-4567890', 'ayesha.siddiqui@hospital.pk', NULL, '2018-07-01'),
('42101-5678901-5', 'Nurse Zainab', 'Ahmed', 'Nurse', 'General Nursing', 1, '0304-5678901', 'zainab.ahmed@hospital.pk', NULL, '2021-09-15'),
('42101-6789012-6', 'Nurse Bilal', 'Hussain', 'Nurse', 'ICU Specialist', 4, '0305-6789012', 'bilal.hussain@hospital.pk', NULL, '2020-11-20'),
('42101-7890123-7', 'Muhammad', 'Raza', 'Technician', 'Lab Technician', 5, '0306-7890123', 'muhammad.raza@hospital.pk', NULL, '2022-01-05'),
('42101-8901234-8', 'Sana', 'Tariq', 'Admin', 'Receptionist', NULL, '0307-8901234', 'sana.tariq@hospital.pk', NULL, '2021-06-10');

INSERT INTO Patients (cnic, first_name, last_name, date_of_birth, gender, blood_group, phone_number, email, address, city, emergency_contact) VALUES
('42201-1111111-1', 'Ali', 'Raza', '1990-05-15', 'Male', 'A+', '0321-1111111', 'ali.raza@email.pk', 'House 123, Street 5, F-7', 'Islamabad', '0321-9999991'),
('42201-2222222-2', 'Maryam', 'Nawaz', '1985-08-22', 'Female', 'B+', '0322-2222222', 'maryam.nawaz@email.pk', 'Plot 45, Sector G-10', 'Islamabad', '0322-9999992'),
('42201-3333333-3', 'Usman', 'Khalid', '2015-12-10', 'Male', 'O+', '0323-3333333', 'usman.khalid@email.pk', 'Flat 7, DHA Phase 2', 'Rawalpindi', '0323-9999993'),
('42201-4444444-4', 'Hina', 'Butt', '1978-03-18', 'Female', 'AB+', '0324-4444444', 'hina.butt@email.pk', 'House 89, Satellite Town', 'Rawalpindi', '0324-9999994'),
('42201-5555555-5', 'Kamran', 'Shah', '1995-11-30', 'Male', 'A-', '0325-5555555', 'kamran.shah@email.pk', 'Street 12, I-8', 'Islamabad', '0325-9999995'),
('42201-6666666-6', 'Sadia', 'Iqbal', '1988-07-25', 'Female', 'O-', '0326-6666666', 'sadia.iqbal@email.pk', 'House 34, Blue Area', 'Islamabad', '0326-9999996'),
('42201-7777777-7', 'Farhan', 'Ahmed', '2010-09-14', 'Male', 'B-', '0327-7777777', 'farhan.ahmed@email.pk', 'Flat 12, Bahria Town', 'Rawalpindi', '0327-9999997'),
('42201-8888888-8', 'Nida', 'Khan', '1992-04-05', 'Female', 'A+', '0328-8888888', 'nida.khan@email.pk', 'Plot 78, E-11', 'Islamabad', '0328-9999998');

-- Insert Medical Records
INSERT INTO Medical_Records (patient_id, staff_id, visit_date, diagnosis, symptoms, treatment, prescription, follow_up_date, record_status) VALUES
(1, 1, '2025-10-15 10:30:00', 'Hypertension', 'High blood pressure, headache', 'Medication and diet control', 'Amlodipine 5mg once daily', '2025-11-15', 'Active'),
(2, 2, '2025-10-16 14:00:00', 'Knee Pain - Osteoarthritis', 'Joint pain, difficulty walking', 'Physical therapy and pain management', 'Ibuprofen 400mg twice daily', '2025-10-30', 'Follow-up Required'),
(3, 3, '2025-10-17 09:00:00', 'Viral Fever', 'High fever, body aches', 'Rest and antipyretics', 'Paracetamol 500mg thrice daily', NULL, 'Completed'),
(4, 4, '2025-10-18 16:45:00', 'Acute Appendicitis', 'Severe abdominal pain', 'Emergency appendectomy performed', 'Post-operative antibiotics', '2025-10-25', 'Active'),
(5, 1, '2025-10-19 11:00:00', 'Chest Pain - Angina', 'Chest discomfort, shortness of breath', 'ECG performed, medication prescribed', 'Aspirin 75mg, Atorvastatin 20mg', '2025-11-19', 'Active');

INSERT INTO Appointments (patient_id, staff_id, dept_id, appointment_date, status, reason, notes) VALUES
(1, 1, 1, '2025-11-15 10:00:00', 'Scheduled', 'Follow-up for hypertension', 'Check BP levels'),
(2, 2, 2, '2025-10-30 14:00:00', 'Scheduled', 'Knee pain follow-up', 'Review X-rays'),
(6, 3, 3, '2025-10-28 09:30:00', 'Scheduled', 'Child vaccination', 'Routine immunization'),
(7, 3, 3, '2025-10-29 11:00:00', 'Scheduled', 'Fever and cough', 'General checkup'),
(8, 1, 1, '2025-11-01 15:00:00', 'Scheduled', 'Heart checkup', 'Routine cardiac evaluation'),
(1, 1, 1, '2025-10-15 10:30:00', 'Completed', 'Regular checkup', NULL),
(3, 3, 3, '2025-10-17 09:00:00', 'Completed', 'Fever treatment', NULL);

INSERT INTO Billing (patient_id, appointment_id, consultation_fee, lab_charges, medicine_charges, room_charges, other_charges, payment_status, payment_method) VALUES
(1, 6, 2000.00, 1500.00, 800.00, 0, 0, 'Paid', 'Cash'),
(2, 2, 2500.00, 2000.00, 1200.00, 0, 0, 'Pending', NULL),
(3, 7, 1500.00, 0, 500.00, 0, 0, 'Paid', 'Card'),
(4, NULL, 3000.00, 5000.00, 2000.00, 15000.00, 3000.00, 'Partially Paid', 'Cash'),
(5, NULL, 2000.00, 3000.00, 1500.00, 0, 0, 'Paid', 'Online');

INSERT INTO Rooms (room_number, room_type, dept_id, bed_capacity, available_beds, rate_per_day) VALUES
('G-101', 'General', 3, 4, 2, 2000.00),
('G-102', 'General', 2, 4, 4, 2000.00),
('P-201', 'Private', 1, 1, 0, 5000.00),
('P-202', 'Private', 2, 1, 1, 5000.00),
('ICU-301', 'ICU', 4, 2, 1, 10000.00),
('ER-001', 'Emergency', 4, 8, 5, 3000.00);

INSERT INTO Admissions (patient_id, room_id, admission_date, discharge_date, admitted_by, admission_reason, status) VALUES
(4, 3, '2025-10-18 17:00:00', NULL, 4, 'Post-operative care - Appendectomy', 'Admitted'),
(5, 5, '2025-10-19 12:00:00', '2025-10-21 14:00:00', 1, 'Cardiac observation', 'Discharged');

INSERT INTO Lab_Tests (patient_id, test_name, test_date, result, conducted_by, test_cost, status) VALUES
(1, 'Complete Blood Count', '2025-10-15 11:00:00', 'Normal ranges', 7, 1200.00, 'Completed'),
(2, 'X-Ray - Knee', '2025-10-16 14:30:00', 'Mild arthritis visible', 7, 2000.00, 'Completed'),
(4, 'Ultrasound - Abdomen', '2025-10-18 16:30:00', 'Appendix inflammation confirmed', 7, 3000.00, 'Completed'),
(5, 'ECG', '2025-10-19 11:15:00', 'Irregular rhythm detected', 7, 2000.00, 'Completed'),
(6, 'Blood Sugar Test', '2025-10-20 09:00:00', NULL, 7, 500.00, 'Pending');

INSERT INTO Medicines (medicine_name, manufacturer, category, unit_price, stock_quantity, expiry_date, reorder_level) VALUES
('Paracetamol 500mg', 'Getz Pharma', 'Analgesic', 2.50, 5000, '2026-12-31', 500),
('Amlodipine 5mg', 'Abbott Laboratories', 'Antihypertensive', 5.00, 2000, '2026-06-30', 200),
('Ibuprofen 400mg', 'Searle Pakistan', 'Anti-inflammatory', 3.00, 3000, '2026-09-30', 300),
('Amoxicillin 500mg', 'GlaxoSmithKline', 'Antibiotic', 8.00, 1500, '2026-03-31', 150),
('Atorvastatin 20mg', 'Pfizer', 'Cholesterol', 12.00, 1000, '2026-08-31', 100),
('Aspirin 75mg', 'Bayer', 'Antiplatelet', 1.50, 8000, '2027-01-31', 800);

-- PART 4: ENCRYPTION IMPLEMENTATION
SET @encryption_key = 'Hospital2025Key!';

UPDATE Staff SET salary = AES_ENCRYPT('250000', @encryption_key) WHERE staff_id = 1;
UPDATE Staff SET salary = AES_ENCRYPT('280000', @encryption_key) WHERE staff_id = 2;
UPDATE Staff SET salary = AES_ENCRYPT('220000', @encryption_key) WHERE staff_id = 3;
UPDATE Staff SET salary = AES_ENCRYPT('260000', @encryption_key) WHERE staff_id = 4;
UPDATE Staff SET salary = AES_ENCRYPT('85000', @encryption_key) WHERE staff_id = 5;
UPDATE Staff SET salary = AES_ENCRYPT('90000', @encryption_key) WHERE staff_id = 6;
UPDATE Staff SET salary = AES_ENCRYPT('65000', @encryption_key) WHERE staff_id = 7;
UPDATE Staff SET salary = AES_ENCRYPT('55000', @encryption_key) WHERE staff_id = 8;

CREATE VIEW Staff_Salary_Decrypted AS
SELECT 
    staff_id,
    CONCAT(first_name, ' ', last_name) AS staff_name,
    role,
    CAST(AES_DECRYPT(salary, 'Hospital2025Key!') AS CHAR) AS decrypted_salary
FROM Staff;

-- PART 5: INDEXING FOR PERFORMANCE
CREATE INDEX idx_patient_cnic ON Patients(cnic);
CREATE INDEX idx_patient_name ON Patients(last_name, first_name);
CREATE INDEX idx_appointment_date ON Appointments(appointment_date);
CREATE INDEX idx_appointment_status ON Appointments(status);
CREATE INDEX idx_billing_patient ON Billing(patient_id);
CREATE INDEX idx_billing_status ON Billing(payment_status);
CREATE INDEX idx_medical_records_patient ON Medical_Records(patient_id);
CREATE INDEX idx_medical_records_date ON Medical_Records(visit_date);
CREATE INDEX idx_staff_dept ON Staff(dept_id);
CREATE INDEX idx_admissions_status ON Admissions(status);

-- PART 6: COMPLEX QUERIES (10-15 Queries)
-- Query 1: Total revenue by department (Aggregate + Join)
SELECT 
    d.dept_name,
    COUNT(DISTINCT b.bill_id) AS total_bills,
    SUM(b.total_amount) AS total_revenue
FROM Departments d
LEFT JOIN Appointments a ON d.dept_id = a.dept_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_revenue DESC;

-- Query 2: Find doctors with more than 2 appointments (Subquery)
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS doctor_name,
    s.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM Staff s
INNER JOIN Appointments a ON s.staff_id = a.staff_id
WHERE s.role = 'Doctor'
GROUP BY s.staff_id, doctor_name, s.specialization
HAVING COUNT(a.appointment_id) > 2;

-- Query 3: Patients with pending bills over 5000 PKR (Join + Filter)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.phone_number,
    b.bill_id,
    b.total_amount,
    b.payment_status
FROM Patients p
INNER JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Pending' AND b.total_amount > 5000
ORDER BY b.total_amount DESC;

-- Query 4: Average billing amount by payment method (Aggregate)
SELECT 
    payment_method,
    COUNT(*) AS total_transactions,
    AVG(total_amount) AS avg_amount,
    SUM(total_amount) AS total_amount
FROM Billing
WHERE payment_status = 'Paid'
GROUP BY payment_method;

-- Query 5: Patients who have never been admitted (Nested Query with NOT EXISTS)
SELECT 
    patient_id,
    CONCAT(first_name, ' ', last_name) AS patient_name,
    phone_number,
    city
FROM Patients p
WHERE NOT EXISTS (
    SELECT 1 
    FROM Admissions a 
    WHERE a.patient_id = p.patient_id
);

-- Query 6: Room occupancy rate by type (Complex calculation)
SELECT 
    room_type,
    COUNT(*) AS total_rooms,
    SUM(bed_capacity) AS total_capacity,
    SUM(available_beds) AS available_beds,
    SUM(bed_capacity - available_beds) AS occupied_beds,
    ROUND((SUM(bed_capacity - available_beds) / SUM(bed_capacity)) * 100, 2) AS occupancy_percentage
FROM Rooms
GROUP BY room_type;

-- Query 7: Top 5 most expensive lab tests conducted (Join + Order + Limit)
SELECT 
    lt.test_name,
    COUNT(*) AS times_conducted,
    AVG(lt.test_cost) AS avg_cost,
    SUM(lt.test_cost) AS total_revenue
FROM Lab_Tests lt
WHERE lt.status = 'Completed'
GROUP BY lt.test_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Query 8: Doctors and their total earnings from consultations (Nested query)
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS doctor_name,
    s.specialization,
    (SELECT SUM(b.consultation_fee)
     FROM Billing b
     INNER JOIN Appointments a ON b.appointment_id = a.appointment_id
     WHERE a.staff_id = s.staff_id) AS total_consultation_earnings
FROM Staff s
WHERE s.role = 'Doctor'
ORDER BY total_consultation_earnings DESC;

-- Query 9: Patients with multiple visits in October 2025 (Subquery + Having)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(mr.record_id) AS visit_count,
    GROUP_CONCAT(DATE(mr.visit_date) ORDER BY mr.visit_date SEPARATOR ', ') AS visit_dates
FROM Patients p
INNER JOIN Medical_Records mr ON p.patient_id = mr.patient_id
WHERE YEAR(mr.visit_date) = 2025 AND MONTH(mr.visit_date) = 10
GROUP BY p.patient_id, patient_name
HAVING visit_count > 1;

-- Query 10: Medicines below reorder level (Critical for inventory)
SELECT 
    medicine_id,
    medicine_name,
    manufacturer,
    stock_quantity,
    reorder_level,
    (reorder_level - stock_quantity) AS shortage,
    expiry_date
FROM Medicines
WHERE stock_quantity < reorder_level
ORDER BY shortage DESC;

-- Query 11: Department-wise staff count and average salary (Complex join with decryption)
SELECT 
    d.dept_name,
    COUNT(s.staff_id) AS staff_count,
    ROUND(AVG(CAST(AES_DECRYPT(s.salary, 'HospitalDB_SecureKey_2025') AS DECIMAL(10,2))), 2) AS avg_salary,
    ROUND(SUM(CAST(AES_DECRYPT(s.salary, 'HospitalDB_SecureKey_2025') AS DECIMAL(10,2))), 2) AS total_salary_expense
FROM Departments d
LEFT JOIN Staff s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_salary_expense DESC;

-- Query 12: Patients with their last visit and next appointment (Self join concept)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    MAX(mr.visit_date) AS last_visit,
    MIN(CASE WHEN a.appointment_date > NOW() THEN a.appointment_date END) AS next_appointment,
    DATEDIFF(MIN(CASE WHEN a.appointment_date > NOW() THEN a.appointment_date END), MAX(mr.visit_date)) AS days_gap
FROM Patients p
LEFT JOIN Medical_Records mr ON p.patient_id = mr.patient_id
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, patient_name;

-- Query 13: Monthly billing trend (Aggregate with date functions)
SELECT 
    DATE_FORMAT(bill_date, '%Y-%m') AS billing_month,
    COUNT(*) AS total_bills,
    SUM(total_amount) AS monthly_revenue,
    AVG(total_amount) AS avg_bill_amount
FROM Billing
GROUP BY billing_month
ORDER BY billing_month DESC;

-- Query 14: Find patients treated by multiple doctors (Complex group by)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(DISTINCT a.staff_id) AS different_doctors,
    GROUP_CONCAT(DISTINCT CONCAT(s.first_name, ' ', s.last_name) SEPARATOR ', ') AS doctors_consulted
FROM Patients p
INNER JOIN Appointments a ON p.patient_id = a.patient_id
INNER JOIN Staff s ON a.staff_id = s.staff_id
GROUP BY p.patient_id, patient_name
HAVING different_doctors > 1;

-- Query 15: Complete patient billing summary with all charges breakdown
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.phone_number,
    COUNT(b.bill_id) AS total_bills,
    SUM(b.consultation_fee) AS total_consultation,
    SUM(b.lab_charges) AS total_lab,
    SUM(b.medicine_charges) AS total_medicine,
    SUM(b.room_charges) AS total_room,
    SUM(b.total_amount) AS grand_total,
    SUM(CASE WHEN b.payment_status = 'Paid' THEN b.total_amount ELSE 0 END) AS paid_amount,
    SUM(CASE WHEN b.payment_status IN ('Pending', 'Partially Paid') THEN b.total_amount ELSE 0 END) AS outstanding_amount
FROM Patients p
LEFT JOIN Billing b ON p.patient_id = b.patient_id
GROUP BY p.patient_id, patient_name, p.phone_number
HAVING grand_total > 0
ORDER BY outstanding_amount DESC;

-- PART 7: STORED PROCEDURES
DELIMITER //
-- Procedure 1: Book new appointment
CREATE PROCEDURE sp_BookAppointment(
    IN p_patient_id INT,
    IN p_staff_id INT,
    IN p_dept_id INT,
    IN p_appointment_date DATETIME,
    IN p_reason VARCHAR(200)
)
BEGIN
    DECLARE staff_dept INT;
    
    -- Verify staff belongs to department
    SELECT dept_id INTO staff_dept FROM Staff WHERE staff_id = p_staff_id;
    
    IF staff_dept = p_dept_id OR p_dept_id IS NULL THEN
        INSERT INTO Appointments (patient_id, staff_id, dept_id, appointment_date, reason, status)
        VALUES (p_patient_id, p_staff_id, p_dept_id, p_appointment_date, p_reason, 'Scheduled');
        
        SELECT 'Appointment booked successfully!' AS message, LAST_INSERT_ID() AS appointment_id;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Staff does not belong to specified department';
    END IF;
END//

-- Procedure 2: Generate patient bill
CREATE PROCEDURE sp_GenerateBill(
    IN p_patient_id INT,
    IN p_appointment_id INT,
    IN p_consultation_fee DECIMAL(10,2),
    IN p_lab_charges DECIMAL(10,2),
    IN p_medicine_charges DECIMAL(10,2),
    IN p_room_charges DECIMAL(10,2),
    IN p_other_charges DECIMAL(10,2)
)
BEGIN
    INSERT INTO Billing (patient_id, appointment_id, consultation_fee, lab_charges, 
                        medicine_charges, room_charges, other_charges, payment_status)
    VALUES (p_patient_id, p_appointment_id, p_consultation_fee, p_lab_charges, 
            p_medicine_charges, p_room_charges, p_other_charges, 'Pending');
    
    SELECT 'Bill generated successfully!' AS message, 
           LAST_INSERT_ID() AS bill_id,
           (p_consultation_fee + p_lab_charges + p_medicine_charges + p_room_charges + p_other_charges) AS total_amount;
END//

-- Procedure 3: Admit patient to room
CREATE PROCEDURE sp_AdmitPatient(
    IN p_patient_id INT,
    IN p_room_id INT,
    IN p_admitted_by INT,
    IN p_admission_reason TEXT
)
BEGIN
    DECLARE available INT;
    
    -- Check room availability
    SELECT available_beds INTO available FROM Rooms WHERE room_id = p_room_id;
    
    IF available > 0 THEN
        -- Insert admission record
        INSERT INTO Admissions (patient_id, room_id, admission_date, admitted_by, admission_reason, status)
        VALUES (p_patient_id, p_room_id, NOW(), p_admitted_by, p_admission_reason, 'Admitted');
        
        -- Update room availability
        UPDATE Rooms SET available_beds = available_beds - 1 WHERE room_id = p_room_id;
        
        SELECT 'Patient admitted successfully!' AS message, LAST_INSERT_ID() AS admission_id;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No beds available in selected room';
    END IF;
END//

-- Procedure 4: Discharge patient
CREATE PROCEDURE sp_DischargePatient(
    IN p_admission_id INT
)
BEGIN
    DECLARE v_room_id INT;
    
    -- Get room ID
    SELECT room_id INTO v_room_id FROM Admissions WHERE admission_id = p_admission_id;
    
    -- Update admission record
    UPDATE Admissions 
    SET discharge_date = NOW(), status = 'Discharged'
    WHERE admission_id = p_admission_id;
    
    -- Update room availability
    UPDATE Rooms SET available_beds = available_beds + 1 WHERE room_id = v_room_id;
    
    SELECT 'Patient discharged successfully!' AS message;
END//

-- Procedure 5: Get patient complete history
CREATE PROCEDURE sp_GetPatientHistory(
    IN p_patient_id INT
)
BEGIN
    -- Patient basic info
    SELECT * FROM Patients WHERE patient_id = p_patient_id;
    
    -- Medical records
    SELECT mr.*, CONCAT(s.first_name, ' ', s.last_name) AS doctor_name
    FROM Medical_Records mr
    LEFT JOIN Staff s ON mr.staff_id = s.staff_id
    WHERE mr.patient_id = p_patient_id
    ORDER BY mr.visit_date DESC;
    
    -- Billing summary
    SELECT * FROM Billing WHERE patient_id = p_patient_id ORDER BY bill_date DESC;
    
    -- Lab tests
    SELECT * FROM Lab_Tests WHERE patient_id = p_patient_id ORDER BY test_date DESC;
END//

DELIMITER ;

-- PART 8: TRIGGERS
DELIMITER //
-- Trigger 1: Auto-update appointment status after medical record
CREATE TRIGGER trg_UpdateAppointmentStatus
AFTER INSERT ON Medical_Records
FOR EACH ROW
BEGIN
    UPDATE Appointments 
    SET status = 'Completed'
    WHERE patient_id = NEW.patient_id 
    AND staff_id = NEW.staff_id
    AND DATE(appointment_date) = DATE(NEW.visit_date)
    AND status = 'Scheduled';
END//

-- Trigger 2: Prevent deletion of staff with active appointments
CREATE TRIGGER trg_PreventStaffDeletion
BEFORE DELETE ON Staff
FOR EACH ROW
BEGIN
    DECLARE active_count INT;
    
    SELECT COUNT(*) INTO active_count
    FROM Appointments
    WHERE staff_id = OLD.staff_id 
    AND status = 'Scheduled'
    AND appointment_date > NOW();
    
    IF active_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete staff with scheduled appointments';
    END IF;
END//

-- Trigger 3: Alert for low medicine stock
CREATE TRIGGER trg_LowStockAlert
AFTER UPDATE ON Medicines
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < NEW.reorder_level THEN
        INSERT INTO System_Alerts (alert_type, message, created_at)
        VALUES ('Low Stock', 
                CONCAT('Medicine "', NEW.medicine_name, '" is below reorder level. Current stock: ', NEW.stock_quantity),
                NOW());
    END IF;
END//
DELIMITER ;

-- Create alerts table for trigger functionality
CREATE TABLE IF NOT EXISTS System_Alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    alert_type VARCHAR(50),
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_resolved BOOLEAN DEFAULT FALSE
);
-- PART 9: TRANSACTION MANAGEMENT (ACID TEST)
-- Transaction Example 1: Transfer patient between rooms
DELIMITER //

CREATE PROCEDURE sp_TransferPatient(
    IN p_admission_id INT,
    IN p_new_room_id INT
)
BEGIN
    DECLARE v_old_room_id INT;
    DECLARE v_new_available INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transaction failed. Patient transfer rolled back.' AS message;
    END;
    
    START TRANSACTION;
    
    -- Get current room
    SELECT room_id INTO v_old_room_id FROM Admissions WHERE admission_id = p_admission_id;
    
    -- Check new room availability
    SELECT available_beds INTO v_new_available FROM Rooms WHERE room_id = p_new_room_id FOR UPDATE;
    
    IF v_new_available > 0 THEN
        -- Free old room
        UPDATE Rooms SET available_beds = available_beds + 1 WHERE room_id = v_old_room_id;
        
        -- Occupy new room
        UPDATE Rooms SET available_beds = available_beds - 1 WHERE room_id = p_new_room_id;
        
        -- Update admission record
        UPDATE Admissions SET room_id = p_new_room_id WHERE admission_id = p_admission_id;
        
        COMMIT;
        SELECT 'Patient transferred successfully!' AS message;
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No beds available in new room';
    END IF;
END//

DELIMITER ;

-- PART 10: USER ROLES AND SECURITY (GRANT/REVOKE)

CREATE USER IF NOT EXISTS 'hospital_admin'@'localhost' IDENTIFIED BY 'Admin@2025Secure';
GRANT ALL PRIVILEGES ON hospital_management.* TO 'hospital_admin'@'localhost';
GRANT GRANT OPTION ON hospital_management.* TO 'hospital_admin'@'localhost';

CREATE USER IF NOT EXISTS 'hospital_manager'@'localhost' IDENTIFIED BY 'Manager@2025';
GRANT SELECT, INSERT, UPDATE ON hospital_management.* TO 'hospital_manager'@'localhost';
GRANT EXECUTE ON hospital_management.* TO 'hospital_manager'@'localhost';
-- Revoke delete privilege
REVOKE DELETE ON hospital_management.* FROM 'hospital_manager'@'localhost';

-- Analyst User (Read-Only Access)
CREATE USER IF NOT EXISTS 'hospital_analyst'@'localhost' IDENTIFIED BY 'Analyst@2025';
GRANT SELECT ON hospital_management.* TO 'hospital_analyst'@'localhost';
-- Specifically allow access to decrypt salary view
GRANT SELECT ON hospital_management.Staff_Salary_Decrypted TO 'hospital_analyst'@'localhost';

CREATE USER IF NOT EXISTS 'hospital_doctor'@'localhost' IDENTIFIED BY 'Doctor@2025';
GRANT SELECT ON hospital_management.Patients TO 'hospital_doctor'@'localhost';
GRANT SELECT ON hospital_management.Medical_Records TO 'hospital_doctor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hospital_management.Appointments TO 'hospital_doctor'@'localhost';
GRANT SELECT ON hospital_management.Lab_Tests TO 'hospital_doctor'@'localhost';
GRANT EXECUTE ON PROCEDURE hospital_management.sp_GetPatientHistory TO 'hospital_doctor'@'localhost';

CREATE USER IF NOT EXISTS 'hospital_reception'@'localhost' IDENTIFIED BY 'Reception@2025';
GRANT SELECT, INSERT, UPDATE ON hospital_management.Patients TO 'hospital_reception'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hospital_management.Appointments TO 'hospital_reception'@'localhost';
GRANT SELECT ON hospital_management.Staff TO 'hospital_reception'@'localhost';
GRANT SELECT ON hospital_management.Departments TO 'hospital_reception'@'localhost';
GRANT EXECUTE ON PROCEDURE hospital_management.sp_BookAppointment TO 'hospital_reception'@'localhost';

FLUSH PRIVILEGES;
SELECT User, Host FROM mysql.user WHERE User LIKE 'hospital_%';

-- PART 11: BACKUP AND RECOVERY COMMANDS

-- Simulate database crash and recovery
CREATE TABLE Backup_Log (
    backup_id INT PRIMARY KEY AUTO_INCREMENT,
    backup_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    backup_type VARCHAR(50),
    status VARCHAR(20)
);
INSERT INTO Backup_Log (backup_type, status) VALUES ('Full Backup', 'Completed');

-- PART 12: PERFORMANCE TESTING (WITH/WITHOUT INDEXES)

-- explain execution
EXPLAIN SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(mr.record_id) AS total_visits
FROM Patients p
LEFT JOIN Medical_Records mr ON p.patient_id = mr.patient_id
GROUP BY p.patient_id, patient_name;

-- all indexes
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    INDEX_TYPE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'hospital_management'
AND TABLE_NAME IN ('Patients', 'Appointments', 'Billing', 'Medical_Records')
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- PART 13: TABLE PARTITIONING (SCALABILITY)

CREATE TABLE Patient_Records_Archive (
    archive_id INT AUTO_INCREMENT,
    patient_id INT,
    record_data TEXT,
    archived_date DATE,
    PRIMARY KEY (archive_id, patient_id)
) ENGINE=InnoDB
PARTITION BY HASH(patient_id)
PARTITIONS 4; 

INSERT INTO Patient_Records_Archive (patient_id, record_data, archived_date)
SELECT patient_id, 
       CONCAT('Medical history for patient ', patient_id),
       CURDATE()
FROM Patients;

SELECT 
    PARTITION_NAME,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'hospital_management'
AND TABLE_NAME = 'Patient_Records_Archive'
ORDER BY PARTITION_NAME;

SELECT 
    TABLE_NAME,
    COUNT(DISTINCT PARTITION_NAME) as num_partitions,
    PARTITION_METHOD,
    SUM(TABLE_ROWS) as total_rows,
    ROUND(SUM(DATA_LENGTH) / 1024 / 1024, 2) as 'Total Data (MB)'
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'hospital_management'
AND PARTITION_NAME IS NOT NULL
GROUP BY TABLE_NAME, PARTITION_METHOD
ORDER BY TABLE_NAME;

-- PART 14: ADDITIONAL USEFUL QUERIES
-- daily appointment
SELECT 
    TIME(a.appointment_date) AS appointment_time,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    CONCAT(s.first_name, ' ', s.last_name) AS doctor_name,
    d.dept_name,
    a.reason,
    a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Staff s ON a.staff_id = s.staff_id
JOIN Departments d ON a.dept_id = d.dept_id
WHERE DATE(a.appointment_date) = '2025-10-28'
ORDER BY a.appointment_date;

-- Department performance dashboard
SELECT 
    d.dept_name,
    COUNT(DISTINCT s.staff_id) AS total_staff,
    COUNT(DISTINCT a.appointment_id) AS total_appointments,
    COUNT(DISTINCT ad.admission_id) AS total_admissions,
    COALESCE(SUM(b.total_amount), 0) AS total_revenue,
    d.budget,
    (d.budget - COALESCE(SUM(b.total_amount), 0)) AS budget_variance
FROM Departments d
LEFT JOIN Staff s ON d.dept_id = s.dept_id
LEFT JOIN Appointments a ON d.dept_id = a.dept_id
LEFT JOIN Admissions ad ON s.staff_id = ad.admitted_by
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY d.dept_id, d.dept_name, d.budget;

-- Query: Patient demographics analysis
SELECT 
    gender,
    blood_group,
    COUNT(*) AS patient_count,
    ROUND(AVG(YEAR(CURDATE()) - YEAR(date_of_birth)), 0) AS avg_age,
    city
FROM Patients
GROUP BY gender, blood_group, city
ORDER BY patient_count DESC;

-- Medicine expiry alert
SELECT 
    medicine_id,
    medicine_name,
    manufacturer,
    stock_quantity,
    expiry_date,
    DATEDIFF(expiry_date, CURDATE()) AS days_until_expiry,
    stock_quantity * unit_price AS inventory_value
FROM Medicines
WHERE expiry_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
ORDER BY expiry_date;

-- Part 15: Test procedures and triggers
CALL sp_BookAppointment(1, 1, 1, '2025-11-05 10:00:00', 'Regular checkup');

CALL sp_GenerateBill(1, NULL, 2500.00, 1000.00, 500.00, 0, 0);

CALL sp_AdmitPatient(6, 1, 4, 'High fever and observation required');

CALL sp_GetPatientHistory(1);

CALL sp_ProcessPayment(1, 'Cash');

CALL sp_TransferPatient(1, 2);

SELECT 'Database Setup Complete!' AS Status;

SELECT 
    'Total Patients' AS Metric, COUNT(*) AS Count FROM Patients
UNION ALL
SELECT 'Total Staff', COUNT(*) FROM Staff
UNION ALL
SELECT 'Total Appointments', COUNT(*) FROM Appointments
UNION ALL
SELECT 'Total Medical Records', COUNT(*) FROM Medical_Records
UNION ALL
SELECT 'Total Bills Generated', COUNT(*) FROM Billing
UNION ALL
SELECT 'Total Revenue (PKR)', SUM(total_amount) FROM Billing WHERE payment_status = 'Paid'
UNION ALL
SELECT 'Current Admissions', COUNT(*) FROM Admissions WHERE status = 'Admitted';

SHOW GRANTS FOR 'hospital_admin'@'localhost';
SHOW GRANTS FOR 'hospital_manager'@'localhost';
SHOW GRANTS FOR 'hospital_analyst'@'localhost';