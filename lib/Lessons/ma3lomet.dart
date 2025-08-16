import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

 class Ma3lometPage extends StatefulWidget {
 

  const Ma3lometPage({
    super.key,
  
  });

  @override
 Ma3lometPageState createState() =>Ma3lometPageState();
}

class Ma3lometPageState extends State<Ma3lometPage > {
 

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
                                    SizedBox(height: 1.h,),
                                subBullet("في طريق ذو اتجاه واحد يمكنني الوقوف من الجانبين"),
                                subBullet(
                                  "في طريق ذو اتجاهين يمكنني الوقوف من الجانب الأيمن فقط",
                                ),
                                subBullet(
                                  "للوقوف داخل مناطق العمران يجب ترك مسافة لا تقل عن 3 أمتار على المفترق ومع المترجلين وخارج مناطق العمران لا تقل عن 10 أمتار وعن السكة الحديدية 10 متر داخل مناطق العمران و 30 متر خارج مناطق العمران",
                                ),
                                subBullet(
                                  "يكون الوقوف والتوقف جائزا في المنعرجات على مسافة 50 متر فما فوق",
                                ),
                                subBullet("يعتبر الوقوف مفرط كل وقوف يتجاوز 7 أيام"),
                                subBullet(
                                  "تتغير جهة الوقوف من الساعة 8 و 30 دق إلى الساعة 9 ليلا",
                                ),
                                sectionTitle("أين يمنع الوقوف ؟"),
                                subBullet("عند وجود علامة منع الوقوف"),
                                subBullet("بجانب مادة سوداء ، بيضاء أو صفراء"),
                                subBullet("أمام مدخل عمارة أو متجر أو ورشة"),
                                subBullet("قرب أو بجانب سكة حديدية وقرب مفترق الطرقات"),
                                subBullet(
                                  "في محطة خاصة ( حافلات أو ( تاكسي وفي الممر الخاص للدراجات",
                                ),
                                subBullet(" بجانب خط أبيض متواصل"),
                                subBullet("بجانب أشغال أو تحت قنطرة"),
                                subBullet("فوق ممرات المترجلين"),
                                subBullet("في صف مزدوج يسمح (بالتوقف فقط )"),
                                subBullet(
                                  "منع الوقوف في المرتفعات ، بجانب العلامات أو أمامها وفي الطريق ذات الأولوية",
                                ),
                                subBullet("يمنع الوقوف والتوقف قرب النفق"),
                                sectionTitle("رخصة السياقة :"),
                                subBullet("إلى حين بلوغ 60 سنة ==> كل 10 سنوات"),
                                subBullet("من 60 سنة إلى 76 سنة ==> كل 5 سنوات"),
                                subBullet("أكثر من 76 سنة ==> كل 3 سنوات"),
                                subBullet(
                                  "أقل عمر للحصول على رخصة سياقة 18 سنة ولسياقة 404 ISUZU يجب أن يكون عمره 20 سنة ",
                                ),
                                subBullet("رصيد النقاط الأقصى المسند إلى الرخصة :: 25 نقطة"),
                                subBullet(
                                  "عند سحب كل النقاط تسحب رخصة السياقة ولا يمكن الحصول على رخصة جديدة إلا بعد مرور 3 أشهر ",
                                ),
                                subBullet(
                                  "عند متابعة تكوين مختص يمكن للمخالف استرجاع رصيد رخصته 4 نقاط",
                                ),
                                subBullet(
                                  "يمكن استرجاع كل النقاط المخصومة إذا لم يتجاوز عددها 8 خلال سنة",
                                ),
                                sectionTitle("حزام الأمان :"),
                                subBullet(" إجباري على جميع الركاب في جميع المناطق"),
                                subBullet("الحمولة :"),
                                subBullet("لا يمكن أن تتجاوز الحمولة من الخلف 3 متر"),
                                subBullet(
                                  "لا يمكن أن تتجاوز الحمولة من الأمام مستوى مقدمة العربة",
                                ),
                                subBullet("لا يمكن أن تتجاوز إرتفاع الحمولة 4 متر"),
                                subBullet("ارتفاع الحمولة على سطح الأرض 1 متر"),
                                subBullet(
                                  "يتم الإشارة إلى الحمولة من الخلف إذا تجاوزت 1 متر",
                                ),
                                subBullet(
                                  " يمكن جر مجرورة من صنف '' ب '' و '' ح '' إذا لم تتجاوز 750 كلغ",
                                ),
                                subBullet(
                                  "إذا تجاوزت 750 كلغ يجب أن لا يتجاوز وزن الجارة والمجرورة 3500 كلغ",
                                ),
                                subBullet("المرآة العاكسة الداخلية إجبارية"),
                                subBullet(
                                  "المجرورة الخاضعة للتسجيل هي التي يتجاوز وزنها 500 كلغ",
                                ),
                                subBullet(
                                  "إستعمال أضواء المقاطعة يجب تخفيض السرعة بكيفية تكون فيها مسافة الوقوف أقل من 30 م",
                                ),
                                subBullet(
                                  "يكون المحرك أكثر قوة عندما يكون في الدرجة الأولى ( Première )",
                                ),
                                subBullet(
                                  "رخصة السياقة صنف '' ب '' لا يمكن لعدد الركاب أن يتجاوز 8 أشخاص",
                                ),
                                subBullet(
                                  "علامات الخطر خارج مناطق العمران يجب أن تكون مسبقة على بعد 150 متر",
                                ),
                                subBullet(
                                  "علامات الخطر داخل مناطق العمران يجب أن تكون مسبقة على بعد 50 متر",
                                ),
                                subBullet("أقصى سرعة لسائق متربص 80 كلم في الساعة"),
                                subBullet("مدة التربص تدوم سنتين"),
                                subBullet(
                                  "بصفة عامة توجد علامات الطريق على الجهة اليمنى لاتجاه الجولان",
                                ),
                                subBullet(
                                  "لتسهيل عملية المجاوزة يجب المحافظة على نفس السرعة ونفس الموضع",
                                ),
                                subBullet(
                                  "يجب ترك مسافة جانبية لا تقل عن 1 م بالنسبة للمترجل , عربة مجرورة بحيوان والدراجات العادية والنارية",
                                ),
                                subBullet(
                                  "يجب ترك مسافة جانبية لا تقل عن 0.5 متر بالنسبة للعربات",
                                ),
                                subBullet(
                                  "تمنع السياقة بداية من نسبة كحول تساوي 0.3 غرام / لتر من الدم",
                                ),
                                subBullet(
                                  "يجب تقديم شهادة طبية عند الحصول على رخصة سياقة لأول مرة وعند تجديدها",
                                ),
                                subBullet("السياقة بدون شهادة تأمين ممنوعة منعا باتا"),
                                subBullet(
                                  "يجب أن تكون حدة البصر الدنيا تم قبولها للمترشح لاجتياز رخصة سياقة من صنف ب لا يقل عن 6 / 10 في كلتا العينين",
                                ),
                                sectionTitle("المسافات :"),
                                bulletPoint("مسافة الأمان :"),
                                noteText("هي المسافة الفاصلة بينك وبين العربة التي أمامك"),
                                SizedBox(height: 2.h),
                                row("القاعدة :", "assets/icharat/w1.png"),
                                row("مثال :", "assets/icharat/w2.png"),
                                   bulletPoint("مسافة الوقوف :"),
                                noteText("هي المسافة التي ما بين الضغط على الفرامل حتى وقوف العجلات بصفة نهائية ."),
                                row("القاعدة :", "assets/icharat/w3.png"),  SizedBox(height: 2.h),
                                row("مثال :", "assets/icharat/w4.png"),
                                SizedBox(height: 2.h),
                                bulletPoint("ملاحظة : في الطريق المبلل نضيف نصف النتيجة ( 25+ (25/2) = 37 م ) .") ,
                                bulletPoint(
                                  'أضواء الوضعية الخلفية : ( فيوز ) يكون اللون الأحمر ويشاهد من الخلف على مسافة 150 م ويمكن استعمالها عند وقوع العربة خارج مناطق العمران .',
                                ),
                                        subBullet("مسافة الوقوف ....... = تزيد"),subBullet("مسافة الفرملة ....... = تتضاعف"),subBullet("درجة احتكاك العجلات بالمعبد = تنخفض"),
                                  sectionTitle("الوقوف والتوقف"),
                                noteText("الوقوف = هو إيقاف كلي للعربة مع عدم تشغيل المحرك لمدة طويلة"),
                                SizedBox(height: 2.h),
                                 noteText("التوقف = هو إيقاف العربة لمدة دقائق مع تشغيل المحرك"),
                                 subBullet("للوقوف والتوقف يجب ترك مسافة امان قرب ممر مترجلين ب 3 أمتار"),
                                 subBullet("للوقوف والتوقف يجب ترك مسافة أمان قرب المفترقات داخل مناطق العمران ب 3 أمتار و خارج مناطق العمران ب 10 أمتار"),
                                SizedBox(height: 5.h),
                                        
                                        
                              ],
                            ),
                          ),
                      Positioned (left: 5.5.h,top: -1.5.h,
                         child: Container(width: 30.h,height: 5.h,
                          decoration: BoxDecoration( borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Color(0xFFa26aff),
                          ),
                         ),
                       )      ],
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
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15),topLeft: Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black54, blurRadius: 5,offset: Offset(2, 2)),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                    ),
                 Positioned (left: 7.9.h,top: 0.0.h,
                   child: Container(width: 29.1.h,height: 5.h,
                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child:    FittedBox(fit: BoxFit.scaleDown,
                      child: Text(
                      "معلومات",
                        style: TextStyle( shadows: [
      Shadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3),
    ],
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 4.h,
                        ),
                      ),
                    ) 
                   ),
                 )  
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 2.7.h,
          fontWeight: FontWeight.bold,
          color: Colors.green,
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
        style: TextStyle(fontSize: 1.8.h, fontWeight: FontWeight.bold,   color: Colors.black87,),
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

  Widget row(String text, String imagePath) {
    return Row(
      children: [
        Expanded(child: SizedBox.shrink()),
        Expanded(flex: 3, child: Image.asset(imagePath, fit: BoxFit.fill)),
        Expanded(
          flex: 2,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 1.5.h,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget noteText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 1.5.h,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
      textDirection: TextDirection.rtl,
    );
  }
}
