// lib/parents/child_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar

class ChildProgressScreen extends StatefulWidget {
  const ChildProgressScreen({super.key});

  @override
  State<ChildProgressScreen> createState() => _ChildProgressScreenState();
}

class _ChildProgressScreenState extends State<ChildProgressScreen> {
  // --- Consistent Color Palette from Student/Parent Home Screens ---
  static const Color _primaryGradientStart = Color(0xFFDFF2B2);
  static const Color _primaryGradientEnd = Color(0xFFB4E197);
  static const Color _primaryAccentColor = Color(0xFF218838); // Dark green accent
  static const Color _iconBgColor = Color(0xFFE6F4EA); // Very light green for icon backgrounds

  // Calendar related state
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // --- Dummy Data ---
  // A map to store daily attendance (true for Present, false for Absent)
  // IMPORTANT: Sundays are explicitly NOT in this map, as they are holidays.
  // Ensure the DateTime objects are UTC to avoid timezone issues with table_calendar
  final Map<DateTime, bool> _dummyDailyOverallAttendance = {
    DateTime.utc(2025, 7, 1): true,
    DateTime.utc(2025, 7, 2): true,
    DateTime.utc(2025, 7, 3): false, // Absent
    DateTime.utc(2025, 7, 4): true,
    DateTime.utc(2025, 7, 5): true, // Saturday, let's assume it can be a school day sometimes
    // DateTime.utc(2025, 7, 6) is Sunday, intentionally omitted
    DateTime.utc(2025, 7, 7): false, // Absent (Monday)
    DateTime.utc(2025, 7, 8): true,
    DateTime.utc(2025, 7, 9): true,
    DateTime.utc(2025, 7, 10): true,
    DateTime.utc(2025, 7, 11): true,
    DateTime.utc(2025, 7, 12): false, // Absent (Saturday) - if school sometimes operates
    // DateTime.utc(2025, 7, 13) is Sunday, intentionally omitted
    DateTime.utc(2025, 7, 14): true,
    DateTime.utc(2025, 7, 15): true,
    // Add more dummy data as needed for testing, e.g., for August 2025 (avoiding Sundays)
    DateTime.utc(2025, 8, 1): true, // Friday
    // DateTime.utc(2025, 8, 2) is Saturday
    // DateTime.utc(2025, 8, 3) is Sunday
    DateTime.utc(2025, 8, 4): false, // Monday
    DateTime.utc(2025, 8, 5): true, // Tuesday
    DateTime.utc(2025, 8, 6): true, // Wednesday
    // DateTime.utc(2025, 8, 9) is Saturday
    // DateTime.utc(2025, 8, 10) is Sunday
    DateTime.utc(2025, 8, 11): true, // Monday
    DateTime.utc(2025, 8, 12): true, // Tuesday
  };

  // Dummy data for subject-wise attendance (e.g., total present/absent counts)
  final Map<String, Map<String, int>> _dummySubjectAttendance = {
    'Math': {'Present': 45, 'Absent': 2},
    'Science': {'Present': 40, 'Absent': 7},
    'English': {'Present': 48, 'Absent': 0},
    'History': {'Present': 43, 'Absent': 4},
  };

  // Dummy data for tasks/events on the calendar
  // Ensure the DateTime objects are UTC
  final Map<DateTime, List<String>> _dummyTasks = {
    DateTime.utc(2025, 7, 5): ['Math Homework', 'Science Quiz'], // This is a Saturday
    DateTime.utc(2025, 7, 10): ['English Essay Due'],
    DateTime.utc(2025, 7, 15): ['History Project Presentation', 'Art Project Idea Submission'],
    DateTime.utc(2025, 7, 20): ['Library Book Return'], // This is a Sunday, task will NOT be marked on calendar
    // Add more dummy tasks for testing, e.g., for August 2025
    DateTime.utc(2025, 8, 1): ['Summer Reading Assignment'],
    DateTime.utc(2025, 8, 10): ['Prepare for Field Trip'], // This is a Sunday, task will NOT be marked on calendar
  };

  // NEW: Dummy data for Academic Performance
  final Map<String, dynamic> _dummyAcademicPerformance = {
    'Grade': 'A+',
    'CGPA': 9.2, // Cumulative Grade Point Average
    'OverallPercentage': 88.5,
    'LastExamScores': { // Example for displaying individual subject scores if desired
      'Math': 92,
      'Science': 85,
      'English': 95,
      'History': 80,
    }
  };

  // List of events for the selected day
  List<String> _selectedDayTasks = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Initialize selected day to today
    // Ensure the initial _selectedDayTasks reflect the tasks for _selectedDay
    _selectedDayTasks = _getTasksForDay(_selectedDay!);
  }

  // Helper method to get tasks for a given day
  List<String> _getTasksForDay(DateTime day) {
    // Normalize the day to UTC date-only for map lookup to avoid time component issues
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _dummyTasks[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Only update if the selected day is different to avoid unnecessary rebuilds
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay; // Update `_focusedDay` to keep the calendar in view
        _selectedDayTasks = _getTasksForDay(selectedDay); // Update tasks for the newly selected day
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Consistent with Parent/Student Home
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
                      'Child Progress',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button space
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // Consistent padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Child Profile Summary ---
            _buildCard(
              context,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Container( // Mimic student app's avatar style
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _iconBgColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _primaryAccentColor.withOpacity(0.05), // Softer shadow for icon
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person, size: 60, color: _primaryAccentColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Student Name: John Doe', // Replace with actual child's name
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _primaryAccentColor,
                      ),
                    ),
                    Text(
                      'Grade: 5th', // Replace with actual grade
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // NEW: --- Academic Performance Section ---
            _buildSectionTitle(context, 'Academic Performance'),
            const SizedBox(height: 15),
            _buildInfoCard(
              context,
              Icons.grade, // Icon for grade/marks
              'Current Grade: ${_dummyAcademicPerformance['Grade']}',
              'CGPA: ${_dummyAcademicPerformance['CGPA']} | Overall: ${_dummyAcademicPerformance['OverallPercentage']}%',
            ),
            const SizedBox(height: 15),
            // Optionally, add another card for detailed recent scores if needed
            // _buildInfoCard(
            //   context,
            //   Icons.poll,
            //   'Last Exam Scores',
            //   'Math: ${_dummyAcademicPerformance['LastExamScores']['Math']}%, Science: ${_dummyAcademicPerformance['LastExamScores']['Science']}%',
            // ),
            // const SizedBox(height: 15), // Spacing if adding more cards

            // --- Overall Attendance Summary ---
            _buildSectionTitle(context, 'Overall Attendance Summary'),
            const SizedBox(height: 15), // Consistent spacing
            _buildInfoCard(
              context,
              Icons.calendar_today,
              'Total Days: 180',
              'Present: 175, Absent: 5',
            ),
            const SizedBox(height: 15),

            // --- Subject-wise Attendance ---
            _buildSectionTitle(context, 'Subject-wise Attendance'),
            const SizedBox(height: 15), // Consistent spacing
            ..._dummySubjectAttendance.entries.map((entry) {
              final subject = entry.key;
              final data = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Consistent spacing between cards
                child: _buildInfoCard(
                  context,
                  Icons.menu_book,
                  '$subject Attendance',
                  'Present: ${data['Present']}, Absent: ${data['Absent']}',
                ),
              );
            }).toList(),
            const SizedBox(height: 15),

            // --- Calendar Attendance & Tasks ---
            _buildSectionTitle(context, 'Calendar View (Attendance & Tasks)'),
            const SizedBox(height: 15), // Consistent spacing
            _buildCard(
              context,
              padding: const EdgeInsets.all(8.0), // Padding inside the calendar card
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
                eventLoader: (day) {
                  // Only tasks are loaded as 'events' for the markerBuilder
                  // Attendance status is handled by dayBuilder
                  final normalizedDay = DateTime.utc(day.year, day.month, day.day);
                  // Ensure tasks are not marked on Sundays for school context
                  if (_dummyTasks.containsKey(normalizedDay) && _dummyTasks[normalizedDay]!.isNotEmpty && day.weekday != DateTime.sunday) {
                    return ['task']; // A generic marker name for tasks
                  }
                  return [];
                },
                // Custom builders for calendar cells
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, focusedDay) {
                    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
                    final isPresent = _dummyDailyOverallAttendance[normalizedDate];
                    final isSelected = isSameDay(_selectedDay, date);

                    Color? bgColor;
                    Color textColor = Colors.black87; // Default text color

                    if (date.weekday == DateTime.sunday) {
                      bgColor = Colors.grey[200]; // Grey background for Sundays (holiday)
                      textColor = Colors.grey; // Grey text for Sundays
                    } else if (isPresent == true) {
                      bgColor = Colors.green[100]; // Light green for present
                      textColor = Colors.green[800]!;
                    } else if (isPresent == false) {
                      bgColor = Colors.red[100]; // Light red for absent
                      textColor = Colors.red[800]!;
                    } else {
                      bgColor = Colors.transparent; // Default for unrecorded/future days
                    }

                    if (isSelected) { // Selected day overrides other backgrounds
                      bgColor = _primaryAccentColor.withOpacity(0.7);
                      textColor = Colors.white;
                    }

                    // Special styling for today, if not selected
                    if (isSameDay(date, DateTime.now()) && !isSelected) {
                      bgColor = _primaryAccentColor.withOpacity(0.2); // Light accent for today
                      textColor = _primaryAccentColor;
                    }


                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: isSelected ? Border.all(color: _primaryAccentColor, width: 2) : null,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: textColor),
                      ),
                    );
                  },
                  markerBuilder: (context, date, events) {
                    // Only show task marker if there are tasks for the day AND it's not a Sunday
                    final hasTasks = events.isNotEmpty && events.contains('task');
                    final isSunday = date.weekday == DateTime.sunday;

                    if (hasTasks && !isSunday) { // Do not show task marker on Sundays
                      return Positioned(
                        bottom: 4, // Position above the bottom of the cell
                        child: Icon(
                          Icons.assignment,
                          size: 14, // Smaller icon
                          color: Colors.blueAccent,
                        ),
                      );
                    }
                    return null;
                  },
                  // Selected and Today builders are simplified, relying more on defaultBuilder
                  selectedBuilder: (context, date, focusedDay) {
                    // Handled by defaultBuilder's isSelected check for consistent look
                    return null;
                  },
                  todayBuilder: (context, date, focusedDay) {
                    // Handled by defaultBuilder's isSameDay(date, DateTime.now()) check
                    return null;
                  },
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: _primaryAccentColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.chevron_left, color: _primaryAccentColor),
                  rightChevronIcon: Icon(Icons.chevron_right, color: _primaryAccentColor),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  // text styles for specific days
                  weekendTextStyle: TextStyle(color: Colors.red[600]), // Weekends (Sat/Sun) default text color
                  todayTextStyle: TextStyle(color: _primaryAccentColor), // Today's number color
                  selectedTextStyle: const TextStyle(color: Colors.white), // Selected day number color
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Tasks for Selected Day ---
            _buildSectionTitle(context, 'Tasks for ${_selectedDay != null ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}' : 'Selected Day'}'),
            const SizedBox(height: 15), // Consistent spacing
            if (_selectedDayTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'No tasks for this day.',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
              )
            else
              ..._selectedDayTasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // Spacing between task cards
                child: _buildActivityCard(
                  context,
                  task,
                  'Scheduled', // Or fetch actual status from task data if available
                ),
              )).toList(),

            const SizedBox(height: 30),

            // --- Generate Report Button ---
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating detailed report...')),
                  );
                  // Implement functionality to generate a detailed report
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryAccentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                icon: const Icon(Icons.description),
                label: const Text(
                  'Generate Report',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets matching the Student/Parent Home Screen Card Style ---

  // Generic card builder for consistent look
  Widget _buildCard(
      BuildContext context, {
        required Widget child,
        EdgeInsetsGeometry? padding,
        BorderRadiusGeometry? borderRadius,
      }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white, // Always white background for cards
        borderRadius: borderRadius ?? BorderRadius.circular(16.0), // Consistent border radius
        boxShadow: [
          BoxShadow(
            color: _primaryAccentColor.withOpacity(0.1), // Consistent shadow
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22, // Slightly larger, matching home screen
          fontWeight: FontWeight.bold,
          color: _primaryAccentColor, // Accent color for titles
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      ) {
    return _buildCard(
      context,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12), // Match student card icon padding
            decoration: BoxDecoration(
              color: _iconBgColor, // Use consistent icon background color
              borderRadius: BorderRadius.circular(12), // Consistent border radius
            ),
            child: Icon(icon, color: _primaryAccentColor, size: 24), // Consistent icon size and color
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context,
      String activity,
      String status,
      ) {
    return _buildCard(
      context,
      child: Row(
        children: [
          Icon(Icons.assignment, color: _primaryAccentColor, size: 24), // Consistent icon size and color
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
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