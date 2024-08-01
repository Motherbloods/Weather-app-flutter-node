import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle notification tap when the app is in the background
  print('Notification tapped in background: ${notificationResponse.payload}');
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Minta izin notifikasi
    await requestPermissions();

    // Initialize local notifications plugin
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          // Handle notification tap (e.g., navigate to a specific screen)
          print('Notification payload: $payload');
        }
      },
    );

    // Set the background message handler
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Configure Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap when app is in foreground
      if (message.notification != null) {
        print('Notification opened app with payload: ${message.data}');
      }
    });
  }

  static Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  // static Future<void> display(RemoteMessage message) async {
  //   try {
  //     final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //     final NotificationDetails notificationDetails = NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'weatherapp',
  //         'weatherapp channel',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         playSound: true,
  //       ),
  //     );

  //     await _notificationsPlugin.show(
  //       id,
  //       message.notification?.title,
  //       message.notification?.body,
  //       notificationDetails,
  //       payload: message.data["route"],
  //     );
  //   } catch (e) {
  //     print('Error displaying notification: $e');
  //   }
  // }

  static Future<void> display(RemoteMessage message) async {
    try {
      // Periksa status izin terlebih dahulu
      NotificationSettings settings =
          await _firebaseMessaging.getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('Notifications are not authorized. Requesting permission...');
        await requestPermissions();
        // Periksa lagi setelah meminta izin
        settings = await _firebaseMessaging.getNotificationSettings();
        if (settings.authorizationStatus != AuthorizationStatus.authorized) {
          print('User declined notification permission');
          return; // Jangan tampilkan notifikasi jika izin ditolak
        }
      }

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'weatherapp',
          'weatherapp channel',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(), // Tambahkan ini untuk iOS
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } catch (e) {
      print('Error displaying notification: $e');
    }
  }
}
