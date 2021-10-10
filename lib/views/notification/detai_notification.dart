import 'package:flutter/material.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/styling.dart';
import 'package:udcks_news_app/views/rounded_avatar.dart';
import 'package:udcks_news_app/views/transaction/expland_transaction.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationDetails extends StatefulWidget {
  const NotificationDetails({
    required this.item,
    required this.sourceRect,
    required this.publisher,
  });

  static Route<dynamic> route(
      BuildContext context, NotificationModel item, UserModel publisher) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) => NotificationDetails(
        item: item,
        sourceRect: sourceRect,
        publisher: publisher,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();

  final NotificationModel item;
  final UserModel publisher;
  final Rect sourceRect;
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return ExpandItemPageTransition(
      source: widget.sourceRect,
      title: widget.item.title,
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
                  _header,
                  Expanded(flex: 10, child: _body),
                  Expanded(flex: 5, child: _listOfComment),
                  _messageBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _listOfComment {
    return ListView(
      children: [Text("")],
    );
  }

  Widget get _messageBox {
    var inputBottomRadius = const Radius.circular(24);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                TextField(
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
                  onChanged: (value) => setState(() {}),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: null,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _header {
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
                    child: Text(widget.item.title,
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
                            timeago.format(widget.item.timeStamp,
                                allowFromNow: true),
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

  Widget get _body {
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
                widget.item.content,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              if (widget.item.containsPictures) const SizedBox(height: 24),
              if (widget.item.containsPictures)
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
