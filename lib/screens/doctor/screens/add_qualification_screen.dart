import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/get_doctor_detail_model.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AddQualificationScreen extends StatefulWidget {
  Qualification? qualification;
  List<Qualification>? qualificationList;
  GetDoctorDetailModel? data;

  AddQualificationScreen({this.qualification, this.data, this.qualificationList});

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
  GetDoctorDetailModel? data;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    qualification = widget.qualification;
    data = widget.data;
    isUpdate = widget.qualification != null;
    if (isUpdate) {
      degreeCont.text = qualification!.degree!;
      universityCont.text = qualification!.university!;
      yearCont.text = qualification!.year!;
      selectedDate = DateFormat('yyyy').parse(qualification!.year!);
    }
  }

  void addQualificationData() async {
    appStore.setLoading(true);
    widget.qualificationList!.add(Qualification(
      university: universityCont.text,
      degree: degreeCont.text,
      year: yearCont.text,
      file: "",
    ));
    appStore.setLoading(false);
    finish(context);
  }

  void updateQualificationData() async {
    appStore.setLoading(true);
    widget.qualificationList![widget.qualificationList!.indexOf(widget.qualification!)] = Qualification(
      university: "${universityCont.text}",
      degree: "${degreeCont.text}",
      year: "${yearCont.text}",
      file: "",
    );
    appStore.setLoading(false);
    finish(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Body(
      child: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: degreeCont,
            focus: degreeFocus,
            textFieldType: TextFieldType.OTHER,
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblDegree,
            ).copyWith(suffixIcon: ic_degree.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
          ),
          20.height,
          AppTextField(
            controller: universityCont,
            focus: universityFocus,
            textFieldType: TextFieldType.OTHER,
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblUniversity,
            ).copyWith(suffixIcon: ic_collage.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
          ),
          20.height,
          AppTextField(
            controller: yearCont,
            focus: yearFocus,
            textFieldType: TextFieldType.OTHER,
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblYear,
            ).copyWith(suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return YearPicker(
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
                  );
                },
              );
            },
          ),
          20.height,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        !isUpdate ? locale.lblAddQualification : locale.lblEditQualification,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        textColor: Colors.white,
        actions: [
          if (isUpdate)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //TODO
              },
            ),
        ],
      ),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          showConfirmDialogCustom(
            context,
            dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
            primaryColor: context.primaryColor,
            title: "Are you sure you want to submit qualification?",
            onAccept: (p0) {
              isUpdate ? updateQualificationData() : addQualificationData();
            },
          );
          // isUpdate ? updateHolidays() : insertHolidays();
        },
      ),
    );
  }
}
