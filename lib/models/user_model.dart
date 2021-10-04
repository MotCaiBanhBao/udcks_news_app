import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/utils/utils.dart';

class UserModel {
  String uid;
  String? email;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  late List<TopicModel> subscribedChannels;
  late UserRole userRole;

  UserModel(
      {required this.uid,
      this.email,
      List<TopicModel>? subscribedChannels,
      this.displayName,
      String? phoneNumber,
      UserRole? userRole,
      String? photoUrl}) {
    this.phoneNumber = phoneNumber ?? "";
    this.subscribedChannels = subscribedChannels ??
        [TopicModel(topicName: "udck", typeOfTopic: TypeOfTopics.toanTruong)];
    this.userRole = userRole ?? UserRole.khach;
    this.photoUrl = photoUrl ??
        "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/2048px-Circle-icons-profile.svg.png";
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    List<TopicModel> sub = [];
    List<dynamic> subscribedChannelsRaw = data['subscribedChannels'];
    subscribedChannelsRaw.forEach((element) {
      sub.add(TopicModel(
        topicName: element['topicName'],
        typeOfTopic: (element['typeOfTopic'] as String).toTypeOfTopic(),
      ));
    });
    return UserModel(
        uid: data['uid'],
        email: data['email'],
        displayName: data['displayName'],
        phoneNumber: data['phoneNumber'],
        photoUrl: data['photoUrl'],
        userRole: (data['userRole'] as String).toUserRole(),
        subscribedChannels: sub);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'userRole': userRole.toSortString(),
      'subscribedChannels':
          subscribedChannels.map<Map<String, dynamic>>((value) {
        return value.toMap();
      }).toList()
    };
  }
}

enum UserRole { sinhVien, khach, giaoVien, canBo }
