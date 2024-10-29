import 'package:amekopro/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Authentication instance = Authentication();

  /// Trigger the authentication flow.
  ///
  /// If the user is not signed in with Google yet, this will open the Google
  /// sign-in flow. If the user is signed in with Google already, this will
  /// return their account information.
  ///
  /// After the authentication flow is triggered, it will obtain the auth
  /// details from the request and create a new credential.
  ///
  /// Finally, it will link the Google account with the current user using
  /// [FirebaseAuth.linkWithCredential] and update
  /// [Constants.instance.userProfile] with the new user profile.
  Future<void> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

    Constants.instance.userProfile = await getUserProfile();
  }

  /// Sign in to Firebase anonymously.
  ///
  /// If the user doesn't have a Firebase profile yet, this will create a new
  /// anonymous user profile.
  ///
  /// After signing in, it will update [Constants.instance.userProfile] with the
  /// new user profile.
  Future<void> anonymousSignIn() async {
    await FirebaseAuth.instance.signInAnonymously();

    Constants.instance.userProfile = await getUserProfile();
  }

  /// Gets the current user profile from Firebase.
  ///
  /// If the user is signed in, this will return the user profile.
  /// Otherwise, it will return `null`.
  ///
  /// This is used to initialize [Constants.instance.userProfile] which is
  /// used to store the current user profile.
  ///
  /// See also:
  /// - [Constants.instance.userProfile]
  /// - [anonymousSignIn]
  Future<User?> getUserProfile() async {
    return FirebaseAuth.instance.currentUser;
  }

  /// Initializes the user profile.
  ///
  /// If the user is not signed in, it will sign in anonymously and update
  /// [Constants.instance.userProfile] with the new user profile.
  ///
  /// This is used to initialize [Constants.instance.userProfile] when the app
  /// starts.
  ///
  /// See also:
  /// - [Constants.instance.userProfile]
  /// - [anonymousSignIn]
  Future<void> initUserProfile() async {
    Constants.instance.userProfile = await getUserProfile();
    if (Constants.instance.userProfile == null) {
      anonymousSignIn();
    }
  }
}
