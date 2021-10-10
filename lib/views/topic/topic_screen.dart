import 'package:flutter/material.dart';
import 'package:udcks_news_app/styling.dart';

class TopicScreen extends StatefulWidget {
  List chipName = ["K12TT", "K11TT"];

  TopicScreen({Key? key}) : super(key: key);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<TopicScreen> {
  String _isSelected = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.chipName.forEach((item) {
      choices.add(Container(
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(color: Colors.white),
          selectedColor: Colors.pinkAccent,
          backgroundColor: Colors.deepPurpleAccent,
          selected: _isSelected == item,
          onSelected: (selected) {
            setState(() {
              _isSelected = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.notWhite,
        shadowColor: AppTheme.notWhite,
        title: Text(
          "Topics",
          style: AppTheme.headline,
        ),
        actions: [
          Icon(
            Icons.save,
            color: AppTheme.grey,
          )
        ],
      ),
      body: Wrap(
        spacing: 5.0,
        runSpacing: 3.0,
        children: _buildChoiceList(),
      ),
    );
  }
}
