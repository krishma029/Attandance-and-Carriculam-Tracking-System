// lib/parents/teacher_communication_screen.dart
import 'package:flutter/material.dart';
import 'package:Track_ademy/parents/teacher_chat_screen.dart'; // Ensure lowercase 'parents' in this path


// Define consistent color palette
const Color _primaryGradientStart = Color(0xFFDFF2B2);
const Color _primaryGradientEnd = Color(0xFFB4E197);
const Color _primaryAccentColor = Color(0xFF218838); // Dark green accent
const Color _iconBgColor = Color(0xFFE6F4EA); // Very light green for icon backgrounds

// Model for a Teacher (make sure this is the ONLY definition of Teacher)
class Teacher {
  final String id;
  final String name;
  final String subject;
  final String email;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.email,
  });
}

class TeacherCommunicationScreen extends StatefulWidget {
  const TeacherCommunicationScreen({super.key});

  @override
  State<TeacherCommunicationScreen> createState() => _TeacherCommunicationScreenState();
}

class _TeacherCommunicationScreenState extends State<TeacherCommunicationScreen> {
  // Dummy data for teachers
  final List<Teacher> _teachers = [
    Teacher(
      id: 't001',
      name: 'Ms. Sarah Miller',
      subject: 'Mathematics',
      email: 'sarah.miller@school.com',
    ),
    Teacher(
      id: 't002',
      name: 'Mr. David Lee',
      subject: 'Science',
      email: 'david.lee@school.com',
    ),
    Teacher(
      id: 't003',
      name: 'Ms. Emily White',
      subject: 'English',
      email: 'emily.white@school.com',
    ),
    Teacher(
      id: 't004',
      name: 'Mr. James Brown',
      subject: 'History',
      email: 'james.brown@school.com',
    ),
    Teacher(
      id: 't005',
      name: 'Ms. Olivia Green',
      subject: 'Art & Craft',
      email: 'olivia.green@school.com',
    ),
  ];

  void _navigateToChatScreen(BuildContext context, Teacher teacher) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherChatScreen(teacher: teacher),
      ),
    );
  }

  void _showMeetingRequest(BuildContext context, Teacher teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Meeting with ${teacher.name}'),
        content: const Text('Do you want to send a meeting request to this teacher? They will contact you to schedule a time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Meeting request sent to ${teacher.name}! (Demo)'),
                  backgroundColor: _primaryAccentColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryAccentColor, foregroundColor: Colors.white),
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryGradientStart, _primaryGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Teacher Communication',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _teachers.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No teachers assigned yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _teachers.length,
        itemBuilder: (context, index) {
          final teacher = _teachers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildTeacherCard(context, teacher),
          );
        },
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, Teacher teacher) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: _primaryAccentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            _navigateToChatScreen(context, teacher);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_outline, color: _primaryAccentColor, size: 28),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        teacher.subject,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.message_outlined, color: _primaryAccentColor, size: 24),
                  onPressed: () => _navigateToChatScreen(context, teacher),
                  tooltip: 'Send Message',
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.calendar_month_outlined, color: Colors.blue[600], size: 24),
                  onPressed: () => _showMeetingRequest(context, teacher),
                  tooltip: 'Request Meeting',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}