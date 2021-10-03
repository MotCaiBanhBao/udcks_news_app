class TopicModel {
  String topicName;
  String topicID;

  TopicModel({
    required this.topicID,
    required this.topicName,
  });

  factory TopicModel.fromMap(Map<String, dynamic> data) {
    return TopicModel(
      topicID: data['id'],
      topicName: data['topicName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': topicID,
      'topicName': topicName,
    };
  }
}
