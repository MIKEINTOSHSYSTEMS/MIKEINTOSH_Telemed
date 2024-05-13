import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/components/status_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/encounter_model.dart';
import 'package:kivicare_flutter/screens/doctor/screens/bill_details_screen.dart';
import 'package:kivicare_flutter/screens/encounter/screen/add_encounter_screen.dart';
import 'package:kivicare_flutter/screens/encounter/screen/encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/screens/encounter/screen/patient_encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterComponent extends StatelessWidget {
  final EncounterModel data;
  final Function(int)? deleteEncounter;
  final VoidCallback? callForRefresh;

  EncounterComponent({required this.data, this.deleteEncounter, this.callForRefresh});

  bool get showEncounterDashboard {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterViewKey);
  }

  bool get showEncounterEdit {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterEditKey) && data.status.getBoolInt() && !isPatient();
  }

  bool get showDeleteEncounter {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterDeleteKey);
  }

  bool get showBillDetails {
    return data.status == ClosedEncounterStatusInt.toString() && isVisible(SharedPreferenceKey.kiviCarePatientBillViewKey);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(data.encounterId),
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: ScrollMotion(),
        children: [
          if (showEncounterEdit)
            SlidableAction(
              onPressed: (BuildContext context) {
                AddEncounterScreen(patientId: data.patientId.validate().toInt(), patientEncounterData: data)
                    .launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration)
                    .then((value) {
                  if (value ?? false) callForRefresh?.call();
                });
              },
              backgroundColor: primaryColor,
              padding: EdgeInsets.all(6),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultRadius),
                bottomLeft: Radius.circular(defaultRadius),
                topRight: showBillDetails || showDeleteEncounter ? Radius.zero : Radius.circular(defaultRadius),
                bottomRight: showBillDetails || showDeleteEncounter ? Radius.zero : Radius.circular(defaultRadius),
              ),
              icon: Icons.edit,
              label: locale.lblEdit,
            ),
          if (showBillDetails)
            SlidableAction(
              backgroundColor: showEncounterEdit ? appSecondaryColor : appPrimaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(6),
              borderRadius: BorderRadius.only(
                topLeft: showEncounterEdit || showDeleteEncounter ? Radius.circular(defaultRadius) : Radius.zero,
                bottomLeft: showEncounterEdit || showDeleteEncounter ? Radius.circular(defaultRadius) : Radius.zero,
                topRight: showEncounterEdit || showDeleteEncounter ? Radius.zero : Radius.circular(defaultRadius),
                bottomRight: showEncounterEdit || showDeleteEncounter ? Radius.zero : Radius.circular(defaultRadius),
              ),
              icon: FontAwesomeIcons.moneyBill,
              label: locale.lblBillDetails,
              onPressed: (BuildContext context) {
                BillDetailsScreen(
                    encounterId: data.encounterId.validate().toInt(),
                    callBack: () {
                      callForRefresh?.call();
                    }).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
              },
            ),
          if (showDeleteEncounter)
            SlidableAction(
              borderRadius: BorderRadius.only(
                topLeft: showEncounterEdit || showBillDetails ? Radius.zero : Radius.circular(defaultRadius),
                bottomLeft: showEncounterEdit || showBillDetails ? Radius.zero : Radius.circular(defaultRadius),
                topRight: Radius.circular(defaultRadius),
                bottomRight: Radius.circular(defaultRadius),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              padding: EdgeInsets.all(6),
              label: locale.lblDelete,
              onPressed: (BuildContext context) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.lblDoYouWantToDeleteEncounterDetailsOf,
                  onAccept: (p0) {
                    ifTester(context, () {
                      deleteEncounter?.call(data.encounterId.toInt());
                    }, userEmail: data.patientEmail);
                  },
                );
              },
            ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: showEncounterDashboard ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDoctor() || isReceptionist()) Text(data.patientName.capitalizeEachWord(), style: boldTextStyle()),
                if (isDoctor() || isPatient())
                  Marquee(
                    child: Text(
                      data.clinicName.validate().capitalizeEachWord(),
                      style: isPatient() ? boldTextStyle() : primaryTextStyle(),
                    ),
                  ),
                if (isReceptionist() || isPatient())
                  RichTextWidget(list: [
                    TextSpan(text: locale.lblDoctor + ' : ', style: secondaryTextStyle(size: 14)),
                    TextSpan(text: 'Dr. ' + data.doctorName.validate().capitalizeEachWord(), style: primaryTextStyle()),
                  ]),
                4.height,
                RichTextWidget(
                  list: [
                    TextSpan(text: locale.lblDate + " : ", style: secondaryTextStyle(size: 14)),
                    TextSpan(text: data.encounterDate.validate(), style: primaryTextStyle(size: 14)),
                  ],
                ),
                if (data.description.validate().isNotEmpty) 4.height,
                if (data.description.validate().isNotEmpty)
                  ReadMoreText(
                    data.description.validate(),
                    trimMode: TrimMode.Length,
                    trimLength: 30,
                    colorClickableText: Colors.black,
                  ),
              ],
            ).expand(flex: 3),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showEncounterDashboard)
                  FaIcon(FontAwesomeIcons.gaugeHigh, color: appSecondaryColor, size: 20).withWidth(20).appOnTap(
                    () {
                      if (isPatient()) {
                        PatientEncounterDashboardScreen(
                          id: data.encounterId,
                          isPaymentDone: data.status == '0' ? true : false,
                          callBack: () {
                            callForRefresh?.call();
                          },
                        ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                      } else {
                        EncounterDashboardScreen(encounterId: data.encounterId).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                          callForRefresh?.call();
                        });
                      }
                    },
                  ),
                if (showEncounterDashboard) 16.height,
                if (data.description.validate().isNotEmpty && data.encounterDate.validate().isNotEmpty) 28.height,
                StatusWidget(
                  status: data.status.validate(),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  isEncounterStatus: true,
                ),
              ],
            ).expand()
          ],
        ),
      ).appOnTap(() {
        if (showEncounterEdit)
          AddEncounterScreen(patientId: data.patientId.validate().toInt(), patientEncounterData: data)
              .launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration)
              .then((value) {
            if (value ?? false) callForRefresh?.call();
          });
        else {
          if (showEncounterDashboard) {
            if (isPatient()) {
              PatientEncounterDashboardScreen(
                id: data.encounterId,
                isPaymentDone: data.status == '0' ? true : false,
                callBack: () => callForRefresh,
              ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
            } else {
              EncounterDashboardScreen(encounterId: data.encounterId).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                if (value ?? false) {
                  callForRefresh?.call();
                }
              });
            }
          }
        }
      }),
    ).paddingSymmetric(vertical: 8);
  }
}
