import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:permi_app/quiz_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QuizScreen extends StatefulWidget {
  final int x;
  final int i;
  final int score;
  final bool withCorrection;

  const QuizScreen({
    super.key,
    required this.x,
    required this.i,
    this.score = 0,
    this.withCorrection = true,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _createAd();
  }

  void _createAd() {
    _isBannerAdReady = false;
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerAdReady = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: 100.h,
            child: QuizBody(
              x: widget.x,
              startI: widget.i,
              startScore: widget.score,
              withCorrection: widget.withCorrection,
            ),
          ),
 
if (_isBannerAdReady)
  Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    ),
  ),
        ],
      ),
    
    );
  }
}
