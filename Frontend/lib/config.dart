class Config {
  static const String baseUrl = 'http://10.222.144.176/trackademy/'; // << trailing slash

  // Teacher endpoints
  static const String saveAttendance = '${baseUrl}save_attendance.php';
  static const String saveTopic = "${baseUrl}save_topic.php";
  static const String saveTopicReference = "${baseUrl}save_topic_reference.php";

  static const String signup = '${baseUrl}student_signup.php';
  static const String getStudentAttendance = "${baseUrl}get_student_attendance.php";
  static const String studentLoginUrl = "${baseUrl}student_login.php";
}
