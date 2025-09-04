import 'package:flutter/material.dart';
import 'teacher_home_screen.dart';
import 'teacher_attendance_screen.dart';
import 'teacher_quiz_screen.dart';
import 'teacher_student_record_screen.dart';
import 'teacher_message_screen.dart';
import 'teacher_profile_screen.dart';

class TeacherMainScreen extends StatefulWidget {
  final int initialIndex;

  const TeacherMainScreen({super.key, this.initialIndex = 0});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  late int _selectedIndex;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _screens = [
      const TeacherHomeScreen(),
      const TeacherAttendanceScreen(),
      CreateQuizScreen(
        subject: 'Demo Subject',
        topic: 'Demo Topic',
        link: 'https://example.com',
        date: DateTime.now(),
      ),
      const TeacherStudentRecordScreen(),
      const TeacherMessageScreen(),
      TeacherProfileScreen(
        onNavigateToHome: () {
          Navigator.pushNamed(context, '/teacherHome');
        },
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9), // Light green background like header
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -1),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // So the container's color shows
          elevation: 0, // Remove native shadow
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
