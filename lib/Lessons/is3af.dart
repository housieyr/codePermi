import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Is3afPage extends StatefulWidget {
  const Is3afPage({super.key});

  @override
  Is3afPageState createState() => Is3afPageState();
}

class Is3afPageState extends State<Is3afPage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  void _createAd() {
    _isBannerAdReady = false;
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void initState() {
    _createAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 196, 183, 253),
              Color(0xFFae80fd),

              Color(0xFFa26aff),

              Color.fromARGB(255, 196, 183, 253),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 1.h),
                                subBullet(
                                  "بصفة عامة يتمثل إسعاف مصاب في طمأنته والرفع من معنوياته",
                                ),

                                subBullet(
                                  "يجب وضع المصاب الفاقد للوعي في وضع الضمان الجانبي مع المحافظة على إستواء الرأس والجسم والعنق",
                                ),
                                subBullet(
                                  "عند تعدد الإصابات لدى المصاب يجب إعطاء الأولوية في الإسعاف للإختناق",
                                ),
                                subBullet(
                                  "عند وجود نزيف يجب القيام بالضغط اليدوي المباشر على مكان الإصابة لمدة دقائق وعند عدم توقف النزيف نلتجأ إلى نقطة الضغط",
                                ),
                                subBullet(
                                  "يمكن إخراج مصاب من العربة في حالة وقوع خطر محدق",
                                ),
                                subBullet(
                                  "لطمأنة مصاب يجب مخاطبته وتدفئته بغطاء",
                                ),
                                subBullet(
                                  "يلاحظ إصفرار الشفتين وأطراف الأصابع عند إصابة المصاب بنزيف داخلي",
                                ),
                                subBullet(
                                  "نسق التنفس الإصطناعي عند الرضيع هو من 25 إلى 40 حركة تنفسية في الدقيقة أي بمعدل 30 حركة",
                                ),
                                subBullet(
                                  "نسق التنفس الإصطناعي عند الكهل هو من 12 إلى 20 حركة تنفسية في الدقيقة أي بمعدل 16 حركة",
                                ),
                                subBullet(
                                  "يكون القيام بالتنفس الإصطناعي إلى حين وصول مصالح الإسعاف أو استعادة المصاب تنفسه",
                                ),
                                subBullet(
                                  "مصاب بجرح عميق في البطن يوضع في وضعية الامتداد على الظهر مع طي الركبتين",
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 5.5.h,
                            top: -1.5.h,
                            child: Container(
                              width: 30.h,
                              height: 5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Color(0xFFa26aff),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  if (_isBannerAdReady)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    ),
                ],
              ),

              Positioned(
                left: 2.6.h,
                top: 2.5.h,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 4.5.h,
                    height: 4.5.h,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 140, 0),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 7.9.h,
                top: 0.0.h,
                child: Container(
                  width: 29.1.h,
                  height: 5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "الإسعافات الأولية",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(2, 3),
                            blurRadius: 3,
                          ),
                        ],
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 4.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text(
        '◀  $text',
        style: TextStyle(
          fontSize: 1.8.h,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
