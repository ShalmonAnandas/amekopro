import 'package:amekopro/utils/authentication.dart';
import 'package:amekopro/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing user profile state and functionality.
///
/// This controller handles:
/// - Display name management
/// - Account type tracking (anonymous vs Google)
/// - UI color theming
/// - Converting anonymous accounts to Google accounts
///
/// The controller uses GetX for reactive state management, with several
/// observable values that automatically trigger UI updates when changed:
/// - [dominantColor] - Theme color derived from profile image
/// - [displayName] - User's current display name
/// - [isConvertToGoogleLoginLoading] - Loading state during account conversion
/// - [isProvider] - Whether account is Google (true) or anonymous (false)
///
/// Example usage:
/// ```dart
/// final controller = Get.put(ProfileController());
///
/// // Access reactive values
/// Text(controller.displayName.value);
///
/// // Convert anonymous account to Google
/// controller.convertToGoogleLogin();
/// ```
class ProfileController extends GetxController {
  /// The dominant color used for UI elements like borders and accents.
  /// This color is derived from the user's profile image or pattern.
  Rx<Color> dominantColor = Colors.transparent.obs;

  /// The user's display name shown in the profile.
  /// Updated when the user signs in or changes their display name.
  RxString displayName = "".obs;

  /// Loading state for the Google account conversion process.
  /// True while converting from anonymous to Google account.
  RxBool isConvertToGoogleLoginLoading = false.obs;

  /// Whether the user is signed in with a provider (e.g. Google)
  /// vs anonymously. True if signed in with Google, false if anonymous.
  RxBool isProvider = true.obs;

  /// Initializes the profile controller by:
  /// 1. Retrieving and setting the user's display name from Authentication service
  /// 2. Updating the observable display name value
  /// 3. Determining if the user is signed in with a Google provider
  ///
  /// The display name is fetched using [Authentication.getDisplayName] and stored in
  /// both [Constants.instance.displayName] and the observable [displayName].
  ///
  /// [isProvider] is set to true if:
  /// - The user has provider data
  /// - The first provider ID is "google.com"
  /// This indicates whether the user is signed in with Google vs anonymously.
  @override
  void onInit() async {
    Constants.instance.displayName =
        await Authentication.instance.getDisplayName();

    displayName.value = Constants.instance.displayName!;

    isProvider.value =
        (Constants.instance.userProfile?.providerData.isNotEmpty ?? false) &&
            (Constants.instance.userProfile?.providerData.first.providerId ==
                "google.com");

    super.onInit();
  }

  /// Converts an anonymous account to a Google account by linking Google credentials.
  ///
  /// This method:
  /// 1. Shows a loading indicator by setting [isConvertToGoogleLoginLoading] to true
  /// 2. Links Google credentials to the current anonymous account using [Authentication.authenticateUserWithGoogle]
  /// 3. Updates the display name from the Google account
  /// 4. Updates [isProvider] to reflect that the account is now a Google account
  /// 5. Hides the loading indicator
  ///
  /// After conversion is complete, the user will be able to sign in with their
  /// Google account while retaining all their anonymous account data.
  void convertToGoogleLogin() async {
    isConvertToGoogleLoginLoading.value = true;
    await Authentication.instance.googleSignIn();

    displayName.value = Constants.instance.displayName!;
    isProvider.value =
        (Constants.instance.userProfile?.providerData.isNotEmpty ?? false) &&
            (Constants.instance.userProfile?.providerData.first.providerId ==
                "google.com");
    isConvertToGoogleLoginLoading.value = false;
    update();
  }
}
