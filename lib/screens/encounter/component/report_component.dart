import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/report_model.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_report_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportComponent extends StatelessWidget {
  final ReportData reportData;
  final VoidCallback? deleteReportData;
  final VoidCallback? refreshReportData;
  final bool isForMyReportScreen;
  final bool showDelete;

  ReportComponent({required this.reportData, this.deleteReportData, this.refreshReportData, this.isForMyReportScreen = false, this.showDelete = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(color: isForMyReportScreen ? context.cardColor : context.scaffoldBackgroundColor),
      margin: EdgeInsets.only(top: 8, bottom: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          if (reportData.uploadReport != null && reportData.uploadReport.validate().isNotEmpty)
            Image(
              height: 40,
              width: 40,
              image: AssetImage(reportData.uploadReport!.fileFormatImage()),
            )
          else
            Image(image: AssetImage(ic_invalidURL), color: grey.withOpacity(0.2), height: 30, width: 30),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${reportData.name.validate()}", style: boldTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
              4.height,
              Text(reportData.date.validate(), style: secondaryTextStyle(size: 10)),
            ],
          ).expand(),
          8.width,
          Row(
            children: [
              if (reportData.uploadReport.validate().isNotEmpty)
                TextButton(
                  onPressed: () {
                    commonLaunchUrl(reportData.uploadReport.validate(), launchMode: LaunchMode.externalApplication);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.scaffoldBackgroundColor))),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 0),
                    ),
                  ),
                  child: Text('${locale.lblViewFile}', style: primaryTextStyle(size: 12)),
                ).visible(isVisible(SharedPreferenceKey.kiviCarePatientReportViewKey)),
              if (showDelete && isVisible(SharedPreferenceKey.kiviCarePatientReportDeleteKey))
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.delete, size: 20, color: iconColor),
                  onPressed: deleteReportData,
                ),
            ],
          ),
          8.height,
        ],
      ),
    ).appOnTap(() {
      if (isVisible(SharedPreferenceKey.kiviCarePatientReportEditKey) && !isPatient())
        AddReportScreen(
          patientId: reportData.patientId.validate().toInt(),
          reportData: reportData,
        ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
          if (value ?? false) {
            refreshReportData?.call();
          }
        });
    });
  }
}
