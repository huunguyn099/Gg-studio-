import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class GeminiService {
  // Sử dụng model Gemini 3.7 Flash mới nhất
  static const String _model = "gemini-3.7-flash";
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models";

  Future<String> sendMessage({
    required String apiKey,
    required List<ChatMessage> history,
    required String newPrompt,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception("Chưa cấu hình API Key!");
    }

    final url = Uri.parse("$_baseUrl/$_model:generateContent?key=$apiKey");

    // Xây dựng ngữ cảnh nhiều lượt chat
    final contents = history.map((msg) {
      return {
        "role": msg.isUser ? "user" : "model",
        "parts": [
          {"text": msg.text}
        ]
      };
    }).toList();

    contents.add({
      "role": "user",
      "parts": [
        {"text": newPrompt}
      ]
    });

    final payload = {
      "contents": contents,
      "generationConfig": {
        "temperature": 0.7,
        "topP": 0.95,
        "maxOutputTokens": 4096,
      }
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final candidates = json['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final text = candidates[0]['content']['parts'][0]['text'];
        return text.toString().trim();
      }
      return "Không nhận được phản hồi từ mô hình.";
    } else {
      final errorJson = jsonDecode(response.body);
      throw Exception(errorJson['error']?['message'] ?? "Lỗi gọi API (${response.statusCode})");
    }
  }
}
