import 'package:udcks_news_app/models/topic_model.dart';

abstract class TopicsService {
  Future<void> changeTopic(List<TopicModel> newTopics);
  Stream<List<TopicModel>> topicsStream();
  Stream<List<TopicModel>> topicsOfUserStream(String userID);
  Future<void> pushTopic(List<TopicModel> topic);
  Stream<List<TopicModel>> getTopic(TypeOfTopics typeOfTopics);
  Future<Map<String, List<TopicModel>>> getAllTopic();
  Future<Map<String, List<TopicModel>>> getUserTopic();
}
