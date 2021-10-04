import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/app_localization.dart';
import 'package:udcks_news_app/models/notification_model.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/models/utils/utils.dart';
import 'package:udcks_news_app/services/firebase_database.dart';

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
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget._data.title);
    _readMoreController = TextEditingController(text: widget._data.url);
    _contentController = TextEditingController(text: widget._data.content);
    _kindOfNofitication = TypeOfNotification.thongBaoCuaGiaoVien.toSortString();
  }

  @override
  Widget build(BuildContext context) {
    FirestoreDatabase database = Provider.of<FirestoreDatabase>(context);
    return Scaffold(
      appBar: AppBar(
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
            formForPickImage(context),
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

  Step formForPickImage(BuildContext context) {
    return Step(
      title: Text(AppLocalizations.of(context).translate("notiFormPickImage")),
      content: Form(
        key: formKeys[3],
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
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
    if (formKeys[_currentStep].currentState!.validate()) {
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
                database.pushNotification(
                    NotificationModel(content: content, title: title), [
                  TopicModel(
                      topicName: "k12tt",
                      typeOfTopic: TypeOfTopics.cacTopicKhac)
                ]);
              },
            ),
          ],
        );
      },
    );
  }
}
