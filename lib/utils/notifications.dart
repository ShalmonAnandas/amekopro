import 'dart:convert';

import 'package:amekopro/utils/constants.dart';
import 'package:amekopro/utils/custom_log_printer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
