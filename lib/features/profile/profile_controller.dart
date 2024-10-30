import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/utils/get_dominant_color_from_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessengerController extends GetxController {
  RxBool showGoogleLogin = false.obs;
  Rx<Color> dominantColor = Colors.transparent.obs;

  @override
  void onInit() async {
    if (Constants.instance.userProfile == null ||
        Constants.instance.userProfile!.providerData.isEmpty) {
      showGoogleLogin.value = true;
    } else {
      dominantColor.value = await getDominantColorFromNetworkImage(
          Constants.instance.userProfile!.providerData.first.photoURL ?? "");
    }

    print('MessengerController onInit');
    super.onInit();
  }

  void postGoogleLogin() async {
    showGoogleLogin.value = false;
    dominantColor.value = await getDominantColorFromNetworkImage(
        Constants.instance.userProfile!.providerData.first.photoURL ?? "");
    update();
  }
}
