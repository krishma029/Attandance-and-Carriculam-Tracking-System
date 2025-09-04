<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Database config
$host = "localhost";
$port = "5432";
$dbname = "trackademy_db";
$user = "postgres";
$password = "admin123";

try {
    $pdo = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['class'], $data['subject'], $data['topic_name'], $data['date'])) {
        echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
        exit;
    }

    $class = $data['class'];
    $subject = $data['subject'];
    $topic_name = $data['topic_name'];
    $reference_link = $data['reference_link'] ?? null; // optional
    $date = $data['date'];

    // Insert or update topic for that class and date
    $sql = "
        INSERT INTO topics (class_name, subject, topic_name, reference_link, date)
        VALUES (:class, :subject, :topic_name, :reference_link, :date)
        ON CONFLICT (class_name, date) DO UPDATE
        SET subject = EXCLUDED.subject,
            topic_name = EXCLUDED.topic_name,
            reference_link = EXCLUDED.reference_link
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':class' => $class,
        ':subject' => $subject,
        ':topic_name' => $topic_name,
        ':reference_link' => $reference_link,
        ':date' => $date,
    ]);

    // Return success
    echo json_encode([
        'status' => 'success',
        'message' => 'Topic saved successfully',
        'topic_id' => $pdo->lastInsertId()
    ]);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
