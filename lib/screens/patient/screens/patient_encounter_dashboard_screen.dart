import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/bill_details_screen.dart';
import 'package:momona_healthcare/screens/patient/components/precription_widget.dart';
import 'package:momona_healthcare/screens/patient/components/problem_list_widget.dart';
import 'package:momona_healthcare/screens/patient/models/patient_encounter_dashboard_model.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/patient_report_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';

class PatientEncounterDashboardScreen extends StatefulWidget {
  final int? id;

  PatientEncounterDashboardScreen({this.id});

  @override
  _PatientEncounterDashboardScreenState createState() => _PatientEncounterDashboardScreenState();
}

class _PatientEncounterDashboardScreenState extends State<PatientEncounterDashboardScreen> {
  int? encounterId;
  List<Widget> dataWidgets = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget profileDetailFragment(PatientEncounterDashboardModel data) {
    return Container(
      child: Column(
        children: [
          if (data.payment_status == 'paid')
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: boxDecorationDefault(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book, color: primaryColor, size: 20),
                    4.width,
                    Text(locale.lblBillDetails, style: primaryTextStyle(color: primaryColor)),
                    4.width,
                  ],
                ),
              ).onTap(() {
                BillDetailsScreen(encounterId: data.id.toInt()).launch(context);
              }),
            ),
          8.height,
          //Divider(color: viewLineColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.lblName + ':', style: secondaryTextStyle(size: 16)),
                  8.height,
                  Text(locale.lblEmail + ':', style: secondaryTextStyle(size: 16)),
                  8.height,
                  Text(locale.lblEncounterDate + ':', style: secondaryTextStyle(size: 16)),
                  8.height,
                  Text(locale.lblClinicName + ':', style: secondaryTextStyle(size: 16)),
                  8.height,
                  Text(locale.lblDoctorName + ':', style: secondaryTextStyle(size: 16)),
                  8.height,
                  if (data.description.validate().isNotEmpty) Text(locale.lblDesc + ':', style: secondaryTextStyle(size: 16)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data.patient_name.validate()}', style: boldTextStyle(size: 16)),
                  8.height,
                  Text('${data.patient_email.validate()}', style: boldTextStyle(size: 16)),
                  8.height,
                  Text('${data.encounter_date.validate()}'.capitalizeFirstLetter(), style: boldTextStyle(size: 16)),
                  8.height,
                  Text('${data.clinic_name.validate()}', style: boldTextStyle(size: 16)),
                  8.height,
                  Text('${data.doctor_name.validate()}', style: boldTextStyle(size: 16)),
                  8.height,
                  if (data.description.validate().isNotEmpty) Text('${data.description.validate()}'.capitalizeFirstLetter(), style: boldTextStyle(size: 16)),
                ],
              )
            ],
          ),
          4.height,
          Divider(color: viewLineColor),
          4.height,
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 120,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: boxDecorationDefault(color: getEncounterStatusColor(data.status).withOpacity(0.2), borderRadius: BorderRadius.circular(defaultRadius)),
              child: Text(
                "${getEncounterStatus(data.status.validate())}".toUpperCase(),
                style: boldTextStyle(size: 12, color: getEncounterStatusColor(data.status)),
              ).center(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblEncounterDashboard, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: FutureBuilder<PatientEncounterDashboardModel>(
        future: getPatientEncounterDetailsDashBoard(widget.id!.toInt()),
        builder: (_, snap) {
          if (snap.hasData) {
            encounterId = snap.data!.id.validate().toInt();
            if (dataWidgets.isEmpty) {
              if (getBoolAsync(USER_PRO_ENABLED)) {
                snap.data!.enocunter_modules.validate().forEach((element) {
                  if (element.status.toInt() == 1) {
                    if (element.name == "problem") {
                      dataWidgets.add(ProblemListWidget(medicalHistory: snap.data!.problem, encounterType: PROBLEM));
                      dataWidgets.add(Divider(color: viewLineColor));
                    } else if (element.name == "observation") {
                      dataWidgets.add(ProblemListWidget(medicalHistory: snap.data!.observation, encounterType: OBSERVATION));
                      dataWidgets.add(Divider(color: viewLineColor));
                    } else if (element.name == "note") {
                      dataWidgets.add(ProblemListWidget(medicalHistory: snap.data!.note, encounterType: NOTE));
                      dataWidgets.add(Divider(color: viewLineColor));
                    }
                  }
                });

                snap.data!.prescription_module.validate().forEach((element) {
                  if (element.status.toInt() == 1) {
                    if (element.name == "prescription") {
                      dataWidgets.add(PrescriptionWidget(prescription: snap.data!.prescription));
                    }
                  }
                });
              } else {
                dataWidgets.add(ProblemListWidget(medicalHistory: snap.data!.problem, encounterType: PROBLEM));
                dataWidgets.add(Divider(color: viewLineColor));

                dataWidgets.add(ProblemListWidget(medicalHistory: snap.data!.observation, encounterType: OBSERVATION));
                dataWidgets.add(Divider(color: viewLineColor));

                dataWidgets.add(ProblemListWidget(medicalHistory: snap.data!.note, encounterType: NOTE));
                dataWidgets.add(Divider(color: viewLineColor));

                dataWidgets.add(PrescriptionWidget(prescription: snap.data!.prescription));
              }
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: AnimatedScrollView(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileDetailFragment(snap.data!),
                  16.height,
                  isProEnabled()
                      ? Container(
                          decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, border: Border.all(color: context.dividerColor)),
                          padding: EdgeInsets.all(16),
                          child: Text(locale.lblViewAllReports, style: boldTextStyle()).center().onTap(() {
                            PatientReportScreen(patientId: snap.data!.patient_id.toInt()).launch(context);
                          }),
                        )
                      : Offstage(),
                  16.height,
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: dataWidgets,
                  ),
                ],
              ),
            );
          } else {
            return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
          }
        },
      ),
    );
  }
}
