import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

 class Mo5alfaPage extends StatefulWidget {
 

  const Mo5alfaPage({
    super.key,
  
  });

  @override
Mo5alfaPageState createState() => Mo5alfaPageState();
}

class Mo5alfaPageState extends State<Mo5alfaPage> {
 

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
                            padding: EdgeInsets.fromLTRB(1.3.h, 2.h, 1.3.h, 1.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                             
                              
                                sectionTitle("المخالفات الخطيرة :", Colors.green),
                          
                                // Replace with actual asset path
                                subBullet(" عرقلة الجولان بأي شكل من الأشكال"),
                                subBullet(
                                  "عدم إحترام أولوية المترجل ( عدم إحترام الأولوية )",
                                ),
                                subBullet(
                                  "عدم فسح المجال للعربات ذات الأولوية ( إسعاف ، حماية )",
                                ),
                                subBullet("الوقوف على جانب الوقوف الإضطراري بدون موجب"),
                                subBullet(
                                  "تجاوز السرعة القصوى المسموح بها بأقل من 20 كلم / س",
                                ),
                                subBullet("السير بدون إنارة ليلا"),
                                subBullet("المقاطعة على اليسار"),
                                subBullet(
                                  "إستعمال عربة تحدث ضجيج أو تنفث دخان يفوق 20 % ويقل عن 50 %",
                                ),
                                subBullet("إستعمال أضواء الطريق أثناء المقاطعة"),
                                subBullet("السياقة برخصة معلقة الصلوحية"),
                                subBullet("الدخول لاتجاه ممنوع sens interdit"),
                                subBullet("عدم إستعمال حزام الأمان"),
                                subBullet("السير بعربة غير مجهزة بعجلة إحتياطية"),
                                sectionTitle("المخالفات العادية :", Colors.green),
                          
                                Text(
                                  "خطية مالية أدناها 6 د وأقصاها 20 د :",
                                  style: TextStyle(
                                    fontSize: 1.8.h,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                subBullet("عند المجاوزة بدون استعمال أضواء تغير الإتجاه"),
                                subBullet("عند الوقوف والتوقف فوق الرصيف أو المادة"),
                                subBullet("عند السير أو التوقف فوق المسلك الخاص بالحافلات"),
                                SizedBox(height: 4.h),
                                sectionTitle(" جنح صنف 1 :", Colors.blue),
                          
                                subBullet(
                                  "يعاقب السائق بالسجن لمدة أقصاها شهر وخطية مالية من 100 د إلى 200 د عند عدم احترام إشارات الوقوف :",
                                ),
                                bulletPoint("علامة قف"),
                                bulletPoint("ضوء أحمر"),
                                bulletPoint("حواجز السكة"),
                                subBullet("المجاوزة الممنوعة أو وجود علامة منع المجاوزة"),
                          
                                subBullet("نقل أشخاص على عربة غير مهيأة لذلك"),
                                subBullet("وضع آلة كشف الرادار بالعربة أو تجهيزها بها"),
                                subBullet("أثر فرار سائق تسبب في أضرار مادية للغير"),
                                subBullet("الجولان بدون شهادة تسجيل"),
                                subBullet("إستعمال أكثر من رخصة سياقة"),
                                sectionTitle("جنحة :", Colors.blue),
                                Text(
                                  "جنحة العقوبة من 61 إلى 200 د :",
                                  style: TextStyle(
                                    fontSize: 1.8.h,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                subBullet("تجاوز السرعة بأكثر من 20 كلم / س"),
                                subBullet("السير بعربة تحدث ضجيج أو دخان يفوق 50 %"),
                                sectionTitle(" جنح صنف 2 :", Colors.blue),
                                Text(
                                  "يعاقب السائق بالسجن لمدة أقصاها 6 أشهر أو بخطية مالية تتراوح من 200 د إلى 500 د",
                                  style: TextStyle(
                                    fontSize: 1.8.h,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                subBullet("عدم الإمتثال لإشارات أعوان المرور"),
                                subBullet("السير في الإتجاه المعاكس في الطريق السيارة"),
                                subBullet("السياقة تحت تأثير حالة كحولية"),
                                subBullet("التدخين إثر مباشرة العمل لنقل المواد الخطرة"),
                                subBullet("السياقة بدون رخصة"),
                                subBullet("رفض الخضوع لإجراء إثبات الحالة الكحولية"),
                                sectionTitle("ملاحظة :", Colors.red),
                                 Text(
                               "سحب فوري لرخصة السياقة يكون إثر ارتكاب أحد الجنح",
                                  style: TextStyle(
                                    fontSize: 1.8.h,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                 Text(
                                  "السير بعربة تحمل لوحة تسجيل مزورة يكون وضعها فورا في المستودع البلدي",
                                  style: TextStyle(
                                    fontSize: 1.8.h,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                        sectionTitle("جنح خصم 4 نقاط :", Colors.blue),
                                subBullet("تجاوز السرعة المحددة بأكثر من 40 كلم / س"),
                                subBullet("الرجوع على الأعقاب في الطريق السيارة"),
                                  sectionTitle("جنح خصم 4 نقاط :", Colors.blue),
                                subBullet("جنح خصم 6 نقاط :"),
                                subBullet("القتل على وجه الخطأ"),
                                subBullet("السير على عربة غير مسجلة : 3000 د"),
                                subBullet("تجاوز السرعة ب 50 كلم س أو أكثر"),
                          
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
                       )    
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
                       "المخالفات و العقوبات" ,
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
        style: TextStyle(fontSize: 1.8.h, fontWeight: FontWeight.bold, color: Colors.black87,),
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
