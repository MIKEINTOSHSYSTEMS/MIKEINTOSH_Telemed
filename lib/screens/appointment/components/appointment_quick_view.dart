import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/common_row_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppointmentQuickView extends StatelessWidget {
  final UpcomingAppointmentModel upcomingAppointment;

  AppointmentQuickView({required this.upcomingAppointment});

  num getTotal() {
    num total = 0.0;
    if (upcomingAppointment.taxData!.taxList.validate().isNotEmpty)
      total = (upcomingAppointment.taxData!.taxList.validate().sumByDouble((e) => e.charges.validate()) + upcomingAppointment.allServiceCharges.validate());
    else
      return upcomingAppointment.allServiceCharges.validate();
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.start,
        listAnimationType: ListAnimationType.None,
        children: [
          Text("${upcomingAppointment.patientName.validate().capitalizeEachWord()}", style: boldTextStyle(size: 20)),
          8.height,
          Wrap(
            runSpacing: 8,
            children: [
              CommonRowWidget(
                title: locale.lblDate.suffixText(value: ' : '),
                value: upcomingAppointment.getAppointmentStartDate,
                titleSize: 16,
                valueStyle: primaryTextStyle(),
              ),
              CommonRowWidget(
                title: locale.lblTime.suffixText(value: ' : '),
                value: upcomingAppointment.getDisplayAppointmentTime,
                titleSize: 16,
                valueStyle: primaryTextStyle(),
              ),
              if (upcomingAppointment.description.validate().isNotEmpty)
                CommonRowWidget(
                  title: locale.lblDesc.suffixText(value: ' : '),
                  value: upcomingAppointment.description.validate(),
                  titleSize: 16,
                  valueStyle: primaryTextStyle(),
                ),
            ],
          ),
          24.height,
          DottedBorderWidget(
            color: appPrimaryColor,
            gap: 3,
            radius: 8,
            strokeWidth: 1,
            child: Container(
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(locale.lblService.capitalizeFirstLetter(), style: boldTextStyle(size: 14)).expand(),
                      16.width,
                      Text(locale.lblCharges.capitalizeFirstLetter(), style: boldTextStyle(size: 14)),
                    ],
                  ),
                  10.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      upcomingAppointment.visitType.validate().length,
                      (index) => Row(
                        children: [
                          Text(
                            "${upcomingAppointment.visitType![index].serviceName}",
                            style: secondaryTextStyle(size: 12),
                          ).expand(flex: 2),
                          FittedBox(
                            child: Text(
                              "${appStore.currencyPrefix.validate(value: appStore.currency.validate())}${upcomingAppointment.visitType![index].charges.validate().toDouble().toStringAsFixed(2)}${appStore.currencyPostfix.validate()} ",
                              style: primaryTextStyle(size: 12),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 4),
                    ),
                  ),
                  Divider(
                    height: 8,
                    color: context.dividerColor,
                  ),
                  if (upcomingAppointment.taxData != null && upcomingAppointment.taxData!.taxList.validate().isNotEmpty)
                    Row(
                      children: [
                        Text(locale.lblSubTotal, style: secondaryTextStyle(size: 12)).expand(),
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${appStore.currencyPrefix.validate(value: appStore.currency.validate())}${upcomingAppointment.allServiceCharges.validate().toDouble().toStringAsFixed(2)}${appStore.currencyPostfix.validate()}',
                            style: primaryTextStyle(size: 12),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 4),
                  if (upcomingAppointment.taxData != null && upcomingAppointment.taxData!.taxList.validate().isNotEmpty)
                    Divider(
                      height: 1,
                      color: context.dividerColor,
                    ),
                  if (upcomingAppointment.taxData != null && upcomingAppointment.taxData!.taxList.validate().isNotEmpty)
                    Row(
                      children: [
                        Text(locale.lblTax, style: boldTextStyle(size: 12)).expand(),
                        16.width,
                        Text(
                          locale.lblTaxRate,
                          style: boldTextStyle(size: 12),
                          textAlign: TextAlign.center,
                        ).expand(flex: 2),
                        16.width,
                        FittedBox(
                          child: Text(
                            locale.lblCharges,
                            style: boldTextStyle(size: 12),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  if (upcomingAppointment.taxData != null && upcomingAppointment.taxData!.taxList.validate().isNotEmpty)
                    Divider(
                      height: 8,
                      color: context.dividerColor,
                    ),
                  if (upcomingAppointment.taxData != null)
                    ...upcomingAppointment.taxData!.taxList.validate().map((e) {
                      return Row(
                        children: [
                          Text(e.taxName.validate().replaceAll(RegExp(r'[^a-zA-Z]'), ''), maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 12)).expand(),
                          if (e.taxName.validate().contains('%'))
                            Text(
                              e.taxRate.validate().toString().suffixText(value: '%'),
                              style: primaryTextStyle(size: 12),
                              textAlign: TextAlign.center,
                            ).expand(flex: 2)
                          else
                            PriceWidget(
                              price: e.taxRate.validate().toStringAsFixed(2),
                              textStyle: primaryTextStyle(size: 12),
                              textAlign: TextAlign.center,
                            ).paddingLeft(4).expand(flex: 2),
                          PriceWidget(
                            price: e.charges.validate().toStringAsFixed(2),
                            textStyle: primaryTextStyle(size: 12),
                            textAlign: TextAlign.end,
                          ).paddingLeft(4).expand(),
                        ],
                      ).paddingSymmetric(vertical: 4);
                    }).toList(),
                  if (upcomingAppointment.taxData != null && upcomingAppointment.taxData!.taxList.validate().isNotEmpty)
                    Divider(
                      height: 8,
                      color: context.dividerColor,
                    ),
                  if (upcomingAppointment.taxData != null)
                    Row(
                      children: [
                        Text(locale.lblTotal, style: secondaryTextStyle()).expand(),
                        FittedBox(
                          child: Text(
                            '${appStore.currencyPrefix.validate(value: appStore.currency.validate())}${getTotal().toStringAsFixed(2)}${appStore.currencyPostfix.validate()}',
                            style: boldTextStyle(color: appStore.isDarkModeOn ? white : appPrimaryColor),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 4),
                ],
              ),
            ),
          ),
          if (upcomingAppointment.appointmentReport.validate().isNotEmpty)
            Divider(
              height: 16,
              color: context.dividerColor,
            ),
          if (upcomingAppointment.appointmentReport.validate().isNotEmpty) Text(locale.lblMedicalReports, style: boldTextStyle()),
          if (upcomingAppointment.appointmentReport.validate().isNotEmpty)
            Column(
              children: List.generate(
                upcomingAppointment.appointmentReport!.length,
                (index) {
                  AppointmentReport data = upcomingAppointment.appointmentReport![index];

                  return GestureDetector(
                    onTap: () {
                      if (isVisible(SharedPreferenceKey.kiviCarePatientReportViewKey)) commonLaunchUrl(data.url, launchMode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: boxDecorationDefault(
                        color: context.cardColor,
                        boxShadow: defaultBoxShadow(spreadRadius: 0, blurRadius: 0),
                        border: Border.all(color: context.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Text('${locale.lblMedicalReports} ${index + 1}', style: boldTextStyle()).expand(),
                          Icon(Icons.arrow_forward_ios_outlined, size: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
