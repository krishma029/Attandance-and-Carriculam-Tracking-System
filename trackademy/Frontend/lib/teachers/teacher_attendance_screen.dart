import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'teacher_home_screen.dart';
import 'teacher_topic_screen.dart';
import 'package:Track_ademy/config.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final Map<String, List<String>> classStudents = {
    "5TC2": [
      "Simran Malhotra", "Anjali Sharma", "Simran Rastogi", "Anaya Patel",
      "Saanvi Sharma", "Om Gupta", "Anaya Joshi", "Meera Jain", "Isha Rastogi",
      "Rohit Nair", "Ritika Singh", "Isha Chopra", "Ritika Chopra",
      "Neha Rastogi", "Shruti Nair", "Rohit Thakur", "Rohit Reddy",
      "Anaya Chopra", "Aryan Joshi", "Rohit Tiwari", "Karan Reddy",
      "Rohit Chopra", "Vivaan Tiwari", "Diya Singh", "Pooja Reddy",
      "Sneha Yadav", "Simran Tiwari", "Isha Iyer", "Kabir Rastogi",
      "Tanya Chopra", "Anaya Thakur", "Riya Iyer", "Rohit Rastogi",
      "Aditya Mehta", "Pooja Chopra", "Rudra Rastogi", "Anaya Yadav",
      "Ritika Verma", "Sneha Chopra", "Anjali Verma", "Anjali Chopra",
      "Kabir Yadav", "Meera Singh", "Anaya Bhat", "Sneha Nair", "Pooja Thakur",
      "Saanvi Jain", "Sneha Bhat", "Isha Thakur", "Om Rastogi"
    ],
    "6TC1": [
      "Rudra Thakur", "Ishaan Jain", "Neha Tiwari", "Rudra Tiwari",
      "Kriti Iyer", "Vivaan Iyer", "Saanvi Patel", "Simran Mehta",
      "Kriti Sharma", "Neha Patel", "Rahul Desai", "Saanvi Bhat",
      "Aditya Singh", "Siddharth Reddy", "Aryan Singh", "Anaya Tiwari",
      "Aryan Yadav", "Kabir Rastogi", "Krishna Verma", "Pooja Sharma",
      "Anjali Gupta", "Yash Tiwari", "Rudra Patel", "Kabir Patel",
      "Saanvi Kapoor", "Meera Thakur", "Tanya Bhat", "Rohit Singh",
      "Shruti Yadav", "Tanya Jain", "Kabir Tiwari", "Pooja Malhotra",
      "Aryan Tiwari", "Shruti Gupta", "Laksh Patel", "Diya Gupta",
      "Pooja Mehta", "Ritika Nair", "Aryan Jain", "Rahul Nair",
      "Yash Sharma", "Tanya Kapoor", "Krishna Mehta", "Aditya Nair",
      "Aarav Jain", "Anjali Rastogi", "Isha Yadav", "Tanya Malhotra",
      "Meera Iyer", "Saanvi Tiwari"
    ],
    "6TC2": [
      "Karan Yadav", "Laksh Reddy", "Aryan Patel", "Om Joshi", "Meera Reddy",
      "Sneha Kapoor", "Shruti Iyer", "Anaya Joshi", "Riya Malhotra",
      "Rohit Malhotra", "Simran Verma", "Diya Reddy", "Diya Bhat", "Om Thakur",
      "Siddharth Joshi", "Meera Tiwari", "Laksh Gupta", "Aditya Singh",
      "Shruti Desai", "Meera Kapoor", "Aditya Verma", "Rudra Nair",
      "Neha Chopra", "Kabir Singh", "Meera Verma", "Saanvi Iyer",
      "Krishna Verma", "Rahul Iyer", "Neha Jain", "Riya Iyer", "Aarav Iyer",
      "Neha Nair", "Sneha Sharma", "Aditya Mehta", "Krishna Yadav",
      "Aarav Yadav", "Tanya Bhat", "Aditya Thakur", "Tanya Joshi", "Rudra Iyer",
      "Shruti Gupta", "Aryan Gupta", "Diya Malhotra", "Ishaan Kapoor",
      "Aditya Malhotra", "Isha Tiwari", "Karan Thakur", "Simran Gupta",
      "Anjali Rastogi", "Saanvi Rastogi"
    ]
  };

  final List<String> classOptions = ["6TC1", "6TC2", "5TC2"];
  String? selectedClass;
  DateTime? selectedDate;
  List<bool?> attendance = [];
  bool isSaved = false;
  bool isEditing = false;

  final Map<String, int> classOffsets = {
    "6TC1": 0,
    "6TC2": 50,
    "5TC2": 100,
  };

  void pickDate() async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void updateAttendanceListLength(int length) {
    attendance = List<bool?>.filled(length, null);
  }

  void setBulkAttendance(int index, bool value) {
    if (isSaved && !isEditing) return;
    setState(() {
      attendance[index] = value;
    });
  }

  void markAllPresent() {
    if (isSaved && !isEditing) return;
    setState(() {
      for (int i = 0; i < attendance.length; i++) {
        attendance[i] = true;
      }
    });
  }

  Future<void> saveAttendanceToBackend() async {
    if (selectedClass == null || selectedDate == null) return;

    final offset = classOffsets[selectedClass!]!;
    final studentNames = classStudents[selectedClass!]!;

    final studentsData = List.generate(attendance.length, (i) {
      return {
        "enrollment_no": (offset + i + 1).toString(),
        "student_name": studentNames[i],
        "status": (attendance[i] ?? false) ? "Present" : "Absent",
      };
    });

    final body = jsonEncode({
      "class": selectedClass,
      "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
      "students": studentsData,
    });

    try {
      final response = await http.post(
        Uri.parse(Config.saveAttendance),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final resData = jsonDecode(response.body);
      if (resData['success'] == true) {
        setState(() {
          isSaved = true;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resData['message'] ?? "Attendance saved!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${resData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentNames =
    selectedClass != null ? classStudents[selectedClass!]! : [];
    final offset = selectedClass != null ? classOffsets[selectedClass!]! : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const TeacherHomeScreen()),
                  (route) => false,
            );
          },
        ),
        title: const Text(
          'Attendance Sheet',
          style:
          TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedClass,
                    hint: const Text("Select Class"),
                    items: classOptions.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (value) {
                      if (isSaved && !isEditing) return;
                      setState(() {
                        selectedClass = value;
                        updateAttendanceListLength(
                            classStudents[value!]!.length);
                        selectedDate = null;
                        isSaved = false;
                        isEditing = false;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: isSaved && !isEditing ? null : pickDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat('dd-MMM-yyyy').format(selectedDate!),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: selectedClass == null || selectedDate == null
                ? const Center(
                child: Text(
                    "Please select class and date to take attendance"))
                : ListView.builder(
              itemCount: studentNames.length,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemBuilder: (context, index) {
                final name = studentNames[index];
                final isPresent = attendance[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 40, child: Text('${offset + index + 1}')),
                      const SizedBox(width: 12),
                      Expanded(child: Text(name)),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: isPresent,
                            activeColor: Colors.green,
                            onChanged: (isSaved && !isEditing)
                                ? null
                                : (_) => setBulkAttendance(index, true),
                          ),
                          const Text("Present"),
                          const SizedBox(width: 8),
                          Radio<bool>(
                            value: false,
                            groupValue: isPresent,
                            activeColor: Colors.red,
                            onChanged: (isSaved && !isEditing)
                                ? null
                                : (_) => setBulkAttendance(index, false),
                          ),
                          const Text("Absent"),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: (isSaved &&
                          selectedClass != null &&
                          selectedDate != null)
                          ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherTopicScreen(
                              selectedClass: selectedClass!,
                              selectedDate: selectedDate!,
                            ),
                          ),
                        );
                      }
                          : null,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("Add Topic"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: (!isSaved || isEditing) ? markAllPresent : null,
                      icon: const Icon(Icons.done_all, size: 16),
                      label: const Text("Mark All Present"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: saveAttendanceToBackend,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
