import 'package:amekopro/features/profile/profile_ui.dart';
import 'package:amekopro/utils/authentication.dart';
import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/utils/custom_log_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing login functionality and state.
///
/// This controller handles both anonymous and Google sign-in flows, including:
/// - Display name validation and management for anonymous login
/// - Loading states during authentication
/// - Error handling and display
/// - Navigation after successful login
///
/// The controller uses GetX for reactive state management, with observable values
/// that automatically trigger UI updates:
/// - [isAnonymousLoginLoading] - Loading state during anonymous sign in
/// - [isGoogleLoginLoading] - Loading state during Google sign in
///
/// For anonymous login, it manages:
/// - Display name input via [displayNameController]
/// - Validation errors via [displayNameError]
///
/// Example usage:
/// ```dart
/// final controller = Get.put(LoginController());
///
/// // Anonymous login with display name
/// controller.displayNameController.text = "User123";
/// controller.anonymousLogin();
///
/// // Google sign in
/// controller.googleLogin();
/// ```
///
/// The controller handles all authentication through the [Authentication] service
/// and navigates to [ProfileUi] on successful login.
class LoginController extends GetxController {
  /// Controller for the display name text input field.
  /// Used to get and set the display name entered by the user during login.
  final displayNameController = TextEditingController();

  /// Error message shown when display name validation fails.
  /// Null when there are no validation errors.
  String? displayNameError;

  /// Loading state for anonymous login process.
  /// True while anonymous authentication is in progress.
  RxBool isAnonymousLoginLoading = false.obs;

  /// Loading state for Google sign-in process.
  /// True while Google authentication is in progress.
  RxBool isGoogleLoginLoading = false.obs;

  @override
  void onInit() async {
    print("LoginController onInit");
    super.onInit();
  }

  /// Handles anonymous login flow with display name validation.
  ///
  /// This method:
  /// 1. Shows a loading indicator via [isAnonymousLoginLoading]
  /// 2. Validates that display name is not empty
  /// 3. Attempts anonymous sign in with the provided display name
  /// 4. Navigates to [ProfileUi] on success
  /// 5. Shows appropriate error messages on failure
  ///
  /// The display name is required and must not be empty. If empty, sets
  /// [displayNameError] with validation message and returns early.
  ///
  /// On successful login:
  /// - Clears any previous [displayNameError]
  /// - Waits briefly for Firebase auth state to update
  /// - Navigates to profile screen
  ///
  /// On failure:
  /// - Sets [displayNameError] with appropriate error message
  /// - Hides loading indicator
  /// - Updates UI to show error state
  ///
  /// The loading state is always cleaned up in a finally block by setting
  /// [isAnonymousLoginLoading] to false.
  void anonymousLogin() async {
    isAnonymousLoginLoading.value = true;
    if (displayNameController.text.trim().isEmpty) {
      displayNameError = 'Display name is required for Anonymous Login';
      isAnonymousLoginLoading.value = false;
      update();
      return;
    }

    try {
      displayNameError = null;
      final success = await Authentication.instance
          .anonymousSignIn(displayName: displayNameController.text.trim());

      if (success && Constants.instance.userProfile != null) {
        await Future.delayed(const Duration(milliseconds: 100));
        Get.to(() => const ProfileUi());
      } else {
        displayNameError = 'Login failed. Please try again.';
      }
    } catch (e) {
      displayNameError = 'An error occurred: ${e.toString()}';
    } finally {
      isAnonymousLoginLoading.value = false;
      update();
    }
  }

  /// Handles Google sign in flow and navigation.
  ///
  /// This method:
  /// 1. Shows a loading indicator via [isGoogleLoginLoading]
  /// 2. Attempts Google sign in using [Authentication.authenticateUserWithGoogle]
  /// 3. Navigates to [ProfileUi] on success
  /// 4. Logs any errors that occur
  ///
  /// On successful login:
  /// - Waits for Firebase auth state to update
  /// - Navigates to profile screen
  ///
  /// On failure:
  /// - Logs the error and stack trace using [CustomLogPrinter]
  /// - Hides loading indicator
  /// - Updates UI
  ///
  /// The loading state is always cleaned up in a finally block by setting
  /// [isGoogleLoginLoading] to false.
  void googleLogin() async {
    try {
      isGoogleLoginLoading.value = true;
      final success = await Authentication.instance.googleSignIn();

      if (success) {
        Get.to(() => const ProfileUi());
      }
    } catch (e, s) {
      CustomLogPrinter.instance.printDebugLog('Google login error', e, s);
    } finally {
      isGoogleLoginLoading.value = false;
      update();
    }
  }
}
