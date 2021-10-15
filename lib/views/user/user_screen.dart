import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/routers.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/styling.dart';

class ProfilePage extends StatefulWidget {
  late String? id;

  ProfilePage({Key? key, String? userID}) : super(key: key) {
    id = userID;
  }

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController _textUserNameEdit = TextEditingController();
  TextEditingController _photoURLEdit = TextEditingController();

  @override
  void dispose() {
    _textUserNameEdit.dispose();
    _photoURLEdit.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? data = ModalRoute.of(context)!.settings.arguments as String?;
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Profile", style: AppTheme.headline),
        ),
        body: StreamBuilder<UserModel>(
            stream: data == null
                ? firestoreDatabase.currentUser()
                : firestoreDatabase.getUser(widget.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasData) {
                var userData = snapshot.data;
                return Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 250.0,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 140.0,
                                        height: 140.0,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(
                                            userData?.photoUrl ??
                                                'https://cdn4.iconfinder.com/data/icons/ui-beast-4/32/Ui-12-512.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                          child: Text("Logout"),
                                          onPressed: () {
                                            authProvider.signOut();
                                            Navigator.of(context)
                                                .popAndPushNamed(Routes.login);
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const <Widget>[
                                              Text(
                                                'Personal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : Container(),
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const <Widget>[
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                              controller: _textUserNameEdit,
                                              decoration: InputDecoration(
                                                hintText:
                                                    (userData?.displayName ??
                                                        "null"),
                                              ),
                                              enabled: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const <Widget>[
                                              Text(
                                                'Email ID',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                                decoration: InputDecoration(
                                                    hintText: userData?.email ??
                                                        "null"),
                                                enabled: false),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const <Widget>[
                                              Text(
                                                'PhotoUrl',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                              controller: _photoURLEdit,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      userData?.photoUrl ??
                                                          "null"),
                                              enabled: !_status,
                                              autofocus: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const <Widget>[
                                              Text(
                                                'Sub topics',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                                userData?.getAllTopic ?? ""),
                                          ),
                                        ],
                                      )),
                                  !_status
                                      ? _getActionButtons(
                                          firestoreDatabase, userData!)
                                      : Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Widget _getActionButtons(
      FirestoreDatabase firestoreDatabase, UserModel currentData) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                child: RaisedButton(
                  child: Text("Save"),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      _status = true;
                      firestoreDatabase.updateUser({
                        "displayName": _textUserNameEdit.text.isEmpty
                            ? currentData.displayName!
                            : _textUserNameEdit.text,
                        "photoUrl": _photoURLEdit.text.isEmpty
                            ? currentData.photoUrl!
                            : _photoURLEdit.text
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
