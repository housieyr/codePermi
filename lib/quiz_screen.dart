import 'dart:convert';
 

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';  
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permi_app/ad_helper.dart'; 
import 'package:permi_app/data.dart';
import 'package:permi_app/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart' show DeviceExt;
import 'package:shared_preferences/shared_preferences.dart';

class QuizBody extends StatefulWidget {
  final int x;
  final int startI;
  final int startScore;
  final bool withCorrection;

  const QuizBody({
    super.key,
    required this.x,
    required this.startI,
    required this.startScore,
    required this.withCorrection,
  });

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> with SingleTickerProviderStateMixin {

 InterstitialAd? _interstitialAd;
  bool _isInterstitialReady = false;

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId, // add this in AdHelper
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
          _isInterstitialReady = false;
        },
      ),
    );
  }
  
  List<Answer> answers = [];
  String questionText = '';
  String explanation = '';
  int correctIndex = -1;
  int selectedIndex = -1;
  List<String> options = [];
  bool _movedNext = false;
  bool _graded = false;
  bool isFavorited = false;
  late String _imagePath;

  // --- Timer ---
  late AnimationController _controller;
  late AnimationStatusListener _timerListener;

  // --- TTS ---
  late final FlutterTts _tts;

  // local quiz progress (no routing)
  late int _i;
  late int _score;
  late bool _withCorrection;

  int get _gainForThisQuestion =>
      (selectedIndex != -1 && selectedIndex == correctIndex) ? 1 : 0;

  String get timerString {
    final duration = _controller.duration! * _controller.value;
    final seconds = duration.inSeconds;
    return seconds.toString().padLeft(2, '0');
  }

  @override
  void initState() {
    super.initState();

    _i = widget.startI;
    _score = widget.startScore;
    _withCorrection = widget.withCorrection;
  _loadInterstitial();
    _imagePath = 'assets/exams/exam${widget.x}/$_i.jpg';

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..value = 1.0;

    _timerListener = (status) {
    if (!mounted) return;
    if (_isBootstrappingTimer) return;                // ignore internal resets
    if (status == AnimationStatus.dismissed) {
      _goNext();
    }
  };
    _controller.addStatusListener(_timerListener);

    _tts = FlutterTts();
    _initTts();

    loadQuestion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/exams/exam${widget.x}/$_i.jpg'), context);
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ar-TN');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> _stopTts() => _tts.stop();
  bool _shouldShowInterstitialFor(int i) => i == 0 || i == 10 || i == 20;

  void _showInterstitialThen(Future<void> Function() after) {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialReady = false;
          _loadInterstitial();        // queue next interstitial
          after();                    // continue flow
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialReady = false;
          _loadInterstitial();
          after();
        },
      );
      _interstitialAd!.show();
      _isInterstitialReady = false;   // prevent double show
    } else {
      after();
    }
  }
  @override
  void dispose() { _interstitialAd?.dispose();
    _controller.removeStatusListener(_timerListener);
    _controller.dispose();
    _stopTts();
    super.dispose();
  }
bool _isBootstrappingTimer = false;
  // ======================= LOAD QUESTION =======================
  Future<void> loadQuestion() async {
      _isBootstrappingTimer = true;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/bandito.json');
      final Map<String, dynamic> root = jsonDecode(jsonStr);

      final exKey = 'ex${widget.x}';
      final qKey = '$_i';

      final Map<String, dynamic>? q =
          (root['bandito']?['exam']?[exKey]?[qKey]) as Map<String, dynamic>?;

      if (q == null) {
        debugPrint("❌ question not found for $exKey/$qKey");
        return;
      }

      final rawAnswers = (q['answers'] as List<dynamic>).map((a) {
        final m = a as Map<String, dynamic>;
        return Answer(text: m['text'] ?? '', isCorrect: m['isCorrect'] == true);
      }).toList()
        ..shuffle();

      if (!mounted) return;
      setState(() {
        questionText = q['question'] ?? '';
        explanation = q['solution'] ?? '';
        answers = rawAnswers;
        options = rawAnswers.map((e) => e.text).toList();
        correctIndex = rawAnswers.indexWhere((a) => a.isCorrect);

        _imagePath = 'assets/exams/exam${widget.x}/$_i.jpg';
        selectedIndex = -1;
        _graded = false;
        isFavorited = false;
      });

      // restart timer for this question
      _controller.stop();
  _controller.value = 1.0;
  _isBootstrappingTimer = false;
  _controller.reverse(from: 1.0);

      if (!mounted) return;
      await checkIfFavorited();

      if (mounted) precacheImage(AssetImage(_imagePath), context);
    } catch (e) {
      debugPrint('❌ Error loading bandito.json: $e');
    }
  }

  // ======================= FAVORITES =======================
  Future<void> checkIfFavorited() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList('favorites') ?? [];

    for (var item in existing) {
      final favorite = FavoriteItem.fromJson(jsonDecode(item));
      if (favorite.question == questionText) {
        if (!mounted) return;
        setState(() => isFavorited = true);
        break;
      }
    }
  }

  // ======================= INTERACTION =======================
  void handleTap(int index) {
    if (!mounted) return;
    setState(() {
      selectedIndex = index;
      _graded = false;
    });
  }

  Future<void> _showMustChooseDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'وين ماشي',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 2.h, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'ماو إختار الإجابة الساعة',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 2.h, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text(
                'باهي',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 2.h, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goNext() async {
    if (_movedNext) return;
    _movedNext = true;

    await _stopTts();

    final newScore = _score + _gainForThisQuestion;

    // Last question?
    if (_i >= 30) {
      _controller.stop();
      _showResultCard(newScore, 30);
      _movedNext = false;
      return;
    }

  final nextI = _i + 1;

    setState(() {
      _score = newScore;
      _i = nextI;
    });

    // If the arriving question index is 10 or 20, show ad first, then load
    if (_shouldShowInterstitialFor(nextI)) {
      _showInterstitialThen(() async {
        await loadQuestion();
        _movedNext = false;
      });
    } else {
      await loadQuestion();
      _movedNext = false;
    }

    await loadQuestion();
    _movedNext = false;
  }

  void _showResultCard(int score, int total) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'result',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 80.w,
                padding: EdgeInsets.all(2.2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      score >= 24 ? "assets/smile.png" : "assets/sad.png",
                      height: 10.h,
                    ),
                    SizedBox(height: 1.5.h),
                    Text('نتيجتك', style: TextStyle(fontSize: 2.4.h, fontWeight: FontWeight.bold)),
                    SizedBox(height: 1.h),
                    Text('$score / $total ', style: TextStyle(fontSize: 3.2.h, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreenv()),
                                (_) => false,
                              );
                            },
                            child: Text('الرئيسية', style: TextStyle(fontSize: 1.5.h, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(width: 1.2.h),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6F00),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _i = 1;
                                _score = 0;
                                selectedIndex = -1;
                                _graded = false;
                                isFavorited = false;
                              });
                              loadQuestion();
                            },
                            child: Text('إعادة الاختبار', style: TextStyle(fontSize: 1.5.h, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, _, child) =>
          Transform.scale(scale: 0.95 + 0.05 * anim.value, child: child),
    );
  }

  void _showExplanationCard() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'explanation',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;

        final size = MediaQuery.of(context).size;
        final double cardW = 94.w;
        final double cardMinH = 28.h;
        final double topSafe = MediaQuery.of(context).padding.top + 12;

        Offset offset = Offset((size.width - cardW) / 2, topSafe);

        return StatefulBuilder(
          builder: (ctx, setState) {
            Offset clamp(Offset o) {
              final maxX = size.width - cardW;
              final maxY = size.height - cardMinH;
              final dx = o.dx.clamp(0.0, maxX);
              final dy = o.dy.clamp(0.0, maxY);
              return Offset(dx, dy);
            }

            return SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: offset.dx,
                    top: offset.dy,
                    width: cardW,
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            offset = clamp(offset + details.delta);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
                          ),
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.drag_indicator, color: Colors.amber, size: 2.4.h),
                                  const Spacer(),
                                  Text('التصحيح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 2.h)),
                                  SizedBox(width: 0.8.h),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      _stopTts();
                                    },
                                    child: Icon(Icons.close, size: 2.4.h, color: isDark ? Colors.white70 : Colors.black54),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.2.h),
                              Text(
                                explanation.isEmpty ? 'لا يوجد تفسير.' : explanation,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 2.h, height: 1.35),
                              ),
                              SizedBox(height: 1.6.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _speak(explanation),
                                      icon: const Icon(Icons.volume_up),
                                      label: const Text('سماع التفسير'),
                                    ),
                                  ),
                                  SizedBox(width: 1.h),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF6F00),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _stopTts();
                                        _goNext();
                                      },
                                      child: Text("فهمتك", style: TextStyle(fontSize: 2.h, height: 1.35)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      transitionBuilder: (_, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(opacity: curved, child: child);
      },
    );
  }
Widget buildQuizUI(BuildContext context) {
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
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Stack(
      children: [
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
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreenv()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: 4.5.h,
                        height: 4.5.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: const Center(child: Icon(Icons.arrow_back, color: Colors.black)),
                      ),
                    ),
                    Text(
                      "السؤال $_i من 30",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 2.h),
                    ),
                    InkWell(
                      onTap: () async {
                        final item = FavoriteItem(
                          savedAt: DateTime.now(),
                          question: questionText,
                          correctAnswer: (correctIndex >= 0 && correctIndex < answers.length)
                              ? answers[correctIndex].text
                              : '',
                          solution: explanation,
                          assetPath: _imagePath,
                        );

                        final prefs = await SharedPreferences.getInstance();
                        final List<String> existing = prefs.getStringList('favorites') ?? [];

                        List<FavoriteItem> allItems = existing
                            .map((e) => FavoriteItem.fromJson(jsonDecode(e)))
                            .toList();

                        if (isFavorited) {
                          allItems.removeWhere((f) => f.question == questionText);
                          final updated = allItems.map((f) => jsonEncode(f.toJson())).toList();
                          await prefs.setStringList('favorites', updated);

                          if (!mounted) return;
                          setState(() => isFavorited = false);
                          if (!context.mounted) return;
                          showToast(context, "تمت الإزالة من المفضلة", success: false);
                        } else {
                          allItems.add(item);
                          final updated = allItems.map((f) => jsonEncode(f.toJson())).toList();
                          await prefs.setStringList('favorites', updated);

                          if (!mounted) return;
                          setState(() => isFavorited = true);
                          if (!context.mounted) return;
                          showToast(context, "تمت الإضافة إلى المفضلة", success: true);
                        }
                      },
                      child: Container(
                        width: 4.5.h,
                        height: 4.5.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Center(
                          child: Icon(
                            isFavorited ? Icons.bookmark : Icons.bookmark_border_outlined,
                            color: isFavorited ? Colors.deepOrange : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main quiz card
              Stack(
                children: [
                  Container(height:77.h,
                    margin: EdgeInsets.only(top: 4.h, left: 2.h, right: 2.h),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // image
                        Container(
                          margin: EdgeInsets.all(1.h),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 25.5.h,
                              child: Image.asset(
                                _imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Center(child: Text('الصورة غير متوفّرة')),
                              ),
                            ),
                          ),
                        ),
              
                        // question + options
                        Column(
                                children: [
                                  Container(
                                    height: 9.h,
                                    margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 0.5.h),
                                    child: Center(
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          questionText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 2.h),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: options.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final baseFill = isDark ? Colors.black26 : Colors.white;
                                      final baseBorder = isDark ? Colors.black : Colors.black12;
                                      
                                      Color bg = baseFill;
                                      Color border = baseBorder;
                                      
                                      if (!_graded) {
                                        if (index == selectedIndex) {
                                          if (!isDark) bg = const Color(0xFFF4EEB6);
                                          border = Colors.yellow;
                                        }
                                      } else {
                                        if (!_withCorrection) {
                                          if (index == selectedIndex) {
                                            if (!isDark) bg = const Color(0xFFF4EEB6);
                                            border = Colors.yellow;
                                          }
                                        } else {
                                          if (index == correctIndex) {
                                            if (!isDark) bg = const Color(0xffbfffef);
                                            border = Colors.green;
                                          } else if (index == selectedIndex && selectedIndex != correctIndex) {
                                            if (!isDark) bg = const Color(0xffffbfbf);
                                            border = Colors.red;
                                          }
                                        }
                                      }
                                      
                                      return GestureDetector(
                                        onTap: () => handleTap(index),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.5.h),
                                          padding: EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: bg,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: border, width: 0.25.h),
                                          ),
                                          child: Row(
                                            children: [
                                              getIcon(index),
                                              Expanded(
                                                child: Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: Text(
                                                    options[index],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                ['- أ', '- ب', '- ج'][index],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.h,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
              
                        // next button
                        Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: GestureDetector(
                            onTap: () async {
                              // Must choose if time is still running
                              if (!_controller.isDismissed && selectedIndex == -1) {
                                await _showMustChooseDialog();
                                return;
                              }
              
                              // If time ended: just proceed
                              if (_controller.isDismissed) {
                                _goNext();
                                return;
                              }
              
                              final isCorrect = selectedIndex == correctIndex;
              
                              setState(() => _graded = true);
              
                              if (!_withCorrection) {
                                _goNext();
                                return;
                              }
              
                              if (!isCorrect) {
                                _controller.stop();
                                _showExplanationCard(); // "فهمتك" calls _goNext()
                              } else {
                                await Future.delayed(const Duration(milliseconds: 700));
                                _goNext();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 3.h),
                              padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6F00), Color(0xFFFF9800)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  // Use withOpacity to keep compatibility
                                  BoxShadow(
                                    color: Colors.orange.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.double_arrow, color: Colors.white),
                                  SizedBox(width: 1.h),
                                  Text(
                                    "إمشي",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 2.2.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  // timer bubble
                  Positioned(
                    top: 0,
                    left: 40.w,
                    child: Container(
                      height: 8.h,
                      width: 8.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: cardColor),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final p = _controller.value.clamp(0.0, 1.0);
                          return Center(
                            child: CircularPercentIndicator(
                              radius: 3.5.h,
                              lineWidth: 0.6.h,
                              percent: p,
                              center: Text(
                                timerString,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 3.h),
                              ),
                              progressColor: const Color(0xFFFF6F00),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
 
}bool connected = true;bool _wasTimerRunningBeforeDisconnect = false;
  // ======================= BUILD =======================
  @override
  Widget build(BuildContext context) {
return ConnectivityWidget(
    onlineCallback: () {
    setState(() {
        connected = true;

        // Resume timer if it was running before
        if (_wasTimerRunningBeforeDisconnect && !_controller.isAnimating) {
          _controller.reverse(from: _controller.value);
        }
      });
    },
    offlineCallback: () {
       setState(() {
        connected = false;

        // Pause the timer but remember if it was running
        _wasTimerRunningBeforeDisconnect = _controller.isAnimating;
        _controller.stop();
      });
    },
    builder: (context, isOnline) {
      if (!connected) {
        return Stack(
          children: [
            // Skeleton loader
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) => Container(
                color: Colors.white,
                child: SkeletonItem(
                  child: Column(
                    children: [
                      SizedBox(height: 6.h,),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 26.h,borderRadius: BorderRadius.circular(20),
                          padding: EdgeInsets.symmetric(vertical: 4.5.h, horizontal: 2.h),
                        ),
                      ),
                       SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 3.7.h,
                          width: 20.h,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 28  .w,bottom: 4 .h ),
                        ),
                      ),
                      
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 6 .h,    borderRadius: BorderRadius.circular(10),
                          width: 100.w,
                          alignment: Alignment.centerRight,
                         padding: EdgeInsets.only(right: 4.h  ,left: 4.h,bottom: 1 .h ),
                          
                        ),
                      ), 
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 6 .h,
                          width: 100.w, borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 4.h  ,left: 4.h,bottom: 1 .h ),
                          
                        ),
                      ),
                        SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 6 .h,
                          width: 100.w, borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 4.h  ,left: 4.h,bottom: 1 .h ),
                          
                        ),
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 7.h,
                          width: 100.w, borderRadius: BorderRadius.circular(25),
                          alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 7.h  ,left: 7.h,top: 3.h ),
                          
                        ),
                      ),
                  
                    ],
                  ),
                ),
              ),
            ),

            // Centered Lottie no-wifi animation
            Center(
              child: Lottie.asset('assets/wifi2.json', height: 30.h),
            ),
          ],
        );
      }

      // ✅ If connected → return the normal quiz UI
      return buildQuizUI(context);
    },
  );
}

  // ======================= ICON =======================
  Widget getIcon(int index) {
    if (!_graded) {
      return Container(
        width: 2.3.h,
        height: 2.3.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black38),
          color: index == selectedIndex ? Colors.yellow : Colors.white,
        ),
      );
    }

    if (_withCorrection) {
      if (index == correctIndex) {
        return Icon(Icons.check_circle, color: Colors.green, size: 2.3.h);
      } else if (index == selectedIndex && selectedIndex != correctIndex) {
        return Icon(Icons.cancel, color: Colors.red, size: 2.3.h);
      }
    }

    return Container(
      width: 2.3.h,
      height: 2.3.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black38),
        color: Colors.white,
      ),
    );
  }
}


// ======================= FAVORITE MODEL + TOAST =======================
class FavoriteItem {
  final String question;
  final String correctAnswer;
  final String solution;
  final String assetPath;
  final DateTime savedAt;

  FavoriteItem({
    required this.question,
    required this.correctAnswer,
    required this.solution,
    required this.assetPath,
    required this.savedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      solution: json['solution'] ?? '',
      assetPath: json['assetPath'] ?? json['imageUrl'] ?? '',
      savedAt: json['savedAt'] != null
          ? DateTime.parse(json['savedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'correctAnswer': correctAnswer,
      'solution': solution,
      'assetPath': assetPath,
      'savedAt': savedAt.toIso8601String(),
    };
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.deepOrangeAccent,
          child: Icon(Icons.abc, color: Colors.white), // placeholder
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

void showToast(BuildContext context, String message, {bool success = true}) {
  final color = success ? Colors.green.shade600 : Colors.red.shade400;

  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 8.h,
      left: (100.w - 80.w) / 2,
      width: 80.w,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
}
