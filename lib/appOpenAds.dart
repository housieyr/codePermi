import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  AppOpenAd? _ad;
  bool _isShowingAd = false;
  bool _isLoading = false;
  DateTime? _loadTime;
  String? _adUnitId;
  bool _showOnLoad = false;

  static const Duration _maxCacheDuration = Duration(hours: 4);

  bool get isAvailable => _ad != null;

  bool get _isExpired {
    if (_loadTime == null) return true;
    return DateTime.now().difference(_loadTime!) > _maxCacheDuration;
  }

  /// Load an App Open ad. If [showOnLoad] is true, it will auto-show as soon as
  /// it’s ready (useful for cold start after first frame).
  void load({required String adUnitId, bool showOnLoad = false}) {
    _adUnitId = adUnitId;
    _showOnLoad = showOnLoad;

    if (_isLoading) return;

    // If we already have a fresh ad, optionally show it now.
    if (_ad != null && !_isExpired) {
      if (_showOnLoad) {
        scheduleMicrotask(showIfAvailable);
      }
      return;
    }

    _isLoading = true;
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
       
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loadTime = DateTime.now();
          _isLoading = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAd = true;
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              _isShowingAd = false;
              _ad = null;
              ad.dispose();
              // Preload again for next time
              if (_adUnitId != null) {
                load(adUnitId: _adUnitId!, showOnLoad: false);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingAd = false;
              _ad = null;
              ad.dispose();
              // Preload next one
              if (_adUnitId != null) {
                load(adUnitId: _adUnitId!, showOnLoad: false);
              }
            },
          );

          if (_showOnLoad) {
            showIfAvailable();
          }
        },
        onAdFailedToLoad: (err) {
          _isLoading = false;
          _ad = null;
          // Gentle retry
          Future.delayed(const Duration(seconds: 30), () {
            if (_adUnitId != null) {
              load(adUnitId: _adUnitId!, showOnLoad: _showOnLoad);
            }
          });
        },
      ),
    );
  }

  /// Show the ad if present; otherwise load and show when ready.
  void showIfAvailable() {
    if (_isShowingAd) return;

    if (_ad == null) {
      if (_adUnitId != null) {
        load(adUnitId: _adUnitId!, showOnLoad: true);
      }
      return;
    }

    if (_isExpired) {
      _ad?.dispose();
      _ad = null;
      if (_adUnitId != null) {
        load(adUnitId: _adUnitId!, showOnLoad: true);
      }
      return;
    }

    _ad!.show();
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
    _isShowingAd = false;
    _isLoading = false;
  }
}
