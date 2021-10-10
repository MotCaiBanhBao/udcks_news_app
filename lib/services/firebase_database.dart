import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udcks_news_app/models/message_model.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:udcks_news_app/services/use_cases/message_services.dart';
import 'package:udcks_news_app/services/use_cases/notification_services.dart';
import 'package:udcks_news_app/services/use_cases/topic_services.dart';
import 'package:udcks_news_app/services/use_cases/user_services.dart';
import 'package:uuid/uuid.dart';

import 'firebase_path.dart';
import 'firestore_services.dart';

class FirestoreDatabase
    with NotificationService, TopicsService, UserService, MessageService {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String? uid;

  final _firestoreService = FirestoreService.instance;

  //Notification
  //
  @override
  Stream<List<NotificationModel>> loadNotificationOfUser(UserModel user) {
    var listNotificationID = user.notificationID;

    return _firestoreService.collectionStream(
      path: FirebasePath.notificationKEY,
      builder: (data, documentId) => NotificationModel.fromMap(data),
      id: listNotificationID,
    );
  }

  @override
  Stream<List<NotificationModel>> notificationsStream() =>
      _firestoreService.collectionStream(
        path: FirebasePath.notificationKEY,
        builder: (data, documentId) => NotificationModel.fromMap(data),
      );

  @override
  Stream<NotificationModel> notificationStream(String notificationId) =>
      _firestoreService.documentStream(
        path: FirebasePath.notification(notificationId),
        builder: (data, documentId) => NotificationModel.fromMap(data),
      );

  Future<void> sendNoti(
      List<TopicModel> topics, String title, String content, String id) async {
    var uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    Map<String, String> header = {
      "Authorization":
          "key=AAAANglE1WA:APA91bFGH05L71y14I1Q8bwOgzPmsclOFd6StLyAKk9ivPmGWUnZreTCs190sZBlcUe7t8cFki2uqDG0NDqZtSi2YrVisflZnBde9E9DdFqtUeWdmUm19h51RRbATnDMU7owaDw0CbSl",
      'Content-Type': 'application/json'
    };

    print(topics.toString() + " " + id);

    //"/topics/test"
    for (var topic in topics) {
      http
          .post(
            uri,
            body: jsonEncode({
              "notification": {"title": title, "text": content, "tag": id},
              "data": {
                "id": id,
                "tag": id.hashCode,
              },
              "android": {
                "tag": id,
              },
              "to": topic.topicID,
            }),
            headers: header,
          )
          .then((value) => print("cogui " + value.statusCode.toString()));
    }
  }

  @override
  Future<void> pushNotification(
      NotificationModel data, List<TopicModel> topics) async {
    data.publisherID = uid!;
    await _firestoreService.set(
      path: FirebasePath.notificaionPath(data.id),
      data: data.toMap(),
    );

    sendNoti(topics, data.title, data.content, data.id);
  }

  //Message
  //
  @override
  Stream<List<MessageModel>> loadMessagesOnNoti(String notificationId) =>
      _firestoreService.collectionStream(
        path: FirebasePath.messageOfNotification(notificationId),
        builder: (data, documentId) => MessageModel.fromMap(data),
      );

  @override
  Future<void> pushMessage(MessageModel message, String notificationId) async =>
      await _firestoreService.set(
        path: FirebasePath.messageOfNotification(notificationId),
        data: message.toMap(),
      );

  //Topics
  //
  @override
  Future<void> changeTopic(List<TopicModel> newTopics) {
    // TODO: implement changeTopic
    throw UnimplementedError();
  }

  @override
  Stream<List<TopicModel>> topicsStream() => _firestoreService.collectionStream(
        path: FirebasePath.topicKEY,
        builder: (data, documentId) => TopicModel.fromMap(data),
      );

  @override
  Stream<List<TopicModel>> topicsOfUserStream(String userID) =>
      _firestoreService.collectionStream(
        path: FirebasePath.topicsOfUser(uid!),
        builder: (data, documentId) => TopicModel.fromMap(data),
      );

  //User
  //

  @override
  Stream<UserModel> getUser(String userID) => _firestoreService.documentStream(
      path: FirebasePath.userPath(userID),
      builder: (data, documentId) {
        return UserModel.fromMap(data);
      });

  Stream<UserModel> currentUser() => _firestoreService.documentStream(
      path: FirebasePath.userPath(uid!),
      builder: (data, documentId) {
        return UserModel.fromMap(data);
      });

  @override
  Future<void> reSubTopics() {
    // TODO: implement reSubTopics
    throw UnimplementedError();
  }

  @override
  Future<void> unSubTopics() {
    // TODO: implement unSubTopics
    throw UnimplementedError();
  }
}
