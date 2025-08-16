import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

 class IcharatPage extends StatefulWidget {
 

  const IcharatPage({
    super.key,
  
  });

  @override
  IcharatPageState createState() => IcharatPageState();
}

class IcharatPageState extends State<IcharatPage> {
 

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
                    
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                    
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(1.3.h, 2.h, 1.3.h, 1.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                sectionTitle("العلامات العمودية :", Colors.green),
                                row(
                                  'علامات الخطر',
                                  "assets/icharat/danger.png",
                                  false,
                                ),
                                row('علامات المنع', "assets/icharat/no.png", false),
                                row(
                                  'علامات خاصة بالمفترقات',
                                  "assets/icharat/stop.png",
                                  true,
                                ),
                                row('علامات الجبر', "assets/icharat/must.png", false),
                                row(
                                  'علامات نهاية الجبر',
                                  "assets/icharat/nomust.png",
                                  false,
                                ),
                                row(
                                  'علامات الإرشاد والتوجيه',
                                  "assets/icharat/irched.png",
                                  false,
                                ),
                                sectionTitle(
                                  "علامات الإرشاد و التوجيه :",
                                  Colors.green,
                                ),
                                column(
                                  "بداية مواطن عمران السرعة 50 كلم س",
                                  "نهاية مواطن عمران السرعة 90 كلم / س",
                                  "مأوى للوقوف بدون مقابل",
                                  "assets/icharat/city.png",
                                  "assets/icharat/nocity.png",
                                  "assets/icharat/park.png",
                                ),
                                SizedBox(height: 3.h),
                                column(
                                  "جولان في اتجاه واحد",
                                  "محطة الحافلات",
                                  "مستشفى",
                                  "assets/icharat/up.png",
                                  "assets/icharat/irched.png",
                                  "assets/icharat/h.png",
                                ),
                                sectionTitle(
                                  "علامات نقل المواد الخطرة :",
                                  Colors.green,
                                ),
                                column(
                                  "خطر حریق",
                                  "خطر انفجار",
                                  "غازات غير قابلة للالتهاب",
                                  "assets/icharat/flam.png",
                                  "assets/icharat/blom.png",
                                  "assets/icharat/gaz.png",
                                ),
                                SizedBox(height: 3.h),
                                column(
                                  "مواد متفجرة",
                                  "ممنوع الجولان على العربات الناقلة لمواد يمكنها تلويث المياه",
                                  "مواد خطرة",
                                  "assets/icharat/car_blom.png",
                                  "assets/icharat/ma.png",
                                  "assets/icharat/danger2.png",
                                ),
                                sectionTitle("علامات الوقوف الوقوف :", Colors.green),
                                column2(
                                  'ممنوع الوقوف والتوقف',
                                  'تمنع الوقوف وتسمح بالتوقف',
                                  "assets/nostop.png",
                                  "assets/icharat/nostop1.png",
                                ),
                                SizedBox(height: 3.h),
                                column2(
                                  'ممنوع الوقوف في الأيام الفردية يسمح بالوقوف في الأيام الزوجية',
                                  'ممنوع الوقوف في الأيام الزوجية ويسمح بالوقوف في الأيام الفردية',
                                  "assets/icharat/nostop2.png",
                                  "assets/icharat/nostop3.png",
                                ),
                                SizedBox(height: 3.h),
                                column(
                                  "ممنوع الوقوف قبل وبعد العلامة",
                                  "ممنوع الوقوف بعد العلامة",
                                  "ممنوع الوقوف قبل العلامة",
                                  "assets/icharat/nostop6.png",
                                  "assets/icharat/nostop4.png",
                                  "assets/icharat/nostop5.png",
                                ),  
                                sectionTitle(
                                  "علامات نقل المواد الخطرة :",
                                  Colors.green,
                                ),
                                row2("مفترق ذو اتجاه دوراني تطبق به اللأولوية على اليسار", "assets/icharat/m1.png"),
                                  row2("افسح المجال للعربات القادمة من اليمين و اليسار", "assets/icharat/m2.png"),
                                 row2("الوقوف اجباري مع فسح المجال لليمين و اليسار", "assets/icharat/m3.png"),
                                 row2("طريق ذات أولوية التمتع بالأولوية في جميع المفترقات", "assets/icharat/m4.png"),
                                 row2("نهاية طريق ذات أولوية", "assets/icharat/m9.png"),
                                 row2("مفترق طرقات تطبق به اللأولوية على اليمين", "assets/icharat/m5.png"),
                                 row2("اعلان عن علامة فسح المجال على المسافة التقريبية المبينة", "assets/icharat/m6.png"),
                                 row2("اعلان عن علامة قف على المسافة التقريبية المبينة", "assets/icharat/m7.png"),
                                 row2("التمتع بالأولوية في المفترق القادم فقط", "assets/icharat/m8.png"),
                    
                                 column2(
                                  "مقطع سكة حديدية محروسة حاجز يدوي",
                                 "طريق رئيسي يشقه طريق فرعي من اليسار",
                                "assets/icharat/m11.png",   "assets/icharat/m10.png",
                                 
                                ),  
                                
                                
                                SizedBox(height: 5.h),
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
                  SizedBox(height: 1.h,),
                 if (_isBannerAdReady)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              width: _bannerAd.size.width.toDouble(),
                              height: _bannerAd.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd),
                            ),
                          ), ],
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
                      "إشارات المرور",
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

  Widget column(String text1, String text2, String text3, i1, i2, i3) {
    return Padding(
      padding: EdgeInsets.all(0.5.h),
      child: Column(
        children: [
          Row(
            spacing: 2.h,
            children: [
              Expanded(child: Image.asset(i3, fit: BoxFit.fill)),
              Expanded(child: Image.asset(i2, fit: BoxFit.fill)),
              Expanded(child: Image.asset(i1, fit: BoxFit.fill)),
            ],
          ),
          Row(
            spacing: 2.h,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    text3,
                    style: TextStyle(
                      fontSize: 1.7.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    text2,
                    style: TextStyle(
                      fontSize: 1.7.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    text1,
                    style: TextStyle(
                      fontSize: 1.7.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget column2(String text1, String text2, i1, i2) {
    return Padding(
      padding: EdgeInsets.all(0.5.h),
      child: Column(
        children: [
          Row(
            spacing: 2.h,
            children: [
              Expanded(child: Image.asset(i2, fit: BoxFit.fill)),
              Expanded(child: Image.asset(i1, fit: BoxFit.fill)),
            ],
          ),
          Row(
            spacing: 2.h,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    text2,
                    style: TextStyle(
                      fontSize: 1.7.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    text1,
                    style: TextStyle(
                      fontSize: 1.7.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget row2(String text, String imagePath ) {
    return Padding(
      padding: EdgeInsets.all(0.5.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(2.h),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 2 .h,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
       
          Expanded(
            child: Image.asset(imagePath, fit: BoxFit.fill)
           ,
          ),
           ],
      ),
    );
  }
  Widget row(String text, String imagePath, bool dd) {
    return Padding(
      padding: EdgeInsets.all(0.5.h),
      child: Row(
        children: [
          Expanded(
            child: dd
                ? Image.asset("assets/icharat/majal.png", fit: BoxFit.fill)
                : SizedBox.shrink(),
          ),
          Expanded(child: Image.asset(imagePath, fit: BoxFit.fill)),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(2.h),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 2.5.h,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 2.7.h,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        '✸ $text',
        style: TextStyle(fontSize: 1.8.h, fontWeight: FontWeight.bold),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget subBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0, top: 2.h),
      child: Text(
        '◀  $text',
        style: TextStyle(
          fontSize: 1.5.h,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget imageRow(String imagePath) {
    return Image.asset(imagePath, fit: BoxFit.fill);
  }

  Widget noteText(String text) {
    return Text(
      '◀◀   $text',
      style: TextStyle(
        fontSize: 2.h,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
      textDirection: TextDirection.rtl,
    );
  }
}
