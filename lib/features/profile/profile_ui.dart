import 'dart:ui';

import 'package:amekopro/features/profile/profile_controller.dart';
import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/widgets/generate_random_pattern.dart';
import 'package:amekopro/widgets/common_text_widget.dart';
import 'package:amekopro/widgets/glassy_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUi extends StatelessWidget {
  const ProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      global: false,
      builder: (controller) {
        final userProfile = Constants.instance.userProfile;

        if (userProfile == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const AmekoText(text: "Profile", fontSize: 24),
          ),
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: ClipRRect(
                  child: Transform.rotate(
                    angle: 10,
                    child: Opacity(
                      opacity: 0.3,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: RandomPatternGenerator(
                            seed: controller.displayName.value),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: controller.dominantColor.value,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Obx(
                          () => RandomPatternGenerator(
                              seed: controller.displayName.value),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AmekoText(
                        text: Constants.instance.displayName ?? "",
                        fontSize: 24,
                      ),
                    ),
                    Obx(
                      () => controller.isProvider.value
                          ? const SizedBox()
                          : GlassyButton(
                              onTap: controller.convertToGoogleLogin,
                              width:
                                  controller.isConvertToGoogleLoginLoading.value
                                      ? 100
                                      : null,
                              textVerticalPadding: 8,
                              textHorizontalPadding: 16,
                              text:
                                  controller.isConvertToGoogleLoginLoading.value
                                      ? const CircularProgressIndicator()
                                      : const AmekoText(
                                          text: "Convert to Google Account",
                                          fontSize: 16),
                              borderRadius: 100,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
