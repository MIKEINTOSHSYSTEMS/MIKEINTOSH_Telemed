import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
// ignore: unused_import
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentDateComponent extends StatefulWidget {
  final DateTime? initialDate;

  AppointmentDateComponent({this.initialDate});

  @override
  State<AppointmentDateComponent> createState() => _AppointmentDateComponentState();
}

class _AppointmentDateComponentState extends State<AppointmentDateComponent> {
  TextEditingController appointmentDateCont = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    isUpdate = widget.initialDate != null;
    appointmentDateCont.text = DateTime.now().getFormattedDate(SAVE_DATE_FORMAT);

    if (isUpdate) {
      appointmentDateCont.text = widget.initialDate!.getFormattedDate(SAVE_DATE_FORMAT);
      selectedDate = widget.initialDate!;
      appointmentAppStore.setSelectedAppointmentDate(widget.initialDate!);
    } else {
      selectedDate = DateTime.now().add(appStore.restrictAppointmentPre.days);
      //appointmentDateCont.text = selectedDate!.getFormattedDate(SAVE_DATE_FORMAT);
      appointmentAppStore.setSelectedAppointmentDate(selectedDate);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: appointmentDateCont,
      textFieldType: TextFieldType.OTHER,
      keyboardAppearance: appStore.isDarkModeOn ? Brightness.dark : Brightness.light,
      selectionControls: EmptyTextSelectionControls(),
      decoration: inputDecoration(context: context, labelText: locale.lblAppointmentDate, suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
      onTap: () async {
        hideKeyboard(context);
        datePickerComponent(context,
            initialDate: selectedDate,
            firstDate: DateTime.now().add(appStore.restrictAppointmentPre.days),
            lastDate: DateTime.now().add(Duration(days: 365)),
            helpText: locale.lblSelectAppointmentDate, onDateSelected: (selectedAppointmentDate) {
          if (selectedAppointmentDate != null) {
            selectedDate = DateFormat(SAVE_DATE_FORMAT).parse(selectedAppointmentDate.toString());
            appointmentDateCont.text = DateFormat(SAVE_DATE_FORMAT).format(selectedAppointmentDate);

            appointmentAppStore.setSelectedAppointmentDate(selectedAppointmentDate);
            LiveStream().emit(CHANGE_DATE, true);
            setState(() {});
          } else {
            hideKeyboard(context);
          }
        });
      },
      validator: (s) {
        if (s!.trim().isEmpty) return locale.lblFieldIsRequired;
        return null;
      },
    );
  }
}
