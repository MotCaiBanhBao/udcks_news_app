import 'package:udcks_news_app/models/utils/utils.dart';

class TopicModel {
  String topicName;
  TypeOfTopics typeOfTopic;

  String get topicID => "/topics/$topicName";

  TopicModel({
    required this.topicName,
    required this.typeOfTopic,
  });

  factory TopicModel.fromMap(Map<String, dynamic> data) {
    return TopicModel(
      topicName: data['topicName'],
      typeOfTopic: (data['typeOfTopic'] as String).toTypeOfTopic(),
    );
  }

  Map<String, String> toMap() {
    return {
      'id': topicID,
      'topicName': topicName,
      'typeOfTopic': typeOfTopic.toSortString(),
    };
  }
}

enum TypeOfTopics {
  khoaKyThuat,
  khoaSuPham,
  khoaKinhTe,
  toanTruong,
  cacTopicKhac
}
