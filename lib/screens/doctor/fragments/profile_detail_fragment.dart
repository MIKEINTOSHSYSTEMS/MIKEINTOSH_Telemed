import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/encounter_dashboard_model.dart';
import 'package:kivicare_flutter/model/report_model.dart';
import 'package:kivicare_flutter/network/appointment_respository.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/network/report_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_report_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/bill_details_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/generate_bill_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/int_extesnions.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileDetailFragment extends StatefulWidget {
  final int? encounterId;
  final EncounterDashboardModel? patientEncounterDetailData;
  final bool? isStatusBack;

  ProfileDetailFragment({this.encounterId, this.patientEncounterDetailData, this.isStatusBack = false});

  @override
  _ProfileDetailFragmentState createState() => _ProfileDetailFragmentState();
}

class _ProfileDetailFragmentState extends State<ProfileDetailFragment> {
  EncounterDashboardModel? patientEncounterDetailData;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    patientEncounterDetailData = widget.patientEncounterDetailData;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isStatusBack ?? false) {
      setDynamicStatusBarColor(color: appPrimaryColor);
    } else {
      getDisposeStatusBarColor();
    }
  }

  closeEncounter() {
    appStore.setLoading(true);
    setState(() {});
    Map<String, dynamic> request = {
      "encounter_id": patientEncounterDetailData?.id,
    };
    encounterClose(request).then((value) {
      toast(locale.lblEncounterClosed);
      LiveStream().emit(UPDATE, true);
      LiveStream().emit(APP_UPDATE, true);
      finish(context);
    }).catchError(((e) {
      toast(e.toString());
    }));
    appStore.setLoading(false);
  }

  updateStatus({int? id, int? status}) {
    Map<String, dynamic> request = {
      "appointment_id": id.toString(),
      "appointment_status": status.toString(),
    };
    updateAppointmentStatus(request).then((value) {
      LiveStream().emit(UPDATE, true);
      LiveStream().emit(APP_UPDATE, true);
      toast(locale.lblChangedTo + " ${status.getStatus()}");
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  Widget reportWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(locale.lblMedicalReport, style: boldTextStyle(size: 18)).expand(),
            Text(locale.lblNewMedicalReport, style: secondaryTextStyle(size: 14)).onTap(
              () async {
                bool? res = await AddReportScreen(patientId: patientEncounterDetailData?.patient_id.toInt()).launch(context);
                if (res ?? false) {
                  setState(() {});
                }
              },
            ).visible(patientEncounterDetailData!.payment_status.validate() != 'paid')
          ],
        ),
        Divider(),
        FutureBuilder<ReportModel>(
          future: getReportData(patientId: patientEncounterDetailData?.patient_id.toInt()),
          builder: (_, snap) {
            if (snap.hasData) {
              if (snap.data!.reportData.validate().isEmpty) return NoDataFoundWidget(text: "No Reports").center();
              return Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snap.data!.reportData.validate().length,
                  itemBuilder: (context, index) {
                    ReportData data = snap.data!.reportData![index];
                    DateTime tempDate = new DateFormat(CONVERT_DATE).parse(data.date!);

                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        border: Border.all(color: context.dividerColor),
                        color: context.scaffoldBackgroundColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: tempDate.day.toString(), style: boldTextStyle(size: 18)),
                                      WidgetSpan(
                                        child: Transform.translate(
                                          offset: const Offset(2, -10),
                                          child: Text(
                                            getDayOfMonthSuffix(tempDate.day).toString(),
                                            textScaleFactor: 0.7,
                                            style: boldTextStyle(size: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(tempDate.month.getMonthName(), textAlign: TextAlign.center, style: secondaryTextStyle(size: 14)),
                              ],
                            ),
                          ),
                          VerticalDivider(color: viewLineColor, width: 25, thickness: 1, indent: 1, endIndent: 1).withHeight(50),
                          Text('${data.name}', style: boldTextStyle(size: 18)).expand(),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.8)),
                                onPressed: () {
                                  //
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, color: primaryColor),
                                onPressed: () {
                                  commonLaunchUrl("https://docs.google.com/viewer?url=${data.upload_report_url}");
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      padding: EdgeInsets.all(16),
      children: [
        if (patientEncounterDetailData?.is_billing ?? false)
          if (patientEncounterDetailData?.payment_status != 'paid' || patientEncounterDetailData?.payment_status == null)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: boxDecorationDefault(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear, color: Colors.red, size: 20),
                    4.width,
                    Text(locale.lblEncounterClose, style: boldTextStyle(color: Colors.red)),
                    4.width,
                  ],
                ),
              ).onTap(() async {
                if (patientEncounterDetailData!.is_billing!) {
                  if (patientEncounterDetailData?.bill_id == null) {
                    GenerateBillScreen(
                      data: patientEncounterDetailData,
                    ).launch(context);
                  } else {
                    GenerateBillScreen(
                      data: patientEncounterDetailData,
                    ).launch(context);
                  }
                } else {
                  showConfirmDialogCustom(
                    context,
                    title: locale.lblEncounterWillBeClosed,
                    dialogType: DialogType.CONFIRMATION,
                    onAccept: (p0) {
                      closeEncounter();
                    },
                  );
                }
              }),
            )
          else
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: boxDecorationDefault(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius)),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.book, color: primaryColor, size: 20),
                    4.width,
                    Text(locale.lblBillDetails, style: boldTextStyle(color: primaryColor)),
                    4.width,
                  ],
                ),
              ).onTap(() {
                BillDetailsScreen(encounterId: patientEncounterDetailData?.id.toInt()).launch(context); //
              }),
            ),
        8.height,
        Divider(color: viewLineColor),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.lblName + ' :', style: secondaryTextStyle(size: 16)),
            2.width,
            Text('${patientEncounterDetailData?.patient_name}', style: boldTextStyle(size: 16)).expand(),
          ],
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.lblEmail + ' :', style: secondaryTextStyle(size: 16)),
            2.width,
            Text('${patientEncounterDetailData?.patient_email}', style: boldTextStyle(size: 16)).expand(),
          ],
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.lblEncounterDate + ' :', style: secondaryTextStyle(size: 16)),
            2.width,
            Text('${patientEncounterDetailData?.encounter_date.validate()}'.capitalizeFirstLetter(), style: boldTextStyle(size: 16)).expand(),
          ],
        ),
        4.height,
        Divider(color: viewLineColor),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.lblClinicName + ' :', style: secondaryTextStyle(size: 16)),
            2.width,
            Text('${patientEncounterDetailData?.clinic_name.validate()}', style: boldTextStyle(size: 16)).expand(),
          ],
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.lblDoctorName + ' :', style: secondaryTextStyle(size: 16)),
            2.width,
            Text('${patientEncounterDetailData?.doctor_name.validate()}', style: boldTextStyle(size: 16)).expand(),
          ],
        ),
        8.height,
        if (patientEncounterDetailData!.description.validate().isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lblDesc + ' :', style: secondaryTextStyle(size: 16)),
              2.width,
              Text('${patientEncounterDetailData?.description.validate()}'.capitalizeFirstLetter(), style: boldTextStyle(size: 16)).expand(),
            ],
          ),
        4.height,
        Divider(color: viewLineColor),
        8.height,
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: boxDecorationDefault(
              color: getEncounterStatusColor(patientEncounterDetailData?.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
            child: Text(
              "${getEncounterStatus(patientEncounterDetailData?.status)}".toUpperCase(),
              style: boldTextStyle(size: 12, color: getEncounterStatusColor(patientEncounterDetailData?.status)),
            ).center(),
          ),
        ),
        8.height,
        Divider(color: viewLineColor),
        16.height,
        isProEnabled() ? reportWidget() : 0.height,
      ],
    ).visible(patientEncounterDetailData != null, defaultWidget: LoaderWidget()).visible(!appStore.isLoading, defaultWidget: LoaderWidget());
  }
}
