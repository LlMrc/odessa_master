import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pdf_reader/pdf_package/browser.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/admob_helper.dart';

class DetailsBook extends StatefulWidget {
  final String url;
  final String description;
  final String title;
  final String initialRoute;
  final String previewedLink;
  const DetailsBook(
      {super.key,
      this.previewedLink = '',
      required this.url,
      required this.description,
      required this.title,
      required this.initialRoute});

  @override
  State<DetailsBook> createState() => _DetailsBookState();
}

class _DetailsBookState extends State<DetailsBook> {
  @override
  void initState() {
    createInterstitialAds();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final size = MediaQuery.of(context).size;
    final Image noImage = Image.asset("assets/thumbnail.png");
    bool validURL = Uri.parse(widget.url).isAbsolute;
    bool valideWebReader = Uri.parse(widget.initialRoute).isAbsolute;

    String descp = widget.description == 'null'
        ? 'Description not found'
        : widget.description;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          _showInterstitialAds();

          return true;
        },
        child: Scaffold(
          backgroundColor: const Color(0xff0F52BA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: const Text('Books and magazines'),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      _launchInBrowser(valideWebReader == true
                          ? Uri.parse(widget.initialRoute)
                          : Uri.parse("https://www.google.com/"));
                    },
                    child: Image.asset(
                      "assets/thumbnail.png",
                      width: 40,
                      height: 40,
                      color: Colors.amber.shade200,
                    )),
              )
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: size.height / 1.3,
                          width: size.width,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 2,
                                    spreadRadius: 2)
                              ],
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 90,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.title,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  const Divider(
                                    indent: 40,
                                    endIndent: 40,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12),
                                    height: orientation ? 270 : 100,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        descp,
                                        maxLines: descp.length,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: orientation ? true : false,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.amber.shade300,
                                      side: const BorderSide(
                                          color: Color(0xff0F52BA)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => Browser(
                                                  initialUrl:
                                                      widget.previewedLink)));
                                    },
                                    child: Text(
                                      'Previewed',
                                      style: TextStyle(
                                          color: Colors.grey.shade800),
                                    )),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: -55,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 140,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: validURL == true
                                  ? Image.network(
                                      widget.url,
                                      fit: BoxFit.fill,
                                    )
                                  : noImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: orientation ? false : true,
            child: OutlinedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(15, 235, 142, 235))),
              child: const Text('Previewed'),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  // Load interstitial AD
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
