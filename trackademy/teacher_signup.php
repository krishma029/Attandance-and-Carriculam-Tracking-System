<?php
header('Content-Type: application/json');

$host = "localhost";
$port = "5432";
$dbname = "trackademy_db";
$user = "postgres";
$password = "admin123";

$conn = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$data = json_decode(file_get_contents("php://input"), true);
$full_name = $data['full_name'];
$teacher_id = $data['teacher_id'];
$email = $data['email'];
$phone = $data['phone'];
$password = password_hash($data['password'], PASSWORD_DEFAULT);

try {
    $stmt = $conn->prepare("INSERT INTO teachers (teacher_id, full_name, email, phone, password) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$teacher_id, $full_name, $email, $phone, $password]);
    echo json_encode(['status' => 'success', 'message' => 'Teacher registered successfully']);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
