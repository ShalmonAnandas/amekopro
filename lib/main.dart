import 'package:amekopro/features/profile/profile_ui.dart';
import 'package:amekopro/firebase_options.dart';
import 'package:amekopro/utils/authentication.dart';
import 'package:amekopro/utils/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Notifications.instance.initNotifications();
  await Authentication.instance.initUserProfile();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ameko Pro',
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const MessengerUi(),
    );
  }
}
