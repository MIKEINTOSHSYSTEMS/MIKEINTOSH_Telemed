import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/app_setting_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/encounter/screen/encounter_list_screen.dart';
import 'package:momona_healthcare/screens/patient/screens/my_bill_records_screen.dart';
import 'package:momona_healthcare/screens/patient/screens/my_report_screen.dart';
import 'package:momona_healthcare/screens/patient/screens/patient_clinic_selection_screen.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class GeneralSettingComponent extends StatelessWidget {
  final VoidCallback? callBack;
  GeneralSettingComponent({this.callBack});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16,
      runSpacing: 16,
      children: [
        if (isVisible(SharedPreferenceKey.kiviCarePatientEncounterListKey))
          AppSettingWidget(
            name: locale.lblEncounters,
            image: ic_services,
            widget: EncounterListScreen(),
            subTitle: locale.lblYourEncounters,
          ),
        if (isVisible(SharedPreferenceKey.kiviCarePatientReportKey))
          AppSettingWidget(
            name: locale.lblMedicalReports,
            image: ic_reports,
            widget: MyReportsScreen(),
            subTitle: locale.lblYourReports,
          ),
        if (isVisible(SharedPreferenceKey.kiviCarePatientBillListKey) && isProEnabled())
          AppSettingWidget(
            name: locale.lblBillingRecords,
            image: ic_bill,
            widget: MyBillRecordsScreen(),
            subTitle: locale.lblYourBills,
          ),
        if (isVisible(SharedPreferenceKey.kiviCarePatientClinicKey))
          AppSettingWidget(
            name: locale.lblChangeYourClinic,
            image: ic_clinic,
            widget: PatientClinicSelectionScreen(callback: () {
              callBack?.call();
            }),
            subTitle: locale.lblChooseYourFavouriteClinic,
          ),
      ],
    );
  }
}
