import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/routers.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/styling.dart';
import 'package:udcks_news_app/views/notification/notification_screen.dart';
import 'package:udcks_news_app/views/topic/topic_screen.dart';
import 'package:udcks_news_app/views/transaction/scale_out_transcation.dart';
import 'package:udcks_news_app/views/udck_detail/udck_detail_screen.dart';
import 'package:udcks_news_app/views/user/user_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late List<Map<String, Object>> _listOfScreen;

  @override
  void initState() {
    _listOfScreen = [
      {
        "page": const NotificationScreen(),
        "title": "Notification",
      },
      {
        "page": TopicScreen(),
        "title": "Channel",
      },
      {
        "page": UdckDetailScreen(),
        "title": "UDCK Detail Page",
      },
      {
        "page": ProfilePage(),
        "title": "User",
      }
    ];
    super.initState();
  }

  void _onSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.grey,
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.notificationForm);
        },
        child: const Icon(
          Icons.send,
          color: AppTheme.notWhite,
        ),
      ),
      body: ScaleOutTransition(
          child: _listOfScreen[_currentIndex]["page"] as Widget),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) => _onSelected(index),
      //   unselectedItemColor: Colors.grey,
      //   type: BottomNavigationBarType.shifting,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.home,
      //         ),
      //         label: "Home Page",
      //         backgroundColor: Theme.of(context).primaryColor),
      //     BottomNavigationBarItem(
      //       icon: const Icon(Icons.topic),
      //       label: "Topics",
      //       backgroundColor: Theme.of(context).primaryColor,
      //     ),
      //   ],
      // ),
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: AppTheme.grey,
        circleColor: AppTheme.notWhite,
        barBackgroundColor: AppTheme.darkGrey,
        inactiveIconColor: AppTheme.notWhite,
        textColor: AppTheme.notWhite,
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.turned_in, title: "Search"),
          TabData(iconData: Icons.web, title: "Detail"),
          TabData(iconData: Icons.account_circle, title: "User")
        ],
        onTabChangedListener: (position) => _onSelected(position),
      ),
    );
  }
}
