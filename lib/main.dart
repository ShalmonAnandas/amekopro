import 'package:amekopro/features/anime/homepage/home_ui.dart';
import 'package:amekopro/firebase_options.dart';
import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/utils/hex_color.dart';
import 'package:amekopro/utils/notifications.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notifications().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ameko Pro',
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const AnimeHomePage(),
    );
  }
}
