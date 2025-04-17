import 'package:firebase_messaging/firebase_messaging.dart' show AuthorizationStatus, FirebaseMessaging, NotificationSettings;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:jellycollapse/LoadLoader.dart';


import 'main.dart' show WebViewScreen;

class getFcmToken extends StatefulWidget {
  const getFcmToken({super.key});

  @override
  State<getFcmToken> createState() => _getFcmTokenState();
}

class _getFcmTokenState extends State<getFcmToken> {
  String? fcmToken;
  bool permissionGranted = false;



  @override
  void initState() {
    super.initState();

    // Start listening for FCM token updates
    FCMTokenListener.listenForTokenUpdates((token) {
      setState(() {
        fcmToken = token;

      });
      // You can also send the token to your backend or use it in your app
      print('FCM Token updated in Flutter: $token');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(token)),
      );
    });
  }

  /// Request notification permissions and fetch the FCM token
  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Permission granted
      setState(() {
        permissionGranted = true;
      });

      // Fetch the FCM token
      String? token = await messaging.getToken();
      setState(() {
        fcmToken = token;
      });
      print("FCM Token load: $token");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(token)),
      );
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Provisional permission granted
      setState(() {
        permissionGranted = true;

      });

      // Fetch the FCM token
      String? token = await messaging.getToken();
      setState(() {
        fcmToken = token;
      });
      print("FCM Token (provisional): $token");
    } else {
      // Permission denied
      setState(() {
        permissionGranted = false;
      });
      print('User declined or has not accepted notification permissions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class FCMTokenListener {
  static const MethodChannel _channel = MethodChannel('com.example.fcm/token');

  /// Listener for FCM token updates
  static void listenForTokenUpdates(Function(String token) onTokenUpdated) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'setToken') {
        final String token = call.arguments as String;
        onTokenUpdated(token);
        print('FCM Token received in Flutter: $token');
      }
    });
  }
}
