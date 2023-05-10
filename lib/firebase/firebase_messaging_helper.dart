import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';

class FirebaseMessgingHelper {
  late final FirebaseMessaging messaging;

  void settingNotification() async {
    await messaging.requestPermission(alert: true, sound: true, badge: true);
  }

  void connectNotisication() async {
    messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
        alert: true, sound: true, badge: true);
    settingNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("Gelen Bildirom : ${event.notification!.title}");
      Grock.snackBar(
          title: '${event.notification!.title}',
          description: '${event.notification!.body}',
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage("assets/progress.png"),
            backgroundColor: Colors.transparent,
          ),
          opacity: 0.5,
          position: SnackbarPosition.top);
    });
    messaging
        .getToken()
        .then((value) => log("Token: $value", name: "FCM Token"));
  }

  static Future<void> firebaseBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }
}
