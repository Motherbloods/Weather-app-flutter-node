import '../screen/weather_details_screen.dart';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherCard extends StatelessWidget {
  final String location; // This is now a "lat,lon" string
  final ApiService _apiService = ApiService();

  WeatherCard({required this.location});

  @override
  Widget build(BuildContext context) {
    List<String> latLon = location.split(',');
    String lat = latLon[0];
    String lon = latLon[1];
    print('ini berapa');
    return Card(
      child: FutureBuilder<Weather>(
        future: _apiService.getWeatherData(lat, lon),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(title: Text('Loading...'));
          }
          if (snapshot.hasError) {
            return ListTile(title: Text('Error: ${snapshot.error}'));
          }
          Weather weather = snapshot.data!;
          return ListTile(
            title: Text('Lat: $lat, Lon: $lon'),
            subtitle: Text('${weather.temperature}°C, ${weather.description}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WeatherDetailsScreen(lat: lat, lon: lon),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
