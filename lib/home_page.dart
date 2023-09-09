import 'package:flutter/cupertino.dart';
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
  @override
  void initState() {
    getIt<PageManager>().init();
    super.initState();
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
