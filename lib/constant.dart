import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_reader/pdf_package/pdf_viewer.dart';


double smallScreen = 480;

bool isSmallScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < smallScreen;
}

void openPDF(BuildContext context, File file) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
    );
 final Image noImage = Image.asset("assets/thumbnail.png");