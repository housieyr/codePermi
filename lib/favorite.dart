import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permi_app/controller.dart';
import 'package:permi_app/quiz_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; 

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteItem> favorites = [];

  @override
  void initState() {
    super.initState();
   // Re-run loader whenever 'favorites' changes (reset, add, remove…)
  box.listenKey('favorites', (_) => loadFavorites());

  loadFavorites();
  }

Future<void> loadFavorites() async {
  final raw = box.read('favorites');
  final list = (raw as List?) ?? const <dynamic>[];

  final items = <FavoriteItem>[];
  for (final e in list) {
    try {
      if (e is String) {
        items.add(
          FavoriteItem.fromJson(jsonDecode(e) as Map<String, dynamic>),
        );
      } else if (e is Map) {
        items.add(
          FavoriteItem.fromJson(Map<String, dynamic>.from(e)),
        );
      }
    } catch (_) {
      // skip corrupt entries
    }
  }

  if (!mounted) return;
  setState(() => favorites = items);
}

Future<void> removeFavorite(int index) async {
  if (index < 0 || index >= favorites.length) return;

  final target = favorites[index];

  // Read raw list exactly as stored (could be List<String> or List<Map>)
  final raw = (box.read('favorites') as List?)?.toList() ?? <dynamic>[];

  // Find the raw index that corresponds to the tapped item.
  // Prefer a stable key (savedAt). Fallback: (question + assetPath).
  int rawIndex = -1;
  for (int i = 0; i < raw.length; i++) {
    try {
      Map<String, dynamic> m;
      final e = raw[i];
      if (e is String) {
        m = jsonDecode(e) as Map<String, dynamic>;
      } else if (e is Map) {
        m = Map<String, dynamic>.from(e);
      } else {
        continue;
      }

      final savedAtStr = m['savedAt']?.toString();
      final savedAt = savedAtStr != null ? DateTime.tryParse(savedAtStr) : null;

      final sameByTime = savedAt != null && savedAt.isAtSameMomentAs(target.savedAt);
      final sameByContent =
          (m['question']?.toString() == target.question) &&
          (m['assetPath']?.toString() == target.assetPath);

      if (sameByTime || sameByContent) {
        rawIndex = i;
        break;
      }
    } catch (_) {
      // ignore bad entry
    }
  }

  // As a last resort, if sizes match perfectly, fall back to positional delete.
  if (rawIndex == -1 && raw.length == favorites.length) {
    rawIndex = index;
  }

  if (rawIndex == -1) return; // nothing matched; bail safely

  raw.removeAt(rawIndex);
  await box.write('favorites', raw); // triggers listenKey -> loadFavorites()
  // No setState here; your listenKey('favorites', ...) will refresh the UI.
}

  @override
  Widget build(BuildContext context) {
   
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [
            const Color(0xFF1F1C2C), // deep purple/gray
            const Color(0xFF2A2A72), // dark indigo
            const Color(0xFF1D2671), // blue-purple tone
            const Color(0xFF240B36), // black-purple
          ]
        : [
            const Color(0xFFd6cdfc),
            const Color(0xFFae80fd),
            const Color(0xFFad7bfe),
            const Color(0xFFa26aff),
            const Color(0xFFbea4ff),
            const Color(0xFFd6cdfc),
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: favorites.isEmpty
            ? Center(
                child: Text(
                  "لا توجد أسئلة محفوظة",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 2.h,
                    color: isDark ? Colors.white70 : Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(3, 4),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 12.h),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return Card(  key: ValueKey(item.savedAt.microsecondsSinceEpoch), // or item.id
                    elevation: 5,
                    shadowColor: isDark ? Colors.white54 : Colors.black26,
                    margin: EdgeInsets.symmetric(
                      horizontal: 1.5.h,
                      vertical: 1.h,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(1.h, 1.h, 1.h, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImageView(
                                          imagePath: item.assetPath,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    item.assetPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Center(
                                      child: Text('الصورة غير متوفّرة'),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "📌: السؤال",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 1.7.h,
                                      ),
                                    ),
                                    Directionality(
  textDirection: TextDirection.rtl,
                                                      child: Text(
                                        item.question,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 1.5.h),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "✅: الإجابة الصحيحة",
                                      style: TextStyle(
                                        fontSize: 1.7.h,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                   Directionality(
  textDirection: TextDirection.rtl,
                                                      child: Text(
                                        item.correctAnswer,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 1.5.h),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "🧠 : الإصلاح",
                            style: TextStyle(
                              fontSize: 1.7.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                       Directionality(
  textDirection: TextDirection.rtl,
                                                      child: Text(
        
                              item.solution,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 1.5.h),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeFavorite(index),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "⏰ تم الحفظ في: ${item.savedAt.toLocal().toString().substring(0, 16)}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;
  const FullScreenImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text(
                'الصورة غير متوفّرة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
