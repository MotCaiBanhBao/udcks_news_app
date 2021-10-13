import 'package:udcks_news_app/models/topic_model.dart';

abstract class TopicsService {
  Future<void> changeTopic(List<TopicModel> newTopics);
  Stream<List<TopicModel>> topicsStream();
  Stream<List<TopicModel>> topicsOfUserStream(String userID);
  Future<void> pushTopic(TopicModel topic);
}
