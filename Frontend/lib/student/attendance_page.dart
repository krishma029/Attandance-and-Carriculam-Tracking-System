// lib/student/attendance_page.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart'; // Make sure this package is in your pubspec.yaml
import 'package:table_calendar/table_calendar.dart'; // Make sure this package is in your pubspec.yaml

// --- Attendance Data Models ---
class SubjectAttendance {
  final String subject;
  double percentage; // e.g., 0.75 for 75%
  Map<DateTime, bool> dailyAttendance; // true for present, false for absent

  SubjectAttendance({
    required this.subject,
    this.percentage = 0.0,
    required this.dailyAttendance,
  }) {
    _calculatePercentage(); // Calculate initial percentage
  }

  void _calculatePercentage() {
    if (dailyAttendance.isEmpty) {
      percentage = 0.0;
      return;
    }

    // Filter out entries where attendance is not defined or is null for the purpose of percentage calculation
    final validAttendanceDays = dailyAttendance.entries.where((entry) => entry.value != null);

    if (validAttendanceDays.isEmpty) {
      percentage = 0.0;
      return;
    }

    int presentDays = validAttendanceDays.where((entry) => entry.value == true).length;
    percentage = presentDays / validAttendanceDays.length;
  }

  void updateDailyAttendance(DateTime date, bool isPresent) {
    // Normalize the date to midnight UTC for consistent keys
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    dailyAttendance[normalizedDate] = isPresent;
    _calculatePercentage(); // Recalculate percentage after update
  }
}

// --- Attendance Page Widget ---
class AttendancePage extends StatefulWidget {
  final VoidCallback onNavigateToHome;

  const AttendancePage({super.key, required this.onNavigateToHome});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Dummy Attendance Data - In a real app, this would come from a backend
  // Key: Subject Name, Value: SubjectAttendance object
  final Map<String, SubjectAttendance> _allSubjectsAttendance = {
    'Maths': SubjectAttendance(
      subject: 'Maths',
      dailyAttendance: {
        DateTime.utc(2025, 6, 1): true, // Sun
        DateTime.utc(2025, 6, 2): true,
        DateTime.utc(2025, 6, 3): false, // Absent
        DateTime.utc(2025, 6, 4): true,
        DateTime.utc(2025, 6, 5): true,
        DateTime.utc(2025, 6, 6): true, // Fri
        DateTime.utc(2025, 6, 7): true, // Sat
        DateTime.utc(2025, 6, 8): true, // Sun
        DateTime.utc(2025, 6, 9): true,
        DateTime.utc(2025, 6, 10): true,
        DateTime.utc(2025, 6, 11): true, // Matches image_0aa79c.png (green)
        DateTime.utc(2025, 6, 12): true,
        DateTime.utc(2025, 6, 13): true,
        DateTime.utc(2025, 6, 14): true,
        DateTime.utc(2025, 6, 15): true, // Matches image_0aa79c.png (red) - actually green here for Maths
        DateTime.utc(2025, 6, 16): true, // Matches image_0aa79c.png (red) - actually green here for Maths
        // Add more daily attendance data for Maths
      },
    ),
    'OOP': SubjectAttendance(
      subject: 'OOP',
      dailyAttendance: {
        DateTime.utc(2025, 6, 1): true,
        DateTime.utc(2025, 6, 2): true,
        DateTime.utc(2025, 6, 3): true,
        DateTime.utc(2025, 6, 4): true,
        DateTime.utc(2025, 6, 5): false, // Absent
        DateTime.utc(2025, 6, 6): true,
        DateTime.utc(2025, 6, 7): true,
        DateTime.utc(2025, 6, 8): true,
        DateTime.utc(2025, 6, 9): true,
        DateTime.utc(2025, 6, 10): true,
        DateTime.utc(2025, 6, 11): true, // Matches image_0aa79c.png (green)
        DateTime.utc(2025, 6, 12): true,
        DateTime.utc(2025, 6, 13): true,
        DateTime.utc(2025, 6, 14): true,
        DateTime.utc(2025, 6, 15): true,
        DateTime.utc(2025, 6, 16): true,
      },
    ),
    'Java': SubjectAttendance(
      subject: 'Java',
      dailyAttendance: {
        DateTime.utc(2025, 6, 1): true,
        DateTime.utc(2025, 6, 2): false, // Absent
        DateTime.utc(2025, 6, 3): true,
        DateTime.utc(2025, 6, 4): true,
        DateTime.utc(2025, 6, 5): true,
        DateTime.utc(2025, 6, 6): true,
        DateTime.utc(2025, 6, 7): true,
        DateTime.utc(2025, 6, 8): true,
        DateTime.utc(2025, 6, 9): true,
        DateTime.utc(2025, 6, 10): false, // Absent
        DateTime.utc(2025, 6, 11): true, // Matches image_0aa79c.png (green)
        DateTime.utc(2025, 6, 12): true,
        DateTime.utc(2025, 6, 13): true,
        DateTime.utc(2025, 6, 14): true,
        DateTime.utc(2025, 6, 15): true,
        DateTime.utc(2025, 6, 16): true,
      },
    ),
    'CV': SubjectAttendance(
      subject: 'CV',
      dailyAttendance: {
        DateTime.utc(2025, 6, 1): true,
        DateTime.utc(2025, 6, 2): true,
        DateTime.utc(2025, 6, 3): true,
        DateTime.utc(2025, 6, 4): true,
        DateTime.utc(2025, 6, 5): true,
        DateTime.utc(2025, 6, 6): true,
        DateTime.utc(2025, 6, 7): true,
        DateTime.utc(2025, 6, 8): true,
        DateTime.utc(2025, 6, 9): false, // Absent
        DateTime.utc(2025, 6, 10): true,
        DateTime.utc(2025, 6, 11): true, // Matches image_0aa79c.png (green)
        DateTime.utc(2025, 6, 12): true,
        DateTime.utc(2025, 6, 13): true,
        DateTime.utc(2025, 6, 14): true,
        DateTime.utc(2025, 6, 15): true,
        DateTime.utc(2025, 6, 16): true,
      },
    ),
    '.Net': SubjectAttendance(
      subject: '.Net',
      dailyAttendance: {
        DateTime.utc(2025, 6, 1): true,
        DateTime.utc(2025, 6, 2): true,
        DateTime.utc(2025, 6, 3): true,
        DateTime.utc(2025, 6, 4): true,
        DateTime.utc(2025, 6, 5): true,
        DateTime.utc(2025, 6, 6): true,
        DateTime.utc(2025, 6, 7): true,
        DateTime.utc(2025, 6, 8): true,
        DateTime.utc(2025, 6, 9): true,
        DateTime.utc(2025, 6, 10): true,
        DateTime.utc(2025, 6, 11): true, // Matches image_0aa79c.png (green)
        DateTime.utc(2025, 6, 12): true,
        DateTime.utc(2025, 6, 13): true,
        DateTime.utc(2025, 6, 14): true,
        DateTime.utc(2025, 6, 15): true,
        DateTime.utc(2025, 6, 16): false, // Absent (for testing red day)
      },
    ),
  };

  @override
  void initState() {
    super.initState();
    // Initialize selectedDay to today's date
    _selectedDay = DateTime.now();
  }

  // Determines if a given day had any absence across all subjects
  bool _hasAbsence(DateTime day) {
    // Normalize the date to midnight UTC
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);

    for (var subjectAttendance in _allSubjectsAttendance.values) {
      // Check if the subject had class on this day and if the student was absent
      if (subjectAttendance.dailyAttendance.containsKey(normalizedDay) &&
          !subjectAttendance.dailyAttendance[normalizedDay]!) {
        return true; // Found at least one absence
      }
    }
    return false; // No absences found for this day
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay; // update _focusedDay here as well
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFDFF2B2);
    const Color gradientEnd = Color(0xFFB4E197);
    const Color iconColor = Color(0xFF218838); // Green color
    const Color iconBgColor = Color(0xFFE6F4EA); // Light green background

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      widget.onNavigateToHome(); // Go back to home/dashboard
                    },
                  ),
                  const Expanded( // Use Expanded to center the title
                    child: Text(
                      "Attendance",
                      textAlign: TextAlign.center, // Center the text
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Occupy space equivalent to back button
                  // Removed the GestureDetector containing the notification icon
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
                "Subject Attendance Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            // Subject-wise attendance cards
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _allSubjectsAttendance.length,
                itemBuilder: (context, index) {
                  final subjectAtt = _allSubjectsAttendance.values.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80, // Fixed width for subject name
                          child: Text(
                            subjectAtt.subject,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LinearPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            lineHeight: 12.0,
                            percent: subjectAtt.percentage,
                            backgroundColor: iconBgColor,
                            progressColor: iconColor,
                            barRadius: const Radius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${(subjectAtt.percentage * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Every day attendance:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            // Calendar View
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
                // Custom day builder to color days based on attendance using calendarBuilders
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
                    bool isSelected = isSameDay(_selectedDay, day);
                    bool isToday = isSameDay(DateTime.now(), day);
                    bool hasDataForDay = _allSubjectsAttendance.values.any((subAtt) => subAtt.dailyAttendance.containsKey(normalizedDay));
                    bool isAbsenceDay = _hasAbsence(day);

                    // Default style for days outside of defined attendance data
                    Color cellColor = Colors.transparent;
                    Color textColor = Colors.black87;
                    FontWeight fontWeight = FontWeight.normal;

                    // Apply styling based on criteria
                    if (isSelected) {
                      cellColor = iconColor; // Selected day is always green
                      textColor = Colors.white;
                      fontWeight = FontWeight.bold;
                    } else if (isToday) {
                      cellColor = iconColor.withOpacity(0.7); // Today
                      textColor = Colors.white;
                      fontWeight = FontWeight.bold;
                    } else if (hasDataForDay) {
                      if (isAbsenceDay) {
                        cellColor = Colors.red[400]!; // Red if any absence
                        textColor = Colors.white;
                      } else {
                        cellColor = iconColor; // Green if full attendance
                        textColor = Colors.white;
                      }
                      fontWeight = FontWeight.bold;
                    } else if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
                      textColor = Colors.red[600]!; // Weekend color
                    }

                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(8), // Square cells with rounded corners
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: fontWeight,
                        ),
                      ),
                    );
                  },
                ),

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
                // CalendarStyle will be mostly overridden by calendarBuilders, but still useful for defaults
                calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: Colors.red[600]), // Ensures weekends are initially red
                  defaultTextStyle: const TextStyle(color: Colors.black87),
                  outsideTextStyle: TextStyle(color: Colors.grey[500]),
                  // Markers are not used with calendarBuilders defaultBuilder
                  markerDecoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[600]),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Daily Attendance Details for Selected Day
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _selectedDay == null
                    ? "Select a date to view daily attendance."
                    : "Daily Attendance for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildDailyAttendanceDetails(_selectedDay, iconColor),
            const SizedBox(height: 80), // Space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildDailyAttendanceDetails(DateTime? day, Color iconColor) {
    if (day == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "No date selected.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    bool hasDataForSelectedDay = _allSubjectsAttendance.values.any((subAtt) => subAtt.dailyAttendance.containsKey(normalizedDay));

    if (!hasDataForSelectedDay) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "No attendance records for this day.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _allSubjectsAttendance.length,
      itemBuilder: (context, index) {
        final subjectAtt = _allSubjectsAttendance.values.elementAt(index);
        final isPresent = subjectAtt.dailyAttendance[normalizedDay];

        // Only show subjects that actually have data for the selected day
        if (isPresent == null) {
          return const SizedBox.shrink(); // Don't display if no data for this subject on this day
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subjectAtt.subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: isPresent ? iconColor : Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPresent ? "Present" : "Absent",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isPresent ? iconColor : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}