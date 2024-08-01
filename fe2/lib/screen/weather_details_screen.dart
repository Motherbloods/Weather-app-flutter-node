import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final String lat;
  final String lon;
  final ApiService _apiService = ApiService();

  WeatherDetailsScreen({required this.lat, required this.lon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Details')),
      body: FutureBuilder<Weather>(
        future: _apiService.getWeatherData(lat, lon),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          Weather weather = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Latitude: $lat'),
                Text('Longitude: $lon'),
                Text('Temperature: ${weather.temperature}°C'),
                Text('Humidity: ${weather.humidity}%'),
                Text('Description: ${weather.description}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
