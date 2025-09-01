import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd extends StatefulWidget {
  /// The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize;
  final String adUnitId;

  const MyBannerAd({
    super.key,
    this.adSize = AdSize.banner,
    required this.adUnitId,
  });

  @override
  State<MyBannerAd> createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  /// The banner ad to show. This is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;
  bool _isAdFailedToLoad = false;

  @override
  Widget build(BuildContext context) {
    if (_isAdFailedToLoad) {
      return Container(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        color: Colors.grey[300],
        child: const Center(
          child: Text('Ad Banner Here'),
        ),
      );
    }
    return SafeArea(
      child: SizedBox(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        child: _bannerAd == null
            ? const Center(child: CircularProgressIndicator())
            : AdWidget(ad: _bannerAd!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
    _bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          setState(() {
            _isAdFailedToLoad = true;
          });
        },
      ),
    );

    // Start loading.
    _bannerAd?.load();
  }
}