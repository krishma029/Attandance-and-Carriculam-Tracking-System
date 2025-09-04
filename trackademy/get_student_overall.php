<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db.php'; // Your PDO connection file

$data = json_decode(file_get_contents("php://input"), true);
$enrollment_no = $data['enrollment_no'] ?? null;

if(!$enrollment_no){
    echo json_encode(["success"=>false,"message"=>"Enrollment number missing"]);
    exit();
}

try{
    // 1️⃣ Overall attendance
    $stmt = $conn->prepare("
        SELECT COUNT(*) as total, 
               SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) as present_count
        FROM class_attendance
        WHERE enrollment_no=:enrollment_no
    ");
    $stmt->execute([':enrollment_no'=>$enrollment_no]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $total = (int)$row['total'];
    $present = (int)$row['present_count'];
    $percentage = $total>0 ? round(($present/$total)*100,1) : 0;

    // 2️⃣ Today’s tasks for absent lectures
    $today = date('Y-m-d');
    $taskStmt = $conn->prepare("
        SELECT subject, topic, reference_link
        FROM class_attendance
        WHERE enrollment_no=:enrollment_no
        AND date=:today
        AND status='Absent'
    ");
    $taskStmt->execute([':enrollment_no'=>$enrollment_no, ':today'=>$today]);
    $tasks = $taskStmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        "success"=>true,
        "attendance_percentage"=>$percentage,
        "tasks_today"=>$tasks
    ]);

}catch(Exception $e){
    echo json_encode(["success"=>false,"message"=>$e->getMessage()]);
}
?>
