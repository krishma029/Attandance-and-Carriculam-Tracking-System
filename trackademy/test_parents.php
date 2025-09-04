<?php
header("Content-Type: application/json");
include 'db.php';

try {
    $stmt = $conn->query("SELECT id, full_name, parent_id, email, phone, created_at FROM parents");
    $parents = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "status" => "success",
        "parents" => $parents
    ]);

} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}
?>
