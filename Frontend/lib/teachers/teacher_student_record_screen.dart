import 'package:flutter/material.dart';

class TeacherStudentRecordScreen extends StatefulWidget {
  const TeacherStudentRecordScreen({super.key});

  @override
  State<TeacherStudentRecordScreen> createState() =>
      _TeacherStudentRecordScreenState();
}

class _TeacherStudentRecordScreenState
    extends State<TeacherStudentRecordScreen> {
  final Map<String, List<String>> classStudents = {
    "5TC1": [
      "Om Yadav", "Simran Kapoor", "Om Joshi", "Anaya Iyer", "Anjali Mehta", "Aarav Thakur", "Kabir Reddy",
      "Riya Sharma", "Sneha Malhotra", "Kriti Sharma", "Rahul Desai", "Ishaan Tiwari", "Krishna Jain",
      "Aryan Chopra", "Rahul Jain", "Rohit Thakur", "Aryan Joshi", "Riya Singh", "Pooja Kapoor", "Aryan Yadav",
      "Kabir Singh", "Aditya Chopra", "Saanvi Nair", "Aryan Thakur", "Om Kapoor", "Aarav Sharma", "Tanya Chopra",
      "Meera Joshi", "Krishna Bhat", "Riya Iyer", "Yash Tiwari", "Meera Desai", "Ritika Rastogi", "Aarav Yadav",
      "Krishna Reddy", "Isha Yadav", "Anjali Verma", "Ritika Bhat", "Ritika Nair", "Kriti Chopra", "Kabir Thakur",
      "Rahul Tiwari", "Pooja Rastogi", "Anjali Rastogi", "Aryan Verma", "Sneha Desai", "Saanvi Joshi",
      "Kabir Sharma", "Isha Sharma", "Rohit Jain"
    ],
    "5TC2": [
      "Simran Malhotra", "Anjali Sharma", "Simran Rastogi", "Anaya Patel", "Saanvi Sharma", "Om Gupta",
      "Anaya Joshi", "Meera Jain", "Isha Rastogi", "Rohit Nair", "Ritika Singh", "Isha Chopra", "Ritika Chopra",
      "Neha Rastogi", "Shruti Nair", "Rohit Thakur", "Rohit Reddy", "Anaya Chopra", "Aryan Joshi",
      "Rohit Tiwari", "Karan Reddy", "Rohit Chopra", "Vivaan Tiwari", "Diya Singh", "Pooja Reddy",
      "Sneha Yadav", "Simran Tiwari", "Isha Iyer", "Kabir Rastogi", "Tanya Chopra", "Anaya Thakur",
      "Riya Iyer", "Rohit Rastogi", "Aditya Mehta", "Pooja Chopra", "Rudra Rastogi", "Anaya Yadav",
      "Ritika Verma", "Sneha Chopra", "Anjali Verma", "Anjali Chopra", "Kabir Yadav", "Meera Singh",
      "Anaya Bhat", "Sneha Nair", "Pooja Thakur", "Saanvi Jain", "Sneha Bhat", "Isha Thakur", "Om Rastogi"
    ],
    "6TC1": [
      "Rudra Thakur", "Ishaan Jain", "Neha Tiwari", "Rudra Tiwari", "Kriti Iyer", "Vivaan Iyer", "Saanvi Patel",
      "Simran Mehta", "Kriti Sharma", "Neha Patel", "Rahul Desai", "Saanvi Bhat", "Aditya Singh",
      "Siddharth Reddy", "Aryan Singh", "Anaya Tiwari", "Aryan Yadav", "Kabir Rastogi", "Krishna Verma",
      "Pooja Sharma", "Anjali Gupta", "Yash Tiwari", "Rudra Patel", "Kabir Patel", "Saanvi Kapoor",
      "Meera Thakur", "Tanya Bhat", "Rohit Singh", "Shruti Yadav", "Tanya Jain", "Kabir Tiwari",
      "Pooja Malhotra", "Aryan Tiwari", "Shruti Gupta", "Laksh Patel", "Diya Gupta", "Pooja Mehta",
      "Ritika Nair", "Aryan Jain", "Rahul Nair", "Yash Sharma", "Tanya Kapoor", "Krishna Mehta",
      "Aditya Nair", "Aarav Jain", "Anjali Rastogi", "Isha Yadav", "Tanya Malhotra", "Meera Iyer",
      "Saanvi Tiwari"
    ],
    "6TC2": [
      "Karan Yadav", "Laksh Reddy", "Aryan Patel", "Om Joshi", "Meera Reddy", "Sneha Kapoor", "Shruti Iyer",
      "Anaya Joshi", "Riya Malhotra", "Rohit Malhotra", "Simran Verma", "Diya Reddy", "Diya Bhat",
      "Om Thakur", "Siddharth Joshi", "Meera Tiwari", "Laksh Gupta", "Aditya Singh", "Shruti Desai",
      "Meera Kapoor", "Aditya Verma", "Rudra Nair", "Neha Chopra", "Kabir Singh", "Meera Verma",
      "Saanvi Iyer", "Krishna Verma", "Rahul Iyer", "Neha Jain", "Riya Iyer", "Aarav Iyer", "Neha Nair",
      "Sneha Sharma", "Aditya Mehta", "Krishna Yadav", "Aarav Yadav", "Tanya Bhat", "Aditya Thakur",
      "Tanya Joshi", "Rudra Iyer", "Shruti Gupta", "Aryan Gupta", "Diya Malhotra", "Ishaan Kapoor",
      "Aditya Malhotra", "Isha Tiwari", "Karan Thakur", "Simran Gupta", "Anjali Rastogi", "Saanvi Rastogi"
    ]
  };

  String selectedClass = "6TC1";

  List<Map<String, dynamic>> _generateStudentData(String className) {
    final students = classStudents[className]!;
    return students.asMap().entries.map((entry) {
      final i = entry.key;
      final name = entry.value;
      return {
        'roll': i + 1,
        'name': name,
        'quizzes': [
          10 + (i % 11),
          9 + ((i + 3) % 11),
        ]
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final studentData = _generateStudentData(selectedClass);
    final quizCount = studentData.first['quizzes'].length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        title: const Text("Student Records"),
        centerTitle: true,
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF2E7D32),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF2E7D32)),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: InputDecoration(
                labelText: 'Select Class',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: classStudents.keys.map((String className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(color: Colors.green.shade100),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.green.shade50),
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Roll", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Student", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            for (int i = 0; i < quizCount; i++)
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "Quiz ${i + 1}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        ...studentData.map((student) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text("${student['roll']}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(student['name']),
                              ),
                              ...student['quizzes'].map<Widget>((mark) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  "$mark",
                                  style: TextStyle(
                                    color: mark >= 17
                                        ? Colors.green
                                        : mark >= 14
                                        ? Colors.orange
                                        : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
