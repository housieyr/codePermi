import 'package:flutter/material.dart';
import 'package:permi_app/quiz_banner_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart' show DeviceExt ;
// import your quiz screen

enum QuizMode { withCorrection, test }

class QuizModeScreen extends StatelessWidget {
    final int x;

 QuizModeScreen({super.key, required this.x});

  void _start(BuildContext context, QuizMode mode ) {
    final withCorrection = mode == QuizMode.withCorrection;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          x: x,           // <- set your exam set here
          i: 1,           // start at question 1
          score: 0,      // start score
          withCorrection: withCorrection,
        ),
      ),
    );
  }
  int  seconds=0;
 
  @override
  Widget build(BuildContext context) {
 
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [
            const Color(0xFF1F1C2C),
            const Color(0xFF2A2A72),
            const Color(0xFF1D2671),
            const Color(0xFF240B36),
          ]
        : [
            const Color(0xFFd6cdfc),
            const Color(0xFFae80fd),
            const Color(0xFFad7bfe),
            const Color(0xFFa26aff),
            const Color(0xFFbea4ff),
            const Color(0xFFd6cdfc),
          ];
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          // background like your quiz page (top/bottom gradients)
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: gradientColors,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.h),
              child: Column(
                children: [
                  // header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48), // spacer to center title
                      Text(
                        "اختيار نوع الاختبار",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 2.2.h,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // big floating card container
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(1.h),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 1.h),
                          Icon(Icons.school, size: 5.2.h, color: Colors.amber),
                          SizedBox(height: 1.2.h),
                          Text(
                            "اختر طريقة الاختبار المناسبة لك",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 2.h,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),

                          // options grid (two large cards)
                          Expanded(
                            child: ListView(
                            
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _ModeCard(
                                  title: "اختبار تعليمي (مع تصحيح)",
                                  subtitle:
                                      "تسمع السؤال والخيارات ثم بعد إجابتك تحصل على التصحيح الفوري والتنبيه على الخطأ.",
                                  icon: Icons.fact_check,
                                  gradient: const [
                                    Color(0xFF00C853), // green accent
                                    Color(0xFF64DD17),
                                  ],
                                  onTap: () => _start(context, QuizMode.withCorrection  ),
                                ), SizedBox(height: 2.5.h),
                                _ModeCard(
                                  title: "اختبار حقيقي (بدون تصحيح)",
                                  subtitle:
                                      "جرب نفسك تحت ضغط الوقت، بدون إظهار الإجابات الصحيحة أثناء الحل.",
                                  icon: Icons.timer_rounded,
                                  gradient: const [
                                    Color(0xFFFF6F00), // deep orange
                                    Color(0xFFFF9800), // amber
                                  ],
                                  onTap: () => _start(context, QuizMode.test  ),
                                ),
                              ],
                            ),
                          ),

                          // tip
                         
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container( 
        padding: EdgeInsets.fromLTRB( 2.h, 3.h,  2.h, 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12,width: 0.3.h ),
        ),
        child: Column(
          children: [
Text(
                        title,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 2.5.h,
                        ),
                      ),
SizedBox(height: 3.h,),
            Row(
              children: [
                // left gradient badge
                Container(
                  width: 8.h,
                  height: 8.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.last.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 3.4.h),
                ),
                SizedBox(width: 1.6.h),
                // texts
                Expanded(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 1.7.h,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 

