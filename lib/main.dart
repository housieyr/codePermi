import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import 'package:permi_app/ad_helper.dart';
import 'package:permi_app/favorite.dart';
import 'package:permi_app/home.dart';
import 'package:permi_app/setting.dart';

import 'theme_manager.dart';

final ThemeNotifier themeNotifier = ThemeNotifier();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
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
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: const HomeScreenv(),
            );
          },
        );
      },
    );
  }
}

class HomeScreenv extends StatefulWidget {
  const HomeScreenv({super.key});

  @override
  State<HomeScreenv> createState() => HomeScreenvState();
}

class HomeScreenvState extends State<HomeScreenv> with WidgetsBindingObserver {
  final Upgrader _upgrader =
      Upgrader(durationUntilAlertAgain: const Duration(days: 1));

  final NotchBottomBarController _navController =
      NotchBottomBarController(index: 0);

  late final List<Widget> _screens;

  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool _isShowingAd = false;
  bool _firstFrameShown = false;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [HomeScreen(), FavoritesScreen(), SettingsScreen()];
    WidgetsBinding.instance.addObserver(this);

    // Avoid covering initial UI with an ad.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstFrameShown = true;
      Future.delayed(const Duration(milliseconds: 900), _loadAppOpenAd);
    });
  }

  void _loadAppOpenAd() {
    _appOpenAd = null;
    _isAdAvailable = false;

    AppOpenAd.load(
      adUnitId: AdHelper.openAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
          _maybeShowAd();
        },
        onAdFailedToLoad: (error) {
          _isAdAvailable = false;
        },
      ),
    );
  }

  void _maybeShowAd() {
    if (!_isAdAvailable || _isShowingAd || !_firstFrameShown) return;
    if (!mounted) return;

    _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdFailedToShowFullScreenContent: (ad, error) => _resetAd(ad),
      onAdDismissedFullScreenContent: (ad) {
        _resetAd(ad);
        // Optionally preload next ad for resume-only scenarios:
        // _loadAppOpenAd();
      },
    );

    _appOpenAd?.show();
  }

  void _resetAd(Ad ad) {
    _isShowingAd = false;
    _isAdAvailable = false;
    _appOpenAd = null;
    ad.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _firstFrameShown) {
      if (!_isAdAvailable) _loadAppOpenAd();
      _maybeShowAd();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: UpgradeAlert(
        shouldPopScope: () => true,
        showIgnore: false,
        barrierDismissible: true,
        dialogStyle: UpgradeDialogStyle.cupertino,
        upgrader: _upgrader,
        child: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _screens),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 250, 247, 247)
                          .withOpacity(0.1), // fixed (was withValues)
                      spreadRadius: 0.2,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedNotchBottomBar(
                  bottomBarHeight: 8.5.h,
                  bottomBarWidth: 100.w,
                  notchBottomBarController: _navController,
                  color: isDark ? const Color(0xff1A1A1A) : Colors.white,
                  elevation: 5,
                  showLabel: true,
                  textOverflow: TextOverflow.visible,
                  maxLine: 1,
                  shadowElevation: 5,
                  kBottomRadius: 20,
                  notchColor: const Color.fromARGB(255, 253, 130, 30),
                  removeMargins: false,
                  showShadow: false,
                  durationInMilliSeconds: 300,
                  itemLabelStyle: TextStyle(
                    fontSize: 1.3.h,
                    color: isDark ? Colors.white : Colors.black54,
                  ),
                  bottomBarItems: [
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.home_outlined,
                        size: 2.h,
                        color: isDark ? Colors.white : Colors.black54,
                      ),
                      activeItem: Icon(
                        Icons.home_outlined,
                        size: 2.h,
                        color: Colors.white,
                      ),
                      itemLabel: 'الرئيسية',
                    ),
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.bookmark_border,
                        size: 2.h,
                        color: isDark ? Colors.white : Colors.black54,
                      ),
                      activeItem: Icon(
                        Icons.bookmark_border,
                        size: 2.h,
                        color: Colors.white,
                      ),
                      itemLabel: 'المفضلة',
                    ),
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.settings_outlined,
                        size: 2.h,
                        color: isDark ? Colors.white : Colors.black54,
                      ),
                      activeItem: Icon(
                        Icons.settings_outlined,
                        size: 2.h,
                        color: Colors.white,
                      ),
                      itemLabel: 'الإعدادت',
                    ),
                  ],
                  onTap: (index) {
                    if (_currentIndex == index) return;
                    setState(() => _currentIndex = index);
                  },
                  kIconSize: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
