
import 'dart:io';

class AdHelper {
  static String get myAppsLink {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/search?q=pub:housie&c=apps";
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/us/developer/laftam-hasneen/id1782798648";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
 
    return "ca-app-pub-3843819580286818/9381829634";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3843819580286818/5108532383";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
 


       return "ca-app-pub-3843819580286818/3709064079";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3843819580286818/6959319030";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get openAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3843819580286818/4129502955";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3843819580286818/5646237364";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

 
}
