import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/utils/custom_log_printer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A utility class for handling Firebase Cloud Messaging (FCM) notifications.
///
/// This class provides functionality to:
/// - Initialize Firebase Messaging
/// - Set up notification permissions
/// - Create notification channels
/// - Handle foreground notifications
/// - Display local notifications
///
/// The class follows a singleton pattern with a static [instance] for global access.
///
/// Example usage:
/// ```dart
/// void main() async {
///   // Initialize notifications during app startup
///   await Notifications.instance.initNotifications();
/// }
/// ```
///
/// Key features:
/// - Manages FCM token storage in [Constants.instance.firebaseMessagingToken]
/// - Creates high importance notification channel for Android
/// - Handles both FCM remote messages and local notifications
/// - Provides error logging through [CustomLogPrinter]
class Notifications {
  static Notifications instance = Notifications();

  /// Initialize Firebase Messaging and the Flutter Local Notifications plugin.
  ///
  /// This function should be called in the `main` method of your app.
  /// It will:
  /// - Initialize Firebase Messaging
  /// - Request permissions for the app to show notifications
  /// - Get the FCM token for the app
  /// - Create a notification channel for Android
  /// - Initialize the Flutter Local Notifications plugin
  /// - Set up foreground notification handling
  ///
  /// If an error occurs during the initialization process, it will be logged
  /// to the debug console.
  Future<void> initNotifications() async {
    /// Initialize Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// Request permissions
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      sound: true,
    );

    /// Get FCM token
    Constants.instance.firebaseMessagingToken = await messaging.getToken();

    /// Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    /// Initialize flutter local notifications plugin
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    /// Initialize settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Combine platform specific settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    /// Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    // Create the notification channel on Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Foreground notification handling
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) => notificationListener(
        message: message,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        channel: channel,
      ),
    );
  }

  /// Handles incoming FCM messages and displays local notifications.
  ///
  /// Takes three required parameters:
  /// - [message] - The FCM remote message to handle
  /// - [flutterLocalNotificationsPlugin] - Plugin instance for showing notifications
  /// - [channel] - The Android notification channel to use
  ///
  /// If the message contains notification data:
  /// - Prints message data if present
  /// - Otherwise displays a local notification with the message content
  ///
  /// Any errors during notification handling are logged via [CustomLogPrinter].
  void notificationListener(
      {required RemoteMessage message,
      required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      required AndroidNotificationChannel channel}) async {
    try {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        if (message.data.isNotEmpty) {
          print(message.data);
        } else {
          await flutterLocalNotificationsPlugin
              .show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channelDescription: channel.description,
                      icon: '@mipmap/ic_launcher', // Specify icon
                      importance: Importance.max,
                      priority: Priority.high,
                      enableLights: true,
                      enableVibration: true,
                      playSound: true,
                    ),
                  ),
                  payload: message.data.toString())
              .then((_) {})
              .catchError((error) {});
        }
      }
    } catch (e, s) {
      CustomLogPrinter.instance.printDebugLog("NOTIFICATION ERROR", e, s);
    }
  }
}
