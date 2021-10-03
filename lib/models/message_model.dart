class MessageModel {
  String id;
  DateTime timeStamp = DateTime.now();
  String userName;
  String userID;
  String content;
  String photoUrl;

  MessageModel({
    required this.id,
    required this.userID,
    required this.userName,
    required this.content,
    required this.photoUrl,
    required this.timeStamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      id: data['id'],
      userID: data['userID'],
      userName: data['userName'],
      content: data['content'],
      photoUrl: data['photoUrl'],
      timeStamp: data['timeStamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'userName': userName,
      'content': content,
      'photoUrl': photoUrl,
      'timeStamp': timeStamp,
    };
  }
}
