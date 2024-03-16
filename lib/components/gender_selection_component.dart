import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/gender_model.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class GenderSelectionComponent extends StatefulWidget {
  final String? type;
  final Function(String value) onTap;

  GenderSelectionComponent({Key? key, this.type, required this.onTap}) : super(key: key);

  @override
  State<GenderSelectionComponent> createState() => _GenderSelectionComponentState();
}

class _GenderSelectionComponentState extends State<GenderSelectionComponent> {
  int selectedGender = -1;
  bool isUpdate = false;

  List<GenderModel> genderList = [
    GenderModel(name: locale.lblMale, icon: FontAwesomeIcons.person, value: "male"),
    GenderModel(name: locale.lblFemale, icon: FontAwesomeIcons.personDress, value: "female"),
    GenderModel(name: locale.lblOther, icon: FontAwesomeIcons.personDress, value: "other"),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    isUpdate = widget.type != null;

    if (isUpdate) {
      selectedGender = genderList.indexWhere((element) => element.value == widget.type.validate());
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(locale.lblGender1, style: secondaryTextStyle()),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              genderList.length,
              (index) {
                bool isSelected = selectedGender == index;

                return Container(
                  width: context.width() / 3 - 32,
                  decoration: boxDecorationDefault(borderRadius: radius(defaultRadius), color: context.cardColor),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: boxDecorationDefault(
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? primaryColor : secondaryTxtColor.withOpacity(0.5)),
                          color: Colors.transparent,
                        ),
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: isSelected ? primaryColor : context.cardColor),
                        ),
                      ),
                      10.width,
                      Text("${genderList[index].name.validate()}",
                              style: isSelected ? boldTextStyle(size: 14) : primaryTextStyle(size: 14), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)
                          .flexible(),
                    ],
                  ).paddingBottom(4).center(),
                ).appOnTap(
                  () {
                    if (isSelected) {
                      selectedGender = -1;
                    } else {
                      widget.onTap.call(genderList[index].value.validate());
                      selectedGender = index;
                    }
                    setState(() {});
                  },
                ).paddingRight(16);
              },
            ),
          ),
        ],
      ),
    );
  }
}
