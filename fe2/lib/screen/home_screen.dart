import 'package:fe/screen/notifikasi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/weather_card.dart';
import '../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => Get.to(() => NotificationScreen()),
          ),
          IconButton(
            icon: Icon(Icons.warning),
            onPressed: () => _simulateExtremeWeather(),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (authController.user.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: authController.user.value!.locations.length,
          itemBuilder: (context, index) {
            print(authController.user.value!.locations.length);
            return WeatherCard(
                location: authController.user.value!.locations[index]);
          },
        );
      }),
    );
  }

  void _simulateExtremeWeather() async {
    final user = authController.user.value;
    if (user != null && user.locations.isNotEmpty) {
      final location = user.locations.first.split(',');
      await apiService.simulateExtremeWeather(
        user.id,
        location[0],
        location[1],
        ['extreme heat', 'heavy rain'],
      );
    }
  }
}
