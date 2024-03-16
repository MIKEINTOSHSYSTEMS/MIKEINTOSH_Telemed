import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/generate_bill_screen.dart';
import 'package:momona_healthcare/screens/encounter/component/expandable_encounter_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/enums.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/screens/encounter/component/encounter_expandable_view.dart';

class EncounterDashboardScreen extends StatefulWidget {
  final String? encounterId;

  final VoidCallback? refreshAppointment;

  EncounterDashboardScreen({this.encounterId, this.refreshAppointment});

  @override
  State<EncounterDashboardScreen> createState() => _EncounterDashboardScreenState();
}

class _EncounterDashboardScreenState extends State<EncounterDashboardScreen> {
  Future<EncounterModel>? future;

  FilePickerResult? result;
  File? file;

  bool isBillPaid = false;

  bool isProblem = false, isNotes = false, isObservation = false, isPrescription = false, isMedicalReport = false;

  DateTime current = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    future = getEncounterDetailsDashBoardAPI(encounterId: widget.encounterId.toInt()).then((value) {
      isBillPaid = value.paymentStatus == 'paid';

      setState(() {});
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

  void closeEncounter({String? appointmentId, bool isCheckOut = false}) async {
    appStore.setLoading(true);
    Map<String, dynamic> request = {
      "encounter_id": widget.encounterId,
    };
    if (isCheckOut) {
      request.putIfAbsent("appointment_id", () => appointmentId.validate());
      request.putIfAbsent("appointment_status", () => CheckOutStatusInt);
    }

    await encounterClose(request).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, isCheckOut);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void _handleCloseEncounterClick({required EncounterModel encounterData, bool isCheckOut = false}) async {
    if (appStore.isLoading) return;

    if (isBillPaid && isCheckOut) {
      showConfirmDialogCustom(
        context,
        title: locale.lblEncounterWillBeClosed + ' & ' + locale.lblCheckOut,
        dialogType: DialogType.CONFIRMATION,
        onAccept: (p0) {
          closeEncounter(isCheckOut: isCheckOut, appointmentId: encounterData.appointmentId);
        },
      );
    } else {
      if (isBillPaid == false && encounterData.paymentStatus != null) {
        showConfirmDialogCustom(
          context,
          title: locale.lblEncounterWillBeClosed,
          dialogType: DialogType.CONFIRMATION,
          onAccept: (p0) {
            closeEncounter(appointmentId: encounterData.appointmentId, isCheckOut: false);
          },
        );
      } else {
        await GenerateBillScreen(data: encounterData).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
          if (value != null) {
            if (value == "paid") {
              init();
            }
            if (value == 'unpaid') {
              init();
            }
          }
        });
      }
    }
  }

  Widget encounterDetail({required EncounterModel encounterData}) {
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
                Text(encounterData.patientName.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblEmail, style: secondaryTextStyle(size: 12)),
                Text(encounterData.patientEmail.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblEncounterDate, style: secondaryTextStyle(size: 12)),
                Text(encounterData.encounterDate.validate(), style: boldTextStyle()),
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
                Text(encounterData.clinicName.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblDoctorName, style: secondaryTextStyle(size: 12)),
                Text(encounterData.doctorName.validate(), style: boldTextStyle()),
                8.height,
                Text(locale.lblDescription, style: secondaryTextStyle(size: 12)),
                Text(encounterData.description.validate(value: " -- "), style: boldTextStyle()),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }

  Widget buildExpandableWidget({
    required String title,
    required EncounterTypeEnum encounterType,
    required EncounterModel encounterData,
    required bool isExpanded,
    required Function() onTap,
    EncounterTypeValues? encounterTypeValue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
        child: AnimatedCrossFade(
          firstChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title.capitalizeFirstLetter(), style: secondaryTextStyle(size: 16)),
              (isExpanded ? ic_arrow_up : ic_arrow_down).iconImage(size: 16, color: context.iconColor).paddingAll(14).onTap(onTap),
            ],
          ),
          secondChild: Stack(
            children: [
              Column(
                children: [
                  Divider(thickness: 1, color: context.dividerColor, height: 2),
                  4.height,
                  EncounterExpandableView(
                    encounterType: title,
                    encounterData: encounterData,
                    callForRefresh: () async {
                      init();
                    },
                  ),
                ],
              ).paddingTop(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title.capitalizeFirstLetter(), style: secondaryTextStyle(size: 16)),
                  (isExpanded ? ic_arrow_up : ic_arrow_down).iconImage(size: 16, color: context.iconColor).paddingAll(14).onTap(onTap),
                ],
              ),
            ],
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: 600.milliseconds,
          firstCurve: Curves.bounceInOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: appBarWidget(
        locale.lblEncounterDashboard,
        titleTextStyle: boldTextStyle(color: textPrimaryDarkColor, size: 18),
        color: appPrimaryColor,
        elevation: 0,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        textColor: Colors.white,
      ),
      body: Stack(
        children: [
          FutureBuilder<EncounterModel>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                EncounterModel encounterData = snap.requireData;
                return Stack(
                  children: [
                    AnimatedScrollView(
                      listAnimationType: ListAnimationType.None,
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 500),
                      onSwipeRefresh: () async {
                        init();
                        return await 1.seconds.delay;
                      },
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: StatusWidget(
                            width: 80,
                            status: encounterData.status.validate(),
                            isEncounterStatus: true,
                          ),
                        ),
                        12.height,
                        encounterDetail(encounterData: encounterData).paddingSymmetric(vertical: 6),

                        //region Others
                        if (isVisible(SharedPreferenceKey.kiviCareMedicalRecordsListKey)) ...[
                          16.height,
                          ExpandableEncounterComponent(
                            title: PROBLEM,
                            isExpanded: isProblem,
                            encounterData: encounterData,
                            encounterType: EncounterTypeEnum.OTHERS,
                            encounterTypeValue: EncounterTypeValues.PROBLEM,
                            refreshCallBack: () {
                              init();
                            },
                          ),
                          16.height,
                          ExpandableEncounterComponent(
                            title: OBSERVATION,
                            encounterData: encounterData,
                            isExpanded: isObservation,
                            encounterTypeValue: EncounterTypeValues.OBSERVATION,
                            encounterType: EncounterTypeEnum.OTHERS,
                            refreshCallBack: () {
                              init();
                            },
                          ),
                          16.height,
                          ExpandableEncounterComponent(
                            title: NOTE,
                            isExpanded: isNotes,
                            encounterData: encounterData,
                            encounterTypeValue: EncounterTypeValues.NOTE,
                            encounterType: EncounterTypeEnum.OTHERS,
                            refreshCallBack: () {
                              init();
                            },
                          )
                        ],
                        16.height,
                        //endregion
                        //region Prescriptions
                        ExpandableEncounterComponent(
                          title: PRESCRIPTION,
                          isExpanded: isPrescription,
                          encounterData: encounterData,
                          encounterType: EncounterTypeEnum.PRESCRIPTIONS,
                          refreshCallBack: () {
                            init();
                          },
                        ),
                        16.height,
                        //endregion
                        //region Medical Report
                        ExpandableEncounterComponent(
                          title: REPORT,
                          encounterData: encounterData,
                          encounterType: EncounterTypeEnum.REPORTS,
                          isExpanded: isMedicalReport,
                          refreshCallBack: () {
                            init();
                          },
                        ),

                        //endregion
                      ],
                    ),
                    if ((encounterData.status == '1') && (isDoctor() || isReceptionist()) && isVisible(SharedPreferenceKey.kiviCarePatientBillAddKey))
                      Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                8.height,
                                Text('\t${locale.lblNote}: ${locale.lblToCloseTheEncounterInvoicePaymentIsMandatory}', style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                                8.height,
                                Row(
                                  children: [
                                    AppButton(
                                      text: isBillPaid ? '${locale.lblClose} & ${locale.lblCheckOut}' : locale.lblClose,
                                      color: context.cardColor,
                                      textStyle: primaryTextStyle(color: Colors.red),
                                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: Colors.red)),
                                      onTap: () async {
                                        _handleCloseEncounterClick(encounterData: encounterData, isCheckOut: true);
                                      },
                                    ).expand(),
                                    16.width,
                                    AppButton(
                                      text: locale.lblBillDetails,
                                      color: context.cardColor,
                                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: Colors.red)),
                                      textStyle: primaryTextStyle(color: Colors.red),
                                      onTap: () async {
                                        await GenerateBillScreen(
                                          data: encounterData,
                                        ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                                          if (value != null) {
                                            if (value == "paid") {
                                              init();
                                            }
                                            if (value == 'unpaid') {
                                              init();
                                            }
                                          }
                                        });
                                      },
                                    ).expand(),
                                  ],
                                ),
                              ],
                            ).paddingOnly(left: 16, right: 16, bottom: 16, top: 0),
                            decoration: boxDecorationDefault(
                              color: context.scaffoldBackgroundColor,
                            ),
                          ))
                  ],
                );
              }
              return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
            },
          ),
          Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading).center(),
          )
        ],
      ),
    );
  }
}
