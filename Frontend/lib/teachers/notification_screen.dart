import 'package:flutter/material.dart';
import 'teacher_attendance_screen.dart';
import 'teacher_student_record_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_message_screen.dart';
import 'teacher_home_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const TeacherHomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const TeacherAttendanceScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Placeholder())); // Quiz screen
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const TeacherStudentRecordScreen()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const TeacherMessageScreen()));
        break;
      case 5:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => TeacherProfileScreen(
                  onNavigateToHome: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> meetings = [
      {
        'title': 'Department Meeting',
        'date': '11 July 2025',
        'time': '3:00 PM',
        'location': 'HOD Office'
      },
      {
        'title': 'PTM Review',
        'date': '12 July 2025',
        'time': '11:00 AM',
        'location': 'Main Hall'
      },
    ];

    final List<Map<String, String>> studentsMissedQuiz = [
      {'name': 'Simran Malhotra', 'class': '5TC2'},
      {'name': 'Om Joshi', 'class': '6TC1'},
      {'name': 'Sneha Rastogi', 'class': '5TC1'},
      {'name': 'Aryan Thakur', 'class': '6TC2'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: const Color(0xFFE8F5E9),
        foregroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "📅 Upcoming Meetings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...meetings.map((meeting) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.green),
              title: Text(meeting['title']!),
              subtitle: Text('${meeting['date']} at ${meeting['time']}'),
              trailing: Text(meeting['location']!),
            ),
          )),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          const Text(
            "🚫 Students Who Missed Quiz",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...studentsMissedQuiz.map((student) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading:
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              title: Text(student['name']!),
              subtitle: Text('Class: ${student['class']}'),
              trailing: const Text('Missed'),
            ),
          )),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5E9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -1),
            )
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green.shade800,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_rounded),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_rounded),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
