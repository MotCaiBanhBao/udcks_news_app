import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/views/notification/notification_screen.dart';
import 'package:udcks_news_app/views/topic/topic_screen.dart';

import 'models/user_model.dart';

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
        "page": const TopicScreen(),
        "title": "Channel",
      },
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_listOfScreen[_currentIndex]["title"].toString()),
        actions: [
          StreamBuilder(
              stream: authProvider.user,
              builder: (BuildContext context,
                  AsyncSnapshot<UserModel> userSnapshot) {
                if (userSnapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        userSnapshot.data!.photoUrl.toString(),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              })
        ],
      ),
      body: _listOfScreen[_currentIndex]["page"] as Widget,
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
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.search, title: "Search"),
          TabData(iconData: Icons.shopping_cart, title: "Basket")
        ],
        onTabChangedListener: (position) => _onSelected(position),
      ),
    );
  }
}
