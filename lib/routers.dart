import 'package:flutter/material.dart';
import 'package:udcks_news_app/views/auth/sign_in_screen.dart';
import 'package:udcks_news_app/views/notification/notification_screen.dart';
import 'package:udcks_news_app/views/splash/splash_screen.dart';

import 'main_page.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainPage = '/home';
  static const String topic = '/topic';
  static const String notification = '/notification';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    mainPage: (BuildContext context) => MainPage(),
    notification: (BuildContext context) => NotificationScreen(),
  };
}
