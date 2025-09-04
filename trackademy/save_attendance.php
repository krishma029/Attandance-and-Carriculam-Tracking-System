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
    $conn = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->exec("SET search_path TO public");
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Database connection failed: " . $e->getMessage()]);
    exit();
}

// Read input
$data = json_decode(file_get_contents("php://input"), true);
if (!$data) {
    echo json_encode(["success" => false, "message" => "No data received"]);
    exit();
}

// Extract data
$class = $data["class"] ?? null;
$date = $data["date"] ?? null; // expected yyyy-MM-dd
$subject = $data["subject"] ?? "General";
$topic = $data["topic"] ?? "N/A";
$reference_link = $data["reference_link"] ?? "";
$students = $data["students"] ?? [];

if (!$class || !$date || empty($students)) {
    echo json_encode(["success" => false, "message" => "Missing required fields"]);
    exit();
}

// Validate date format
$dateObj = DateTime::createFromFormat('Y-m-d', $date);
if (!$dateObj || $dateObj->format('Y-m-d') !== $date) {
    echo json_encode(["success" => false, "message" => "Invalid date format. Use yyyy-MM-dd"]);
    exit();
}

try {
    $conn->beginTransaction();

    // 1️⃣ Insert or update topic
    $topicStmt = $conn->prepare("
        INSERT INTO topics (class_name, subject, topic_name, date)
        VALUES (:class_name, :subject, :topic_name, :date)
        ON CONFLICT (class_name, date)
        DO UPDATE SET subject = EXCLUDED.subject, topic_name = EXCLUDED.topic_name
        RETURNING id
    ");
    $topicStmt->execute([
        ":class_name" => $class,
        ":subject" => $subject,
        ":topic_name" => $topic,
        ":date" => $date
    ]);
    $topicId = $topicStmt->fetchColumn();

    // 2️⃣ Insert or update reference link if provided
    if (!empty($reference_link)) {
        $refStmt = $conn->prepare("
            INSERT INTO topic_reference (topic_id, reference_link)
            VALUES (:topic_id, :reference_link)
            ON CONFLICT (topic_id)
            DO UPDATE SET reference_link = EXCLUDED.reference_link
        ");
        $refStmt->execute([
            ":topic_id" => $topicId,
            ":reference_link" => $reference_link
        ]);
    }

    // 3️⃣ Insert or update student attendance
    $attendanceStmt = $conn->prepare("
        INSERT INTO class_attendance (
            enrollment_no, student_name, class_name, date, subject, topic, reference_link, status
        )
        VALUES (:enrollment_no, :student_name, :class_name, :date, :subject, :topic, :reference_link, :status)
        ON CONFLICT (enrollment_no, date)
        DO UPDATE SET 
            student_name = EXCLUDED.student_name,
            status = EXCLUDED.status,
            subject = EXCLUDED.subject,
            topic = EXCLUDED.topic,
            reference_link = EXCLUDED.reference_link
    ");

    foreach ($students as $student) {
        $attendanceStmt->execute([
            ":enrollment_no" => $student['enrollment_no'],
            ":student_name" => $student['student_name'] ?? "",
            ":class_name" => $class,
            ":date" => $date,
            ":subject" => $subject,
            ":topic" => $topic,
            ":reference_link" => $reference_link,
            ":status" => $student['status']
        ]);
    }

    $conn->commit();

    echo json_encode([
        "success" => true,
        "message" => "Attendance, topic, and reference saved successfully",
        "topic_id" => $topicId
    ]);

} catch (Exception $e) {
    $conn->rollBack();
    echo json_encode(["success" => false, "message" => "Error: " . $e->getMessage()]);
}
?>
