class Weather {
  final String latitude;
  final String longitude;
  final String temperature;
  final int humidity;
  final String description;
  final DateTime timestamp;

  Weather({
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.timestamp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      latitude: json['latitude'],
      longitude: json['longitude'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
