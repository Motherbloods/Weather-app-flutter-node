import 'package:fe/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screen/login_screen.dart';
import './screen/home_screen.dart';
import './services/notification_service.dart';
import './controllers/auth_controller.dart';
import './controllers/notification_controller.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final notificationController =
      Get.put(NotificationController()); // Ensure controller is initialized

  AppNotification newNotification = AppNotification(
    id: message.messageId ?? DateTime.now().toString(),
    title: message.notification?.title ?? 'Weather Alert',
    body: message.notification?.body ?? 'New weather update',
    timestamp: DateTime.now(),
    data: message.data,
  );

  notificationController.addNotification(newNotification);
  print('Added new notification: ${newNotification.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  // Initialize Firebase only once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await requestNotificationPermissions();
  // Set the background message handler before calling other Firebase services
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();

  final notificationController = Get.put(NotificationController());

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      NotificationService.display(message);

      // Add notification to NotificationController
      AppNotification newNotification = AppNotification(
        id: message.messageId ?? DateTime.now().toString(),
        title: message.notification?.title ?? 'Weather Alert',
        body: message.notification?.body ?? 'New weather update',
        timestamp: DateTime.now(),
        data: message.data,
      );
      notificationController.addNotification(newNotification);
      print('Added new notification in foreground: ${newNotification.title}');
    }
  });

  runApp(MyApp());
}

Future<void> requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
    // Tampilkan dialog yang menjelaskan pentingnya izin
    Get.dialog(
      AlertDialog(
        title: Text('Izin Notifikasi Diperlukan'),
        content: Text(
            'Notifikasi diperlukan untuk memberitahu Anda tentang perubahan cuaca penting. Tanpa izin ini, Anda mungkin melewatkan informasi penting.'),
        actions: [
          TextButton(
            child: Text('Buka Pengaturan'),
            onPressed: () {
              // Buka pengaturan aplikasi
              openAppSettings();
            },
          ),
          TextButton(
            child: Text('Nanti'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Obx(() {
        if (authController.user.value != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      }),
    );
  }
}
