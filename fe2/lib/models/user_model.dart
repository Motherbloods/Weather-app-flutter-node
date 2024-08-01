class User {
  final String id;
  final String email;
  final List<String> locations; // This will store "lat,lon" strings
  final Map<String, bool> notificationPreferences;
  final String fcmToken;

  User(
      {required this.id,
      required this.email,
      required this.locations,
      required this.notificationPreferences,
      required this.fcmToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      email: json['email'],
      locations: List<String>.from(json['locations']),
      notificationPreferences: json.containsKey('notificationPreferences')
          ? Map<String, bool>.from(json['notificationPreferences'])
          : {},
      fcmToken: json['fcmToken'],
    );
  }
}
