import 'package:amekopro/features/anime/homepage/home_controller.dart';
import 'package:amekopro/utils/authentication.dart';
import 'package:amekopro/utils/custom_log_printer.dart';
import 'package:amekopro/widgets/glassy_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimeHomePage extends StatefulWidget {
  const AnimeHomePage({super.key});

  @override
  State<AnimeHomePage> createState() => _AnimeHomePageState();
}

class _AnimeHomePageState extends State<AnimeHomePage> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GlassyButton(
          onTap: () async {},
          text: "Anime",
          showIcon: true,
        ),
        body: Column(
          children: [
            GlassyButton(
              onTap: () async {
                await Authentication.instance.googleSignIn();
              },
              text: "Google Login",
              showIcon: true,
            ),
            GlassyButton(
              onTap: () async {
                final res = await Authentication.instance.getUserProfile();
                CustomLogPrinter.instance.printLog("res ====> ${res}");
              },
              text: "Get Profile",
              showIcon: true,
            )
          ],
        ),
      ),
    );
  }
}
