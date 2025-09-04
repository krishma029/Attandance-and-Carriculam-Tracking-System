<?php
header("Content-Type: application/json");

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
    echo json_encode([
        "status" => "error",
        "message" => "Database connection failed: " . $e->getMessage()
    ]);
    exit;
}

// Handle POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    $full_name  = $data['full_name'] ?? null;
    $parent_id  = $data['parent_id'] ?? null;
    $email      = $data['email'] ?? null;
    $phone      = $data['phone'] ?? null;
    $password   = $data['password'] ?? null;

    if (!$full_name || !$parent_id || !$email || !$password) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing required fields"
        ]);
        exit;
    }

    $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

    try {
        // Check if parent already exists
        $checkSql = "SELECT 1 FROM parents WHERE email = :email OR parent_id = :parent_id LIMIT 1";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([
            ':email' => $email,
            ':parent_id' => $parent_id
        ]);

        if ($checkStmt->fetch()) {
            echo json_encode([
                "status" => "error",
                "message" => "Parent already exists"
            ]);
            exit;
        }

        // Insert new parent
        $sql = "INSERT INTO parents (full_name, parent_id, email, phone, password)
                VALUES (:full_name, :parent_id, :email, :phone, :password)";
        $stmt = $conn->prepare($sql);
        $stmt->execute([
            ':full_name' => $full_name,
            ':parent_id' => $parent_id,
            ':email' => $email,
            ':phone' => $phone,
            ':password' => $hashedPassword
        ]);

        echo json_encode([
            "status" => "success",
            "message" => "Parent registered successfully"
        ]);
    } catch (Exception $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }
}
?>
