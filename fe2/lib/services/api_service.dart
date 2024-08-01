import 'package:fe/controllers/notification_controller.dart';
import 'package:fe/models/notification_model.dart';
import 'package:fe/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ApiService {
  final String baseUrl = dotenv.env['URL'] ?? '';

  Future<User> login(String email, List<String> locations,
      Map<String, bool> notificationPreferences, String fcmToken) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'locations': locations,
        'notificationPreferences': notificationPreferences,
        'fcmToken': fcmToken,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Weather> getWeatherData(String lat, String lon) async {
    final response =
        await http.get(Uri.parse('${baseUrl}api/weather?lat=$lat&lon=$lon'));
    print('ini get wesatheaesrasere');
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> simulateExtremeWeatherNotification() async {
    // Simulate a remote message
    final RemoteMessage simulatedMessage = RemoteMessage(
      messageId:
          'simulated_extreme_weather_${DateTime.now().millisecondsSinceEpoch}',
      notification: RemoteNotification(
        title: 'Extreme Weather Alert!',
        body:
            'Heavy rainfall expected in your area. Take necessary precautions.',
      ),
      data: {
        'type': 'extreme_weather',
        'severity': 'high',
        'location': 'Current Location',
      },
    );

    // Display the notification
    await NotificationService.display(simulatedMessage);

    // Add the notification to the NotificationController
    final notificationController = Get.find<NotificationController>();
    notificationController.addNotification(AppNotification(
      id: simulatedMessage.messageId ?? DateTime.now().toString(),
      title: simulatedMessage.notification?.title ?? 'Weather Alert',
      body: simulatedMessage.notification?.body ?? 'New weather update',
      timestamp: DateTime.now(),
      data: simulatedMessage.data,
    ));

    print('Simulated extreme weather notification sent and added to the list.');
  }

  Future<void> simulateExtremeWeather(
      String userId, String lat, String lon, List<String> conditions) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}simulate-extreme-weather'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'lat': lat,
          'lon': lon,
          'conditions': conditions,
        }),
      );

      if (response.statusCode == 200) {
        print('Extreme weather simulation triggered successfully');
      } else {
        throw Exception('Failed to simulate extreme weather');
      }
    } catch (e) {
      print('Error simulating extreme weather: $e');
    }
  }
}
