import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/report_model.dart';
import 'package:kivicare_flutter/network/report_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AddReportScreen extends StatefulWidget {
  final int? patientId;
  final ReportData? reportData;

  AddReportScreen({this.patientId, this.reportData});

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
  bool isUpdate = false;
  bool isFirstTime = true;

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
    isUpdate = widget.reportData != null;

    if (isUpdate) {
      nameCont.text = widget.reportData!.name.validate();
      if (widget.reportData!.date.validate().isNotEmpty) {
        current = DateFormat(SAVE_DATE_FORMAT).parse(widget.reportData!.reportDate.validate());
        dateCont.text = current.getFormattedDate(SAVE_DATE_FORMAT);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pickSingleFile() async {
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

      Map<String, dynamic> req = {
        "name": "${nameCont.text}",
        "patient_id": isPatient() ? userStore.userId : "${widget.patientId}",
        "date": "${current.getFormattedDate(SAVE_DATE_FORMAT)}",
      };
      if (isUpdate) {
        req.putIfAbsent('id', () => widget.reportData!.id.validate().toString());
      }

      if (!isUpdate && file == null) {
        toast(locale.lblPleaseUploadReport);
        return;
      }

      await addReportDataAPI(req, file: file != null ? File(file!.path) : null).then((value) {
        if (isUpdate)
          toast(locale.lblReportUpdatedSuccessfully);
        else
          toast(value.message);

        appStore.setLoading(false);
        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.message);
      });
    } else {
      isFirstTime = !isFirstTime;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAddReportScreen, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AppTextField(controller: nameCont, textFieldType: TextFieldType.NAME, decoration: inputDecoration(context: context, labelText: locale.lblName)),
                  16.height,
                  AppTextField(
                    keyboardAppearance: appStore.isDarkModeOn ? Brightness.dark : Brightness.light,
                    selectionControls: EmptyTextSelectionControls(),
                    onTap: () async {
                      datePickerComponent(
                        context,
                        initialDate: current,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        helpText: locale.lblSelectReportDate,
                        onDateSelected: (selectedDate) {
                          if (selectedDate != null) {
                            current = selectedDate;
                            dateCont.text = selectedDate.getFormattedDate(SAVE_DATE_FORMAT);
                            setState(() {});
                          }
                        },
                      );
                    },
                    controller: dateCont,
                    readOnly: true,
                    textFieldType: TextFieldType.OTHER,
                    validator: (s) {
                      if (s!.trim().isEmpty) return locale.lblDateCantBeNull;
                      return null;
                    },
                    decoration: inputDecoration(
                      context: context,
                      labelText: locale.lblDate,
                      suffixIcon: Icon(Icons.date_range),
                    ),
                  ),
                  16.height,
                  Container(
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Row(
                      children: [
                        Text(
                          isUpdate
                              ? file == null
                                  ? locale.lblUploadReport
                                  : fileCont.text
                              : fileCont.text,
                          style: secondaryTextStyle(),
                        ).paddingLeft(16).expand(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isUpdate && file == null && widget.reportData!.uploadReport.validateURL())
                              TextButton(
                                onPressed: () {
                                  commonLaunchUrl(widget.reportData!.uploadReport.validate(), launchMode: LaunchMode.externalApplication);
                                },
                                style: ButtonStyle(
                                  visualDensity: VisualDensity.compact,
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 0),
                                  ),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.scaffoldBackgroundColor))),
                                ),
                                child: Text('${locale.lblViewFile}', style: primaryTextStyle(size: 10)),
                              ),
                            IconButton(
                              icon: Icon(Icons.upload_file, color: context.iconColor),
                              onPressed: () {
                                pickSingleFile();
                              },
                            ),
                            if (file != null)
                              IconButton(
                                icon: Icon(Icons.remove_red_eye_outlined),
                                onPressed: () {
                                  if (file != null) {
                                    OpenFile.open(file?.path);
                                  }
                                },
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading).center(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
