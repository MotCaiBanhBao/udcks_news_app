
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/user_model.dart';

abstract class NotificationService {
  Stream<List<NotificationModel>> notificationsStream();
  Future<void> pushNotification(
      NotificationModel data, List<TopicModel> topics);
  Stream<NotificationModel> notificationStream(String notificationId);
  Stream<List<NotificationModel>> loadNotificationOfUser(UserModel user);
}
