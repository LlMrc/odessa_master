import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/multimedia/page_manager.dart';
import 'package:pdf_reader/responsive/tablet_body.dart';
import 'package:pdf_reader/service/service.dart';

import 'constant.dart';
import 'responsive/mobile_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      if (width > smallScreen) {
        return const TableteBody();
      }
      return const MobileBody();
    });
  }
}
