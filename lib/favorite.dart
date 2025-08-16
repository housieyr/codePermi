import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permi_app/quiz_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('favorites') ?? [];
    setState(() {
      favorites = saved
          .map((e) => FavoriteItem.fromJson(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> removeFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('favorites') ?? [];
    saved.removeAt(index);
    await prefs.setStringList('favorites', saved);
    setState(() {
      favorites.removeAt(index);
    });
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
                  return Card(
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
