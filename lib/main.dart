import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permi_app/appOpenAds.dart';
import 'package:upgrader/upgrader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'dart:async' show unawaited;
import 'package:permi_app/ad_helper.dart';
import 'package:permi_app/favorite.dart';
import 'package:permi_app/home.dart';
import 'package:permi_app/setting.dart';

import 'theme_manager.dart';

final ThemeNotifier themeNotifier = ThemeNotifier();

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // لا تنتظر — يقلل حجز الـ UI thread
  unawaited(MobileAds.instance.initialize());
  await GetStorage.init('permi');
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
            return  MaterialApp(
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
  int _currentIndex = 0; 
  
  
    final _appOpenManager = AppOpenAdManager();

  // Track when we left foreground
  DateTime? _lastPausedAt;

  // Only show app-open if backgrounded at least this long (tweak to taste)
  static const Duration _minBackgroundForAppOpen = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _screens = [HomeScreen(), FavoritesScreen(), SettingsScreen()];

    // Cold start: load and (optionally) auto-show when ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Optional: also set a cooldown in the manager, e.g. 3 minutes
      // _appOpenManager.setMinInterval(const Duration(minutes: 3));
      _appOpenManager.load(adUnitId: AdHelper.openAdUnitId, showOnLoad: true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Mark when we left foreground
      _lastPausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // Show only if we were away long enough (not just a short overlay)
      final wasAwayLongEnough = _lastPausedAt != null &&
          DateTime.now().difference(_lastPausedAt!) >= _minBackgroundForAppOpen;

      if (wasAwayLongEnough) {
        _appOpenManager.showIfAvailable();
      }
      // Clear so rapid resume/pauses don’t accumulate
      _lastPausedAt = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenManager.dispose();
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
