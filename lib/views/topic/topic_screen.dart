import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/utils/utils.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/styling.dart';

class TopicScreen extends StatefulWidget {
  TopicScreen({Key? key}) : super(key: key);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<TopicScreen> {
  Map<String, List<TopicModel>> topicsSelected = {
    TypeOfTopics.khoaKinhTe.toSortString(): [],
    TypeOfTopics.khoaKyThuat.toSortString(): [],
    TypeOfTopics.khoaSuPham.toSortString(): [],
  };
  Map<String, List<TopicModel>> allTopic = {
    TypeOfTopics.khoaKinhTe.toSortString(): [],
    TypeOfTopics.khoaKyThuat.toSortString(): [],
    TypeOfTopics.khoaSuPham.toSortString(): [],
  };
  late FirestoreDatabase firestoreDatabase;

  Future<void> initData(FirestoreDatabase firestoreDatabase) async {
    await firestoreDatabase.getUserTopic().then((value) {
      topicsSelected = value;
    });
    await firestoreDatabase.getAllTopic().then((value) {
      allTopic = value;
    });
  }

  showLoaderDialog(BuildContext context) async {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSusscesDialog(BuildContext context, String text) async {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          Container(margin: const EdgeInsets.only(left: 7), child: Text(text)),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firestoreDatabase = Provider.of<FirestoreDatabase>(context);

    firestoreDatabase.getUserTopic().then((value) {
      setState(() {
        topicsSelected = value;
      });
    });
    firestoreDatabase.getAllTopic().then((value) {
      setState(() {
        allTopic = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showMultiSelect(BuildContext context, List<TopicModel> items,
        List<TopicModel> initItem, TypeOfTopics typeOfTopics) async {
      await showDialog(
        context: context,
        builder: (ctx) {
          return MultiSelectDialog<TopicModel>(
              items: items.map((e) => MultiSelectItem(e, e.topicName)).toList(),
              initialValue: initItem,
              listType: MultiSelectListType.CHIP,
              onConfirm: (element) {
                setState(() {
                  topicsSelected[typeOfTopics.toSortString()] = element;
                });
              });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.notWhite,
        shadowColor: AppTheme.notWhite,
        title: const Text(
          "Choose your topics",
          style: AppTheme.headline,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: AppTheme.grey,
            ),
            onPressed: () {
              List<TopicModel> subedTopic =
                  topicsSelected[TypeOfTopics.khoaKinhTe.toSortString()]!;
              subedTopic.addAll(
                  topicsSelected[TypeOfTopics.khoaKyThuat.toSortString()]!);
              subedTopic.addAll(
                  topicsSelected[TypeOfTopics.khoaSuPham.toSortString()]!);

              firestoreDatabase
                  .pushTopic(subedTopic)
                  .whenComplete(() => showSusscesDialog(context, "SUCCESS"));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: SizedBox(
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppTheme.darkGrey),
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Your choice",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topicsSelected[
                                    TypeOfTopics.khoaKyThuat.toSortString()]!
                                .length,
                            itemBuilder: (ctx, index) {
                              print("CO CHAY");
                              return Chip(
                                label: Text(topicsSelected[TypeOfTopics
                                        .khoaKyThuat
                                        .toSortString()]![index]
                                    .topicName),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topicsSelected[
                                    TypeOfTopics.khoaKinhTe.toSortString()]!
                                .length,
                            itemBuilder: (ctx, index) {
                              print("CO CHAY");
                              return Chip(
                                label: Text(topicsSelected[TypeOfTopics
                                        .khoaKinhTe
                                        .toSortString()]![index]
                                    .topicName),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topicsSelected[
                                    TypeOfTopics.khoaSuPham.toSortString()]!
                                .length,
                            itemBuilder: (ctx, index) {
                              print("CO CHAY");
                              return Chip(
                                label: Text(topicsSelected[TypeOfTopics
                                        .khoaSuPham
                                        .toSortString()]![index]
                                    .topicName),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text("Khoa kĩ thuật"),
                    trailing: const Icon(Icons.touch_app),
                    onTap: () {
                      _showMultiSelect(
                        context,
                        allTopic[TypeOfTopics.khoaKyThuat.toSortString()]!,
                        topicsSelected[
                            TypeOfTopics.khoaKyThuat.toSortString()]!,
                        TypeOfTopics.khoaKyThuat,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Khoa kinh tế"),
                    trailing: const Icon(Icons.touch_app),
                    onTap: () {
                      _showMultiSelect(
                        context,
                        allTopic[TypeOfTopics.khoaKinhTe.toSortString()]!,
                        topicsSelected[TypeOfTopics.khoaKinhTe.toSortString()]!,
                        TypeOfTopics.khoaKinhTe,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Khoa sư phạm"),
                    trailing: const Icon(Icons.touch_app),
                    onTap: () {
                      _showMultiSelect(
                        context,
                        allTopic[TypeOfTopics.khoaSuPham.toSortString()]!,
                        topicsSelected[TypeOfTopics.khoaSuPham.toSortString()]!,
                        TypeOfTopics.khoaSuPham,
                      );
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
