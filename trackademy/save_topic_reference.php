<?php
// save_topic_reference.php
header('Content-Type: application/json');

// Database configuration
$host = "localhost";
$port = "5432";
$dbname = "trackademy_db";
$user = "postgres";
$password = "admin123";

// Connect to PostgreSQL
try {
    $conn = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed: " . $e->getMessage()
    ]);
    exit;
}

// Read JSON input
$data = json_decode(file_get_contents("php://input"), true);

$topic_id = isset($data['topic_id']) ? intval($data['topic_id']) : null;
$reference_link = isset($data['reference_link']) ? trim($data['reference_link']) : null;
$description = isset($data['description']) ? trim($data['description']) : '';

// Validate required fields
if (!$topic_id || !$reference_link) {
    echo json_encode([
        "status" => "error",
        "message" => "Missing required fields: topic_id or reference_link"
    ]);
    exit;
}

try {
    // Insert reference into database
    $stmt = $conn->prepare("
        INSERT INTO topic_references (topic_id, reference_link, description)
        VALUES (:topic_id, :reference_link, :description)
    ");
    
    $stmt->execute([
        ':topic_id' => $topic_id,
        ':reference_link' => $reference_link,
        ':description' => $description
    ]);

    echo json_encode([
        "status" => "success",
        "message" => "Reference saved successfully"
    ]);
} catch (PDOException $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Database error: " . $e->getMessage()
    ]);
}
