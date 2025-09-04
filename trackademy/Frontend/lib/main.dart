// lib/main.dart
import 'package:flutter/material.dart';
import 'student/splash_screen.dart';
import 'student/role_selection_screen.dart';
import 'student/student_login_screen.dart';
import 'student/student_registration_screen.dart';
import 'student/student_home_screen.dart';
import 'parents/parent_login_page.dart' hide ParentHomeScreen;
import 'parents/parent_signup_page.dart';
import 'package:Track_ademy/parents/parent_home_screen.dart';
import 'teachers/teacher_login_screen.dart';
import 'teachers/teacher_register_screen.dart';
import 'teachers/teacher_topic_screen.dart';
import 'teachers/notification_screen.dart';
import 'teachers/teacher_quiz_screen.dart';
import 'teachers/teacher_main_screen.dart';
import 'package:Track_ademy/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackacademy',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const RoleSelectionScreen(),

        // Parent routes
        '/parents': (context) => const ParentLoginPage(),
        '/parentRegister': (context) => const ParentSignUpPage(),
        '/parentHome': (context) => const ParentHomeScreen(),

        // Student routes
        '/student': (context) => const StudentLoginScreen(),
        '/register': (context) => const StudentRegistrationScreen(),
        '/studentHome': (context) => StudentHomeScreen(
          enrollmentNo: "123456", // replace dynamically after login
          studentName: "Krishma", // replace dynamically after login
          className: "12-A",      // replace dynamically after login
        ),

        // Teacher routes
        '/teacher': (context) => const TeacherLoginScreen(),
        '/teacherRegister': (context) => const TeacherRegistrationScreen(),
        '/teacherHome': (context) => const TeacherMainScreen(initialIndex: 0),
        '/attendance': (context) => const TeacherMainScreen(initialIndex: 1),
        '/quiz': (context) => const TeacherMainScreen(initialIndex: 2),
        '/student-records': (context) => const TeacherMainScreen(initialIndex: 3),
        '/messages': (context) => const TeacherMainScreen(initialIndex: 4),
        '/profile': (context) => const TeacherMainScreen(initialIndex: 5),
        '/notifications': (context) => const NotificationScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/create-quiz') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CreateQuizScreen(
              subject: args['subject'],
              topic: args['topic'],
              link: args['link'],
              date: args['date'],
            ),
          );
        }
        return null;
      },
    );
  }
}
