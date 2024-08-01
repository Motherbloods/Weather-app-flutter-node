// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import '../controllers/auth_controller.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class LoginScreen extends StatelessWidget {
//   final AuthController authController = Get.find<AuthController>();
//   final TextEditingController emailController = TextEditingController();

//   Future<String?> _getFcmToken() async {
//     return await FirebaseMessaging.instance.getToken();
//   }

//   Future<String> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     return "${position.latitude},${position.longitude}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 String? fcmToken = await _getFcmToken();
//                 String location = await _getCurrentLocation();
//                 authController.login(
//                   emailController.text,
//                   [location],
//                   {'daily': true, 'extreme': true},
//                   fcmToken ?? '',
//                 );
//               },
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import '../controllers/auth_controller.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class LoginScreen extends StatelessWidget {
//   final AuthController authController = Get.find<AuthController>();
//   final TextEditingController emailController = TextEditingController();

//   Future<String?> _getFcmToken() async {
//     return await FirebaseMessaging.instance.getToken();
//   }

//   Future<String?> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled, don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       Get.snackbar('Error', 'Location services are disabled.');
//       return null;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         Get.snackbar('Error', 'Location permissions are denied');
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       Get.snackbar('Error',
//           'Location permissions are permanently denied, we cannot request permissions.');
//       return null;
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     try {
//       Position position = await Geolocator.getCurrentPosition();
//       return "${position.latitude},${position.longitude}";
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get location: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 String? fcmToken = await _getFcmToken();
//                 String? location = await _getCurrentLocation();
//                 if (location != null) {
//                   authController.login(
//                     emailController.text,
//                     [location],
//                     {'daily': true, 'extreme': true},
//                     fcmToken ?? '',
//                   );
//                 } else {
//                   Get.snackbar('Error',
//                       'Unable to get location. Please check your settings and try again.');
//                 }
//               },
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();

  Future<String?> _getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<String?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Get.snackbar('Error', 'Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Get.snackbar('Error', 'Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Get.snackbar('Error',
          'Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition();
      return "${position.latitude},${position.longitude}";
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? fcmToken = await _getFcmToken();
                String? location = await _getCurrentLocation();

                if (location != null) {
                  print("Calling login method");
                  authController.login(
                    emailController.text,
                    [location],
                    {'daily': true, 'extreme': true},
                    fcmToken ?? '',
                  );
                  print("Login method completed");
                } else {
                  Get.snackbar('Error',
                      'Unable to get location. Please check your settings and try again.');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
