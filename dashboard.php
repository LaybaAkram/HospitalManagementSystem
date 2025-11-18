<?php
require_once 'config.php';
checkLogin();

$conn = getDBConnection();

// Get statistics
$result = $conn->query("SELECT COUNT(*) as count FROM Patients");
$total_patients = $result->fetch_assoc()['count'];

$result = $conn->query("SELECT COUNT(*) as count FROM Staff");
$total_staff = $result->fetch_assoc()['count'];

$result = $conn->query("SELECT COUNT(*) as count FROM Appointments WHERE DATE(appointment_date) = CURDATE()");
$todays_appointments = $result->fetch_assoc()['count'];

$result = $conn->query("SELECT COALESCE(SUM(total_amount), 0) as total FROM Billing WHERE payment_status = 'Paid'");
$total_revenue = $result->fetch_assoc()['total'];

$result = $conn->query("SELECT COUNT(*) as count FROM Billing WHERE payment_status = 'Pending'");
$pending_bills = $result->fetch_assoc()['count'];

$result = $conn->query("SELECT COUNT(*) as count FROM Admissions WHERE status = 'Admitted'");
$current_admissions = $result->fetch_assoc()['count'];

$result = $conn->query("SELECT SUM(available_beds) as total FROM Rooms");
$available_beds = $result->fetch_assoc()['total'] ?? 0;

$result = $conn->query("SELECT COUNT(*) as count FROM Appointments WHERE status = 'Scheduled' AND appointment_date > NOW()");
$pending_appointments = $result->fetch_assoc()['count'];

// Recent appointments
$recent_appointments = $conn->query("
    SELECT a.*, 
           CONCAT(p.first_name, ' ', p.last_name) as patient_name,
           CONCAT(s.first_name, ' ', s.last_name) as doctor_name,
           d.dept_name
    FROM Appointments a
    JOIN Patients p ON a.patient_id = p.patient_id
    JOIN Staff s ON a.staff_id = s.staff_id
    LEFT JOIN Departments d ON a.dept_id = d.dept_id
    ORDER BY a.appointment_date DESC
    LIMIT 5
");

// Recent patients
$recent_patients = $conn->query("
    SELECT * FROM Patients 
    ORDER BY registration_date DESC 
    LIMIT 5
");
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Hospital Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: #f5f7fa;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            font-size: 24px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
            font-weight: 600;
        }
        
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            background: rgba(255,255,255,0.2);
            border-radius: 8px;
            transition: background 0.3s;
        }
        
        .navbar a:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .main-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }
        
        .sidebar {
            width: 260px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            padding: 20px 0;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 5px;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
            gap: 12px;
        }
        
        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .sidebar-menu i {
            width: 20px;
            text-align: center;
        }
        
        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        
        .page-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .page-header p {
            color: #666;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stat-card i {
            font-size: 48px;
            opacity: 0.3;
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: 700;
        }
        
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        
        .card h3 {
            margin-bottom: 20px;
            color: #333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #e0e0e0;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .badge {
            padding: 5px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-scheduled {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .badge-completed {
            background: #e8f5e9;
            color: #388e3c;
        }
        
        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .tables-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 1200px) {
            .tables-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">
            <i class="fas fa-hospital"></i>
            Hospital Management System
        </div>
        <div class="navbar-right">
            <div class="user-info">
                <div class="user-avatar">
                    <?php echo strtoupper(substr($_SESSION['name'], 0, 1)); ?>
                </div>
                <div>
                    <div style="font-weight: 600;"><?php echo $_SESSION['name']; ?></div>
                    <div style="font-size: 12px; opacity: 0.8;"><?php echo $_SESSION['role']; ?></div>
                </div>
            </div>
            <a href="/hospital_management/logout.php">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
    
    <div class="main-container">
        <div class="sidebar">
            <ul class="sidebar-menu">
                <li>
                    <a href="/hospital_management/dashboard.php" class="active">
                        <i class="fas fa-dashboard"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="/hospital_management/patients/list.php">
                        <i class="fas fa-users"></i>
                        <span>Patients</span>
                    </a>
                </li>
                <li>
                    <a href="/hospital_management/appointments/list.php">
                        <i class="fas fa-calendar-check"></i>
                        <span>Appointments</span>
                    </a>
                </li>
                <li>
                    <a href="/hospital_management/medical_records/list.php">
                        <i class="fas fa-file-medical"></i>
                        <span>Medical Records</span>
                    </a>
                </li>
                <li>
                    <a href="/hospital_management/billing/list.php">
                        <i class="fas fa-file-invoice-dollar"></i>
                        <span>Billing</span>
                    </a>
                </li>
                <li>
                    <a href="/hospital_management/staff/list.php">
                        <i class="fas fa-user-md"></i>
                        <span>Staff</span>
                    </a>
                </li>
                <li>
                    <a href="/hospital_management/reports/dashboard.php">
                        <i class="fas fa-chart-line"></i>
                        <span>Reports</span>
                    </a>
                </li>
            </ul>
        </div>
        
        <div class="content">
            <div class="page-header">
                <h1><i class="fas fa-dashboard"></i> Dashboard</h1>
                <p>Welcome back, <?php echo $_SESSION['name']; ?>!</p>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <div>
                        <div class="stat-label">Total Patients</div>
                        <div class="stat-value"><?php echo $total_patients; ?></div>
                    </div>
                    <i class="fas fa-users"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <div>
                        <div class="stat-label">Today's Appointments</div>
                        <div class="stat-value"><?php echo $todays_appointments; ?></div>
                    </div>
                    <i class="fas fa-calendar-day"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <div>
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">PKR <?php echo number_format($total_revenue, 0); ?></div>
                    </div>
                    <i class="fas fa-dollar-sign"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                    <div>
                        <div class="stat-label">Current Admissions</div>
                        <div class="stat-value"><?php echo $current_admissions; ?></div>
                    </div>
                    <i class="fas fa-bed"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <div>
                        <div class="stat-label">Pending Bills</div>
                        <div class="stat-value"><?php echo $pending_bills; ?></div>
                    </div>
                    <i class="fas fa-file-invoice"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);">
                    <div>
                        <div class="stat-label">Available Beds</div>
                        <div class="stat-value"><?php echo $available_beds; ?></div>
                    </div>
                    <i class="fas fa-procedures"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); color: #333;">
                    <div>
                        <div class="stat-label">Total Staff</div>
                        <div class="stat-value"><?php echo $total_staff; ?></div>
                    </div>
                    <i class="fas fa-user-md"></i>
                </div>
                
                <div class="stat-card" style="background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%); color: #333;">
                    <div>
                        <div class="stat-label">Pending Appointments</div>
                        <div class="stat-value"><?php echo $pending_appointments; ?></div>
                    </div>
                    <i class="fas fa-clock"></i>
                </div>
            </div>
            
            <div class="tables-grid">
                <div class="card">
                    <h3><i class="fas fa-calendar-alt"></i> Recent Appointments</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($recent_appointments->num_rows > 0): ?>
                                <?php while ($row = $recent_appointments->fetch_assoc()): ?>
                                <tr>
                                    <td><?php echo $row['patient_name']; ?></td>
                                    <td><?php echo $row['doctor_name']; ?></td>
                                    <td><?php echo formatDateTime($row['appointment_date']); ?></td>
                                    <td>
                                        <span class="badge badge-<?php echo strtolower($row['status']); ?>">
                                            <?php echo $row['status']; ?>
                                        </span>
                                    </td>
                                </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="4" style="text-align: center; color: #999;">No appointments yet</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
                
                <div class="card">
                    <h3><i class="fas fa-user-plus"></i> Recent Patients</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Gender</th>
                                <th>Blood</th>
                                <th>Registered</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($recent_patients->num_rows > 0): ?>
                                <?php while ($row = $recent_patients->fetch_assoc()): ?>
                                <tr>
                                    <td><?php echo $row['first_name'] . ' ' . $row['last_name']; ?></td>
                                    <td><?php echo $row['gender']; ?></td>
                                    <td><span class="badge badge-info"><?php echo $row['blood_group']; ?></span></td>
                                    <td><?php echo formatDate($row['registration_date']); ?></td>
                                </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="4" style="text-align: center; color: #999;">No patients yet</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<?php $conn->close(); ?>