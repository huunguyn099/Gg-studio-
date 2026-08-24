import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'glass_container.dart';

class GradientPickerSheet extends StatelessWidget {
  const GradientPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);

    return GlassContainer(
      borderRadius: 28,
      blur: 25,
      color: Colors.black.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette_outlined, color: Colors.cyanAccent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Tùy biến dải màu loang",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: themeProv.presets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = themeProv.presets[index];
                  final isSelected = themeProv.currentIndex == index;

                  return GestureDetector(
                    onTap: () => themeProv.setGradient(index),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: item.colors,
                            ),
                            border: Border.all(
                              color: isSelected ? Colors.cyanAccent : Colors.white24,
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 10)]
                                : [],
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 26)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: TextStyle(
                            color: isSelected ? Colors.cyanAccent : Colors.white70,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
