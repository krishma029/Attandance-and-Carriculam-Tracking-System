<?php
$host = "localhost";
$port = "5432";
$dbname = "trackademy_db";
$user = "postgres";
$password = "admin123";

try {
    $conn = new PDO("pgsql:host=$host;port=$port;dbname=$dbname", $user, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Force schema to public
    $conn->exec("SET search_path TO public");

    echo "✅ Connected to PostgreSQL successfully!";
} catch (PDOException $e) {
    echo "❌ Connection failed: " . $e->getMessage();
}
?>
