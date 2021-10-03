class FirebasePath {
  static const notificationKEY = "notifications";
  static const orderCriteria = "timestamp";
  static const messageKEY = "messages";
  static const topicKEY = "topics";
  static String notificaionPath(String id) => 'notifications/$id';
  static String topicsOfUser(String uid) => 'users/$uid/topics';
  static String notificationsOfUser(String uid) => 'users/$uid/notifications';
  static String notification(String notificationId) =>
      '$notificationKEY/$notificationId';
  static String messageOfNotification(String notificationId) =>
      '$notificationKEY/$notificationId/$messageKEY';
}
