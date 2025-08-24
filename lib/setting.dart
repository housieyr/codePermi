
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permi_app/controller.dart';
import 'package:permi_app/main.dart'; // provides themeNotifier
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ====== Preferences (keys) ======
  //  static const _kSound = 'soundEnabled';
  //  static const _kLang = 'language';
  //  static const _kSeconds = 'questionSeconds';

  // ====== Local State ======
  String selectedLanguage = 'العربية';
  bool soundEnabled = true;
  bool isDarkMode = false;
  String _appVersion = '';

  // Counter state
  int _seconds = 30;
  static const int _minSec = 5;
  static const int _maxSec = 300;
  static const int _step = 5;

  @override
  void initState() {
    super.initState();
    _seconds = box.read('second') ?? 30;
    // reflect current theme immediately
    isDarkMode = themeNotifier.value == ThemeMode.dark;
    _loadSettings();
  }

  // ====== Load & Save ======
  Future<void> _loadSettings() async {
    final pkg = await PackageInfo.fromPlatform();

    if (!mounted) return;
    setState(() {
      // soundEnabled = prefs.getBool(_kSound) ?? true;
      //  selectedLanguage = prefs.getString(_kLang) ?? 'العربية';

      _appVersion = pkg.version;
      isDarkMode = themeNotifier.value == ThemeMode.dark;
    });
  }
  /*
  Future<void> _saveSound(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSound, v);
  }

  Future<void> _saveLanguage(String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLang, v);
  }*/

  Future<void> _resetFavorites() async {
    // Make it deterministic for readers: favorites is now an empty list.
    await box.write('favorites', <String>[]);

    // (Optional) If you really want the key gone, you can also do:
    // await box.remove('favorites');

    if (!mounted) return;
    showToast(context, 'تمت إعادة ضبط المفضلة');
  
  }

  // ====== Counter logic ======
  void _setSeconds(int v) {
    v = v.clamp(_minSec, _maxSec);
    setState(() => _seconds = v);
    box.write("second", v); // <-- store immediately
  }

  void _increment() => _setSeconds(_seconds + _step);
  void _decrement() => _setSeconds(_seconds - _step);

  // ====== Helpers ======
  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Code Permi Tunisie',
      applicationVersion: 'Version: $_appVersion',
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تطبيق يعاونك باش تنجح في إمتحان كود السياقة. كان تتمكن من الأسئلة الكل '
            'نضمنلك تاخو الكود — عن تجربة شخصية.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 2.h),
          ),
        ),
      ],
    );
  }

  Future<void> _launchFacebook() async {
    const fbDeep = 'fb://profile/100078439645165';
    const fbWeb = 'https://www.facebook.com/profile.php?id=100078439645165';
    final deepOk = await canLaunchUrl(Uri.parse(fbDeep));
    final uri = Uri.parse(deepOk ? fbDeep : fbWeb);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchMail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'banditscreator@gmail.com',
      queryParameters: {'subject': 'Ekteb nasay7 mte3ek'},
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(1.2.h, 6.h, 1.2.h, 0),
      child: Column(
        children: [
          // ====== Language ======
          /*        Card(
            child: ListTile(
              leading: Icon(Icons.language, color: scheme.primary),
              title: Text('اللغة', style: TextStyle(fontSize: 1.7.h)),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  items: const [
                    DropdownMenuItem(
                      value: 'العربية',
                      child: Text('العربية'),
                    ),
                    DropdownMenuItem(
                      value: 'Français',
                      child: Text('Français'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => selectedLanguage = v);
                    _saveLanguage(v);
                  },
                ),
              ),
            ),
          ),
      
          // ====== Sound ======
          Card(
            child: SwitchListTile(
              secondary: Icon(Icons.volume_up, color: scheme.primary),
              title: Text('تشغيل الصوت', style: TextStyle(fontSize: 1.7.h)),
              value: soundEnabled,
              onChanged: (v) {
                setState(() => soundEnabled = v);
                _saveSound(v);
              },
            ),
          ),*/
      
          // ====== Question Duration (Counter) ======
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
              child: Row(
                children: [
                  Icon(Icons.more_time_sharp, color: scheme.primary),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.end,
                      'مدة السؤال (ثواني)',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 1.7.h),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: scheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'نقص $_step ثواني',
      
                          onPressed: _seconds > _minSec ? _decrement : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.2.w),
                          child: Text(
                            '$_seconds',
                            style: TextStyle(
                              fontSize: 2.h,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'زيد $_step ثواني',
                          onPressed: _seconds < _maxSec ? _increment : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      
          // ====== Theme ======
          Card(
            child: SwitchListTile(
              secondary: Icon(Icons.dark_mode, color: scheme.primary),
              title: Text('الوضع الليلي', style: TextStyle(fontSize: 1.7.h)),
              value: isDarkMode,
              onChanged: (val) {
                setState(() => isDarkMode = val);
                // main.dart owns the source of truth & persistence
                themeNotifier.toggleTheme(val);
              },
            ),
          ),
      
          // ====== Reset favorites ======
          Card(
            child: ListTile(
              leading: Icon(Icons.restore, color: scheme.primary),
              title: Text(
                'إعادة ضبط المفضلة',
                style: TextStyle(fontSize: 1.7.h),
              ),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: _resetFavorites,
            ),
          ),
      
          // ====== About ======
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: scheme.primary),
              title: Text('حول التطبيق', style: TextStyle(fontSize: 1.7.h)),
              subtitle: _appVersion.isEmpty
                  ? null
                  : Text('Version: $_appVersion'),
              onTap: _showAbout,
            ),
          ),
      
          // ====== Contact ======
          SizedBox(height: 1.h),
            
          Expanded(
            child: Align(alignment: Alignment.bottomCenter,
              child: Text( 
                'للتواصل معي :',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 3.8.h),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _launchFacebook,
                  icon: const Icon(Icons.facebook),
                  iconSize: 5.h,
                  color: Colors.blueAccent,
                ),
                IconButton(
                  onPressed: _launchMail,
                  icon: const Icon(Icons.email),
                  iconSize: 5.h,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
      
       
          Expanded(
            child: Align(alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'جميع الحقوق محفوظة',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 1.6.h),
                  ),
                  Icon(Icons.copyright, size: 2.h),
                ],
              ),
            ),
          ),
             SizedBox(height: 10 .h,)
        ],
      ),
    );
  }
}

void showToast(BuildContext context, String message, {bool success = true}) {
 

  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 8.h,
      left: (100.w - 80.w) / 2,
      width: 80.w,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
}
