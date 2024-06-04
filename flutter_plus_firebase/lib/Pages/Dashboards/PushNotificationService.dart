import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "onMessage: ${message.notification?.title ?? ''} ${message.notification?.body ?? ''}");
    });
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
