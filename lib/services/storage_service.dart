import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_session.dart';

class StorageService {
  static const _keyApiKey = 'gemini_api_key';
  static const _keySessions = 'gemini_sessions';
  static const _keyActiveSession = 'gemini_active_session_id';
  static const _keyGradientIndex = 'gemini_gradient_index';

  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, apiKey.trim());
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyApiKey);
  }

  Future<void> saveSessions(List<ChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_keySessions, data);
  }

  Future<List<ChatSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keySessions);
    if (data == null) return [];
    try {
      final List decoded = jsonDecode(data);
      return decoded.map((s) => ChatSession.fromJson(s)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveActiveSessionId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveSession, id);
  }

  Future<String?> getActiveSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveSession);
  }

  Future<void> saveGradientIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGradientIndex, index);
  }

  Future<int> getGradientIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyGradientIndex) ?? 0;
  }
}
