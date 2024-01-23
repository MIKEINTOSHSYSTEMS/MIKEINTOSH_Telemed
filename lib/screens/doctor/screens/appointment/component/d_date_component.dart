import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DDateComponent extends StatefulWidget {
  final DateTime? initialDate;

  DDateComponent({this.initialDate});

  @override
  State<DDateComponent> createState() => _DDateComponentState();
}

class _DDateComponentState extends State<DDateComponent> {
  TextEditingController appointmentDateCont = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      appointmentDateCont.text = widget.initialDate!.getFormattedDate(CONVERT_DATE);
      appointmentAppStore.setSelectedAppointmentDate(widget.initialDate!);
      appointmentAppStore.selectedAppointmentDate = widget.initialDate!;
    } else {
      appointmentDateCont.text = DateTime.now().add(appStore.restrictAppointmentPre.days).getFormattedDate(CONVERT_DATE);
      appointmentAppStore.setSelectedAppointmentDate(DateTime.now().add(appStore.restrictAppointmentPre.days));
    }
    setState(() {});
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppTextField(
          controller: appointmentDateCont,
          textFieldType: TextFieldType.OTHER,
          decoration: inputDecoration(
            context: context,
            labelText: locale.lblAppointmentDate,
          ).copyWith(suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
          readOnly: true,
          onTap: () async {
            selectedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now().add(appStore.restrictAppointmentPre.days),
              firstDate: DateTime.now().add(appStore.restrictAppointmentPre.days),
              lastDate: DateTime.now().add(appStore.restrictAppointmentPost.days),
              helpText: "Select Appointment Date",
              builder: (context, child) {
                if (appStore.isDarkModeOn) {
                  return Theme(data: ThemeData.dark(), child: child!);
                }
                return child!;
              },
            );
            appointmentDateCont.text = DateFormat(CONVERT_DATE).format(selectedDate!);
            appointmentAppStore.setSelectedAppointmentDate(selectedDate!);
            LiveStream().emit(CHANGE_DATE, true);
            setState(() {});
          },
          validator: (s) {
            if (s!.trim().isEmpty) return locale.lblDateIsRequired;
            return null;
          },
        ).expand(),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
