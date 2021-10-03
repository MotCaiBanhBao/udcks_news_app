

import 'package:udcks_news_app/models/user_model.dart';

abstract class UserService {
  Future<UserModel> getUser(String userID);
  Future<void> reSubTopics();
  Future<void> unSubTopics();
}
