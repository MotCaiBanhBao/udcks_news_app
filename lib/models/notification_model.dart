import 'package:uuid/uuid.dart';

class NotificationModel {
  String id = const Uuid().v1();
  String content;
  String url;
  String publisher;
  String target;
  bool checked = false;
  DateTime timeStamp = DateTime.now();

  NotificationModel({
    required this.content,
    required this.url,
    required this.publisher,
    required this.target,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      content: data['content'],
      publisher: data['publisher'],
      target: data['target'],
      url: data['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'id': id,
      'publisher': publisher,
      'target': target,
      'url': url,
    };
  }

  String get getTitle {
    return "";
  }
}
