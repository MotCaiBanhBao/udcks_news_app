import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:udcks_news_app/services/firebase_path.dart';
import 'package:udcks_news_app/services/firestore_services.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_important_channel",
    "High Important Notifications",
    "This channel is use for important notifications",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandle(RemoteMessage message) async {
  
  await flutterLocalNotificationsPlugin
  .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);

  await Firebase.initializeApp();
  
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestore = FirestoreService.instance;
  firestore.set(
      path: FirebasePath.userNotificationPath(firebaseUser!.uid),
      data: {
        "messagesID": FieldValue.arrayUnion([message.data['id']])
      },
      mergeBool: true);
  print("CO NHAN NE? 3" + message.data['id'].toString());
}

class FCMServices {
  FCMServices._();
  static Future<void> setUp() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      var firebaseUser = FirebaseAuth.instance.currentUser;
      final firestore = FirestoreService.instance;
      firestore.set(
          path: FirebasePath.userNotificationPath(firebaseUser!.uid),
          data: {
            "messagesID": FieldValue.arrayUnion([message.data['id']])
          },
          mergeBool: true);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            int.parse(message.data['tag'].toString()),
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    tag: message.data['tag'].toString(),
                    icon: '@mipmap/ic_launcher')));
      }
      print("CO NHAN NE?1 " + message.data['id'].toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("CO NHAN NE?2 " + event.data['id'].toString());
    });
  }

  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandle);

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken();
    
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
