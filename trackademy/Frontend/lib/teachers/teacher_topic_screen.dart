import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:Track_ademy/config.dart';

class TeacherTopicScreen extends StatefulWidget {
  final String selectedClass;
  final DateTime selectedDate;

  const TeacherTopicScreen({
    super.key,
    required this.selectedClass,
    required this.selectedDate,
  });

  @override
  State<TeacherTopicScreen> createState() => _TeacherTopicScreenState();
}

class _TeacherTopicScreenState extends State<TeacherTopicScreen> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  bool _isSubmitted = false;
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 1;

  Future<void> submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Save topic along with reference link in one API call
      final response = await http.post(
        Uri.parse(Config.saveTopic), // PHP endpoint for topics table
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "class": widget.selectedClass,
          "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate),
          "subject": subjectController.text.trim(),
          "topic_name": topicController.text.trim(),
          "reference_link": linkController.text.trim(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Server error: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      if (data["status"] != "success") {
        throw Exception(data["message"] ?? "Failed to save topic");
      }

      setState(() => _isSubmitted = true);

      Navigator.pop(context, {
        "subject": subjectController.text.trim(),
        "topic": topicController.text.trim(),
        "referenceLink": linkController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Topic and reference submitted for ${widget.selectedClass} on ${DateFormat('dd-MMM-yyyy').format(widget.selectedDate)}"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void clearForm() {
    subjectController.clear();
    topicController.clear();
    linkController.clear();
    setState(() => _isSubmitted = false);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/teacherHome');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/quiz');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/student-records');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/messages');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Topic',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Topic Submission",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Class: ${widget.selectedClass} | Date: ${DateFormat('dd-MMM-yyyy').format(widget.selectedDate)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    if (_isSubmitted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Topic submitted successfully!",
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    customInputField(
                      label: "Subject",
                      icon: Icons.menu_book_rounded,
                      controller: subjectController,
                      iconColor: Colors.deepOrange,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Subject is required";
                        }
                        if (value.trim().length < 3) {
                          return "Subject must be at least 3 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    customInputField(
                      label: "Topic Covered",
                      icon: Icons.lightbulb_outline,
                      controller: topicController,
                      iconColor: Colors.blueAccent,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Topic is required";
                        }
                        if (value.trim().length < 5) {
                          return "Topic must be at least 5 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    customInputField(
                      label: "Reference Link",
                      icon: Icons.link_rounded,
                      controller: linkController,
                      iconColor: Colors.purple,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Reference Link is required";
                        }
                        final urlPattern =
                        RegExp(r'^(https?:\/\/)[\w\-]+(\.[\w\-]+)+[/#?]?.*$');
                        if (!urlPattern.hasMatch(value.trim())) {
                          return "Please enter a valid URL (http/https)";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: submitForm,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text("Submit"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: clearForm,
                            icon: const Icon(Icons.refresh, color: Colors.green),
                            label: const Text("Clear",
                                style: TextStyle(color: Colors.green)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.green.shade700),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFE8F5E9),
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_rounded), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_rounded), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget customInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Color iconColor,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: iconColor),
        filled: true,
        fillColor: const Color(0xFFF3F6EF),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
