// lib/student/student_home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;

import 'student_quiz_screen.dart';
import 'student_message_screen.dart';
import 'student_profile_screen.dart';
import 'task_page.dart';
import 'attendance_page.dart';
import 'package:Track_ademy/config.dart';

class StudentHomeScreen extends StatefulWidget {
  final String enrollmentNo;
  final String studentName;
  final String className;

  const StudentHomeScreen({
    super.key,
    required this.enrollmentNo,
    required this.studentName,
    required this.className,
  });

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Attendance state
  double _overallAttendance = 0.0;
  bool _loadingAttendance = true;

  // Today's tasks state
  List<Map<String, dynamic>> _todayTasks = [];
  bool _loadingTasks = true;

  // Student name for greeting
  late String _studentName;

  @override
  void initState() {
    super.initState();
    _studentName = widget.studentName;
    _pageController = PageController(initialPage: _currentIndex);

    _fadeController =
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideController =
        AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();

    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() {
      _loadingAttendance = true;
      _loadingTasks = true;
    });

    try {
      final res = await http.get(
        Uri.parse("${Config.baseUrl}get_student_attendance.php?enrollment_no=${widget.enrollmentNo}"),
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        final List records = data["attendance"] ?? [];

        int total = records.length;
        int present = records.where((r) => r["status"] == "Present").length;
        double percentage = total > 0 ? (present / total) : 0.0;

        String name = data["student_name"] ?? widget.studentName;

        // Today's tasks
        final today = DateTime.now().toIso8601String().substring(0, 10);
        List<Map<String, dynamic>> tasks = [];
        for (var r in records) {
          if (r["date"] == today) {
            tasks.add({
              "subject": r["subject"],
              "topic": r["topic"],
              "reference_link": r["reference_link"] ?? "",
              "status": r["status"]
            });
          }
        }

        if (!mounted) return;
        setState(() {
          _overallAttendance = percentage;
          _todayTasks = tasks;
          _loadingAttendance = false;
          _loadingTasks = false;
          _studentName = name;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _loadingAttendance = false;
          _loadingTasks = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingAttendance = false;
        _loadingTasks = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goToHomePage() {
    _pageController.jumpToPage(0);
    setState(() {
      _currentIndex = 0;
    });
  }

  Widget _buildHomePageContent() {
    const Color iconBgColor = Color(0xFFE6F4EA);
    const Color iconColor = Color(0xFF218838);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_studentName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Hello, $_studentName 👋",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                // Attendance card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.analytics_rounded,
                                color: iconColor, size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              "Overall Attendance",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _loadingAttendance
                          ? const CircularProgressIndicator()
                          : CircularPercentIndicator(
                        radius: 90.0,
                        lineWidth: 12.0,
                        animation: true,
                        percent: _overallAttendance,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${(_overallAttendance * 100).toStringAsFixed(1)}%",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0,
                                  color: iconColor),
                            ),
                            Text("Attendance",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600])),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: iconColor,
                        backgroundColor: iconBgColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Today's Tasks
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.task_alt, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text("Today's Tasks",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                _loadingTasks
                    ? const Center(child: CircularProgressIndicator())
                    : _todayTasks.isEmpty
                    ? const Text("✅ No tasks assigned for today.")
                    : Column(
                  children: _todayTasks
                      .map((t) => buildTaskCard(
                      subject: t["subject"] ?? "",
                      topic: t["topic"] ?? "",
                      reference: t["reference_link"] ?? "",
                      status: t["status"] ?? "Present"))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTaskCard(
      {required String subject,
        required String topic,
        required String reference,
        required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Subject: $subject",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Topic: $topic",
            style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        if (reference.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text("Ref: $reference",
              style: TextStyle(fontSize: 14, color: Colors.blue[700])),
        ],
        const SizedBox(height: 6),
        Text("Status: $status",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: status == "Present" ? Colors.green : Colors.red)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFDFF2B2);
    const Color gradientEnd = Color(0xFFB4E197);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Trackademy",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ]),
            ),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: [
              _buildHomePageContent(),
              AttendancePage(onNavigateToHome: _goToHomePage),
              StudentQuizScreen(onNavigateToHome: _goToHomePage),
              StudentMessageScreen(onNavigateToHome: _goToHomePage),
              TaskPage(onNavigateToHome: _goToHomePage),
              StudentProfileScreen(onNavigateToHome: _goToHomePage),
            ],
          ),
        ),
      ]),
    );
  }
}
