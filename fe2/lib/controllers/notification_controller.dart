import 'package:fe/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationController extends GetxController {
  RxList<AppNotification> notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void addNotification(AppNotification notification) {
    notifications.insert(0, notification);
    saveNotifications();
    update();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final updatedNotification = AppNotification(
        id: notifications[index].id,
        title: notifications[index].title,
        body: notifications[index].body,
        timestamp: notifications[index].timestamp,
        isRead: true,
        data: notifications[index].data,
      );
      notifications[index] = updatedNotification;
      saveNotifications();
    }
  }

  Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String notificationsJson =
        jsonEncode(notifications.map((n) => n.toJson()).toList());
    await prefs.setString('notifications', notificationsJson);
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationsJson = prefs.getString('notifications');
    if (notificationsJson != null) {
      final List<dynamic> decodedNotifications = jsonDecode(notificationsJson);
      notifications.value =
          decodedNotifications.map((n) => AppNotification.fromJson(n)).toList();
    }
  }
}
