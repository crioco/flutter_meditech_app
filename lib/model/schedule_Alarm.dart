import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'alarm_info.dart';


void scheduleAlarm(DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'your channel description',
      icon: 'alarm_icon',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      additionalFlags: Int32List.fromList(<int>[4]),
      sound: const RawResourceAndroidNotificationSound('alarm_sound'),
      largeIcon: const DrawableResourceAndroidBitmap('alarm_icon'),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
        sound: 'alarm_sound.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);


  await flutterLocalNotificationsPlugin.schedule(0,alarmInfo.title, alarmInfo.alarmLabel, 
      scheduledNotificationDateTime, platformChannelSpecifics);
}