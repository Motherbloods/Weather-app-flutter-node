import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  Rx<User?> user = Rx<User?>(null);
  @override
  void onInit() {
    super.onInit();
    ever(user, (_) {
      print("User state changed: ${user.value}");
      if (user.value != null) {
        Get.off(() => HomeScreen());
      } else {
        Get.off(() => LoginScreen());
      }
    });
  }

  Future<void> login(String email, List<String> locations,
      Map<String, bool> notificationPreferences, String fcmToken) async {
    try {
      User newUser = await _apiService.login(
          email, locations, notificationPreferences, fcmToken);
      print("Login successful, updating user state"); // New log
      user.value = newUser;
      print("User state updated: ${user.value?.email}"); // New log
      update(); // Explicitly call update
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logout() {
    user.value = null;
    Get.off(() => LoginScreen());
  }
}
