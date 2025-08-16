import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permi_app/main.dart'; // provides themeNotifier
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // state
  String selectedLanguage = 'العربية';
  bool soundEnabled = true;
  bool isDarkMode = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    // read current theme immediately
    isDarkMode = themeNotifier.value == ThemeMode.dark;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final pkg = await PackageInfo.fromPlatform();

    if (!mounted) return;
    setState(() {
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      selectedLanguage = prefs.getString('language') ?? 'العربية';
      _appVersion = pkg.version;
      // keep isDarkMode from themeNotifier (source of truth)
      isDarkMode = themeNotifier.value == ThemeMode.dark;
    });
  }

  Future<void> _saveSound(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', val);
  }

  Future<void> _saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  Future<void> _resetFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تمت إعادة ضبط المفضلة'),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Code Permi Tunisie',
      applicationVersion: 'Version: $_appVersion',
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'تطبيق يعاونك باش تنجح في إمتحان كود السياقة كان تتمكن من الأسئلة الكل نضمنلك تاخو الكود و عن تجربة شخصية.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 2.h),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding:   EdgeInsets.all(1.h),
        child: Column(
         
          children: [
            // اللغة
            /*      Card(
              child: ListTile(
                leading: Icon(Icons.language, color: scheme.primary),
                title: const Text('اللغة'),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLanguage,
                    items: const [
                      DropdownMenuItem(value: 'العربية', child: Text('العربية')),
                      DropdownMenuItem(value: 'Français', child: Text('Français')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedLanguage = value);
                      _saveLanguage(value);
                    },
                  ),
                ),
              ),
            ),
        
            // الصوت
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.volume_up, color: scheme.primary),
                title: const Text('تشغيل الصوت'),
                value: soundEnabled,
                onChanged: (val) {
                  setState(() => soundEnabled = val);
                  _saveSound(val);
                },
              ),
            ),*/
        
            // المظهر
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.dark_mode, color: scheme.primary),
                title: const Text('الوضع الليلي'),
                value: isDarkMode,
                onChanged: (val) {
                  setState(() => isDarkMode = val);
                  // applies & persists theme (your main.dart handles persistence)
                  themeNotifier.toggleTheme(val);
                },
              ),
            ),
        
            // إعادة ضبط المفضلة
            Card(
              child: ListTile(
                leading: Icon(Icons.restore, color: scheme.primary),
                title: const Text('إعادة ضبط المفضلة'),
                trailing: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: _resetFavorites,
              ),
            ),
        
            // حول التطبيق
            Card(
              child: ListTile(
                leading: Icon(Icons.info_outline, color: scheme.primary),
                title: const Text('حول التطبيق'),
                subtitle: _appVersion.isEmpty ? null : Text('Version: $_appVersion'),
                onTap: _showAbout,
              ),
            ),
           
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                children: [ 
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "للتواصل معي :",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                 
                        fontWeight: FontWeight.bold,
                        fontSize: 4.h),
                  ),
           
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          const url = 'fb://profile/100078439645165';
                          const url2 =
                              'https://www.facebook.com/profile.php?id=100078439645165';
                          if (await canLaunchUrlString(url.toString())) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            launchUrl(Uri.parse(url2),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.facebook),
                        iconSize: 5.h,
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        onPressed: () async {
                          String email =
                              Uri.encodeComponent("banditscreator@gmail.com");
                          String subject =
                              Uri.encodeComponent("Ekteb nasay7 mte3ek");
              
                          Uri mail = Uri.parse("mailto:$email?subject=$subject");
                          if (await launchUrl(mail)) {
                            launchUrl(mail);
                          }
                        },
                        icon: const Icon(Icons.email),
                        iconSize: 5.h,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                   
                   
                ],
              ),
            ), Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "جميع الحقوق محفوظة",
                  textDirection: TextDirection.rtl,
                  style: TextStyle( fontSize: 1.6.h),
                ),
                Icon(
                  Icons.copyright,
                  size: 2.h,
                )
                      ],
                    ),SizedBox(height: 6.h,)
           ],),
      )
    );
  }
}
