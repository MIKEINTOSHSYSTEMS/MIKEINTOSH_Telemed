import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/components/role_widget.dart';
import 'package:kivicare_flutter/components/status_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/bill_list_model.dart';
import 'package:kivicare_flutter/model/encounter_model.dart';
import 'package:kivicare_flutter/screens/doctor/screens/bill_details_screen.dart';
import 'package:kivicare_flutter/screens/encounter/screen/encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/generate_bill_screen.dart';
import 'package:kivicare_flutter/screens/encounter/screen/patient_encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class BillComponent extends StatelessWidget {
  final BillListData billData;
  final VoidCallback? callToRefresh;

  BillComponent({required this.billData, this.callToRefresh});

  bool get showBillDetails {
    return isVisible(SharedPreferenceKey.kiviCarePatientBillViewKey);
  }

  bool get showEdit {
    return (isReceptionist() || isDoctor()) && !billData.paymentStatus.validate().getBoolInt() && isVisible(SharedPreferenceKey.kiviCarePatientBillEditKey);
  }

  bool get showEncounterDashboard {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterViewKey);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Slidable(
        key: ValueKey(billData),
        enabled: showEdit || showBillDetails || showEncounterDashboard,
        endActionPane: ActionPane(
          extentRatio: 0.6,
          motion: ScrollMotion(),
          children: [
            if (showEdit)
              SlidableAction(
                onPressed: (BuildContext context) {
                  GenerateBillScreen(
                    data: EncounterModel(
                      encounterId: billData.encounterId.validate().toString(),
                      paymentStatus: billData.paymentStatus.validate(),
                      billId: billData.id.validate().toString(),
                    ),
                  ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                    callToRefresh?.call();
                  });
                },
                backgroundColor: successTextColor,
                foregroundColor: Colors.white,
                borderRadius: showBillDetails || showEncounterDashboard
                    ? BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius))
                    : BorderRadius.circular(defaultRadius),
                icon: Icons.edit,
                label: locale.lblEdit,
              ),
            if (showBillDetails)
              SlidableAction(
                onPressed: (BuildContext context) {
                  BillDetailsScreen(
                    encounterId: billData.encounterId.validate().toInt(),
                    callBack: () => callToRefresh,
                  ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                },
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: showEdit ? Radius.zero : Radius.circular(defaultRadius),
                  bottomLeft: showEdit ? Radius.zero : Radius.circular(defaultRadius),
                  topRight: showEncounterDashboard ? Radius.zero : Radius.circular(defaultRadius),
                  bottomRight: showEncounterDashboard ? Radius.zero : Radius.circular(defaultRadius),
                ),
                icon: FontAwesomeIcons.moneyBillTransfer,
                label: locale.lblBill,
              ),
            if (showEncounterDashboard)
              SlidableAction(
                borderRadius: BorderRadius.only(
                  topLeft: showEdit || showBillDetails ? Radius.zero : Radius.circular(defaultRadius),
                  bottomLeft: showEdit || showBillDetails ? Radius.zero : Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                  bottomRight: Radius.circular(defaultRadius),
                ),
                onPressed: (context) {
                  if (isPatient()) {
                    PatientEncounterDashboardScreen(
                      id: billData.encounterId.validate().toString(),
                      callBack: () {
                        callToRefresh?.call();
                      },
                      isPaymentDone: billData.paymentStatus.validate().getBoolInt(),
                    ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                  } else {
                    EncounterDashboardScreen(encounterId: billData.encounterId.validate().toString()).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                  }
                },
                backgroundColor: appSecondaryColor,
                icon: FontAwesomeIcons.gaugeHigh,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(8),
                label: locale.lblEncounter,
              ),
          ],
        ),
        child: Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoleWidget(
                        isShowDoctor: true,
                        child: Text(billData.patientName.validate(), style: boldTextStyle()),
                      ),
                      RoleWidget(
                        isShowPatient: true,
                        isShowDoctor: true,
                        child: Marquee(child: Text(billData.clinicName.validate(), style: isPatient() ? boldTextStyle() : primaryTextStyle())),
                      ),
                      RoleWidget(
                        isShowPatient: false,
                        isShowReceptionist: true,
                        isShowDoctor: true,
                        child: 4.height,
                      ),
                      RoleWidget(
                        isShowPatient: true,
                        isShowReceptionist: true,
                        child: Text('${billData.doctorName.validate().capitalizeEachWord().prefixText(value: '${locale.lblDr}. ')}',
                            style: primaryTextStyle(color: appPrimaryColor, size: isPatient() ? 14 : 16)),
                      ),
                      2.height,
                      RichTextWidget(list: [TextSpan(text: locale.lblDate + " : ", style: secondaryTextStyle()), TextSpan(text: billData.createdAt.validate(), style: primaryTextStyle(size: 14))])
                    ],
                  ).expand(),
                  10.width,
                  StatusWidget(status: billData.paymentStatus.validate(), isPaymentStatus: true),
                ],
              ),
              16.height,
              DottedBorderWidget(
                radius: defaultRadius,
                color: context.primaryColor,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.lblSubTotal, style: secondaryTextStyle(size: 12)).expand(),
                          4.height,
                          Text(locale.lblDiscount, style: secondaryTextStyle(size: 12)).expand(),
                          if (billData.totalTax != null) 4.height,
                          if (billData.totalTax != null) Text(locale.lblTotalTax, style: secondaryTextStyle(size: 12)).expand(),
                          4.height,
                          Text(locale.lblTotal, style: secondaryTextStyle(size: 12)).expand(),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PriceWidget(price: billData.totalAmount.validate().toStringAsFixed(2), textSize: 14).expand(),
                          PriceWidget(price: billData.discount.validate().toStringAsFixed(2), textSize: 14).expand(),
                          if (billData.totalTax != null) PriceWidget(price: (billData.actualAmount.validate() - billData.totalAmount.validate()).toStringAsFixed(2), textSize: 14).expand(),
                          PriceWidget(price: billData.actualAmount.validate().toStringAsFixed(2), textSize: 14).expand(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).appOnTap(() {
          if (billData.paymentStatus.validate().getBoolInt()) {
            if (isPatient())
              BillDetailsScreen(
                encounterId: billData.encounterId.validate().toInt(),
              ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
            else
              BillDetailsScreen(
                encounterId: billData.encounterId.validate().toInt(),
                callBack: () => callToRefresh,
              ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
          } else {
            if (!isPatient())
              GenerateBillScreen(
                data: EncounterModel(
                  encounterId: billData.encounterId.validate().toString(),
                  paymentStatus: billData.paymentStatus.validate(),
                  billId: billData.id.validate().toString(),
                ),
              ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                callToRefresh?.call();
              });
          }
        }),
      );
    });
  }
}
