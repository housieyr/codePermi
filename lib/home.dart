 
import 'package:flutter/material.dart';
import 'package:permi_app/loading.dart';
import 'package:permi_app/quiz.dart'; 
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:lottie/lottie.dart';
import 'package:permi_app/Lessons/awlawya.dart';
import 'package:permi_app/Lessons/idhaa.dart';
import 'package:permi_app/Lessons/is3af.dart';
import 'package:permi_app/Lessons/ma3lomet.dart';
import 'package:permi_app/Lessons/micanic.dart';
import 'package:permi_app/Lessons/mo5alfa.dart';
import 'package:permi_app/icharat.dart';
import 'package:responsive_sizer/responsive_sizer.dart'
    show DeviceExt;
import 'package:simple_shadow/simple_shadow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> { 
  bool testShow = false;
  bool courShow = false;
  @override
  void initState() {
    super.initState();
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
                  fit: BoxFit.cover, // stretch across the screen
                  repeat: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Column(
                  children: [
                    // Daily Task Card
                    InkWell(
                      onTap: () {
                            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen( widgi:  IcharatPage())),
        );
                   
                      },
                      child: SimpleShadow(
                        opacity: 0.2,
                        color: isDark ? Colors.white : Colors.black,
                        // Default: Black
                        offset: Offset(0, 5), // Default: Offset(2, 2)
                        sigma: 7,
                        child: Container(
                          height: 15.5.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha:0.15)
                                : Colors.white.withValues(alpha:0.4),
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
                                      ? Colors.white.withValues(alpha:0.15)
                                      : Colors.white.withValues(alpha:0.4),
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
                                      child: Text(
                                        "إشارات المرور",
                                        style: TextStyle(
                                          fontSize: 4.h,
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
                                        color: Color(0xFFFF9800), // Bolt orange
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.shade200,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
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

                    SizedBox(height: 3.5.h),

                    // Quiz Categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox.shrink(),
                    /*    InkWell(
                          onTap: () {
                            testShow = !testShow;
                            setState(() {});
                          },
                          child: Text(
                            testShow ? "⏫ إخفاء" : "⏬ إضهار الكل",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 1.2.h,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 3),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        Text(
                          "الإختبارات",

                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 2.6.h,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
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
                          _quizIcon('assets/vitess.png', 8, isDark),
                          _quizIcon('assets/triangle.png', 7, isDark),
                          _quizIcon('assets/stops.png', 6, isDark),
                        ],
                      ),
                 /*   if (testShow) SizedBox(height: 1.3.h),

                    if (testShow)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _quizIcon('assets/ajla.png', 15, isDark),
                          _quizIcon('assets/bouji.png', 14, isDark),
                          _quizIcon('assets/tawjihet.png', 13, isDark),
                          _quizIcon('assets/vitess.png', 12, isDark),
                          _quizIcon('assets/panne.png', 11, isDark),
                        ],
                      ),*/
                    SizedBox(height: 3.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            courShow = !courShow;
                            setState(() {});
                          },
                          child: Text(
                            courShow ? "⏫ إخفاء" : "⏬ إضهار الكل",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 1.2.h,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 3),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Text(
                          "الدروس",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 2.6.h,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        _gameCard(
                          "الأولوية",
                          'assets/awlawya.png',
                          '24.7K',
                          AwlawyaPage(),
                          isDark,
                        ),
                        SizedBox(width: 1.2.h),
                        _gameCard(
                          "المخالفات و العقوبات",
                          'assets/mo5alfa.png',
                          '12.5K',
                          Mo5alfaPage(),
                          isDark,
                        ),
                      ],
                    ),
                    if (courShow) SizedBox(height: 1.2.h),
                    if (courShow)
                      Row(
                        children: [
                          _gameCard(
                            "الميكانيك",
                            'assets/doubil.png',
                            '24.7K',
                            MicanicPage(),
                            isDark,
                          ),
                          SizedBox(width: 1.2.h),
                          _gameCard(
                            "إضاءة العربات و إشاراتها",
                            'assets/idhaa.png',
                            '12.5K',
                            LightingPage(),
                            isDark,
                          ),
                        ],
                      ),
                    if (courShow) SizedBox(height: 1.2.h),
                    if (courShow)
                      Row(
                        children: [
                          _gameCard(
                            "الإسعافات الأولية",
                            'assets/is3af.png',
                            '24.7K',
                            Is3afPage(),
                            isDark,
                          ),
                          SizedBox(width: 1.2.h),
                          _gameCard(
                            "معلومات",
                            'assets/ma3loma.png',
                            '12.5K',
                            Ma3lometPage(),
                            isDark,
                          ),
                        ],
                      ),
                    if (courShow) SizedBox(height: 1.2.h),

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
          MaterialPageRoute(builder: (context) => LoadingScreen( widgi: QuizModeScreen(x: x),)),
        );
 
      },
      child: Column(
        children: [
          SimpleShadow(
            opacity: 0.2,
            color: isDark ? Colors.white : Colors.black,
            // Default: Black
            offset: Offset(0, 5), // Default: Offset(2, 2)
            sigma: 7,
            child: Container(
              padding: EdgeInsets.all(1.h),
              height: 7.5.h,
              width: 7.5.h,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha:0.15)
                    : Colors.white.withValues(alpha:0.4),
                borderRadius: BorderRadius.circular(15),
              ),

              child: Image.asset(ss),
            ),
          ),
          SizedBox(height: 6),
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
    String score,
    Widget dd,
    bool isDark,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
           
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreen( widgi:  dd)));
        },
        child: Container(
          height: 29.5.h,
          padding: EdgeInsets.all(1.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha:0.15)
                : Colors.white.withValues(alpha:0.4),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.white12 : Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟡 Icon Box
              Container(
                height: 16.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                  color: isDark
                      ? Colors.white.withValues(alpha:0.35)
                      : Colors.white.withValues(alpha:0.4),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.white12 : Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 1.5.h),

              // 🟣 Title
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

              Spacer(),

              // 🟢 Bottom Row: Score + Bolt Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 2.h,
                        color: Color(0xFFFF9800), // Orange eye
                      ),
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
                      color: Color(0xFFFF9800), // Bolt orange
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade200,
                          blurRadius: 6,
                          offset: Offset(0, 3),
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
            ],
          ),
        ),
      ),
    );
  }
}
