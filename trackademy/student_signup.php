<?php
header('Content-Type: application/json');

// Database connection
$host = "localhost";
$port = "5432";
$dbname = "trackademy_db";
$user = "postgres";
$password = "admin123";

try {
    $conn = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->exec("SET search_path TO public");
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Read POST JSON data
$data = json_decode(file_get_contents('php://input'), true);

$full_name = trim($data['full_name'] ?? '');
$enrollment_no = trim($data['enrollment_no'] ?? '');
$email = trim($data['email'] ?? '');
$phone_number = trim($data['phone_number'] ?? '');
$class = trim($data['class'] ?? '');
$password = trim($data['password'] ?? '');
$terms_accepted = isset($data['terms_accepted']) ? (bool)$data['terms_accepted'] : false;

// Validation
if (!$full_name || !$enrollment_no || !$email || !$phone_number || !$class || !$password) {
    echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
    exit;
}

// Email validation (strict Gmail)
if (!preg_match('/^(?!.*\.\.)(?!\.)[A-Za-z](?=.*\d)[A-Za-z0-9._]{5,29}(?<!\.)@gmail\.com$/', $email)) {
    echo json_encode(['status' => 'error', 'message' => 'Enter a valid Gmail address']);
    exit;
}

// Phone validation
if (!preg_match('/^\d{10}$/', $phone_number)) {
    echo json_encode(['status' => 'error', 'message' => 'Enter a valid 10-digit phone number']);
    exit;
}

// Password validation
if (!preg_match('/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/', $password)) {
    echo json_encode(['status' => 'error', 'message' => 'Password must be 8+ chars, include upper, lower, number & special (@$!%*?&)']);
    exit;
}

// Check uniqueness
$stmt = $conn->prepare("SELECT * FROM students WHERE email = :email OR enrollment_no = :enrollment OR phone_number = :phone");
$stmt->execute(['email' => $email, 'enrollment' => $enrollment_no, 'phone' => $phone_number]);
if ($stmt->rowCount() > 0) {
    echo json_encode(['status' => 'error', 'message' => 'Email, enrollment number, or phone already exists']);
    exit;
}

// Hash password
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// Insert student
try {
    $insert = $conn->prepare("INSERT INTO students (full_name, enrollment_no, email, phone_number, class, password_hash, terms_accepted) VALUES (:full_name, :enrollment, :email, :phone, :class, :password_hash, :terms)");
    $insert->execute([
        'full_name' => $full_name,
        'enrollment' => $enrollment_no,
        'email' => $email,
        'phone' => $phone_number,
        'class' => $class,
        'password_hash' => $password_hash,
        'terms' => $terms_accepted
    ]);

    echo json_encode(['status' => 'success', 'message' => 'Student registered successfully']);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Registration failed: ' . $e->getMessage()]);
}
?>
