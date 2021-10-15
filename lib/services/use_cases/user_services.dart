import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/user_model.dart';

abstract class UserService {
  Future<void> updateUser(Map<String, String> user);
  Stream<UserModel> getUser(String userID);
  Future<void> reSubTopics(List<TopicModel> topics);
  Future<void> unSubTopics();
}
