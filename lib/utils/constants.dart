import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  /// Singleton instance of the Constants class.
  /// Used to access constants and shared state throughout the app.
  static Constants instance = Constants();

  /// Development flag for enabling special features.
  /// When true, enables development-specific functionality.
  bool prajaktaMode = true;

  /// Firebase Cloud Messaging token for push notifications.
  /// Null until FCM token is retrieved after app initialization.
  String? firebaseMessagingToken;

  /// Currently authenticated Firebase user profile.
  /// Contains user data like UID, email, provider data.
  /// Null when user is not authenticated.
  User? userProfile;

  /// Display name of the currently authenticated user.
  /// Set during sign in and used throughout the app for displaying user name.
  /// Null when user is not authenticated.
  String? displayName;
}
