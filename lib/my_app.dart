import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/routers.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/views/auth/sign_in_screen.dart';
import 'package:udcks_news_app/views/home/home.dart';
import 'auth_widget_builder.dart';
import 'main.dart';

class MyApp extends StatefulWidget {
  final FirestoreDatabase Function(BuildContext context, String uid)
  databaseBuilder;
  const MyApp({Key? key, required this.databaseBuilder}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return AuthWidgetBuilder(
        key: Key("AuthWidget"),
        builder: (BuildContext context, AsyncSnapshot<UserModel> userSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Sigin",
            routes: Routes.routes,
            home: Consumer<AuthProvider>(
              builder: (_, authProviderRef, __) {
                if (userSnapshot.connectionState == ConnectionState.active) {
                  return userSnapshot.hasData &&
                      userSnapshot.data?.uid != "null"
                      ? HomeScreen()
                      : SignInScreen();
                }

                return const Material(
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          );
        },
        databaseBuilder: widget.databaseBuilder);
  }
}
