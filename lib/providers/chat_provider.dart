import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

class ChatProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final GeminiService _geminiService = GeminiService();

  List<ChatSession> _sessions = [];
  String? _activeSessionId;
  String? _apiKey;
  bool _isLoading = false;

  List<ChatSession> get sessions => _sessions;
  String? get apiKey => _apiKey;
  bool get isLoading => _isLoading;

  ChatSession? get activeSession {
    if (_sessions.isEmpty) return null;
    return _sessions.firstWhere(
      (s) => s.id == _activeSessionId,
      orElse: () => _sessions.first,
    );
  }

  ChatProvider() {
    _init();
  }

  Future<void> _init() async {
    _apiKey = await _storageService.getApiKey();
    _sessions = await _storageService.loadSessions();
    _activeSessionId = await _storageService.getActiveSessionId();

    if (_sessions.isEmpty) {
      createNewSession();
    } else if (_activeSessionId == null || !_sessions.any((s) => s.id == _activeSessionId)) {
      _activeSessionId = _sessions.first.id;
    }
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    await _storageService.saveApiKey(key);
    notifyListeners();
  }

  void createNewSession() {
    final newSession = ChatSession(
      id: const Uuid().v4(),
      title: "Đoạn chat mới",
      createdAt: DateTime.now(),
      messages: [],
    );
    _sessions.insert(0, newSession);
    _activeSessionId = newSession.id;
    _storageService.saveSessions(_sessions);
    _storageService.saveActiveSessionId(_activeSessionId!);
    notifyListeners();
  }

  void selectSession(String id) {
    _activeSessionId = id;
    _storageService.saveActiveSessionId(id);
    notifyListeners();
  }

  void deleteSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
    if (_sessions.isEmpty) {
      createNewSession();
    } else if (_activeSessionId == id) {
      _activeSessionId = _sessions.first.id;
    }
    _storageService.saveSessions(_sessions);
    notifyListeners();
  }

  void clearAllSessions() {
    _sessions.clear();
    createNewSession();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || activeSession == null) return;
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception("Vui lòng cấu hình API Key trong mục Cài đặt trước!");
    }

    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    activeSession!.messages.add(userMsg);
    if (activeSession!.messages.length == 1) {
      activeSession!.title = text.length > 25 ? "${text.substring(0, 25)}..." : text;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final aiResponse = await _geminiService.sendMessage(
        apiKey: _apiKey!,
        history: activeSession!.messages.sublist(0, activeSession!.messages.length - 1),
        newPrompt: text.trim(),
      );

      final modelMsg = ChatMessage(
        id: const Uuid().v4(),
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      activeSession!.messages.add(modelMsg);
    } catch (e) {
      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        text: "❌ Lỗi: ${e.toString().replaceAll("Exception: ", "")}",
        isUser: false,
        timestamp: DateTime.now(),
      );
      activeSession!.messages.add(errorMsg);
    } finally {
      _isLoading = false;
      await _storageService.saveSessions(_sessions);
      notifyListeners();
    }
  }
}
