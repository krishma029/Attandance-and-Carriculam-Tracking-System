import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';
import '../services/ai_service.dart';
import 'teacher_attendance_screen.dart';
import 'teacher_student_record_screen.dart';
import 'teacher_message_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_home_screen.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  int? selectedIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    this.selectedIndex,
  });
}

// --------------------------
// Full screen route for independent navigation
// --------------------------
class CreateQuizScreen extends StatelessWidget {
  final String subject;
  final String topic;
  final String link;
  final DateTime date;

  const CreateQuizScreen({
    super.key,
    required this.subject,
    required this.topic,
    required this.link,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Create Quiz",
          style:
          TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications_none, color: Color(0xFF2E7D32)),
          ),
        ],
      ),
      body: const CreateQuizScreenContent(),
    );
  }
}

// --------------------------
// Actual content of the quiz page
// Can be embedded inside TeacherHomeScreen to avoid double footer
// --------------------------
class CreateQuizScreenContent extends StatefulWidget {
  const CreateQuizScreenContent({super.key});

  @override
  State<CreateQuizScreenContent> createState() =>
      _CreateQuizScreenContentState();
}

class _CreateQuizScreenContentState extends State<CreateQuizScreenContent> {
  final topicEditController = TextEditingController();
  File? selectedFile;
  String? fileName;
  int? totalQuestions;
  List<QuizQuestion> generatedQuestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    topicEditController.text = "";
    topicEditController.addListener(() {
      setState(() {}); // live update
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'docx', 'pptx'],
      type: FileType.custom,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
        generatedQuestions.clear();
      });
    }
  }

  Future<void> generateQuestionsFromFile(File file) async {
    if (totalQuestions == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select number of questions first')),
      );
      return;
    }

    setState(() => isLoading = true);
    String extractedText = "";

    try {
      if (file.path.endsWith(".pdf")) {
        PDFDoc doc = await PDFDoc.fromFile(file);
        extractedText = await doc.text;
      } else if (file.path.endsWith(".docx")) {
        Uint8List bytes = await file.readAsBytes();
        extractedText = await docxToText(bytes);
      } else {
        extractedText = "Unsupported file type";
      }

      if (extractedText.trim().isEmpty) {
        throw Exception("No text could be extracted from the file");
      }

      final aiService = AIService();
      final questions = await aiService.generateQuizQuestions(
        extractedText,
        totalQuestions!,
      );

      setState(() {
        generatedQuestions = questions
            .map((q) => QuizQuestion(
          question: q["question"],
          options: List<String>.from(q["options"]),
          selectedIndex: null,
        ))
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void saveQuiz() {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a quiz file first')),
      );
      return;
    }
    if (generatedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No quiz questions generated yet')),
      );
      return;
    }
    if (generatedQuestions.any((q) => q.selectedIndex == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Quiz Summary
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF81C784), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("📋 Quiz Summary",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _overviewItem(Icons.topic_rounded, "Topic",
                        topicEditController.text.isEmpty
                            ? "Not set"
                            : topicEditController.text),
                    _overviewItem(Icons.timer, "Time", "1 hour"),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: topicEditController,
                  decoration: InputDecoration(
                    hintText: "Enter Topic",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Topic updated")),
                        );
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Question Count
          const Text("Select Number of Questions",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32))),
          const SizedBox(height: 12),
          DropdownButton<int>(
            value: totalQuestions,
            isExpanded: true,
            hint: const Text("Choose question count"),
            items: [5, 10, 15, 20]
                .map((count) => DropdownMenuItem(
              value: count,
              child: Text("$count Questions"),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                totalQuestions = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // File Upload
          const Text("Upload Quiz File",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: pickFile,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6EF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upload_file_rounded, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fileName ?? "Click to select PDF/DOCX/PPTX file",
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed:
            selectedFile != null && !isLoading ? () => generateQuestionsFromFile(selectedFile!) : null,
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            label: Text(isLoading ? "Generating..." : "Generate Questions"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Generated Questions
          if (generatedQuestions.isNotEmpty) ...[
            const Text("Generated Quiz Questions:",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
            const SizedBox(height: 8),
            for (int i = 0; i < generatedQuestions.length; i++)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Q${i + 1}: ${generatedQuestions[i].question}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        for (int j = 0; j < generatedQuestions[i].options.length; j++)
                          RadioListTile<int>(
                            title: Text(generatedQuestions[i].options[j]),
                            value: j,
                            groupValue: generatedQuestions[i].selectedIndex,
                            onChanged: (val) {
                              setState(() {
                                generatedQuestions[i].selectedIndex = val;
                              });
                            },
                          ),
                      ]),
                ),
              ),
            const SizedBox(height: 20),
          ],

          // Submit Button
          buildGradientButton(
            onTap: saveQuiz,
            text: "Submit Quiz",
            icon: Icons.save_alt_rounded,
            colors: const [Color(0xFF3949AB), Color(0xFF00ACC1)],
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(IconData icon, String title, String value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget buildGradientButton({
    required VoidCallback? onTap,
    required String text,
    required IconData icon,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 100),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
