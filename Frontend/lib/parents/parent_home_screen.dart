// lib/parents/parent_home_screen.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:Track_ademy/parents/child_progress_screen.dart'; // Ensure lowercase 'parents'
import 'package:Track_ademy/parents/notification_alert_screen.dart'; // Ensure lowercase 'parents'
import 'package:Track_ademy/parents/teacher_communication_screen.dart'; // Ensure lowercase 'parents'

// Define colors based on the student home screen theme
const Color _primaryGradientStart = Color(0xFFDFF2B2);
const Color _primaryGradientEnd = Color(0xFFB4E197);
const Color _primaryAccentColor = Color(0xFF218838); // Dark green accent
const Color _iconBgColor = Color(0xFFE6F4EA); // Very light green for icon backgrounds

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Parent Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text(
                "Parent Name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: const Text(
                "parent.email@example.com",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: _primaryAccentColor,
                ),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryGradientStart, _primaryGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: _primaryAccentColor),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to Profile')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: _primaryAccentColor),
              title: const Text('About App'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to About')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: _primaryAccentColor),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primaryGradientStart, _primaryGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _primaryAccentColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Parent 👋",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _primaryAccentColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Overview of your child's progress.",
                          style: TextStyle(
                            fontSize: 16,
                            color: _primaryAccentColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.family_restroom,
                      size: 32,
                      color: _primaryAccentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _primaryAccentColor.withOpacity(0.1),
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
                          color: _iconBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.analytics_rounded,
                          color: _primaryAccentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Overall Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CircularPercentIndicator(
                    radius: 90.0,
                    lineWidth: 12.0,
                    animation: true,
                    animationDuration: 1200,
                    percent: 0.85,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "85%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: _primaryAccentColor,
                          ),
                        ),
                        Text(
                          "Attendance",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: _primaryAccentColor,
                    backgroundColor: _iconBgColor,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _iconBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Your child has great attendance!",
                      style: TextStyle(
                        color: _primaryAccentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Main Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _primaryAccentColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildActionCard(
              context,
              icon: Icons.bar_chart_outlined,
              title: 'View Child\'s Detailed Progress',
              description: 'Access academic performance, grades, and more.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChildProgressScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.notifications_none,
              title: 'Notifications & Alerts',
              description: 'Stay updated with important announcements.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationAlertScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.message_outlined,
              title: 'Communicate with Teachers',
              description: 'Send messages and schedule meetings.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeacherCommunicationScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryAccentColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _primaryAccentColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}