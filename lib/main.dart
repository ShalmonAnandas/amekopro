import 'package:amekopro/widgets/bottom_navigation_bar.dart';
import 'package:amekopro/features/login/login_ui.dart';
import 'package:amekopro/firebase_options.dart';
import 'package:amekopro/utils/authentication.dart';
import 'package:amekopro/utils/constants.dart';
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
  Constants.instance.userProfile =
      await Authentication.instance.getUserProfile();
  Constants.instance.displayName =
      await Authentication.instance.getDisplayName();
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
      home: Constants.instance.userProfile == null
          ? const LoginUi()
          : const AppHomeUi(),
    );
  }
}
