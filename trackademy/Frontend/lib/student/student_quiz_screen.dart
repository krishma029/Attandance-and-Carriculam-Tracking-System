import 'package:flutter/material.dart';

// 1. Quiz Data Model (No change here, it's just data)
class Quiz {
  final String subject;
  final String topic;
  int? score; // Nullable, as the quiz might not have been taken yet
  int totalQuestions;

  Quiz({
    required this.subject,
    required this.topic,
    this.score,
    required this.totalQuestions,
  });

  // Method to mark quiz as taken and assign a score
  void completeQuiz(int newScore) {
    if (newScore >= 0 && newScore <= totalQuestions) {
      score = newScore;
    } else {
      score = 0; // Or throw an error for invalid score
    }
  }
}

// Placeholder for the Quiz Taking Page
class QuizTakingPage extends StatefulWidget {
  final Quiz quiz;
  final Function(Quiz) onQuizCompleted; // Callback to update score

  const QuizTakingPage({
    super.key,
    required this.quiz,
    required this.onQuizCompleted,
  });

  @override
  State<QuizTakingPage> createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  int? _selectedScore; // To simulate score input

  @override
  Widget build(BuildContext context) {
    // Using your consistent color scheme
    const Color iconColor = Color(0xFF218838); // Dark green
    const Color gradientStart = Color(0xFFDFF2B2); // Light green gradient start
    const Color gradientEnd = Color(0xFFB4E197);   // Light green gradient end
    const Color textColor = Color(0xFF218838); // Text color for clarity

    return Scaffold(
      appBar: AppBar(
        // Transparent background for custom header
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Custom back button color to match theme
        iconTheme: const IconThemeData(color: iconColor),
        title: Text(
          '${widget.quiz.subject}: ${widget.quiz.topic}',
          style: const TextStyle(color: iconColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simulate taking the quiz for: ${widget.quiz.topic}',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 20),
            // In a real app, this would be your quiz questions
            Text(
              'Imagine your quiz questions are here...',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),
            Text(
              'Select a score (out of ${widget.quiz.totalQuestions}):',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
            ),
            DropdownButton<int>(
              value: _selectedScore,
              hint: const Text('Choose Score'),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedScore = newValue;
                });
              },
              items: List.generate(widget.quiz.totalQuestions + 1, (index) => index)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _selectedScore != null
                    ? () {
                  widget.quiz.completeQuiz(_selectedScore!);
                  widget.onQuizCompleted(widget.quiz); // Call the callback
                  Navigator.pop(context); // Go back to the quiz list
                }
                    : null, // Disable button if no score is selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor, // Use your primary dark green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit Quiz & View Score',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. StudentQuizScreen Widget (Main Quiz List Page)
class StudentQuizScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome; // <--- ADD THIS PROPERTY

  const StudentQuizScreen({super.key, required this.onNavigateToHome});
  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

class _StudentQuizScreenState extends State<StudentQuizScreen> {
  // Sample quizzes
  List<Quiz> quizzes = [
    Quiz(subject: 'C++', topic: 'Bitwise operator', totalQuestions: 10),
    Quiz(subject: 'Java', topic: 'Basic of Java', totalQuestions: 10),
    Quiz(subject: 'OOP', topic: 'Operators', totalQuestions: 10),
    Quiz(subject: 'Data Structures', topic: 'Arrays', totalQuestions: 15),
  ];

  // Function to navigate to QuizTakingPage and update score
  void _takeQuiz(Quiz quiz) async {
    // Navigate and wait for the result
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizTakingPage(
          quiz: quiz,
          onQuizCompleted: (updatedQuiz) {
            // Find the updated quiz in the list and refresh the UI
            setState(() {
              int index = quizzes.indexWhere((q) => q.subject == updatedQuiz.subject && q.topic == updatedQuiz.topic);
              if (index != -1) {
                quizzes[index] = updatedQuiz;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reusing colors from your existing theme
    const Color gradientStart = Color(0xFFDFF2B2); // Light green gradient start
    const Color gradientEnd = Color(0xFFB4E197);   // Light green gradient end
    const Color iconColor = Color(0xFF218838);    // Dark green
    const Color iconBgColor = Color(0xFFE6F4EA);  // Very light green

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Adjust height as needed
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
                  // Back Button (if needed, otherwise remove or replace)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                  const Text(
                    "Your Quizzes",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // Placeholder for any right-side icons if you want them
                  const SizedBox(width: 40), // To balance the back button
                ],
              ),
            ),
          ),
        ),
      ),
      body: quizzes.isEmpty
          ? const Center(
        child: Text(
          'No quizzes available yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            // Lighter shadow to match the theme
            shadowColor: gradientEnd.withOpacity(0.4),
            child: Container( // Wrap with Container for internal padding and potential decoration
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Card background
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: iconBgColor, width: 1.0), // Subtle light green border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject: ${quiz.subject}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: iconColor, // Use dark green for main text
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Topic: ${quiz.topic}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        quiz.score != null
                            ? 'Score: ${quiz.score}/${quiz.totalQuestions}' // Changed "View Score" to "Score"
                            : 'Status: Pending', // Changed "Take quiz" to "Status: Pending"
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: quiz.score != null ? iconColor : Colors.orange[700], // Darker orange for pending
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _takeQuiz(quiz),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iconColor, // Primary button color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25), // More rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12), // Larger padding
                          elevation: 3, // Slight elevation for button
                        ),
                        child: Text(
                          quiz.score != null ? 'Retake Quiz' : 'Take Quiz', // Changed "Quiz" to "Take Quiz"
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}