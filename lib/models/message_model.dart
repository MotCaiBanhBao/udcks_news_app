import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:uuid/uuid.dart';

class MessageModel {
  late String id;
  late DateTime timeStamp;
  String userID;
  String content;
  late bool isHasPhoto;
  late List<String> photoUrl = [];
  late TopicModel messageChannelID;

  MessageModel({
    String? id,
    required this.userID,
    required this.content,
    DateTime? timeStamp,
    bool? isHasPhoto,
    List<String>? photoUrl,
  }) {
    this.id = id ?? const Uuid().v1();
    this.timeStamp = timeStamp ?? DateTime.now();
    messageChannelID =
        TopicModel(topicName: this.id, typeOfTopic: TypeOfTopics.cacTopicKhac);
    this.isHasPhoto = isHasPhoto ?? false;
    this.photoUrl = photoUrl ?? [];
  }

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    List<String> photoUrlTemp = [];
    List<dynamic> photoUrlRaw = data['photoUrl'];
    for (var element in photoUrlRaw) {
      photoUrlTemp.add(element);
    }

    MessageModel message = MessageModel(
      id: data['id'],
      userID: data['userID'],
      content: data['content'],
      timeStamp: (data['timeStamp'] as Timestamp).toDate(),
      photoUrl: photoUrlTemp,
      isHasPhoto: data['isHasPhoto'],
    );
    return message;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'content': content,
      'photoUrl': photoUrl,
      'timeStamp': timeStamp,
      'isHasPhoto': isHasPhoto,
    };
  }
}
