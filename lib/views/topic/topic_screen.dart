import 'package:flutter/material.dart';
import 'package:udcks_news_app/models/topic_model.dart';
import 'package:udcks_news_app/styling.dart';

class TopicScreen extends StatefulWidget {
  TopicScreen({Key? key}) : super(key: key);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<TopicScreen> {
  String _isSelected = "";
  List<TopicModel> _tags = [
    TopicModel(topicName: "K12", typeOfTopic: TypeOfTopics.khoaKyThuat)
  ];
  List<TopicModel> _tagsToSelect = [
    TopicModel(topicName: "K12", typeOfTopic: TypeOfTopics.khoaKyThuat)
  ];
  TextEditingController _searchTextEditingController = TextEditingController();
  String get _searchText => _searchTextEditingController.text.trim();

  refreshState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() => refreshState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  List<TopicModel> _filterSearchResultList() {
    if (_searchText.isEmpty) return _tagsToSelect;

    List<TopicModel> _tempList = [];
    for (int index = 0; index < _tagsToSelect.length; index++) {
      TopicModel tagModel = _tagsToSelect[index];
      if (tagModel.topicName
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        _tempList.add(tagModel);
      }
    }

    return _tempList;
  }

  _removeTag(tagModel) async {
    if (_tags.contains(tagModel)) {
      setState(() {
        _tags.remove(tagModel);
      });
    }
  }

  Widget _buildSuggestionWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_filterSearchResultList().length != _tags.length) Text('Suggestions'),
      Wrap(
        alignment: WrapAlignment.start,
        children: _filterSearchResultList()
            .where((tagModel) => !_tags.contains(tagModel))
            .map((tagModel) => tagChip(
                  tagModel: tagModel,
                  onTap: () => _addTags(tagModel),
                  action: 'Add',
                ))
            .toList(),
      ),
    ]);
  }

  _addTags(tagModel) async {
    if (!_tags.contains(tagModel)) {
      setState(() {
        _tags.add(tagModel);
      });
    }
  }

  _displayTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _filterSearchResultList().isNotEmpty
          ? _buildSuggestionWidget()
          : Text('No Labels added'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.notWhite,
        shadowColor: AppTheme.notWhite,
        title: const Text(
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
      body: _tagIcon(),
    );
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_offer_outlined,
          color: Colors.deepOrangeAccent,
          size: 25.0,
        ),
        _tagsWidget(),
      ],
    );
  }

  Widget _tagsWidget() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tags',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
          _tags.isNotEmpty
              ? Column(children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: _tags
                        .map((tagModel) => tagChip(
                              tagModel: tagModel,
                              onTap: () => _removeTag(tagModel),
                              action: 'Remove',
                            ))
                        .toSet()
                        .toList(),
                  ),
                ])
              : Container(),
          _buildSearchFieldWidget(),
          _displayTagWidget(),
        ],
      ),
    );
  }

  Widget tagChip({
    tagModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  '${tagModel.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.orange.shade600,
                radius: 8.0,
                child: Icon(
                  Icons.clear,
                  size: 10.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildSearchFieldWidget() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchTextEditingController,
            decoration: const InputDecoration.collapsed(
              hintText: 'Search Topic',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
        _searchText.isNotEmpty
            ? InkWell(
                child: Icon(
                  Icons.clear,
                  color: Colors.grey.shade700,
                ),
                onTap: () => _searchTextEditingController.clear(),
              )
            : Icon(
                Icons.search,
                color: Colors.grey.shade700,
              ),
        Container(),
      ],
    );
  }
}
