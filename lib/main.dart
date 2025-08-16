import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/ad_helper.dart';
import 'package:permi_app/favorite.dart';
import 'package:permi_app/home.dart'; 
import 'package:permi_app/setting.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
 
import 'theme_manager.dart'; // ✅ استدعاء ملف الثيم

final ThemeNotifier themeNotifier = ThemeNotifier();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); MobileAds.instance.initialize();
  await Firebase.initializeApp();

  // ✅ Use the global instance
  runApp(QuizApp(themeNotifier: themeNotifier));
}

class QuizApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const QuizApp({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, themeMode, _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode, // ✅ التحكم في الوضع الليلي
                  theme: ThemeData.light(),
                  darkTheme: ThemeData.dark(),
                  home: HomeScreenv(),
                );
              },
            );
          },
        );
      }
    );
  }
}

class HomeScreenv extends StatefulWidget {
  const HomeScreenv({super.key});

  @override
    createState() =>  HomeScreenvState();
}

class  HomeScreenvState extends State<HomeScreenv>with WidgetsBindingObserver {
  final Upgrader upgrader = Upgrader(
    durationUntilAlertAgain: const Duration(days: 1),
  );
  late AppOpenAd? _appOpenAd;
  bool isAdAvailable = false;
  bool _isShowingAd = false;
    void loadAd() {
    _appOpenAd = null;
    isAdAvailable = false;
    AppOpenAd.load(
      adUnitId: AdHelper.openAdUnitId,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) { 
          isAdAvailable = true;
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
      ),
      request: const AdRequest(),
    );
  }
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      loadAd();
      return;
    }
    if (_isShowingAd) {
      return;
    }

    _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        _appOpenAd = null;
        ad.dispose();
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        _appOpenAd = null;
        ad.dispose();
        loadAd();
      },
    );
if(   isAdAvailable){

 
    _appOpenAd?.show();
}
  


  }
  @override
  void initState() { WidgetsBinding.instance.addObserver(this);
       AppOpenAd.load(
      adUnitId: AdHelper.openAdUnitId,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) { 
          isAdAvailable = true;
          _appOpenAd = ad;
          showAdIfAvailable();
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
      ),
      request: const AdRequest(),
    ); 
    super.initState();
  }@override
  void dispose() {
     WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
        super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isAdAvailable) {
   
       showAdIfAvailable();
    }
 
  }
  final NotchBottomBarController _cont = NotchBottomBarController(index: 0);
bool testShow=false;
bool courShow=false;final List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) { final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body:    UpgradeAlert(
          shouldPopScope: () => true,
          showIgnore: false,
          barrierDismissible: true, 
          dialogStyle: UpgradeDialogStyle.cupertino,
          upgrader: upgrader,
        child: Stack(
          children: [
             IndexedStack(
        index: _currentIndex,
        children: _screens,
            ),
             Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 250, 247, 247).withValues(alpha:0.1), // soft shadow
                        spreadRadius: 0.2,
                        blurRadius: 10,
                        offset: Offset(0, 0), // 👈 shadow on top of the bar
                      ),
                    ],
                  ),
                  child: AnimatedNotchBottomBar(
                    bottomBarHeight: 8.5.h,
         
                    /// Provide NotchBottomBarController
                    notchBottomBarController: _cont, 
                    
                    color: isDark?        Color(0xff1A1A1A)  :Colors.white ,
                    elevation: 5,
                    
                    showLabel: true,
                    textOverflow: TextOverflow.visible,
                    maxLine: 1,
                    shadowElevation: 5, 
                    kBottomRadius: 20,
                    notchColor: const Color.fromARGB(255, 253, 130, 30),
        
                    /// restart app if you change removeMargins
                    removeMargins: true,
                    showShadow: false,
                    durationInMilliSeconds: 300,
        
                    itemLabelStyle: TextStyle( 
                      fontSize: 1.8.h,
                      color: isDark?Colors.white : Colors.black54,
                    ),
        
                    bottomBarItems: [
                      BottomBarItem(
                        inActiveItem: Icon(
                           size: 2.5.h,
                          Icons.home_outlined,
                          color:  isDark?Colors.white : Colors.black54,
                        ),
                        activeItem: Icon(
                          size: 2.5.h,
                          Icons.home_outlined,
                          color: Colors.white,
                        ),
                        itemLabel: 'الرئيسية',
                      ),
                      BottomBarItem(
                        inActiveItem: Icon(
                          size: 2.5.h,
                          Icons.bookmark_border,
                          color:  isDark?Colors.white : Colors.black54,
                        ),
                        activeItem: Icon(
                          size: 2.5.h,
                          Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        itemLabel: 'المفضلة',
                      ),
                      BottomBarItem(
                        inActiveItem: Icon(
                            size: 2.5.h,
                          Icons.settings_outlined,
                          color:  isDark?Colors.white : Colors.black54,
                        ),
                        activeItem: Icon(
                          size: 2.5.h,
                          Icons.settings_outlined,
                          color: Colors.white,
                        ),
                        itemLabel: 'الإعدادت',
                      ),
                    ],
                    onTap: (index) {
                     
            setState(() => _currentIndex = index);
                     },
                    kIconSize: 24.0,
                  ),
                ),
              ),
          ],
        ),
      ) );
  }


 


}
