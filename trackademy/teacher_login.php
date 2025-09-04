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

// Only POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
    exit;
}

// Get JSON body
$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'] ?? null;
$password = $data['password'] ?? null;

if (!$email || !$password) {
    echo json_encode([
        "status" => "error",
        "message" => "Email and password are required"
    ]);
    exit;
}

try {
    // Check if teacher exists
    $stmt = $conn->prepare("SELECT * FROM teachers WHERE email = :email LIMIT 1");
    $stmt->execute([':email' => $email]);
    $teacher = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$teacher) {
        echo json_encode([
            "status" => "error",
            "message" => "Teacher not found"
        ]);
        exit;
    }

    // Verify password
    if (!password_verify($password, $teacher['password'])) {
        echo json_encode([
            "status" => "error",
            "message" => "Incorrect password"
        ]);
        exit;
    }

    // Success
    echo json_encode([
        "status" => "success",
        "message" => "Login successful",
        "data" => [
            "id" => $teacher['id'],
            "full_name" => $teacher['full_name'],
            "teacher_id" => $teacher['teacher_id'],
            "email" => $teacher['email'],
            "phone" => $teacher['phone'],
            "created_at" => $teacher['created_at']
        ]
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}
?>
