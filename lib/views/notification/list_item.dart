import 'package:flutter/material.dart';
import 'package:udcks_news_app/models/notification_model.dart';

import '../rounded_avatar.dart';

class ListItem extends StatelessWidget {
  const ListItem({required this.item});

  final NotificationModel item;

  @override
  Widget build(BuildContext context) {
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
          color: Colors.green,
          border: Border.all(color: Colors.black, width: 2),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset(
          'assets/images/ic_star.png',
          width: 36,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset(
          'assets/images/ic_trash.png',
          width: 36,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          color: Colors.brown,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _header,
                  _notificationPreview,
                ],
              ),
            ),
            onTap: () => null,
          ),
        ),
      ),
    );
  }

  Widget get _header {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('10s', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 2),
              Text(
                item.publisherID,
                style: TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Hero(
          tag: item.publisherID,
          child: RoundedAvatar(image: item.publisherID),
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
                style: TextStyle(fontSize: 10),
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
                child: Image.network("https://storage.googleapis.com/support-kms-prod/ZAl1gIwyUsvfwxoW9ns47iJFioHXODBbIkrK"),
                
              );
            },
          ),
        ),
      ),
    ];
  }
}
