//from flutter simulation

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/notification_controller.dart';
// import '../screen/weather_details_screen.dart';

// class NotificationScreen extends StatelessWidget {
//   final NotificationController notificationController =
//       Get.find<NotificationController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: Obx(() => ListView.builder(
//             itemCount: notificationController.notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notificationController.notifications[index];
//               return ListTile(
//                 title: Text(notification.title),
//                 subtitle: Text(notification.body),
//                 trailing: Text(
//                   '${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year}',
//                 ),
//                 onTap: () {
//                   notificationController.markAsRead(notification.id);
//                   if (notification.data['lat'] != null &&
//                       notification.data['lon'] != null) {
//                     Get.to(() => WeatherDetailsScreen(
//                           lat: notification.data['lat'],
//                           lon: notification.data['lon'],
//                         ));
//                   }
//                 },
//                 tileColor: notification.isRead ? null : Colors.blue[50],
//               );
//             },
//           )),
//     );
//   }
// }

//from backend simulation
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../screen/weather_details_screen.dart';

class NotificationScreen extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.body),
                trailing: Text(
                  '${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year}',
                ),
                onTap: () {
                  controller.markAsRead(notification.id);
                  if (notification.data['lat'] != null &&
                      notification.data['lon'] != null) {
                    Get.to(() => WeatherDetailsScreen(
                          lat: notification.data['lat'],
                          lon: notification.data['lon'],
                        ));
                  }
                },
                tileColor: notification.isRead ? null : Colors.blue[50],
              );
            },
          )),
    );
  }
}
