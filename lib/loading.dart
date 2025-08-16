// LoadingScreen.dart
import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:adblock_detector/adblock_detector.dart';

class LoadingScreen extends StatefulWidget {
  final Widget widgi;
  final InterstitialAd? ads;

  const LoadingScreen({
    super.key,
    required this.widgi,
    this.ads,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // 0 = offline, 1 = slow/timeout, 2 = ok
  int _isConnect = 2;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      // allow first frame to render
      await Future.delayed(const Duration(milliseconds: 300));

      // Ensure Firebase is initialized (in case main.dart didn't)
      try {
        Firebase.app();
      } catch (_) {
        await Firebase.initializeApp();
      }

      // Optional: show interstitial if ready (non-blocking)
      if (widget.ads != null) {
        await Future.delayed(const Duration(milliseconds: 400));
        // ignore: unawaited_futures
        widget.ads!.show();
      }

      // Connectivity check
      _isConnect = await _fetchConnectivity();

      if (!mounted) return;
      if (_isConnect == 0) {
        _connection(
          context,
          'ماو حل الإنترنات باش يهبط النص',
          'ヅ',
          '',
          'باهي بركا',
          false,
          'wifi',
        );
        return;
      }
      if (_isConnect == 1) {
        _connection(
          context,
          'يظهرلي cnx متعك تاعبة',
          'برى شوف شكون يبرتاجيلك',
          '',
          'باهي تو نتصرف',
          false,
          'wifi',
        );
        return;
      }

      // Remote version check
      final db = FirebaseDatabase.instanceFor(
        databaseURL:
            'https://permi-app-default-rtdb.europe-west1.firebasedatabase.app',
        app: Firebase.app(),
      ).ref('bandito');

      final packageInfo = await PackageInfo.fromPlatform();
      int versionLocal = 0, versionRemote = 0;

      if (Platform.isAndroid) {
        final snap = await db.child('version').get();
        versionLocal = int.parse(packageInfo.version.replaceAll('.', ''));
        versionRemote = int.parse((snap.value ?? '0').toString().replaceAll('.', ''));
      } else if (Platform.isIOS) {
        final buildLocal = int.parse(packageInfo.buildNumber.replaceAll('.', ''));
        final vll = int.parse(packageInfo.version.replaceAll('.', ''));
        versionLocal = vll + buildLocal;
        final snap = await db.child('versionIos').get();
        versionRemote = int.parse((snap.value ?? '0').toString().replaceAll('.', ''));
      }

      if (!mounted) return;
      if (versionRemote > versionLocal) {
        update(context);
        return;
      }

      // Optional AdBlock check (Android only)
      bool isAdblocking = false;
      if (Platform.isAndroid) {
        try {
          final adb = AdBlockDetector();
          isAdblocking = await adb.isAdBlockEnabled(
            testAdNetworks: [AdNetworks.googleAdMob],
          );
        } catch (_) {
          isAdblocking = false; // ignore failures
        }
      }

      if (!mounted) return;
      if (isAdblocking) {
        _blockAd(
          context,
          'جرب سكر مانع الإعلانات و إلا جرب بدل ويفي اخر خاتر ثمة بلوك للإعلانات',
          'باهي لحظة و نجيك',
        );
        return;
      }

      // All good → navigate to target page
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.widgi),
      );
    } catch (_) {
      // last resort: show server dialog instead of hanging
      if (!mounted) return;
      _server(context);
    }
  }

  Future<int> _fetchConnectivity() async {
    try {
      final url = Uri.parse('https://www.google.com/');
      final res = await http.get(url).timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) return 2;
      return 1;
    } on TimeoutException {
      return 1;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SpinKitFadingCircle(
          color: _spinColor(scheme),
          size: 50,
          duration: const Duration(milliseconds: 700),
        ),
      ),
    );
  }

  Color _spinColor(ColorScheme scheme) {
    // Prefer a high-contrast accent that works in both themes
    // primary is already theme-aware; onSecondaryContainer as fallback
    return scheme.primary;
  }

  // ------------------ Dialogs (theme-aware) ------------------

  TextStyle _titleStyle(BuildContext context, double ww) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            // keep your responsive scale but let theme provide color
            fontSize: ww / 15,
          ) ??
      TextStyle(fontSize: ww / 15, fontWeight: FontWeight.bold);

  TextStyle _descStyle(BuildContext context, double ww) =>
      Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ww / 18,
          ) ??
      TextStyle(fontSize: ww / 18, fontWeight: FontWeight.bold);

  TextStyle _buttonTextStyle(BuildContext context, double ww) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ww / 20,
          ) ??
      TextStyle(fontSize: ww / 20, fontWeight: FontWeight.bold, color: Colors.white);

  void _server(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      titleTextStyle: _titleStyle(context, ww),
      descTextStyle: _descStyle(context, ww),
      buttonsTextStyle: _buttonTextStyle(context, ww),
      dialogBackgroundColor: theme.dialogBackgroundColor,
      context: context,
      customHeader: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/server.png', fit: BoxFit.fill),
      ),
      desc: 'السرفر راهو بو بلاش ملخر كي يدخلو اكثر من 100 في نفس الدقيقة يتبلوكا',
      btnOkText: 'باهي تو نستنى شويا ونعاود',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  void update(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      titleTextStyle: _titleStyle(context, ww),
      descTextStyle: _descStyle(context, ww),
      buttonsTextStyle: _buttonTextStyle(context, ww),
      dialogBackgroundColor: theme.dialogBackgroundColor,
      context: context,
      customHeader: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/update.png', fit: BoxFit.fill),
      ),
      title: 'تي برا امشي اعمل',
      desc: 'El mise a jour el jdid',
      btnOkText: 'هات خنشوفو الجديد',
      btnOkOnPress: () {
        Navigator.pop(context);
        OpenStore.instance.open(
          androidAppBundleId: 'com.housie.permi.permi_app',
        );
      },
    ).show();
  }

  void _connection(
    BuildContext context,
    String a,
    String b,
    String d,
    String c,
    bool check,
    String image,
  ) {
    final ww = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      titleTextStyle: _titleStyle(context, ww),
      descTextStyle: _titleStyle(context, ww), // you used same large size here
      buttonsTextStyle: _buttonTextStyle(context, ww),
      dialogBackgroundColor: theme.dialogBackgroundColor,
      context: context,
      customHeader: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/$image.png', fit: BoxFit.fill),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                a,
                textDirection: TextDirection.rtl,
                style: _titleStyle(context, ww),
              ),
            ),
            if (!check)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  b,
                  textDirection: TextDirection.rtl,
                  style: _titleStyle(context, ww),
                ),
              ),
            if (check)
              Text(
                d,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ww / 20,
                    ),
              ),
          ],
        ),
      ),
      btnOkText: c,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  void _blockAd(BuildContext context, String a, String b) {
    final ww = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    AwesomeDialog(
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      titleTextStyle: _titleStyle(context, ww),
      descTextStyle: _titleStyle(context, ww),
      buttonsTextStyle: _buttonTextStyle(context, ww),
      dialogBackgroundColor: theme.dialogBackgroundColor,
      context: context,
      customHeader: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/adblock.png', fit: BoxFit.fill),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          a,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: ww / 20,
              ),
        ),
      ),
      btnOkText: b,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }
}
