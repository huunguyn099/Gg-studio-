import 'chat_message.dart';

class ChatSession {
  final String id;
  String title;
  final DateTime createdAt;
  List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'],
        title: json['title'] ?? 'Đoạn chat mới',
        createdAt: DateTime.parse(json['createdAt']),
        messages: (json['messages'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList(),
      );
}
