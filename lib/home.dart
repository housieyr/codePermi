import 'package:flutter/material.dart';
import 'dart:async' show unawaited;

import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'package:permi_app/lesson_counter_service.dart';
import 'package:permi_app/loading.dart';
import 'package:permi_app/quiz.dart';

import 'package:permi_app/Lessons/awlawya.dart';
import 'package:permi_app/Lessons/idhaa.dart';
import 'package:permi_app/Lessons/is3af.dart';
import 'package:permi_app/Lessons/ma3lomet.dart';
import 'package:permi_app/Lessons/micanic.dart';
import 'package:permi_app/Lessons/mo5alfa.dart';
import 'package:permi_app/icharat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _svc = LessonCounterService();
  Map<String, int> _views = {}; // lessonKey -> count

  @override
  void initState() {
    super.initState();
    _loadCountsOnce();
  }

  Future<void> _loadCountsOnce() async {
    try {
      final latest = await _svc.fetchAll();
      if (!mounted) return;
      setState(() => _views = latest);
    } catch (_) {
      // keep zeros if offline
    }
  }

  Future<void> _openLesson(String key, Widget page) async {
    // server +1 (no login needed)
    unawaited(_svc.increment(key));
    // optimistic UI
    setState(() => _views[key] = (_views[key] ?? 0) + 1);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoadingScreen(widgi: page)),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000000) {
      return (n % 1000000000 == 0)
          ? '${n ~/ 1000000000}B'
          : '${(n / 1000000000).toStringAsFixed(1)}B';
    }
    if (n >= 1000000) {
      return (n % 1000000 == 0)
          ? '${n ~/ 1000000}M'
          : '${(n / 1000000).toStringAsFixed(1)}M';
    }
    if (n >= 1000) {
      return (n % 1000 == 0)
          ? '${n ~/ 1000}K'
          : '${(n / 1000).toStringAsFixed(1)}K';
    }
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [
            Color(0xFF1F1C2C), // deep purple/gray
            Color(0xFF2A2A72), // dark indigo
            Color(0xFF1D2671), // blue-purple tone
            Color(0xFF240B36), // black-purple
          ]
        : const [
            Color(0xFFd6cdfc),
            Color(0xFFae80fd),
            Color(0xFFad7bfe),
            Color(0xFFa26aff),
            Color(0xFFbea4ff),
            Color(0xFFd6cdfc),
          ];

    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Lottie.asset(
                  'assets/jeep.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Column(
                  children: [
                    // Daily Task Card
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoadingScreen(widgi: IcharatPage()),
                            ),
                          );
                        },
                        child: SimpleShadow(
                          opacity: 0.2,
                          color: isDark ? Colors.white : Colors.black,
                          offset: const Offset(0, 5),
                          sigma: 7,
                          child: Container(
                            height: 15.5.h,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity( 0.15)
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 15.h,
                                  margin: EdgeInsets.all(0.5.h),
                                  padding: EdgeInsets.all(0.5.h),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.15)
                                        : Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset('assets/a.png'),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 3.5.h),
                                        child:   Text(
                                          "إشارات المرور",
                                          style: TextStyle(fontSize: 4.h,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 18.h,
                                          top: 0.5.h,
                                        ),
                                        width: 4.5.h,
                                        height: 4.5.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF9800),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.orange.shade200,
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.rocket_launch,
                                          color: Colors.white,
                                          size: 2.5.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Quiz Categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text(
                          "الإختبارات",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 2.6.h,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: 1.3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _quizIcon('assets/centure.png', 5, isDark),
                        _quizIcon('assets/adad.png', 4, isDark),
                        _quizIcon('assets/battery.png', 3, isDark),
                        _quizIcon('assets/park.png', 2, isDark),
                        _quizIcon('assets/sigle.png', 1, isDark),
                      ],
                    ),
                    SizedBox(height: 1.3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _quizIcon('assets/stop.png', 10, isDark),
                        _quizIcon('assets/dhaw.png', 9, isDark),
                        _quizIcon('assets/ronpoi.png', 8, isDark),
                        _quizIcon('assets/triangle.png', 7, isDark),
                        _quizIcon('assets/stops.png', 6, isDark),
                      ],
                    ),
                    SizedBox(height: 1.3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _quizIcon('assets/ajla.png', 15, isDark),
                        _quizIcon('assets/bouji.png', 14, isDark),
                        _quizIcon('assets/tawjihet.png', 13, isDark),
                        _quizIcon('assets/vitess.png', 12, isDark),
                        _quizIcon('assets/panne.png', 11, isDark),
                      ],
                    ),
                    SizedBox(height: 2 .h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text(
                          "الدروس",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 2.6.h,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),

                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        _gameCard(
                          "الأولوية",
                          'assets/awlawya.png',
                          'awlawya',
                          AwlawyaPage(),
                          isDark,
                        ),
                        SizedBox(width: 1.2.h),
                        _gameCard(
                          "المخالفات و العقوبات",
                          'assets/mo5alfa.png',
                          'mo5alfa',
                          Mo5alfaPage(),
                          isDark,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.2.h),
                    Row(
                      children: [
                        _gameCard(
                          "الميكانيك",
                          'assets/doubil.png',
                          'micanic',
                          MicanicPage(),
                          isDark,
                        ),
                        SizedBox(width: 1.2.h),
                        _gameCard(
                          "إضاءة العربات و إشاراتها",
                          'assets/idhaa.png',
                          'idhaa',
                          LightingPage(),
                          isDark,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.2.h),
                    Row(
                      children: [
                        _gameCard(
                          "الإسعافات الأولية",
                          'assets/is3af.png',
                          'is3af',
                          Is3afPage(),
                          isDark,
                        ),
                        SizedBox(width: 1.2.h),
                        _gameCard(
                          "معلومات",
                          'assets/ma3loma.png',
                          'ma3lomet',
                          Ma3lometPage(),
                          isDark,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.2.h),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quizIcon(String ss, int x, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingScreen(widgi: QuizModeScreen(x: x)),
          ),
        );
      },
      child: Column(
        children: [
          SimpleShadow(
            opacity: 0.2,
            color: isDark ? Colors.white : Colors.black,
            offset: const Offset(0, 5),
            sigma: 7,
            child: Container(
              padding: EdgeInsets.all(1.h),
              height: 7.5.h,
              width: 7.5.h,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(ss),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'إمتحان $x',
            style: TextStyle(
              fontSize: 1.4.h,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameCard(
    String title,
    String imagePath,
    String lessonKey,
    Widget page,
    bool isDark,
  ) {
    final score = _fmt(_views[lessonKey] ?? 0);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openLesson(lessonKey, page),
          child: Container(
            height: 29.5.h,
            padding: EdgeInsets.all(1.h),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.white12 : Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image box
                Container(
                  height: 16.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                    color: isDark
                        ? Colors.white.withOpacity(0.35)
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.white12 : Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 1.5.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 2.2.h,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 2.h, color: const Color(0xFFFF9800)),
                        SizedBox(width: 0.5.h),
                        Text(
                          score,
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 1.6.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 4.5.h,
                      height: 4.5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade200,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(Icons.rocket_launch,
                          color: Colors.white, size: 2.5.h),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
