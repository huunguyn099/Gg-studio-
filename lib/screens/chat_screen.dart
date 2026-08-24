import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/gemini_drawer.dart';
import '../widgets/glass_container.dart';
import '../widgets/gradient_picker_sheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(ChatProvider chatProv) {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    chatProv.sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final chatProv = Provider.of<ChatProvider>(context);
    final activeSession = chatProv.activeSession;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const GeminiDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProv.currentTheme.colors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Compact Header tối ưu màn hình lớn (chiều cao họn gàng 52px)
              Container(
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: GlassContainer(
                  borderRadius: 14,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu_rounded, color: Colors.white),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          activeSession?.title ?? "Gemini 3.7 Flash",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.color_lens_outlined, color: Colors.cyanAccent),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const GradientPickerSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Danh sách tin nhắn Chat
              Expanded(
                child: activeSession == null || activeSession.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: const Icon(Icons.auto_awesome, size: 48, color: Colors.cyanAccent),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Tôi có thể giúp gì cho bạn hôm nay?",
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: activeSession.messages.length,
                        itemBuilder: (context, idx) {
                          return ChatBubble(message: activeSession.messages[idx]);
                        },
                      ),
              ),

              if (chatProv.isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.cyanAccent),
                      ),
                      const SizedBox(width: 8),
                      Text("Gemini 3.7 đang suy nghĩ...", style: TextStyle(color: Colors.cyanAccent.shade100, fontSize: 13)),
                    ],
                  ),
                ),

              // Thanh nhập dữ liệu nổi Glassmorphism
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                child: GlassContainer(
                  borderRadius: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "Hỏi Gemini...",
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.cyanAccent),
                        onPressed: () => _handleSend(chatProv),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
