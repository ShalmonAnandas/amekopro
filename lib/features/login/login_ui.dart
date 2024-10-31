import 'package:amekopro/features/login/login_controller.dart';
import 'package:amekopro/widgets/animated_color_bg.dart';
import 'package:amekopro/widgets/common_text_widget.dart';
import 'package:amekopro/widgets/glassy_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginUi extends StatelessWidget {
  const LoginUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(
        init: LoginController(),
        global: false,
        builder: (controller) {
          return Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const AnimatedColorBg(),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      "Welcome to Ameko Pro",
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          controller.displayNameError = null;
                          controller.update();
                        },
                        controller: controller.displayNameController,
                        decoration: InputDecoration(
                          hintText: 'What should we call you?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          errorText: controller.displayNameError,
                          errorStyle: GoogleFonts.sora(
                            fontSize: 12,
                          ),
                        ),
                        style: GoogleFonts.sora(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => GlassyButton(
                        onTap: controller.anonymousLogin,
                        width: controller.isAnonymousLoginLoading.value
                            ? 100
                            : MediaQuery.sizeOf(context).width * 0.8,
                        text: controller.isAnonymousLoginLoading.value
                            ? Lottie.asset(
                                'assets/box_round_loader.json',
                                height: 56,
                              )
                            : const AmekoText(text: "Anonymous Login"),
                        borderRadius: 100,
                        textVerticalPadding:
                            controller.isAnonymousLoginLoading.value ? 0 : 16,
                        textHorizontalPadding:
                            controller.isAnonymousLoginLoading.value ? 0 : 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "or",
                              style: GoogleFonts.sora(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => GlassyButton(
                        onTap: controller.googleLogin,
                        width: controller.isGoogleLoginLoading.value
                            ? 100
                            : MediaQuery.sizeOf(context).width * 0.8,
                        text: controller.isGoogleLoginLoading.value
                            ? Lottie.asset('assets/box_round_loader.json',
                                height: 56)
                            : const AmekoText(text: "Google Login"),
                        borderRadius: 100,
                        textVerticalPadding:
                            controller.isGoogleLoginLoading.value ? 0 : 16,
                        textHorizontalPadding:
                            controller.isGoogleLoginLoading.value ? 0 : 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
