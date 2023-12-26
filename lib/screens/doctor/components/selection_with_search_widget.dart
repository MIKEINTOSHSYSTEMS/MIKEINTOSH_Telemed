import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectionWithSearchWidget extends StatefulWidget {
  final List<String?>? searchList;
  final String? name;

  SelectionWithSearchWidget({this.searchList, this.name});

  @override
  _SelectionWithSearchWidgetState createState() => _SelectionWithSearchWidgetState();
}

class _SelectionWithSearchWidgetState extends State<SelectionWithSearchWidget> {
  TextEditingController prescriptionNameSearch = TextEditingController();

  List<String?> mainList = [];
  List<String?> searchList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mainList.addAll(widget.searchList!);
    searchList.addAll(mainList);
  }

  void filterSearchResults(String query) {
    List<String?> dummySearchList = [];
    dummySearchList.addAll(mainList);
    if (query.isNotEmpty) {
      List<String?> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        searchList.clear();
        searchList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        searchList.clear();
        searchList.addAll(mainList);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: context.height(),
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.fromLTRB(16, 60, 16, 30),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text('${widget.name}', style: boldTextStyle(), textAlign: TextAlign.center).expand(),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        finish(context);
                      },
                    ),
                    6.width,
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        finish(context);
                      },
                    ),
                  ],
                ),
                16.height,
                AppTextField(
                  autoFocus: true,
                  controller: prescriptionNameSearch,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(context: context, labelText: locale.lblSearch),
                  onFieldSubmitted: (s) {
                    finish(context, s);
                  },
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                ),
                16.height,
              ],
            ),
            ListView.separated(
              itemCount: searchList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Text(searchList[index].validate(), style: boldTextStyle()),
                ).onTap(() {
                  finish(context, searchList[index]);
                });
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ).paddingTop(120),
          ],
        ),
      ),
    );
  }
}
