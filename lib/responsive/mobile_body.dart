import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constant.dart';
import '../multimedia/multimedia.dart';
import '../note_package/notepage.dart';
import '../pdf_package/document_listview.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  int index = 0;
  void initAds() async {
    await MobileAds.instance.initialize();
  }

  @override
  void initState() {
    initAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPage(),
      bottomNavigationBar: Visibility(
          visible: isSmallScreen(context) ? true : false,
          child: Container(
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.grey, width: 0.8))),
              child: buildNavigation())),
    );
  }

  Widget buildPage() {
    switch (index) {
      case 1:
        return const NotePage();
      case 2:
        return const Multimedia();
      case 0:
      default:
        return const DocumentListview();
    }
  }

  Widget icons(IconData iconData) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: const Color(0xff0F52BA),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(iconData, size: 18, color: Colors.amber.shade200),
          ),
        ),
      );

  Widget buildNavigation() {
    return BottomNavyBar(
      iconSize: 22,
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: const Icon(
              Icons.apps,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 2.0,
                )
              ],
            ),
            title: const Text('Home'),
            textAlign: TextAlign.center,
            activeColor: Colors.black,
            inactiveColor: Colors.grey),
        BottomNavyBarItem(
          icon: icons(
            Icons.sticky_note_2,
          ),
          title: const Text('Note'),
          textAlign: TextAlign.center,
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: icons(
            Icons.music_note_outlined,
          ),
          title: const Text('Audio'),
          textAlign: TextAlign.center,
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
        ),
      ],
      backgroundColor: Colors.white,
      containerHeight: 60,
    );
  }
}
