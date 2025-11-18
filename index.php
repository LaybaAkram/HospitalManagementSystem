
<?php
require_once 'config.php';

// If already logged in, redirect
if (isset($_SESSION['user'])) {
    header('Location: dashboard.php');
    exit;
}

// Handle login
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = clean($_POST['username']);
    $password = $_POST['password'];
    $role = clean($_POST['role']);
    
    // Simple authentication (in production, use database with hashed passwords)
    $valid_users = [
        'admin' => ['password' => 'Admin@2025', 'role' => 'Admin', 'name' => 'Administrator'],
        'manager' => ['password' => 'Manager@2025', 'role' => 'Manager', 'name' => 'Hospital Manager'],
        'doctor' => ['password' => 'Doctor@2025', 'role' => 'Doctor', 'name' => 'Dr. Ahmed Khan'],
        'reception' => ['password' => 'Reception@2025', 'role' => 'Reception', 'name' => 'Reception Desk']
    ];
    
    if (isset($valid_users[$username]) && 
        $valid_users[$username]['password'] == $password && 
        $valid_users[$username]['role'] == $role) {
        $_SESSION['user'] = $username;
        $_SESSION['role'] = $role;
        $_SESSION['name'] = $valid_users[$username]['name'];
        $_SESSION['login_time'] = time();
        header('Location: dashboard.php');
        exit;
    } else {
        $error = "Invalid credentials! Please try again.";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - <?php echo APP_NAME; ?></title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            display: flex;
            max-width: 900px;
            width: 100%;
        }
        
        .login-left {
            flex: 1;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 60px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-left h1 {
            font-size: 36px;
            margin-bottom: 20px;
        }
        
        .login-left p {
            font-size: 16px;
            line-height: 1.6;
            opacity: 0.9;
        }
        
        .feature-list {
            margin-top: 30px;
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .feature-item i {
            font-size: 20px;
            margin-right: 15px;
        }
        
        .login-right {
            flex: 1;
            padding: 60px 40px;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .login-header h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .login-header p {
            color: #666;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .input-group {
            position: relative;
        }
        
        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
        
        .error {
            background: #fee;
            color: #c33;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            border-left: 4px solid #c33;
        }
        
        .demo-credentials {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            font-size: 13px;
        }
        
        .demo-credentials h4 {
            margin-bottom: 15px;
            color: #333;
        }
        
        .credential-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 8px;
            background: white;
            border-radius: 5px;
        }
        
        .credential-item strong {
            color: #667eea;
        }
        
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }
            
            .login-left {
                padding: 40px 30px;
            }
            
            .login-right {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-left">
            <h1><i class="fas fa-hospital"></i> <?php echo APP_NAME; ?></h1>
            <p>Comprehensive hospital management solution for modern healthcare facilities. Manage patients, appointments, billing, and medical records efficiently.</p>
            
            <div class="feature-list">
                <div class="feature-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Complete Patient Management</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Appointment Scheduling</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Billing & Payment Processing</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Medical Records & Reports</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Staff & Department Management</span>
                </div>
            </div>
        </div>
        
        <div class="login-right">
            <div class="login-header">
                <h2>Welcome Back!</h2>
                <p>Sign in to continue to dashboard</p>
            </div>
            
            <?php if (isset($error)): ?>
                <div class="error">
                    <i class="fas fa-exclamation-circle"></i> <?php echo $error; ?>
                </div>
            <?php endif; ?>
            
            <form method="POST" action="">
                <div class="form-group">
                    <label>Username</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="username" required placeholder="Enter your username">
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" required placeholder="Enter your password">
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Login As</label>
                    <div class="input-group">
                        <i class="fas fa-user-tag"></i>
                        <select name="role" required>
                            <option value="">Select Role</option>
                            <option value="Admin">Admin</option>
                            <option value="Manager">Manager</option>
                            <option value="Doctor">Doctor</option>
                            <option value="Reception">Reception</option>
                        </select>
                    </div>
                </div>
                
                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </button>
            </form>
            
            <div class="demo-credentials">
                <h4><i class="fas fa-info-circle"></i> Demo Credentials</h4>
                <div class="credential-item">
                    <span><strong>Admin:</strong> admin</span>
                    <span>Admin@2025</span>
                </div>
                <div class="credential-item">
                    <span><strong>Manager:</strong> manager</span>
                    <span>Manager@2025</span>
                </div>
                <div class="credential-item">
                    <span><strong>Doctor:</strong> doctor</span>
                    <span>Doctor@2025</span>
                </div>
                <div class="credential-item">
                    <span><strong>Reception:</strong> reception</span>
                    <span>Reception@2025</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

