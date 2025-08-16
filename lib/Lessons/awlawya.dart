import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

 class AwlawyaPage extends StatefulWidget {
 

  const AwlawyaPage({
    super.key,
  
  });

  @override
 AwlawyaPageState createState() =>AwlawyaPageState();
}

class AwlawyaPageState extends State<AwlawyaPage> {
 

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
                                     subBullet("في المرتفعات تكون أولوية المرور للعربات الصاعدة على العربات النازلة ."),  
                                            
                                 subBullet("العربات الخفيفة على الثقيلة ."),
                                 subBullet("للعربة المنفردة على مجموعة العربات ."),
                                 subBullet("عند الاقتراب من مفترق طرقات بدون علامة : أترك الأولوية إلى اليمين ."),
                                 subBullet("ضوء برتقالي ثابت التوقف قبل الضوء ."),
                                 subBullet("ضوء برتقالي رفاف بدون علامة : أترك الأولوية إلى اليمين ."),
                                 subBullet("ضوء برتقالي رفاف + علامة أطبق العلامة ."),
                                 subBullet("المترو لا يتمتع دائما بالأولوية ."),  
                                 subBullet("في صورة عدم خلاص مبلغ الخطية المتعلقة بالمخالفات العادية في ظروف 15 يوم فإن الخطية تتضاعف وفي صورة تجاوزها بشهر فتصبح الرخصة معلقة الصلوحية"),
                                 subBullet("يُمنع نقل الأشخاص في المقاعد الأمامية الذين سنهم دون 10 سنوات"),
                                ],
                              ),
                            ),
                       Positioned (left: 5.5.h,top: -1.5.h,
                         child: Container(width: 30.h,height: 5.h,
                          decoration: BoxDecoration( borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Color(0xFFa26aff),
                          ),
                         ),
                       )    ],
                        ),
                      ),
                   ),      SizedBox(height: 1.h,),
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
                        "الأولوية",
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

   
 
  Widget subBullet(String text) {
    return Padding(
      padding:  EdgeInsets.only( top: 2.h),
      child: Text(
        '◀  $text',
        style: TextStyle(fontSize: 1.8.h, color: Colors.black87,fontWeight: FontWeight.bold,),
        textDirection: TextDirection.rtl,
      ),
    );
  }
 
 
}
