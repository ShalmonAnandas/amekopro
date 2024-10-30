import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  static Constants instance = Constants();

  /// Prajakta Mode
  bool prajaktaMode = true;

  /// User profile data
  String? firebaseMessagingToken;
  User? userProfile;
  String? displayName;
}
