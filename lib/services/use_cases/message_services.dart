
import 'package:udcks_news_app/models/message_model.dart';

abstract class MessageService {
  Stream<List<MessageModel>> loadMessagesOnNoti(String notificationId);
  Future<void> pushMessage(MessageModel message, String notificationId);
}
