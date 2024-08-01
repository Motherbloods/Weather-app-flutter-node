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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final notificationController = Get.find<NotificationController>();
  notificationController.addNotification(AppNotification(
    id: message.messageId ?? DateTime.now().toString(),
    title: message.notification?.title ?? 'Weather Alert',
    body: message.notification?.body ?? 'New weather update',
    timestamp: DateTime.now(),
    data: message.data,
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  // Initialize Firebase only once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the background message handler before calling other Firebase services
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.initialize();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      NotificationService.display(message);
    }
  });

  runApp(MyApp());
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
