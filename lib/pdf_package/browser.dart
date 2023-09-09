import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api/admob_helper.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key, this.initialUrl = "https://www.google.com/"})
      : super(key: key);
  final String initialUrl;
  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  double progress = 0;



  @override
  void initState() {
    super.initState();
    createInterstitialAds();
   
  }

  late WebViewController controller;

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                color: Colors.red,
                backgroundColor: Colors.black12,
              ),
              Expanded(
                child: WebView(
                  initialUrl: widget.initialUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    this.controller = controller;
                  },
                  onPageStarted: (url) {},
                  onProgress: (progress) => setState(() {
                    this.progress = progress / 100;
                  }),
                  // gestureRecognizers: Set()
                  //   ..add(Factory<VerticalDragGestureRecognizer>(
                  //       () => VerticalDragGestureRecognizer())),
                ),
              ),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                  offset: Offset(4, 4), color: Colors.black54, blurRadius: 10)
            ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      controller.clearCache();
                      CookieManager().clearCookies();
                    }),
                IconButton(
                    onPressed: () async {
                      controller.loadUrl("https://www.twitter.com/");
                      await Future.delayed(const Duration(seconds: 20));
                      _showInterstitialAds();
                    },
                    icon: const Icon(FontAwesomeIcons.twitter,
                        color: Colors.blue)),
                IconButton(
                    onPressed: () async {
                      controller.loadUrl("https://www.facebook.com/");
                      await Future.delayed(const Duration(seconds: 20));
                      _showInterstitialAds();
                    },
                    icon: const Icon(FontAwesomeIcons.facebook,
                        color: Color(0xff0F52BA))),
                IconButton(
                    onPressed: () async {
                      controller.loadUrl("https://www.youtube.com/");
                      await Future.delayed(const Duration(seconds: 15));
                      _showInterstitialAds();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.youtube,
                      color: Colors.red,
                    )),
                IconButton(
                    onPressed: () async {
                      controller.loadUrl("https://www.amazon.com/");
                      await Future.delayed(const Duration(seconds: 10));
                      _showInterstitialAds();
                    },
                    icon: const SizedBox(
                        width: 60,
                        height: 25,
                        child: Icon(FontAwesomeIcons.amazon))),
                IconButton(
                    onPressed: () async {
                      if (await controller.canGoBack()) {
                        _showInterstitialAds();
                        controller.reload();
                      }
                    },
                    icon: const Icon(Icons.refresh)),
              ],
            ),
          ),
        ),
      ),
    );
  }

 

  InterstitialAd? _interstitialAd;

  void createInterstitialAds() {
    InterstitialAd.load(
        adUnitId: AbmobService.interstitialAdsId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) => _interstitialAd = ad,
            onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null));
  }

  void _showInterstitialAds() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        createInterstitialAds();
        if (kDebugMode) {
          print('show ads');
        }
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        createInterstitialAds();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }
}
