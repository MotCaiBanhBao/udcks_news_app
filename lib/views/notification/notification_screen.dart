import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/views/notification/list_item.dart';
import 'package:udcks_news_app/views/transaction/scale_out_transcation.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context);
    return Scaffold(
      appBar: null,
      body: StreamBuilder(
        stream: firestoreDatabase.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              (snapshot.data as UserModel).notificationIDs.isNotEmpty) {
            return StreamBuilder(
                stream: firestoreDatabase
                    .loadNotificationOfUser(snapshot.data as UserModel),
                builder: (context, listNotiStream) {
                  if (listNotiStream.hasData) {
                    List<NotificationModel> notifications =
                        listNotiStream.data as List<NotificationModel>;
                    if (notifications.isNotEmpty) {
                      return ScaleOutTransition(
                          child: Material(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListItem(item: notifications[index]);
                            },
                            itemCount: notifications.length,
                          ),
                        ),
                      ));
                    } else {
                      return const Center(
                          child: Text("Tạm thời chưa có thông tin"));
                    }
                  } else {
                    return const Center(
                        child: Text("Tạm thời chưa có thông tin"));
                  }
                });
          }

          return const Center(child: Text("Tạm thời chưa có thông tin"));
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: () {
      //   //   firestoreDatabase.pushNotification(
      //   //     NotificationModel(
      //   //         containsPictures: true,
      //   //         hasAttachment: true,
      //   //         content: "Test content",
      //   //         url: "google.com",
      //   //         publisherID:
      //   //             "https://scontent-xsp1-1.xx.fbcdn.net/v/t1.6435-9/194404813_1476574819368058_642787592080890949_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=UjaXLx4UZdgAX_Bzpev&_nc_ht=scontent-xsp1-1.xx&oh=c7a971bc5b9070da20cfe91a34d17e10&oe=617D17DC",
      //   //         target: "a1"),
      //   //     [TopicModel(topicID: "/topics/k12tt", topicName: "K12TT")],
      //   //   );
      //   // },
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
    );
  }
}
