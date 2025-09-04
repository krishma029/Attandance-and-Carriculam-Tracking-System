import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
final String apiKey = "DUMMY_KEY_FOR_UPLOAD"; // replaced for GitHub

  final String endpoint = "https://yukta-mblp2ycg-eastus2.cognitiveservices.azure.com"; // Azure Endpoint
  final String deploymentId = "gpt-5-chat"; // Your model deployment name

  Future<List<Map<String, dynamic>>> generateQuizQuestions(
      String text, int count) async {
    final prompt = """
You are a quiz generator. Read the following study material and generate exactly $count multiple choice questions with 4 options each. 
Mark the correct answer using "answerIndex" (0-based index).

Material:
$text

Return ONLY a valid JSON array. No explanations, no markdown formatting.
Format:
[
  {
    "question": "Question text",
    "options": ["Option1", "Option2", "Option3", "Option4"],
    "answerIndex": 1
  }
]
""";

    final url =
        "$endpoint/openai/deployments/$deploymentId/chat/completions?api-version=2024-02-15-preview";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "api-key": apiKey,
      },
      body: jsonEncode({
        "messages": [
          {"role": "system", "content": "You are a helpful assistant that outputs only valid JSON."},
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 1500,
        "temperature": 0.7
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Azure OpenAI API failed [${response.statusCode}]: ${response.body}");
    }

    final data = jsonDecode(response.body);
    String content = "";

    if (data["choices"] != null &&
        data["choices"].isNotEmpty &&
        data["choices"][0]["message"] != null &&
        data["choices"][0]["message"]["content"] != null) {
      content = data["choices"][0]["message"]["content"].trim();
    } else {
      throw Exception("Unexpected Azure response format: $data");
    }

    // Debug raw output
    print("RAW AI OUTPUT:\n$content");

    // Remove code fences
    content = content.replaceAll(RegExp(r'```(\w+)?'), '').trim();

    // Extract JSON array part
    final start = content.indexOf('[');
    final end = content.lastIndexOf(']');
    if (start != -1 && end != -1) {
      content = content.substring(start, end + 1);
    }

    // Debug cleaned output
    print("CLEANED JSON:\n$content");

    try {
      final parsed = jsonDecode(content);
      if (parsed is List) {
        return List<Map<String, dynamic>>.from(parsed);
      } else {
        throw Exception("Response was not a JSON array");
      }
    } catch (e) {
      throw Exception(
          "Failed to parse AI response as JSON. Raw content:\n$content");
    }
  }
}
