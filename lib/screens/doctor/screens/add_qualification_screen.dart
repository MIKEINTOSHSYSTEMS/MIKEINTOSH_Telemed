import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/qualification_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddQualificationScreen extends StatefulWidget {
  final Qualification? qualification;
  final Function(Qualification)? onSubmit;

  AddQualificationScreen({this.qualification, this.onSubmit});

  @override
  _AddQualificationScreenState createState() => _AddQualificationScreenState();
}

class _AddQualificationScreenState extends State<AddQualificationScreen> {
  TextEditingController degreeCont = TextEditingController();
  TextEditingController universityCont = TextEditingController();
  TextEditingController yearCont = TextEditingController();

  FocusNode degreeFocus = FocusNode();
  FocusNode universityFocus = FocusNode();
  FocusNode yearFocus = FocusNode();

  DateTime selectedDate = DateTime.now();

  Qualification? qualification;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    qualification = widget.qualification;
    isUpdate = widget.qualification != null;
    if (isUpdate) {
      degreeCont.text = qualification!.degree!;
      universityCont.text = qualification!.university!;
      yearCont.text = qualification!.year!;
      selectedDate = DateFormat('yyyy').parse(qualification!.year!);
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
    return AnimatedScrollView(
      padding: EdgeInsets.all(16),
      listAnimationType: ListAnimationType.None,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 4,
          width: 60,
          decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radius()),
        ).center(),
        4.height,
        Text(
          '${locale.lblAdd} ${locale.lblQualification}',
          style: boldTextStyle(size: 18),
          textAlign: TextAlign.center,
        ).paddingSymmetric(vertical: 8),
        Divider(
          height: 0,
          endIndent: 16,
          indent: 16,
          color: context.dividerColor,
        ),
        16.height,
        AppTextField(
          controller: degreeCont,
          focus: degreeFocus,
          textFieldType: TextFieldType.OTHER,
          textInputAction: TextInputAction.next,
          decoration: inputDecoration(
            context: context,
            labelText: locale.lblDegree,
            suffixIcon: ic_degree.iconImage(size: 10, color: context.iconColor).paddingAll(14),
          ),
        ),
        16.height,
        AppTextField(
          controller: universityCont,
          focus: universityFocus,
          textInputAction: TextInputAction.next,
          textFieldType: TextFieldType.OTHER,
          decoration: inputDecoration(
            context: context,
            labelText: locale.lblUniversity,
            suffixIcon: ic_collage.iconImage(size: 10, color: context.iconColor).paddingAll(14),
          ),
        ),
        16.height,
        AppTextField(
          controller: yearCont,
          focus: yearFocus,
          textInputAction: TextInputAction.done,
          textFieldType: TextFieldType.OTHER,
          decoration: inputDecoration(
            context: context,
            labelText: locale.lblYear,
            suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14),
          ),
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Container(
                      height: 4,
                      width: 60,
                      decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radius()),
                    ).center(),
                    16.height,
                    8.height,
                    YearPicker(
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      dragStartBehavior: DragStartBehavior.start,
                      selectedDate: selectedDate,
                      onChanged: (s) {
                        finish(context);
                        yearCont.text = s.year.toString();
                        selectedDate = s;
                        setState(() {});
                      },
                    ).expand(),
                  ],
                );
              },
            );
          },
        ),
        20.height,
        AppButton(
            width: context.width() - 32,
            padding: EdgeInsets.symmetric(vertical: 10),
            onTap: () {
              widget.onSubmit?.call(Qualification(
                university: universityCont.text,
                degree: degreeCont.text,
                year: yearCont.text,
              ));
              finish(context);
            },
            color: appSecondaryColor,
            text: locale.lblSave)
      ],
    );
  }
}
