<?php
$host = "localhost";
$port = "5432";
$dbname = "trackademy_db";
$user = "postgres";
$password = "admin123";

try {
    $conn = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $conn->exec("SET search_path TO public");

    echo "✅ Connected to PostgreSQL successfully!<br><br>";

    $stmt = $conn->query("SELECT table_name FROM information_schema.tables WHERE table_schema='public'");
    $tables = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "<strong>Tables in public schema:</strong><br>";
    echo "<pre>";
    print_r($tables);
    echo "</pre>";

} catch (PDOException $e) {
    echo "❌ Connection failed: " . $e->getMessage();
}
?>
