import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    print('baseUrl ${response.body}');

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Weather> getWeatherData(String lat, String lon) async {
    final response =
        await http.get(Uri.parse('${baseUrl}api/weather?lat=$lat&lon=$lon'));
    print(response.body);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
