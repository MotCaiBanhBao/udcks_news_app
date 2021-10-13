import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/message_model.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/styling.dart';
import 'package:udcks_news_app/views/rounded_avatar.dart';
import 'package:udcks_news_app/views/transaction/expland_transaction.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationDetails extends StatefulWidget {
  const NotificationDetails(
      {required this.id,
      required this.sourceRect,
      required this.publisher,
      required this.currentUser});

  static Route<dynamic> route(BuildContext context, String notiID,
      UserModel publisher, String? userID) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) => NotificationDetails(
        currentUser: userID!,
        id: notiID,
        sourceRect: sourceRect,
        publisher: publisher,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();

  final String id;
  final UserModel publisher;
  final Rect sourceRect;
  final String currentUser;
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context);

    return StreamBuilder(
      stream: firestoreDatabase.notificationStream(widget.id),
      builder: (context, AsyncSnapshot<NotificationModel> snapshot) => snapshot
              .hasData
          ? ExpandItemPageTransition(
              source: widget.sourceRect,
              title: snapshot.data?.title ??
                  "Hiện tại người đăng tin chưa cập nhật title",
              child: Material(
                child: SafeArea(
                  maintainBottomViewPadding: true,
                  child: Container(
                    height: double.infinity,
                    margin: const EdgeInsets.all(4),
                    color: AppTheme.nearlyWhite,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      bottomNavigationBar:
                          Padding(padding: MediaQuery.of(context).viewInsets),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _header(
                              snapshot.data!.title, snapshot.data!.timeStamp),
                          Expanded(
                            flex: 10,
                            child: _body(
                              snapshot.data!.content,
                              snapshot.data!.isContainsPictures,
                              [],
                            ),
                          ),
                          const Divider(
                            thickness: 5,
                            color: AppTheme.darkGrey,
                          ),
                          Expanded(
                              flex: 5,
                              child: _listOfComment(firestoreDatabase)),
                          _messageBox(firestoreDatabase, snapshot.data!.id)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Scaffold(
              body: Center(
                child: Text("Hiện đang có lỗi, vui lòng thử lại sau",
                    style: AppTheme.headline),
              ),
            ),
    );
  }

  Widget _listOfComment(FirestoreDatabase firestoreDatabase) {
    return StreamBuilder(
      stream: firestoreDatabase.loadMessagesOnNoti(widget.id),
      builder: (context, AsyncSnapshot<List<MessageModel>> snapshot) {
        print("SSSS " + (snapshot.data?.length ?? 0).toString());
        if (snapshot.hasData) {
          List<MessageModel> messages = snapshot.data!;
          return ListView.builder(
            itemBuilder: (content, index) {
              return messages[index].userID == widget.currentUser
                  ? _comment(true, messages[index], firestoreDatabase)
                  : _comment(false, messages[index], firestoreDatabase);
            },
            itemCount: messages.length,
          );
        } else {
          return const Center(child: Text("Hiện chưa có comment nào"));
        }
      },
    );
  }

  Widget _comment(bool isMyComment, MessageModel data,
      FirestoreDatabase firestoreDatabase) {
    return isMyComment
        ? _myComment(data)
        : _anotherComment(data, firestoreDatabase);
  }

  Widget _myComment(MessageModel data) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * (2 / 3),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange,
            ),
            padding: const EdgeInsets.all(10),
            child: Text(data.content),
          ),
          Text(timeago.format(data.timeStamp, allowFromNow: true),
              style: AppTheme.caption),
        ]),
      ),
    );
  }

  Widget _anotherComment(
      MessageModel data, FirestoreDatabase firestoreDatabase) {
    return StreamBuilder(
      stream: firestoreDatabase.getUser(data.userID),
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        return snapshot.hasData
            ? SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoundedAvatar(
                        image: snapshot.data!.photoUrl ??
                            "https://i.pinimg.com/originals/10/b2/f6/10b2f6d95195994fca386842dae53bb2.png"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.displayName ?? "Error",
                          style: AppTheme.body2,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * (2 / 3),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.notWhite,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(data.content),
                        ),
                        Text(timeago.format(data.timeStamp, allowFromNow: true),
                            style: AppTheme.caption),
                      ],
                    )
                  ],
                ),
              )
            : const Card(
                child: Text(
                  "Hiện đang gặp lỗi trong việc load tin này",
                  style: AppTheme.errorText,
                ),
              );
      },
    );
  }

  Widget _messageBox(
      FirestoreDatabase firestoreDatabase, String notificationID) {
    TextEditingController inputText = TextEditingController();
    var inputBottomRadius = const Radius.circular(24);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: inputText,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: inputBottomRadius,
                        topRight: inputBottomRadius,
                        bottomLeft: inputBottomRadius,
                        bottomRight: inputBottomRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Ink(
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                firestoreDatabase.pushMessage(
                    MessageModel(
                        userID: widget.publisher.uid, content: inputText.text),
                    notificationID);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String title, DateTime timeStamp) {
    final Animation<double> fadeAnimation = CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.fastOutSlowIn);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.headline4)),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  padding: const EdgeInsets.only(left: 24, top: 0, right: 12),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.publisher.displayName.toString() +
                            " - " +
                            timeago.format(timeStamp, allowFromNow: true),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
              RoundedAvatar(image: widget.publisher.photoUrl.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _body(
      String content, bool iscontainsPictures, List<String> listImage) {
    final Animation<double> fadeAnimation = CurvedAnimation(
        parent: ModalRoute.of(context)!.animation!,
        curve: Curves.fastOutSlowIn);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 24),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              if (iscontainsPictures) const SizedBox(height: 24),
              if (iscontainsPictures)
                Image.asset(
                    "https://storage.googleapis.com/support-kms-prod/ZAl1gIwyUsvfwxoW9ns47iJFioHXODBbIkrK"),
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
