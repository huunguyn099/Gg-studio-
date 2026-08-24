import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'glass_container.dart';

class GeminiDrawer extends StatelessWidget {
  const GeminiDrawer({super.key});

  void _showApiKeyDialog(BuildContext context) {
    final chatProv = Provider.of<ChatProvider>(context, listen: false);
    final controller = TextEditingController(text: chatProv.apiKey ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E202A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cài đặt API Key", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nhập Google AI Studio API Key để chạy mô hình Gemini 3.7 Flash:",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.cyanAccent),
              decoration: InputDecoration(
                hintText: "AIzaSy...",
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              chatProv.setApiKey(controller.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã lưu API Key thành công!")),
              );
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProv = Provider.of<ChatProvider>(context);

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GlassContainer(
        borderRadius: 0,
        blur: 20,
        color: Colors.black.withOpacity(0.8),
        border: const Border(right: BorderSide(color: Colors.white12, width: 1)),
        child: SafeArea(
          child: Column(
            children: [
              // Header Drawer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      "Gemini Native",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12),

              // Tạo chat mới
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: InkWell(
                  onTap: () {
                    chatProv.createNewSession();
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 12),
                        Text("Cuộc trò chuyện mới", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Gần đây", style: TextStyle(color: Colors.white54, fontSize: 12)),
                ),
              ),

              // Danh sách cuộc trò chuyện
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: chatProv.sessions.length,
                  itemBuilder: (context, idx) {
                    final session = chatProv.sessions[idx];
                    final isSelected = session.id == chatProv.activeSession?.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white70),
                        title: Text(
                          session.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.cyanAccent : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 16, color: Colors.white38),
                          onPressed: () => chatProv.deleteSession(session.id),
                        ),
                        onTap: () {
                          chatProv.selectSession(session.id);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),

              const Divider(color: Colors.white12),

              // Cài đặt API Key & Thông tin
              ListTile(
                leading: const Icon(Icons.key, color: Colors.amberAccent),
                title: const Text("Cài đặt API Key", style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  chatProv.apiKey != null && chatProv.apiKey!.isNotEmpty ? "Đã cấu hình" : "Chưa cấu hình",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                onTap: () => _showApiKeyDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
