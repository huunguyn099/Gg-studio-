import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class GradientTheme {
  final String name;
  final List<Color> colors;

  const GradientTheme({required this.name, required this.colors});
}

class ThemeProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  int _currentIndex = 0;

  final List<GradientTheme> presets = const [
    GradientTheme(
      name: "Gemini Twilight",
      colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF311042)],
    ),
    GradientTheme(
      name: "Cyber Neon",
      colors: [Color(0xFF090A0F), Color(0xFF180E29), Color(0xFF003049)],
    ),
    GradientTheme(
      name: "Emerald Matrix",
      colors: [Color(0xFF021B1A), Color(0xFF06302B), Color(0xFF00120B)],
    ),
    GradientTheme(
      name: "Crimson Velvet",
      colors: [Color(0xFF1C0A0A), Color(0xFF2E0818), Color(0xFF14050E)],
    ),
    GradientTheme(
      name: "Deep Midnight",
      colors: [Color(0xFF050505), Color(0xFF12131C), Color(0xFF1C1D24)],
    ),
  ];

  int get currentIndex => _currentIndex;
  GradientTheme get currentTheme => presets[_currentIndex];

  ThemeProvider() {
    _init();
  }

  void _init() async {
    _currentIndex = await _storageService.getGradientIndex();
    notifyListeners();
  }

  void setGradient(int index) async {
    _currentIndex = index;
    await _storageService.saveGradientIndex(index);
    notifyListeners();
  }
}
