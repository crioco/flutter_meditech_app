import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';


void scheduleAlarm() async {
  

    var scheduledNotificationDateTime =
     DateTime.now().add(Duration(seconds: 10));
    
   const AndroidNotificationDetails  androidPlatformChannelSpecifics =  AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'alarm_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('alarm_icon'),
      ticker: 'ticker'
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      0,
     'Medicine A', 
     'Time to take your pills',
        scheduledNotificationDateTime, 
        platformChannelSpecifics);
        
/***await flutterLocalNotificationsPlugin.show(
    0, 'plain title', 'plain body', platformChannelSpecifics,
    payload: 'item x');*/
        
  }