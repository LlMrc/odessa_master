import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pdf_reader/multimedia/page_manager.dart';

import '../api/admob_helper.dart';
import '../api/buttom_package/button_class.dart';
import '../service/service.dart';

class Multimedia extends StatefulWidget {
  const Multimedia({
    Key? key,
  }) : super(key: key);
  @override
  State<Multimedia> createState() => _MultimrdiaState();
}

class _MultimrdiaState extends State<Multimedia> {
  BannerAd? _bannerAd;

  bool isAldloaded = false;
  @override
  void initState() {
    super.initState();

    _creatBannerAd();
  }

  final pageManager = getIt<PageManager>();
  final _audioHandler = getIt<AudioHandler>();

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/illustration/no_music.svg';
    final size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/mig.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Visibility(
                    visible: isPortrait ? true : false, child: buildcontent()),
                ValueListenableBuilder<List<MediaItem>>(
                  valueListenable: pageManager.playlistNotifier,
                  builder: (context, playlistTitles, _) {
                    if (playlistTitles.isEmpty) {
                      return Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: isPortrait ? 24.0 : 30.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(assetName,
                                semanticsLabel: 'no mp3 files found',
                                height: isPortrait ? 350 : 200),
                            const Text("No Audio Files found",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 24,
                                    shadows: [
                                      Shadow(
                                          // blurRadius: 0.5,
                                          color: Colors.red,
                                          offset: Offset(1, -0))
                                    ])),
                          ],
                        ),
                      ));
                    }
                    return Flexible(
                      child: ListView.builder(
                        itemCount: playlistTitles.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: size.width > 600 ? 8 : 0,
                                horizontal:
                                    size.width > 600 ? size.width * .10 : 10),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white10,
                                      border: Border.all(color: Colors.grey)),
                                  child: ListTile(
                                      leading: CircleAvatar(
                                          child: Icon(
                                        Icons.headphones,
                                        color: Colors.grey[700],
                                      )),
                                      title: Text(playlistTitles[index].title,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 20,
                                              shadows: const [
                                                Shadow(
                                                    // blurRadius: 0.5,
                                                    color: Colors.black,
                                                    offset: Offset(1, -0))
                                              ]),
                                          overflow: TextOverflow.fade),
                                      onTap: () async {
                                        await _audioHandler
                                            .skipToQueueItem(index);
                                        _audioHandler.play();
                                        showSongs();
                                      }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
            tooltip: 'Music',
            elevation: 4,
            heroTag: 'g',
            onPressed: () => showSongs(),
            child: const Icon(Icons.music_note)),
      ),
    );
  }

  void _creatBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AbmobService.bannerAdsId!,
        listener: BannerAdListener(
            onAdLoaded: (ad) => setState(() => isAldloaded = true),
            onAdFailedToLoad: (ad, error) {
              if (kDebugMode) {
                print('$ad $error');
              }
            }),
        request: const AdRequest())
      ..load();
  }

  Widget buildcontent() {
    return isAldloaded
        ? Container(
            margin: const EdgeInsets.all(8),
            height: _bannerAd!.size.height.toDouble(),
            width: _bannerAd!.size.width.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : Container(
            alignment: Alignment.center,
            height: 58,
            color: Colors.white12,
            child: const Text('A U D I O  P L A Y E R',
                style: TextStyle(
                    color: Color(0xff0F52BA),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(color: Colors.grey, offset: Offset(-1, 1))
                    ])));
  }

  void showSongs() {
    showBottomSheet(
        backgroundColor: Colors.white54,
        context: context,
        builder: (context) => Container(
            padding: const EdgeInsets.all(14),
            alignment: Alignment.center,
            height: 350,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: const CurrentSongTitle(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 240,
                    width: 270,
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.center,
                        child: roundedContainer(const PlayButton()),
                      ),
                      const Align(
                        alignment: Alignment.topCenter,
                        child: ShuffleButton(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: roundedContainer(const NextSongButton()),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: roundedContainer(const PreviousSongButton()),
                      ),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: RepeatButton(),
                      ),
                    ]),
                  ),
                ),
              ],
            )));
  }

  Widget roundedContainer(child) {
    return Container(
      child: child,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade400,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white, width: 2.0)),
    );
  }
}
