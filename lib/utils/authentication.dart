import 'package:amekopro/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  final GoogleSignIn _googleSignInClient;
  final FirebaseAuth auth;

  Authentication({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? auth,
  })  : this._googleSignInClient = googleSignIn ?? GoogleSignIn(),
        this.auth = auth ?? FirebaseAuth.instance;

  static Authentication instance = Authentication();

  /// Signs in or links a Google account with Firebase.
  ///
  /// This method handles both new Google sign-ins and linking Google credentials
  /// to existing Firebase accounts:
  /// - For new users, it creates a Firebase account with Google credentials
  /// - For existing users, it links the Google credentials to their account
  ///
  /// After signing in, it will:
  /// 1. Update [Constants.instance.userProfile] with the new user profile
  /// 2. Set the display name from the Google account info
  ///
  /// Returns `true` when sign in is successful.
  ///
  /// See also:
  /// - [anonymousSignIn] for anonymous authentication
  /// - [getUserProfile] to get the current user profile
  Future<bool> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignInClient.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final user = auth.currentUser;

    if (user == null) {
      await auth.signInWithCredential(credential);
    } else {
      await user.linkWithCredential(credential);
    }

    Constants.instance.userProfile = await getUserProfile();
    setDisplayName(
        displayName:
            Constants.instance.userProfile?.providerData.first.displayName);
    return true;
  }

  /// Sign in to Firebase anonymously.
  ///
  /// If the user doesn't have a Firebase profile yet, this will create a new
  /// anonymous user profile.
  ///
  /// After signing in, it will update [Constants.instance.userProfile] with the
  /// new user profile.
  Future<bool> anonymousSignIn({String? displayName}) async {
    await auth.signInAnonymously();
    setDisplayName(displayName: displayName);
    Constants.instance.userProfile = await getUserProfile();
    return true;
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
    return auth.currentUser;
  }

  /// Sets or retrieves the display name for the current user.
  ///
  /// If [displayName] is provided, it will:
  /// 1. Store the name in [Constants.instance.displayName]
  /// 2. Save it to SharedPreferences under "user_display_name" key
  ///
  /// If [displayName] is null, it will:
  /// - Retrieve the previously stored name from SharedPreferences and set it to
  ///   [Constants.instance.displayName]
  ///
  /// This method ensures display name persistence across app restarts by using
  /// SharedPreferences storage.
  Future<void> setDisplayName({String? displayName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (displayName == null) {
      Constants.instance.displayName = prefs.getString("user_display_name");
    } else {
      Constants.instance.displayName = displayName;
      prefs.setString("user_display_name", displayName);
    }
  }

  /// Retrieves the display name for the current user.
  ///
  /// First checks [Constants.instance.displayName] for the cached display name.
  /// If not found there, attempts to retrieve it from SharedPreferences using
  /// the "user_display_name" key.
  ///
  /// Returns:
  /// - The display name if found in either location
  /// - null if no display name has been set
  ///
  /// See also:
  /// - [setDisplayName] for setting/storing the display name
  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Constants.instance.displayName ??
        prefs.getString("user_display_name");
  }
}
