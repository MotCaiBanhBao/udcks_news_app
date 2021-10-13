import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/utils/utils.dart';

class FirebasePath {
  static const notificationKEY = "notifications";
  static const orderCriteria = "timestamp";
  static const messageKEY = "messages";
  static const topicKEY = "topics";


  static String topicPath(TypeOfTopics typeOfTopics, String topicName){
    if(typeOfTopics == TypeOfTopics.cacTopicKhac){
      return "topics/AnotherTopics/${typeOfTopics.toSortString()}/$topicName";
    }else{
      return "topics/RegularTopics/${typeOfTopics.toSortString()}/$topicName";
    }
  } 

  static String userPath(String id) => 'users/$id';
  static String userNotificationPath(String id) => "users/$id";
  static String notificaionPath(String id) => 'notifications/$id';
  static String topicsOfUser(String uid) => 'users/$uid/topics';
  static String notificationsOfUser(String uid) => 'users/$uid/notifications';
  static String notification(String notificationId) =>
      '$notificationKEY/$notificationId';
  static String messagePath(String notificationId, String messageID) =>
      'notifications/$notificationId/messages/$messageID';
  static String messagesOfNotification(String notificationId) =>
      'notifications/$notificationId/messages';
}
