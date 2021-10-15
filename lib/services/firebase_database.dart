import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:udcks_news_app/models/message_model.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:udcks_news_app/services/use_cases/message_services.dart';
import 'package:udcks_news_app/services/use_cases/notification_services.dart';
import 'package:udcks_news_app/services/use_cases/topic_services.dart';
import 'package:udcks_news_app/services/use_cases/user_services.dart';
import 'package:udcks_news_app/models/utils/utils.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/utils/utils.dart';
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
    var listNotificationID = user.notificationIDs;

    return _firestoreService.collectionStream(
      path: FirebasePath.notificationKEY,
      builder: (data, documentId) => NotificationModel.fromMap(data),
      id: listNotificationID,
      sort: (a, b) {
        return b.timeStamp.compareTo(a.timeStamp);
      },
    );
  }

  @override
  Stream<List<NotificationModel>> notificationsStream() =>
      _firestoreService.collectionStream(
        path: FirebasePath.notificationKEY,
        builder: (data, documentId) => NotificationModel.fromMap(data),
      );

  @override
  Stream<NotificationModel> notificationStream(String notificationId) {
    return _firestoreService.documentStream(
      path: FirebasePath.notificaionPath(notificationId),
      builder: (data, documentId) => NotificationModel.fromMap(data),
    );
  }

  Future<void> sendNoti(
      List<TopicModel> topics, String title, String content, String id) async {
    var uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    Map<String, String> header = {
      "Authorization":
          "key=AAAANglE1WA:APA91bFGH05L71y14I1Q8bwOgzPmsclOFd6StLyAKk9ivPmGWUnZreTCs190sZBlcUe7t8cFki2uqDG0NDqZtSi2YrVisflZnBde9E9DdFqtUeWdmUm19h51RRbATnDMU7owaDw0CbSl",
      'Content-Type': 'application/json'
    };

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
  Stream<List<MessageModel>> loadMessagesOnNoti(String notificationId) {
    return _firestoreService.collectionStream(
      path: FirebasePath.messagesOfNotification(notificationId),
      builder: (data, documentId) => MessageModel.fromMap(data),
      sort: (a, b) {
        return a.timeStamp.compareTo(b.timeStamp);
      },
    );
  }

  @override
  Future<void> pushMessage(MessageModel message, String notificationId) async =>
      await _firestoreService.set(
        path: FirebasePath.messagePath(notificationId, message.id),
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
  Future<void> updateUser(Map<String, String> user) async {
    await _firestoreService.set(
        path: FirebasePath.userPath(uid!), data: user, mergeBool: true);
  }

  @override
  Stream<UserModel> getUser(String userID) => _firestoreService.documentStream(
      path: FirebasePath.userPath(userID),
      builder: (data, documentId) {
        return UserModel.fromMap(data);
      });

  Stream<UserModel> currentUser() => _firestoreService.documentStream(
      path: FirebasePath.userPath(uid!),
      builder: (data, documentId) {
        var user = UserModel.fromMap(data);

        return UserModel.fromMap(data);
      });

  @override
  Future<void> reSubTopics(List<TopicModel> topics) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.deleteToken();
    _firebaseMessaging.getInitialMessage();
    _firebaseMessaging.getToken();
    for (var topic in topics) {
      _firebaseMessaging.subscribeToTopic(topic.topicName);
    }
  }

  @override
  Future<void> unSubTopics() {
    // TODO: implement unSubTopics
    throw UnimplementedError();
  }

  @override
  Future<void> pushTopic(List<TopicModel> topic) async {
    final DocumentReference reference =
        FirebaseFirestore.instance.doc(FirebasePath.userPath(uid!));

    await reference.set({
      "subscribedChannels": topic.map<Map<String, dynamic>>((value) {
        return value.toMap();
      }).toList()
    }, SetOptions(merge: true));
    await reSubTopics(topic);
  }

  @override
  Stream<List<TopicModel>> getTopic(TypeOfTopics typeOfTopics) {
    return _firestoreService.collectionStream(
      path: FirebasePath.topicsPath(typeOfTopics),
      builder: (data, documentId) => TopicModel.fromMap(data),
    );
  }

  @override
  Future<Map<String, List<TopicModel>>> getAllTopic() async {
    Map<String, List<TopicModel>> data = {};
    var khoaKinhTeData = _firestoreService.getCollectionData(
        path: FirebasePath.topicsPath(TypeOfTopics.khoaKinhTe),
        builder: (data, documentID) => TopicModel.fromMap(data));

    var khoaSuPham = _firestoreService.getCollectionData(
        path: FirebasePath.topicsPath(TypeOfTopics.khoaSuPham),
        builder: (data, documentID) => TopicModel.fromMap(data));

    var khoaKiThuat = _firestoreService.getCollectionData(
        path: FirebasePath.topicsPath(TypeOfTopics.khoaKyThuat),
        builder: (data, documentID) => TopicModel.fromMap(data));

    await khoaKinhTeData.then((value) {
      data[TypeOfTopics.khoaKinhTe.toSortString()] = value;
    });

    await khoaSuPham.then((value) {
      data[TypeOfTopics.khoaSuPham.toSortString()] = value;
    });

    await khoaKiThuat.then((value) {
      data[TypeOfTopics.khoaKyThuat.toSortString()] = value;
    });

    return data;
  }

  @override
  Future<Map<String, List<TopicModel>>> getUserTopic() async {
    Map<String, List<TopicModel>> userTopic = {
      TypeOfTopics.khoaKinhTe.toSortString(): [],
      TypeOfTopics.khoaKyThuat.toSortString(): [],
      TypeOfTopics.khoaSuPham.toSortString(): [],
    };
    var userData = _firestoreService.getDocumentData(
        path: FirebasePath.userPath(uid!),
        builder: (data, id) => UserModel.fromMap(data));

    await userData.then((value) {
      for (var element in value.subscribedChannels) {
        if (element.typeOfTopic == TypeOfTopics.khoaKinhTe) {
          userTopic[TypeOfTopics.khoaKinhTe.toSortString()]?.add(element);
        }
        if (element.typeOfTopic == TypeOfTopics.khoaKyThuat) {
          userTopic[TypeOfTopics.khoaKyThuat.toSortString()]?.add(element);
        } else if (element.typeOfTopic == TypeOfTopics.khoaSuPham) {
          userTopic[TypeOfTopics.khoaSuPham.toSortString()]?.add(element);
        }
      }
    });

    return userTopic;
  }
}
