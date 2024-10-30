import 'package:amekopro/features/profile/profile_controller.dart';
import 'package:amekopro/utils/authentication.dart';
import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/widgets/glassy_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MessengerUi extends StatelessWidget {
  const MessengerUi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessengerController>(
      init: MessengerController(),
      global: false,
      builder: (controller) {
        final userProfile = Constants.instance.userProfile;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              controller.showGoogleLogin.value ? "Login" : "Profile",
              style: GoogleFonts.sora(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: controller.showGoogleLogin.value
              ? GlassyButton(
                  onTap: () =>
                      Authentication.instance.googleSignIn().then((value) {
                    controller.postGoogleLogin();
                  }),
                  text: "Login Using Google",
                  showIcon: false,
                )
              : SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: controller.dominantColor.value,
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            userProfile!.providerData.first.photoURL ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          userProfile.providerData.first.displayName ?? "",
                          style: GoogleFonts.sora(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
