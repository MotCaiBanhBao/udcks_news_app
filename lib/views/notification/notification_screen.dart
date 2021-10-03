import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/services/firebase_database.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context);
    return Scaffold(
      appBar: null,
      body: StreamBuilder(
        stream: firestoreDatabase.notificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NotificationModel> notifications =
            snapshot.data as List<NotificationModel>;
            if (notifications.isNotEmpty) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notifications[index].getTitle),
                    subtitle: Text(notifications[index].content),
                    leading: Image.network(notifications[index].publisher),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0.5);
                },
                itemCount: notifications.length,
              );
            }
          }
          return const Center(child: Text("Tạm thời chưa có thông tin"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firestoreDatabase.pushNotification(
            NotificationModel(content: "Test content", url: "google.com", publisher: "https://scontent-xsp1-1.xx.fbcdn.net/v/t1.6435-9/194404813_1476574819368058_642787592080890949_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=UjaXLx4UZdgAX_Bzpev&_nc_ht=scontent-xsp1-1.xx&oh=c7a971bc5b9070da20cfe91a34d17e10&oe=617D17DC", target: "a1"),
            [TopicModel(topicID: "/topics/k12tt", topicName: "K12TT")],
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
