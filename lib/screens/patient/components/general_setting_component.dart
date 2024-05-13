import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/app_setting_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/encounter/screen/encounter_list_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/my_bill_records_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/my_report_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/patient_clinic_selection_screen.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/images.dart';
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
