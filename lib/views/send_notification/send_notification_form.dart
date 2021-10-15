import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/app_localization.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/utils/utils.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/styling.dart';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
];

class NotificationForm extends StatefulWidget {
  late NotificationModel _data;
  NotificationForm({Key? key, NotificationModel? data}) : super(key: key) {
    _data = data ?? NotificationModel();
  }

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  late TextEditingController _titleController;
  late TextEditingController _readMoreController;
  late TextEditingController _contentController;
  late String _kindOfNofitication;

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget._data.title);
    _readMoreController = TextEditingController(text: widget._data.url);
    _contentController = TextEditingController(text: widget._data.content);
    _kindOfNofitication = TypeOfNotification.thongBaoCuaGiaoVien.toSortString();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    firestoreDatabase = Provider.of<FirestoreDatabase>(context);
    firestoreDatabase.getAllTopic().then((value) {
      setState(() {
        allTopic = value;
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    FirestoreDatabase database = Provider.of<FirestoreDatabase>(context);
    return Scaffold(
      backgroundColor: AppTheme.notWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.notWhite,
        foregroundColor: AppTheme.grey,
        title: Text(
            AppLocalizations.of(context).translate("notificationFormLeading")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stepper(
          type: stepperType,
          physics: const ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: () => continued(database),
          onStepCancel: cancel,
          steps: <Step>[
            formForKind(context),
            formForTitle(context),
            formForContent(context),
            formForPickTopic(context),
            formForDetail(context),
          ],
        ),
      ),
    );
  }

  Step formForDetail(BuildContext context) {
    return Step(
      title: Text(AppLocalizations.of(context).translate("notiFormDetailPage")),
      content: Form(
        key: formKeys[4],
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _readMoreController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 4 ? StepState.complete : StepState.disabled,
    );
  }

  Step formForPickTopic(BuildContext context) {
    return Step(
      title:
          Text(AppLocalizations.of(context).translate("notiFormChooseTopics")),
      subtitle: Text(
          AppLocalizations.of(context).translate("notiFormChooseTopicsSub")),
      content: Column(
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
                    itemCount:
                        topicsSelected[TypeOfTopics.khoaKyThuat.toSortString()]!
                            .length,
                    itemBuilder: (ctx, index) {
                      print("CO CHAY");
                      return Chip(
                        label: Text(topicsSelected[
                                TypeOfTopics.khoaKyThuat.toSortString()]![index]
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
                    itemCount:
                        topicsSelected[TypeOfTopics.khoaKinhTe.toSortString()]!
                            .length,
                    itemBuilder: (ctx, index) {
                      print("CO CHAY");
                      return Chip(
                        label: Text(topicsSelected[
                                TypeOfTopics.khoaKinhTe.toSortString()]![index]
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
                    itemCount:
                        topicsSelected[TypeOfTopics.khoaSuPham.toSortString()]!
                            .length,
                    itemBuilder: (ctx, index) {
                      print("CO CHAY");
                      return Chip(
                        label: Text(topicsSelected[
                                TypeOfTopics.khoaSuPham.toSortString()]![index]
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
                topicsSelected[TypeOfTopics.khoaKyThuat.toSortString()]!,
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
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
    );
  }

  Step formForContent(BuildContext context) {
    return Step(
      title: Text(AppLocalizations.of(context).translate("notiFormContent")),
      content: Form(
        key: formKeys[2],
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _contentController,
              validator: (value) => value!.isEmpty
                  ? AppLocalizations.of(context).translate("contentTxtError")
                  : null,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
    );
  }

  Step formForTitle(BuildContext context) {
    return Step(
      title: Text(AppLocalizations.of(context).translate("notiFormTitle")),
      subtitle:
          Text(AppLocalizations.of(context).translate("notiFormTitleSub")),
      content: Form(
        key: formKeys[1],
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              autocorrect: true,
              validator: (value) => value!.isEmpty
                  ? AppLocalizations.of(context).translate("titleTxtError")
                  : null,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step formForKind(BuildContext context) {
    return Step(
      title: Text(AppLocalizations.of(context).translate("notiFormKindOfNoti")),
      subtitle:
          Text(AppLocalizations.of(context).translate("notiFormKindOfNotiSub")),
      content: Form(
        key: formKeys[0],
        child: DropdownButton(
          value: _kindOfNofitication,
          items: <String>[
            TypeOfNotification.thoiKhoaBieu.toSortString(),
            TypeOfNotification.thongBaoCuaGiaoVien.toSortString(),
            TypeOfNotification.thongBaoCuaTruong.toSortString()
          ].map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _kindOfNofitication = newValue!;
            });
          },
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued(FirestoreDatabase context) {
    print(_currentStep);
    if (formKeys[_currentStep].currentState?.validate() ?? true) {
      if (_currentStep < 4) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        _showMyDialog(
            _titleController.text,
            "${_contentController.text} \nYou can read more at: ${_readMoreController.text}",
            context);
      }
    }
  }

  cancel() {
    _currentStep == 0 ? Navigator.pop(context) : null;
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
    _currentStep < 0 ? Navigator.pop(context) : null;
  }

  Future<void> _showMyDialog(
      String title, String content, FirestoreDatabase database) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate("notificationPreview")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Title: $title'),
                Text('Content: $content'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                List<TopicModel> subedTopic = [];
                subedTopic.addAll(
                    topicsSelected[TypeOfTopics.khoaKinhTe.toSortString()]!);
                subedTopic.addAll(
                    topicsSelected[TypeOfTopics.khoaKyThuat.toSortString()]!);
                subedTopic.addAll(
                    topicsSelected[TypeOfTopics.khoaSuPham.toSortString()]!);

                database.pushNotification(
                    NotificationModel(content: content, title: title),
                    subedTopic);
              },
            ),
          ],
        );
      },
    );
  }
}
