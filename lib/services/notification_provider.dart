// Dart
import 'dart:async';
// Flutter Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider {
  // Notifications
  final _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationProvider() {
    notificationInitialization();
  }

  void notificationInitialization() async {
    // Local Notifications
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = IOSInitializationSettings();

    // #2
    const initSettings = InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    bool? success = await _localNotifications.initialize(initSettings);
  }

  NotificationDetails getGroupNotifier(
    String groupKey,
    String groupChannelId,
    String groupChannelName,
    String groupChannelDescription,
    int numMessages,
    String summaryText,
  ) {
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
      [],
      contentTitle: '$numMessages mensagens',
      summaryText: summaryText,
    );

    return NotificationDetails(
      android: AndroidNotificationDetails(
        groupChannelId,
        groupChannelName,
        channelDescription: groupChannelDescription,
        groupKey: groupKey,
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: false,
        setAsGroupSummary: true,
        ticker: 'ticker',
        styleInformation: inboxStyleInformation,
      ),
    );
  }

  NotificationDetails getSimpleNotifier(
    String groupKey,
    String groupChannelId,
    String groupChannelName,
    String groupChannelDescription,
  ) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      channelDescription: groupChannelDescription,
      groupKey: groupKey,
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    ));
  }

  void showGroupNotification(int groupId, String group, String title, String body) async {
    String groupKey = 'br.com.wikidados.wikimobile.${group.toUpperCase()}';
    String groupChannelId = 'wikimobile.${group.toLowerCase()}';
    String groupChannelName = 'Wikimobile $group';
    String groupChannelDescription = 'Notificação para $group';

    // NotificationDetails simpleMessage =
    //     getSimpleNotifier(groupKey, groupChannelId, groupChannelName, groupChannelDescription);

    NotificationDetails groupMessage = getGroupNotifier(
      groupKey,
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      5,
      group,
    );

    await _localNotifications.show(
      groupId,
      title,
      body,
      groupMessage,
    );
  }

  void showNotification(int id, String title, String body) {
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'wikidados',
      'Notifications',
      channelDescription: 'Este canal é para notificações!',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );

    _localNotifications.show(id, title, body, NotificationDetails(android: androidDetails));
  }
}

final notificationProvider = Provider<NotificationProvider>(
  (ref) => NotificationProvider(),
);
