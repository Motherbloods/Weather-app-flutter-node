import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  Rx<User?> user = Rx<User?>(null);

  Future<void> login(String email, List<String> locations,
      Map<String, bool> notificationPreferences, String fcmToken) async {
    try {
      User newUser = await _apiService.login(
          email, locations, notificationPreferences, fcmToken);
      user.value = newUser;
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
