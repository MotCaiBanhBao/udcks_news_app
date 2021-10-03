import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/services/firebase_database.dart';

import 'models/user_model.dart';

class AuthWidgetBuilder extends StatelessWidget {
  //Xây dựng widget cho auth
  const AuthWidgetBuilder(
      {required Key key, required this.builder, required this.databaseBuilder})
      : super(key: key);

  //Builder để xây dựng ứng dụng
  final Widget Function(BuildContext, AsyncSnapshot<UserModel>) builder;

  //Firebase database để pass cho các screen khác
  final FirestoreDatabase Function(BuildContext context, String uid)
  databaseBuilder;

  @override
  Widget build(BuildContext context) {

    //Sử dụng Provide để lây AuthProvideModel đã provide từ trước
    final authService = Provider.of<AuthProvider>(context, listen: false);
    return StreamBuilder<UserModel>(
      //Stream để cập nhật các thay đổi
      stream: authService.user,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        final UserModel? user = snapshot.data;
        if (user != null) {
          /*
          * For any other Provider services that rely on user data can be
          * added to the following MultiProvider list.
          * Once a user has been detected, a re-build will be initiated.
           */
          return MultiProvider(
            providers: [
              Provider<UserModel>.value(value: user),
              Provider<FirestoreDatabase>(
                create: (context) => databaseBuilder(context, user.uid),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
