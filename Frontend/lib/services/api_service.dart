import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL points to your backend folder
  static const String baseUrl = "http://172.26.192.176/flutter_api/backend";


  // Register user API
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse("$baseUrl/parent_signup.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password, // PHP will hash it
          "role": role,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Server error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Exception: $e"};
    }
  }
}
