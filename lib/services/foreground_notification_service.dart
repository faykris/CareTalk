import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ForegroundNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings("app_icon");

  ForegroundNotificationService() {
    final InitializationSettings _initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);

    print("Foreground notification constructor");
    
    initAll(_initializationSettings);
  }

  initAll(InitializationSettings initializationSettings) async {
    final response = await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: (payload) async {
      print("on select notification payload : $payload");
    });

    print("local notification initialization status : $response");
  }

  Future<void> showNotification(
      {required String title, required String body}) async {
    try {
      AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel ID',
          title, // 'channel name'
          body, // 'channel description'
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
            // "CHANNEL ID",
            // "Spark chat",
            //   channelDescription: " made by the spark chat team",
            //   importance: Importance.max, color: Colors.
        );

      NotificationDetails generalNotificationDetails =
           NotificationDetails(android: androidDetails);
      await _flutterLocalNotificationsPlugin
          .show(0, title, body, generalNotificationDetails, payload: title);
    } catch (e) {
      print("error occured in sending foreground notification ${e.toString}");
    }
  }
}
