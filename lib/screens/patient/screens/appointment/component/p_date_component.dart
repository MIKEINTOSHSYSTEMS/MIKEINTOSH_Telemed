import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class PDateComponent extends StatefulWidget {
  final DateTime? initialDate;

  PDateComponent({this.initialDate});

  @override
  State<PDateComponent> createState() => _PDateComponentState();
}

class _PDateComponentState extends State<PDateComponent> {
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
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      primaryColor: Color(0xFF4974dc),
                      hintColor: const Color(0xFF4974dc),
                      colorScheme: ColorScheme.light(primary: Color(0xFF4974dc), onSurface: Colors.white),
                    ),
                    child: child!,
                  );
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
    );
  }
}
