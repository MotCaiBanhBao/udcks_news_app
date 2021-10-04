import 'package:udcks_news_app/models/topic_model.dart';

class MessageModel {
  String id;
  DateTime timeStamp = DateTime.now();
  String userID;
  String content;
  late bool isHasPhoto;
  late List<String> photoUrl = [];
  late TopicModel messageChannelID;

  MessageModel({
    required this.id,
    required this.userID,
    required this.content,
    required this.timeStamp,
    bool? isHasPhoto,
    List<String>? photoUrl,
  }) {
    messageChannelID =
        TopicModel(topicName: id, typeOfTopic: TypeOfTopics.cacTopicKhac);
    this.isHasPhoto = isHasPhoto ?? false;
    this.photoUrl = photoUrl ?? [];
  }

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      id: data['id'],
      userID: data['userID'],
      content: data['content'],
      timeStamp: data['timeStamp'],
      photoUrl: data['photoUrl'],
      isHasPhoto: data['isHasPhoto'],
    );
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
