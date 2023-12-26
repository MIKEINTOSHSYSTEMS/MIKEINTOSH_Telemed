import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class DFileUploadComponent extends StatefulWidget {
  @override
  State<DFileUploadComponent> createState() => _DFileUploadComponentState();
}

class _DFileUploadComponentState extends State<DFileUploadComponent> {
  TextEditingController fileCont = TextEditingController();

  FilePickerResult? result;

  File? file;

  init() async {
    setStatusBarColor(appStore.isDarkModeOn ? scaffoldDarkColor : primaryColor);
  }

  void pickSingleFile() async {
    if (isProEnabled()) {
      result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);
    } else {
      result = await FilePicker.platform.pickFiles();
    }

    if (result != null) {
      appointmentAppStore.addReportData(data: result!.files);
      fileCont.text = "${appointmentAppStore.reportList.length} ${locale.lblFilesSelected}";
    } else {
      toast(locale.lblNoReportWasSelected);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: fileCont,
            textFieldType: TextFieldType.OTHER,
            readOnly: true,
            decoration: inputDecoration(context: context, labelText: locale.lblAddMedicalReport).copyWith(
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.upload_file),
                    iconSize: 18,
                    onPressed: () {
                      pickSingleFile();
                    },
                  ),
                ],
              ),
            ),
          ),
          if (appointmentAppStore.reportList.isNotEmpty) 16.height,
          if (appointmentAppStore.reportList.isNotEmpty)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                appointmentAppStore.reportList.length,
                (index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: boxDecorationDefault(
                          boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
                          border: Border.all(color: context.dividerColor),
                        ),
                        padding: EdgeInsets.all(32),
                        child: appointmentAppStore.reportList[index].path.validate().isImage ? Icon(Icons.image) : Icon(Icons.picture_as_pdf_outlined),
                      ),
                      Positioned(
                        right: -20,
                        top: -20,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red, size: 20),
                          onPressed: () {
                            appointmentAppStore.removeReportData(index: index);

                            fileCont.text = "${appointmentAppStore.reportList.length} ${locale.lblFilesSelected}";
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          if (appointmentAppStore.reportListString.isNotEmpty) 16.height,
          if (appointmentAppStore.reportListString.isNotEmpty)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                appointmentAppStore.reportListString.length,
                (index) {
                  AppointmentReport data = appointmentAppStore.reportListString[index];
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SettingItemWidget(
                        width: context.width() / 2 - 26,
                        decoration: boxDecorationDefault(color: context.cardColor),
                        title: '${locale.lblMedicalReport} ${index + 1}',
                        trailing: IconButton(
                          onPressed: () {
                            commonLaunchUrl("${data.url}");
                          },
                          visualDensity: VisualDensity.compact,
                          icon: Icon(Icons.remove_red_eye_outlined),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (appointmentAppStore.reportListString.isNotEmpty) 16.height,
        ],
      ),
    );
  }
}
