import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udcks_news_app/models/utils/utils.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  late String id;
  late String content;
  late String url;
  late String publisherID;
  late String target;
  late bool checked;
  late String title;
  late DateTime timeStamp;
  late final bool hasAttachment;
  late final bool isContainsPictures;
  late TypeOfNotification typeOfNotification;

  NotificationModel(
      {String? id,
      String? content,
      String? url,
      String? publisherID,
      String? target,
      bool? checked,
      DateTime? timeStamp,
      bool? hasAttachment,
      bool? isContainsPictures,
      String? title,
      TypeOfNotification? typeOfNotification}) {
    this.id = id ?? const Uuid().v1();
    this.content = content ?? "";
    this.url = url ?? "";
    this.checked = checked ?? false;
    this.isContainsPictures = isContainsPictures ?? false;
    this.publisherID = publisherID ?? "";
    this.target = target ?? "";
    this.timeStamp = timeStamp ?? DateTime.now();
    this.typeOfNotification =
        typeOfNotification ?? TypeOfNotification.thoiKhoaBieu;
    this.title = title ?? "";
    this.hasAttachment = hasAttachment ?? false;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'],
      timeStamp: (data['timeStamp'] as Timestamp).toDate(),
      title: data['title'],
      hasAttachment: data['hasAttachment'],
      isContainsPictures: data['containsPictures'],
      content: data['content'],
      publisherID: data['publisher'],
      target: data['target'],
      url: data['url'],
      typeOfNotification:
          (data['typeOfTopic'] as String).toTypeOfNotification(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeStamp': timeStamp,
      'title': title,
      'content': content,
      'id': id,
      'publisher': publisherID,
      'target': target,
      'url': url,
      'hasAttachment': hasAttachment,
      'containsPictures': isContainsPictures,
      'typeOfTopic': typeOfNotification.toSortString(),
    };
  }

  String get getType {
    if (typeOfNotification == TypeOfNotification.thoiKhoaBieu) {
      return "Thời khoá biểu";
    } else if (typeOfNotification == TypeOfNotification.thongBaoCuaGiaoVien) {
      return "Thông báo của giáo viên";
    }
    return "Thông báo của trường";
  }

  String get getTitle {
    return "";
  }
}

enum TypeOfNotification { thoiKhoaBieu, thongBaoCuaGiaoVien, thongBaoCuaTruong }
