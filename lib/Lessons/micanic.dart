import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MicanicPage extends StatefulWidget {
  const MicanicPage({super.key});

  @override
  MicanicPageState createState() => MicanicPageState();
}

class MicanicPageState extends State<MicanicPage> {
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
                                  "لضمان مدة صلوحيه البطارية يجب تعبئة مستوى السائل بانتظام",
                                ),
                                subBullet(
                                  "للإقتصاد في الطاقة يجب إبدال شمعات الإشتعال بانتظام",
                                ),
                                subBullet("يكون نظام تشغيل الشمعات 1-3   4-2"),
                                subBullet("الشمعات تعطي شرارة قوة المحرك"),
                                subBullet("تستوجب البطارية المراقبة المنتظمة"),
                                subBullet("بطارية السيارة قابلة للشحن"),
                                subBullet(
                                  "يتمثل دور مصفاة الهواء في منع دخول الغبار لمحرك العربة",
                                ),
                                subBullet(
                                  "يجب أن يكون مستوى السائل ما بين علامتي الاستدلال القصوى والأدنى",
                                ),
                                subBullet(
                                  "عندما ينخفض مستوى زيت الفرامل بصفة ملحوظة أقوم فورا بالتثبت من أجهزة الفرامل",
                                ),
                                subBullet(
                                  "قبل القيام بسفرة طويلة ينصح بالزيادة في الضغط العادي للعجلات عندما تكون السيارة باردة فقط تتم مراقبة :",
                                ),
                                bulletPoint("زيت المحرك"),
                                bulletPoint("العجلات"),
                                bulletPoint("البطارية"),

                                subBullet(
                                  "يجب عرض العربة على الشخص الفني إذا كانت ترسل أدخنة كثيفة",
                                ),
                                subBullet(
                                  "يعلن مؤشر التهرئة للعجلات على أن عمق الأخاديد يصل إلى 1.6 مم",
                                ),
                                subBullet(
                                  "لا يمكن أن يقل عمق الأخاديد عن 1 مم",
                                ),
                                subBullet(
                                  "الفارق بين طوقين مطاطين مركبين على نفس المغزل لا يزيد عن 5 مم. ",
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: imageRow(
                                        'assets/prob_battery.png',
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: subBullet(
                                        "عند إشتعال هذه العلامة أثناء الجولان تشير إلى حدوث خلل في جهاز البطارية",
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: imageRow('assets/prob_tabrid.png'),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: subBullet(
                                        "عند إشتعال هذه العلامة أثناء الجولان تشير إلى حدوث خلل في جهاز التبريد",
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: imageRow('assets/prob_frein.png'),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: subBullet(
                                        "عند إشتعال هذه العلامة أثناء الجولان تشير إلى حدوث خلل في جهاز الفرملة",
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: imageRow('assets/prob_zyt.png'),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: subBullet(
                                        "عند إشتعال هذه العلامة أثناء الجولان تشير إلى حدوث خلل في زيت المحرك",
                                      ),
                                    ),
                                  ],
                                ),

                                subBullet(
                                  "أجهزة الارتكاز لها تأثير كبير على تأكل العجلات المطاطية",
                                ),
                                subBullet(
                                  "العجلات المتآكلة تؤثر على توازن العربة على الطريق واستهلاك الوقود",
                                ),
                                subBullet(
                                  "تؤثر الحمولة على توازن العربة على الطريق واستهلاك الوقود",
                                ),
                                subBullet(
                                  "الاستعمال الصحيح لنسب السرعة يمكن من الاقتصاد في الوقود",
                                ),
                                subBullet(
                                  "السير بعجلات منفوخة أقل من الازم يزيد في خطر الانفلاق",
                                ),
                                subBullet(
                                  "ضغط العجلات المطاطية له تأثير على إستهلاك الوقود",
                                ),
                                subBullet(
                                  "عند السير لمسافات طويلة يجب الزيادة في ضغط العجلات من 100 غ إلى 300 غ",
                                ),
                                subBullet(
                                  "تقوم بتشحيم أطراف البطارية لمنع تسرب الكهرباء",
                                ),
                                subBullet(
                                  "الماء الذي تحتويه البطارية هو ماء مقطر",
                                ),
                                subBullet("الشمعات تعطي شرارة"),
                                subBullet(
                                  "نقوم بتبديل زيت المحرك بعد قطع مسافة 10000 كلم",
                                ),
                                subBullet(
                                  "نقوم بتبديل شمعات الاشتعال بعد قطع مسافة 20000 كلم",
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
                     "الميكانيك",
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

  Widget imageRow(String imagePath) {
    return Image.asset(imagePath, fit: BoxFit.fill);
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

  Widget bulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.h),
      child: Text(
        '✸ $text',
        style: TextStyle(fontSize: 1.8.h, fontWeight: FontWeight.bold,   color: Colors.black87,),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
