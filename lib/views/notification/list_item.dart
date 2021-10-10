import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/services/firebase_path.dart';
import 'package:udcks_news_app/styling.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:udcks_news_app/views/notification/detai_notification.dart';
import '../rounded_avatar.dart';

class ListItem extends StatelessWidget {
  const ListItem({required this.item});
  final NotificationModel item;

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context);
    return Dismissible(
        key: ObjectKey(item.id),
        dismissThresholds: const {
          DismissDirection.startToEnd: 1,
          DismissDirection.endToStart: 0.4,
        },
        onDismissed: (DismissDirection direction) {
          switch (direction) {
            case DismissDirection.endToStart:
              //Todo
              break;
            case DismissDirection.startToEnd:
              // TODO: Handle this case.
              break;
            default:
            // Do not do anything
          }
        },
        background: Container(
          decoration: BoxDecoration(
              color: AppTheme.orange,
              border: Border.all(color: AppTheme.notWhite, width: 2)),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(
            Icons.star,
            size: 36,
            color: AppTheme.notWhite,
          ),
        ),
        secondaryBackground: Container(
            decoration: BoxDecoration(
              color: AppTheme.dismissibleBackground,
              border: Border.all(color: AppTheme.notWhite, width: 2),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, size: 36, color: Colors.red)),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Material(
            color: AppTheme.nearlyWhite,
            child: StreamBuilder<Object>(
                stream: firestoreDatabase.getUser(item.publisherID),
                builder: (context, snapshot) {
                  return InkWell(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              snapshot.hasData
                                  ? _header(snapshot.data as UserModel)
                                  : _header(UserModel(uid: "null")),
                              _notificationPreview,
                            ],
                          )),
                      onTap: () => Navigator.of(context).push<void>(
                          NotificationDetails.route(
                              context, item, snapshot.data as UserModel)));
                }),
          ),
        ));
  }

  Widget _header(UserModel user) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.displayName.toString() +
                    " - " +
                    timeago.format(item.timeStamp, allowFromNow: true),
                style: AppTheme.caption.copyWith(
                    color: item.checked
                        ? AppTheme.deactivatedText
                        : AppTheme.darkText),
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                style: item.containsPictures
                    ? AppTheme.headline
                    : AppTheme.title.copyWith(
                        color: item.checked
                            ? AppTheme.deactivatedText
                            : AppTheme.darkText),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        RoundedAvatar(
          image: user.photoUrl.toString(),
        )
      ],
    );
  }

  Widget get _notificationPreview {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (item.hasAttachment)
              const Padding(
                padding: EdgeInsets.only(right: 18),
                child: Icon(
                  Icons.attachment,
                  size: 24,
                  color: Color(0xFF4A6572),
                ),
              ),
            Flexible(
              child: Text(
                item.content,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTheme.subtitle,
              ),
            ),
          ],
        ),
        if (item.containsPictures) ..._miniGallery,
      ],
    );
  }

  List<Widget> get _miniGallery {
    return <Widget>[
      const SizedBox(height: 21),
      SizedBox(
        width: double.infinity,
        height: 96,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List<Widget>.generate(
            5,
            (int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Image.network(
                    "https://storage.googleapis.com/support-kms-prod/ZAl1gIwyUsvfwxoW9ns47iJFioHXODBbIkrK"),
              );
            },
          ),
        ),
      ),
    ];
  }
}
