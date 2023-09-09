import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_reader/home_page.dart';

import 'package:pdf_reader/service/service.dart';

import 'data/datahelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  registerAdp();
  await Hive.initFlutter();
  await openBox();
  await setupServiceLocator();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Incomplete list',
          style: TextStyle(
              color: Colors.amber.shade200, fontWeight: FontWeight.w700),
        ),
      ),
    );
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Odessa',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff0F52BA),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          
        
            foregroundColor: Colors.amber[50] //here you can give the text color
            ),
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.red.withOpacity(0.2),
            selectionHandleColor: Colors.blue),
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

void registerAdp() {
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(FavoriteAdapter());
}

Future openBox() async {
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Favorite>('favorite');
}
