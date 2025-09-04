<?php
header("Content-Type: application/json");

// DB connection
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
    echo json_encode([
        "status" => "error",
        "message" => "DB Connection failed: " . $e->getMessage()
    ]);
    exit;
}

// Only POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
    exit;
}

// Get JSON body
$data = json_decode(file_get_contents("php://input"), true);
$enrollment_no = strtolower(trim($data['enrollment_no'] ?? '')); // normalize
$password_input = trim($data['password'] ?? '');

// Validate input
if (!$enrollment_no || !$password_input) {
    echo json_encode([
        "status" => "error",
        "message" => "Enrollment number and password are required"
    ]);
    exit;
}

try {
    // Fetch student
    $stmt = $conn->prepare("SELECT * FROM login_students WHERE LOWER(enrollment_no) = :enrollment_no LIMIT 1");
    $stmt->execute([':enrollment_no' => $enrollment_no]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$student) {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid enrollment number or password"
        ]);
        exit;
    }

    // 🔹 Plain text password comparison
    if ($password_input !== $student['password']) {
        echo json_encode([
            "status" => "error",
            "message" => "Invalid enrollment number or password"
        ]);
        exit;
    }

    // Successful login
    echo json_encode([
        "status" => "success",
        "message" => "Login successful",
        "data" => [
            "enrollment_no" => $student['enrollment_no'],
            "student_name"  => $student['student_name'],
            "class_name"    => $student['class_name']
        ]
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Error: " . $e->getMessage()
    ]);
}
?>
