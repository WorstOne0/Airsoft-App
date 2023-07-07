// Dart
import 'dart:io';
// Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// Services
import '/services/notification_provider.dart';

// Not being used for now - If kept like this change StateNotifier => Provider
@immutable
class FirebaseMessagingState {
  const FirebaseMessagingState();
}

class FirebaseMessagingController extends StateNotifier<FirebaseMessagingState> {
  FirebaseMessagingController({required this.ref}) : super(const FirebaseMessagingState());

  Ref ref;

  void firebaseInitialization() {
    requestPermisssion();

    FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    getDeviceToken();

    //
    FirebaseMessaging.onMessage.listen(handleMessaging);
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
  }

  // Handles the messaging coming from firebase
  Future<void> handleMessaging(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    // Show notification, if any.
    RemoteNotification? notification = message.notification;

    if (Platform.isAndroid) {
      AndroidNotification? android = notification?.android;

      if (notification != null && android != null) {
        ref
            .read(notificationProvider)
            .showNotification(android.hashCode, notification.title ?? "", notification.body ?? "");
      }
    }

    if (Platform.isIOS) {}

    // Handles the data
  }

  Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    return token;
  }

  // Ios
  void requestPermisssion() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void subscribeToTopic(String topic) {
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  void unsubscribeFromTopic(String topic) {
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}

// Firebase Messaging Provider
final firebaseMessagingProvider =
    StateNotifierProvider<FirebaseMessagingController, FirebaseMessagingState>((ref) {
  //
  return FirebaseMessagingController(ref: ref);
});
