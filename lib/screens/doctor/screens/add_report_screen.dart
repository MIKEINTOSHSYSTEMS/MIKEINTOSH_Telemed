import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/report_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AddReportScreen extends StatefulWidget {
  final int? patientId;

  AddReportScreen({this.patientId});

  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();
  TextEditingController fileCont = TextEditingController();

  int pages = 0;
  int currentPage = 0;

  bool isReady = false;

  String errorMessage = '';

  DateTime current = DateTime.now();

  FilePickerResult? result;
  File? file;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
  }

  void PickSingleFile() async {
    result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result!.files.single.path!);

      fileCont.text = file!.path.substring(file!.path.lastIndexOf("/") + 1);
      setState(() {});
    } else {
      toast(locale.lblNoReportWasSelected);
    }
  }

  void saveData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map<String, dynamic> res = {
        "name": "${nameCont.text}",
        "patient_id": "${widget.patientId}",
        "date": "${current.getFormattedDate(CONVERT_DATE)}",
      };

      await addReportData(res, file: file != null ? File(file!.path) : null).then((value) {
        finish(context, true);
      }).catchError((e) {
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  Widget buildBodyWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            AppTextField(controller: nameCont, textFieldType: TextFieldType.NAME, decoration: inputDecoration(context: context, labelText: locale.lblName)),
            16.height,
            AppTextField(
              onTap: () async {
                DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: current,
                  firstDate: DateTime(1900),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: appStore.isDarkModeOn
                          ? ThemeData.dark()
                          : ThemeData.light().copyWith(
                              primaryColor: Color(0xFF4974dc),
                              accentColor: const Color(0xFF4974dc),
                              colorScheme: ColorScheme.light(primary: const Color(0xFF4974dc)),
                            ),
                      child: child!,
                    );
                  },
                  lastDate: DateTime.now(),
                );
                if (dateTime != null) {
                  dateCont.text = dateTime.getFormattedDate(APPOINTMENT_DATE_FORMAT);
                  current = dateTime;
                }
              },
              controller: dateCont,
              readOnly: true,
              textFieldType: TextFieldType.OTHER,
              validator: (s) {
                if (s!.trim().isEmpty) return locale.lblDatecantBeNull;
                return null;
              },
              decoration: inputDecoration(context: context, labelText: locale.lblDate).copyWith(
                suffixIcon: Icon(Icons.date_range),
              ),
            ),
            16.height,
            AppTextField(
              controller: fileCont,
              textFieldType: TextFieldType.NAME,
              decoration: inputDecoration(context: context, labelText: locale.lblUploadReport).copyWith(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () {
                        PickSingleFile();
                      },
                    ),
                    file == null
                        ? Offstage()
                        : IconButton(
                            icon: Icon(Icons.remove_red_eye_outlined),
                            onPressed: () {
                              //
                            },
                          ),
                  ],
                ),
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAddReportScreen, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(child: buildBodyWidget()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveData();
        },
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
