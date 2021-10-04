import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/routers.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
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
    final databaseProvider =
        Provider.of<FirestoreDatabase>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(_listOfScreen[_currentIndex]["title"].toString()),
        actions: [
          StreamBuilder(
              stream: authProvider.user,
              builder: (BuildContext context,
                  AsyncSnapshot<UserModel> userSnapshot) {
                if (userSnapshot.hasData) {
                  return StreamBuilder(
                      stream: databaseProvider.getUser(userSnapshot.data!.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<UserModel> userFirestoreSnapshot) {
                        if (userFirestoreSnapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                userFirestoreSnapshot.data!.photoUrl.toString(),
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
                      });
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {Navigator.of(context).pushNamed(Routes.notificationForm)},
        child: Icon(Icons.import_contacts),
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
