import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

 class LightingPage extends StatefulWidget {
 

  const LightingPage({
    super.key,
  
  });

  @override
 LightingPageState createState() =>LightingPageState();
}

class LightingPageState extends State<LightingPage > {
 

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
    return   Scaffold(
     
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
          child:   SafeArea(
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
                                  sectionTitle('من الأمام :'),
                                  Row(
                                    children: [
                                  Expanded(flex: 1,child: imageRow('assets/tari9.png')),
                                      Expanded(flex: 3,child: bulletPoint('أضواء الطريق : ( فار ) يجب أن ترسل نورا يضيء الطريق عن بعد 100 م ويكون مبهرا')),
                                    ],
                                  ),
                                   Row(
                                    children: [
                                  Expanded(flex: 1,child: imageRow('assets/mo9at3aLight.png')),
                                      Expanded(flex: 3,child: bulletPoint("أضواء المقاطعة ( كود ) يجب تخفيض السرعة بكيفية تكون مسافة الوقوف أقل من 30 م ويجب استعماله :")),
                                    ],
                                  ),
                                 // Replace with actual asset path
                                  
                                  subBullet('داخل مناطق العمران'),
                                  subBullet('عند السير وراء عربة أخرى في الليل'),
                                    Row(
                                    children: [
                                  Expanded(flex: 1,child: Padding(padding: EdgeInsets.only(top:2.h),child: imageRow('assets/mtar.png'))),
                                      Expanded(flex: 3,child:        subBullet('عند وجود المطر أو ضباب في النهار') ,),
                                    ],
                                  ),
                            
                                  subBullet('عند مقاطعة ضوء في الليل'),
                                      SizedBox(height: 2.h),
                                   Row(
                                    children: [
                                  Expanded(flex: 1,child: imageRow('assets/wadh3ya.png')),
                                      Expanded(flex: 3,child:   bulletPoint('أضواء الوضعية: تُرى على بعد 150م.'),),
                                    ],
                                  ),
                                
                                
                            
                                     SizedBox(height: 2.h),
                            
                                  sectionTitle('من الخلف :'),
                                  bulletPoint('أضواء الوضعية الخلفية : ( فيوز ) يكون اللون الأحمر ويشاهد من الخلف على مسافة 150 م ويمكن استعمالها عند وقوع العربة خارج مناطق العمران .'),
                                  bulletPoint('عند إضاءتها بأضواء الطريق على بعد 100 م'),
                                  bulletPoint('أضواء لوحة التسجيل ( série ) تشاهد على بعد 20 م'),
                                    SizedBox(height: 5.h),
                                  noteText('أضواء الضباب اختيارية وليست إجبارية.'),  SizedBox(height: 2.h),
                                  noteText('أضواء السير إلى الخلف اختيارية وليست إجبارية.'),
                                ],
                              ),
                            ),
                    Positioned (left: 5.5.h,top: -1.5.h,
                         child: Container(width: 30.h,height: 5.h,
                          decoration: BoxDecoration( borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Color(0xFFa26aff),
                          ),
                         ),
                       )          ],
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
                      'الإنارة',
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
     
    ));
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 2.7.h, fontWeight: FontWeight.bold, color: Colors.green),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding:   EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        '✸ $text',
        style: TextStyle(fontSize: 1.8.h ,fontWeight: FontWeight.bold, color: Colors.black87,),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget subBullet(String text) {
    return Padding(
      padding:  EdgeInsets.only(right: 16.0, top: 2.h),
      child: Text(
        '◀  $text',
        style: TextStyle(fontSize: 1.5.h, color: Colors.black87,fontWeight: FontWeight.bold,),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget imageRow(String imagePath) {
    return  Image.asset(imagePath , fit: BoxFit.fill, );
  }

  Widget noteText(String text) {
    return Text(
      '◀◀   $text',
      style: TextStyle(fontSize: 2.h, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold ,color: const Color.fromARGB(255, 0, 0, 0)),
      textDirection: TextDirection.rtl,
    );
  }
}
