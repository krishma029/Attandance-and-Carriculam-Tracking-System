// lib/task_page.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the calendar package
import 'package:url_launcher/url_launcher.dart'; // For opening reference links

// --- Task Data Model ---
class Task {
  final String subject;
  final String description;
  final String? referenceLink;
  bool isDone;
  final DateTime date; // The date this task is due

  Task({
    required this.subject,
    required this.description,
    this.referenceLink,
    this.isDone = false,
    required this.date,
  });
}

// --- Task Page Widget ---
class TaskPage extends StatefulWidget {
  final VoidCallback onNavigateToHome;

  const TaskPage({super.key, required this.onNavigateToHome});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Dummy task data - This now represents the tasks "added by the teacher"
  final Map<DateTime, List<Task>> _tasks = {
    // Ensure dates are normalized to midnight for accurate comparison
    DateTime.utc(2025, 6, 2): [
      Task(subject: 'C++', description: 'Read functions', referenceLink: 'https://www.geeksforgeeks.org/functions-in-cpp/', date: DateTime.utc(2025, 6, 2)),
      Task(subject: 'C++', description: 'Code of palindrome number', referenceLink: 'https://www.geeksforgeeks.org/program-check-palindrome-number/', date: DateTime.utc(2025, 6, 2)),
    ],
    DateTime.utc(2025, 6, 3): [
      Task(subject: 'Python', description: 'Code of power of 2 number', referenceLink: 'https://www.geeksforgeeks.org/python-program-check-power-2/', date: DateTime.utc(2025, 6, 3), isDone: true),
    ],
    DateTime.utc(2025, 6, 4): [
      Task(subject: 'Java', description: 'Study OOP concepts', referenceLink: 'https://www.javatpoint.com/java-oops-concepts', date: DateTime.utc(2025, 6, 4)),
    ],
    DateTime.utc(2025, 6, 11): [
      Task(subject: 'Math', description: 'Practice calculus problems', date: DateTime.utc(2025, 6, 11)),
      Task(subject: 'Physics', description: 'Read about quantum mechanics', date: DateTime.utc(2025, 6, 11)),
    ],
    DateTime.utc(2025, 6, 16): [
      Task(subject: 'Operating Systems', description: 'Review Deadlock concepts', date: DateTime.utc(2025, 6, 16)),
    ],
    // Add more dummy tasks for other dates if needed
  };

  @override
  void initState() {
    super.initState();
    // Initialize selectedDay to today if there are tasks for today, otherwise null
    _selectedDay = _focusedDay;
  }

  List<Task> _getTasksForDay(DateTime day) {
    // Normalize the date to midnight for consistent key lookup
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _tasks[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay; // update `_focusedDay` here as well
      _calendarFormat = CalendarFormat.month; // Always show month view on day select
    });
  }

  void _toggleTaskDone(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFDFF2B2);
    const Color gradientEnd = Color(0xFFB4E197);
    const Color iconColor = Color(0xFF218838);

    final List<Task> selectedTasks = _getTasksForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      widget.onNavigateToHome(); // Use the callback to go to home/dashboard
                    },
                  ),
                  const Text(
                    "Task",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // Notification icon removed from here (previously GestureDetector for notifications)
                  // Instead, add an empty SizedBox or Spacer if you need to push the title to the center
                  const SizedBox(width: 40), // Placeholder for spacing, or Spacer()
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Your Tasks:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2026, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: _getTasksForDay,

                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    color: iconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: iconColor),
                  rightChevronIcon: Icon(Icons.chevron_right, color: iconColor),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: iconColor.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red[300],
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.grey[700]),
                  defaultTextStyle: const TextStyle(color: Colors.black87),
                  outsideTextStyle: TextStyle(color: Colors.grey[500]),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[600]),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _selectedDay == null
                    ? "Please select a date to view tasks."
                    : "Tasks for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),

            selectedTasks.isEmpty && _selectedDay != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "No tasks for this day. Enjoy your free time!",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                final task = selectedTasks[index];
                return _buildTaskCard(task);
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    const Color iconColor = Color(0xFF218838);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      shadowColor: iconColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subject: ${task.subject}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleTaskDone(task),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: task.isDone ? iconColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      task.isDone ? Icons.check : Icons.close,
                      color: task.isDone ? Colors.white : Colors.grey[700],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Task: ${task.description}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            if (task.referenceLink != null && task.referenceLink!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () => _launchUrl(task.referenceLink!),
                  child: Text(
                    "Reference Link: ${task.referenceLink!}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      decoration: TextDecoration.underline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}