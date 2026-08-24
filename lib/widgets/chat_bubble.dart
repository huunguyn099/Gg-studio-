import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_message.dart';
import 'glass_container.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 48, bottom: 12, right: 4),
          child: GlassContainer(
            borderRadius: 20,
            color: const Color(0xFF2563EB).withOpacity(0.35),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 15.5, height: 1.3),
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 24, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4, right: 10),
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.blueAccent, Colors.purpleAccent],
                ),
              ),
              child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
            Expanded(
              child: GlassContainer(
                borderRadius: 20,
                color: Colors.black.withOpacity(0.25),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: MarkdownBody(
                  data: message.text,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                    code: TextStyle(
                      color: Colors.cyanAccent.shade100,
                      backgroundColor: Colors.black.withOpacity(0.4),
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
