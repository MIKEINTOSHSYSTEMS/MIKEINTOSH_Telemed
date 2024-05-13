import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentFragmentStatusComponent extends StatefulWidget {
  final Function(int)? callForStatusChange;
  final int selectedIndex;
  AppointmentFragmentStatusComponent({this.callForStatusChange, required this.selectedIndex});

  @override
  State<AppointmentFragmentStatusComponent> createState() => _AppointmentFragmentStatusComponentState();
}

class _AppointmentFragmentStatusComponentState extends State<AppointmentFragmentStatusComponent> {
  List<String> appointmentStatusList = [locale.lblAll, locale.lblLatest, locale.lblPending, locale.lblCompleted, locale.lblCancelled, locale.lblPast];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.lblMyAppointments, style: boldTextStyle(size: fragmentTextSize)).paddingSymmetric(horizontal: 16),
        HorizontalList(
          itemCount: appointmentStatusList.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            bool isSelected = widget.selectedIndex == index;
            return GestureDetector(
              onTap: () {
                widget.callForStatusChange?.call(index);
              },
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                decoration: boxDecorationDefault(color: isSelected ? context.primaryColor : context.cardColor, borderRadius: radius()),
                child: Text(appointmentStatusList[index], style: primaryTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal, size: 14)),
              ),
            );
          },
        ).paddingTop(16),
      ],
    ).paddingOnly(bottom: 16);
  }
}
