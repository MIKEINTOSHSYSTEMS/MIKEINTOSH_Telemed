import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/internet_connectivity_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/ul_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/model/encounter_type_model.dart';
import 'package:momona_healthcare/model/prescription_model.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/screens/doctor/screens/bill_details_screen.dart';
import 'package:momona_healthcare/screens/patient/components/patient_report_component.dart';

class PatientEncounterDashboardScreen extends StatefulWidget {
  final String? id;

  final bool isPaymentDone;

  final VoidCallback? callBack;

  PatientEncounterDashboardScreen({Key? key, this.callBack, this.id, this.isPaymentDone = false}) : super(key: key);

  @override
  State<PatientEncounterDashboardScreen> createState() => _PatientEncounterDashboardScreenState();
}

class _PatientEncounterDashboardScreenState extends State<PatientEncounterDashboardScreen> {
  Future<EncounterModel>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getEncounterDetailsDashBoardAPI(encounterId: widget.id!.toInt()).then((value) {
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildHeaderWidget({required EncounterModel data}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: boxDecorationDefault(color: context.cardColor),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.lblName, style: secondaryTextStyle(size: 12)),
                Text(data.patientName.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblEmail, style: secondaryTextStyle(size: 12)),
                Text(data.patientEmail.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblEncounterDate, style: secondaryTextStyle(size: 12)),
                Text(data.encounterDate != null ? data.encounterDate.validate() : '', style: boldTextStyle()),
              ],
            ),
          ).expand(),
          16.width,
          Container(
            decoration: boxDecorationDefault(color: context.cardColor),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(locale.lblClinicName, style: secondaryTextStyle(size: 12)),
                Text(data.clinicName.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblDoctorName, style: secondaryTextStyle(size: 12)),
                Text(data.doctorName.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblDescription, style: secondaryTextStyle(size: 12)),
                Text(data.description.validate(value: " -- "), style: boldTextStyle()),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }

  Widget buildEncounterDetailsWidget({required EncounterModel data}) {
    return Container(
      padding: EdgeInsets.only(top: 28, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isVisible(SharedPreferenceKey.kiviCareMedicalRecordsListKey)) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.lblProblems, style: boldTextStyle()),
                    12.height,
                    if (data.problem.validate().isNotEmpty)
                      ULWidget(
                        customSymbol: Icon(Icons.arrow_forward, color: context.primaryColor, size: 16).paddingSymmetric(vertical: 2),
                        spacing: 4,
                        symbolType: SymbolTypeEnum.Custom,
                        children: List.generate(
                          data.problem.validate().length,
                          (index) {
                            EncounterType encounterData = data.problem.validate()[index];
                            return ReadMoreText(
                              encounterData.title.validate().capitalizeFirstLetter(),
                              style: secondaryTextStyle(size: 13),
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              colorClickableText: Colors.black,
                              trimExpandedText: ' ${locale.lblReadLess}',
                              trimCollapsedText: " ...${locale.lblReadMore}",
                            );
                          },
                        ),
                      )
                    else
                      Text(
                        locale.lblNoProblemFound.capitalizeEachWord(),
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.start,
                      ),
                  ],
                ).expand(),
                16.width,
              ],
            ),
            24.height,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.lblObservation, style: boldTextStyle()),
                    12.height,
                    if (data.observation.validate().isNotEmpty)
                      ULWidget(
                        customSymbol: Icon(Icons.arrow_forward, color: context.primaryColor, size: 16),
                        symbolCrossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          data.observation.validate().length,
                          (index) {
                            EncounterType encounterData = data.observation.validate()[index];
                            return ReadMoreText(
                              encounterData.title.validate().capitalizeFirstLetter(),
                              style: secondaryTextStyle(size: 13),
                              trimLength: 40,
                              trimMode: TrimMode.Length,
                              colorClickableText: Colors.black,
                              trimExpandedText: ' ${locale.lblReadLess}',
                              trimCollapsedText: " ...${locale.lblReadMore}",
                            );
                          },
                        ),
                      )
                    else
                      Text(locale.lblNoObservationsFound.capitalizeEachWord(), style: secondaryTextStyle()),
                  ],
                ).expand()
              ],
            ),
            24.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.lblNotes, style: boldTextStyle()),
                    12.height,
                    if (data.note.validate().isNotEmpty)
                      ULWidget(
                        customSymbol: Icon(Icons.arrow_forward, color: context.primaryColor, size: 16),
                        symbolType: SymbolTypeEnum.Custom,
                        children: List.generate(
                          data.note.validate().length,
                          (index) {
                            EncounterType encounterData = data.note.validate()[index];
                            return ReadMoreText(
                              encounterData.title.validate().capitalizeFirstLetter(),
                              style: secondaryTextStyle(size: 13),
                              trimLines: 3,
                              trimMode: TrimMode.Line,
                              colorClickableText: Colors.black,
                              trimExpandedText: ' ${locale.lblReadLess}',
                              trimCollapsedText: " ...${locale.lblReadMore}",
                            );
                          },
                        ),
                      )
                    else
                      Text(
                        locale.lblNoNotesFound.capitalizeEachWord(),
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.start,
                      ),
                  ],
                ).expand(),
              ],
            ),
          ],
          if (isVisible(SharedPreferenceKey.kiviCareMedicalRecordsListKey)) 32.height,
          if (data.prescription != null && isVisible(SharedPreferenceKey.kiviCarePrescriptionListKey))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(locale.lblPrescription, style: boldTextStyle()),
                12.height,
                if (data.prescription.validate().isNotEmpty)
                  UL(
                    symbolType: SymbolType.Numbered,
                    symbolCrossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      data.prescription!.validate().length,
                      (index) {
                        PrescriptionData encounterData = data.prescription!.validate()[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(locale.lblName, style: primaryTextStyle()),
                                    Divider(height: 8),
                                    Text(encounterData.name.validate().capitalizeFirstLetter(), style: secondaryTextStyle(color: Colors.black)),
                                  ],
                                ).expand(),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(locale.lblFrequency, style: primaryTextStyle()),
                                    Divider(height: 8),
                                    Text(encounterData.frequency.validate(), style: secondaryTextStyle(color: Colors.black)),
                                  ],
                                ).expand(),
                              ],
                            ),
                            if (encounterData.instruction.validate().isNotEmpty) 14.height,
                            if (encounterData.instruction.validate().isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(locale.lblInstruction, style: primaryTextStyle()),
                                  Text(encounterData.instruction.validate(), style: primaryTextStyle(size: 14)),
                                ],
                              )
                          ],
                        ).paddingBottom(8);
                      },
                    ),
                  )
                else
                  Text(locale.lblNoPrescriptionFound.capitalizeEachWord(), style: secondaryTextStyle()),
              ],
            ),
          if (isVisible(SharedPreferenceKey.kiviCarePatientReportKey)) 32.height,
          if (isVisible(SharedPreferenceKey.kiviCarePatientReportKey)) Text(locale.lblMedicalReports, style: boldTextStyle()),
          16.height,
          if (isVisible(SharedPreferenceKey.kiviCarePatientReportKey)) PatientReportComponent(reportList: data.reportData.validate())
        ],
      ),
    ).paddingBottom(60);
  }

  Widget buildBodyWidget() {
    return SnapHelperWidget<EncounterModel>(
      future: future,
      errorWidget: ErrorStateWidget(),
      loadingWidget: LoaderWidget(),
      onSuccess: (snap) {
        return AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          physics: AlwaysScrollableScrollPhysics(),
          onSwipeRefresh: () async {
            init();
            return await 2.seconds.delay;
          },
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: StatusWidget(
                status: snap.status.validate(),
                width: 80,
                isEncounterStatus: true,
              ),
            ).paddingBottom(16),
            buildHeaderWidget(data: snap),
            buildEncounterDetailsWidget(data: snap),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        locale.lblEncounterDashboard,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: InternetConnectivityWidget(
        retryCallback: () async {
          init();
          setState(() {});

          return await 1.seconds.delay;
        },
        child: buildBodyWidget(),
      ),
      floatingActionButton: widget.isPaymentDone
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              decoration: boxDecorationDefault(color: appSecondaryColor),
              child: Text(locale.lblBillDetails, style: primaryTextStyle(color: Colors.white)).appOnTap(
                () {
                  if (widget.isPaymentDone)
                    BillDetailsScreen(
                      encounterId: widget.id.validate().toInt(),
                      callBack: () {
                        widget.callBack?.call();
                      },
                    ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                },
              ),
            ).visible(isVisible(SharedPreferenceKey.kiviCarePatientBillViewKey))
          : Offstage(),
    );
  }
}
