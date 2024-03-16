import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/static_data_model.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';

// ignore: must_be_immutable
class MultiSelectSpecialization extends StatefulWidget {
  final int? id;
  List<String?>? selectedServicesId;

  MultiSelectSpecialization({this.id, this.selectedServicesId});

  @override
  _MultiSelectSpecializationState createState() => _MultiSelectSpecializationState();
}

class _MultiSelectSpecializationState extends State<MultiSelectSpecialization> {
  TextEditingController search = TextEditingController();

  List<StaticData?> searchSpecializationList = [];

  List<StaticData?> specializationList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getData();
  }

  void getData({String searchString = ''}) async {
    appStore.setLoading(true);

    await getStaticDataResponseAPI('specialization', searchString: searchString).then((value) {
      appStore.setLoading(false);
      specializationList.addAll(value.staticData!);
      searchSpecializationList.addAll(value.staticData!);
      setState(() {});
      multiSelectStore.clearStaticList();
      specializationList.forEach((element) {
        if (widget.selectedServicesId!.contains(element!.id)) {
          multiSelectStore.addSingleStaticItem(element, isClear: false);
          element.isSelected = true;
        }
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(appPrimaryColor, statusBarIconBrightness: Brightness.light);

    super.dispose();
  }

  onSearchTextChanged(String text) async {
    specializationList.clear();

    if (text.isEmpty) {
      specializationList.addAll(searchSpecializationList);
      setState(() {});
      return;
    }
    searchSpecializationList.forEach((element) {
      if (element!.value!.toLowerCase().contains(text)) specializationList.add(element);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblSpecialization, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.lblSelectSpecialization, style: boldTextStyle(size: 18)),
            Divider(),
            8.height,
            AppTextField(
              decoration: inputDecoration(context: context, labelText: locale.lblSearch),
              controller: search,
              onChanged: onSearchTextChanged,
              autoFocus: false,
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.OTHER,
              onFieldSubmitted: (searchString) {},
              suffix: Icon(
                Icons.search,
                color: appStore.isDarkModeOn ? Colors.grey : Colors.black,
                size: 25,
              ).appOnTap(
                () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
            8.height,
            ListView.builder(
              itemCount: specializationList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                StaticData data = specializationList[index]!;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: boxDecorationDefault(boxShadow: [], color: context.cardColor),
                  child: CheckboxListTile(
                    splashRadius: 16,
                    visualDensity: VisualDensity.compact,
                    controlAffinity: ListTileControlAffinity.leading,
                    checkboxShape: RoundedRectangleBorder(borderRadius: radius(6)),
                    contentPadding: EdgeInsets.zero,
                    value: data.isSelected,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onChanged: (v) {
                      data.isSelected = !data.isSelected;
                      if (v!) {
                        multiSelectStore.addSingleStaticItem(data, isClear: false);
                        widget.selectedServicesId.validate().add(data.id);
                      } else {
                        multiSelectStore.removeStaticItem(data);
                        widget.selectedServicesId.validate().remove(data.id);
                      }
                      setState(() {});
                    },
                    title: Text(data.label.validate(), maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()),
                  ),
                ).paddingSymmetric(vertical: 8);
              },
            ),
            Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading).center().paddingSymmetric(vertical: 120),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          finish(context, true);
        },
      ),
    );
  }
}
