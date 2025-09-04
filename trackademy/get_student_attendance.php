<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Turn off PHP warnings/notices to prevent HTML output
error_reporting(E_ERROR | E_PARSE);

include 'db.php';

// Expecting GET parameter: enrollment_no
$enrollment_no = $_GET['enrollment_no'] ?? null;

if (!$enrollment_no) {
    echo json_encode([
        "success" => false, 
        "message" => "Missing enrollment number"
    ]);
    exit();
}

try {
    // Fetch all attendance records for this student
    $stmt = $conn->prepare("
        SELECT class_name, date, status, subject, topic, reference_link, student_name
        FROM class_attendance
        WHERE enrollment_no = :enrollment_no
        ORDER BY date ASC
    ");
    $stmt->execute([':enrollment_no' => $enrollment_no]);
    $records = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($records)) {
        echo json_encode([
            "success" => true,
            "message" => "No attendance records found",
            "attendance" => [],
            "tasks" => [],
            "overall_attendance" => 0,
            "student_name" => ""
        ]);
        exit();
    }

    // Calculate overall attendance
    $total = count($records);
    $presentCount = 0;
    foreach ($records as $r) {
        if (strtolower($r['status']) === 'present') $presentCount++;
    }
    $overallAttendance = $total > 0 ? ($presentCount / $total) : 0.0;

    // Today's tasks
    $today = date('Y-m-d');
    $tasks = [];
    $studentName = $records[0]['student_name'] ?? '';

    foreach ($records as $r) {
        if (substr($r['date'], 0, 10) === $today) { // ignore time if exists
            $tasks[] = [
                "status" => $r['status'],
                "subject" => $r['subject'],
                "topic" => $r['topic'],
                "reference_link" => $r['reference_link'] ?? ""
            ];
        }
    }

    echo json_encode([
        "success" => true,
        "attendance" => $records,
        "overall_attendance" => $overallAttendance,
        "tasks" => $tasks,
        "student_name" => $studentName
    ]);

} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}
?>
