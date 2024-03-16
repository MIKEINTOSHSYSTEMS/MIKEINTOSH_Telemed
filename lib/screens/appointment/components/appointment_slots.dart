import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/appointment_slot_model.dart';
import 'package:momona_healthcare/network/appointment_repository.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentSlots extends StatefulWidget {
  final String? date;
  final String? clinicId;
  final String? doctorId;
  final String? appointmentTime;

  AppointmentSlots({required this.date, required this.clinicId, required this.doctorId, this.appointmentTime});

  @override
  State<AppointmentSlots> createState() => _AppointmentSlotsState();
}

class _AppointmentSlotsState extends State<AppointmentSlots> {
  Future<List<List<AppointmentSlotModel>>>? future;

  int sessionTimeListIndex = -1;
  int sessionListIndex = -1;
  bool isFirst = true;
  bool isUpdate = false;

  TextEditingController appointmentSlotsCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    isUpdate = widget.appointmentTime != null;
    if (isUpdate) appointmentSlotsCont.text = widget.appointmentTime.validate();
    LiveStream().on(CHANGE_DATE, (isUpdate) {
      if (isUpdate as bool) {
        appointmentSlotsCont.clear();
        if (DateFormat(GLOBAL_FORMAT).parse(widget.date.validate()) == appointmentAppStore.selectedAppointmentDate) {
          isFirst = true;
        } else {
          sessionTimeListIndex = -1;
          sessionListIndex = -1;
          if (widget.appointmentTime == null) appointmentSlotsCont.clear();
        }
        setState(() {});
        init(date: appointmentAppStore.selectedAppointmentDate.getFormattedDate(SAVE_DATE_FORMAT));
      }
    });

    init();
  }

  void init({String? date}) async {
    future = getAppointmentTimeSlotList(
      appointmentDate: date ?? widget.date,
      clinicId: widget.clinicId,
      doctorId: widget.doctorId,
    ).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(CHANGE_DATE);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: appointmentSlotsCont,
          readOnly: true,
          errorThisFieldRequired: locale.lblPleaseSelectTime,
          decoration: inputDecoration(
            context: context,
            labelText: locale.lblSelectedSlots,
            suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14),
          ),
        ),
        16.height,
        FutureBuilder<List<List<AppointmentSlotModel>>>(
          future: future,
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data.validate().isEmpty)
                return NoDataWidget(
                  title: locale.lblNoSlotAvailable,
                  subTitle: locale.lblPleaseChooseAnotherDay,
                );

              return AnimatedListView(
                itemCount: snap.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List<AppointmentSlotModel> sessionList = snap.data![index];

                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(ic_morning, height: 20, color: (index + 1).isEven ? appointmentSlotEveningImageColor : null),
                            5.width,
                            Text(locale.lblSession + ' ${index + 1}', style: boldTextStyle(size: 16)),
                          ],
                        ),
                        16.height,
                        AnimatedWrap(
                          spacing: 12,
                          runSpacing: 16,
                          children: List.generate(
                            sessionList.length,
                            (i) {
                              AppointmentSlotModel sessionTimeData = sessionList[i];

                              bool isSelected = sessionTimeListIndex == i && sessionListIndex == index;
                              Color redColor = sessionTimeData.available == false ? errorBackGroundColor.withOpacity(0.4) : context.scaffoldBackgroundColor;

                              if (isFirst && sessionTimeData.time == widget.appointmentTime) {
                                sessionTimeData.available = true;
                                sessionTimeListIndex = i;
                                sessionListIndex = index;
                                isFirst = false;
                                appointmentSlotsCont.text = sessionTimeData.time.validate();
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (sessionTimeData.available!) {
                                    sessionTimeListIndex = i;
                                    sessionListIndex = index;
                                    appointmentSlotsCont.text = sessionTimeData.time.validate();
                                    appointmentAppStore.setSelectedTime(sessionTimeData.time.validate());
                                    setState(() {});
                                  } else {
                                    Fluttertoast.cancel();
                                    toast(locale.lblTimeSlotIsBooked);
                                  }
                                },
                                child: Container(
                                  width: context.width() / 5 - 24,
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: isSelected ? primaryColor : redColor,
                                    borderRadius: BorderRadius.circular(defaultRadius),
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      sessionTimeData.time.validate(),
                                      style: boldTextStyle(
                                        color: (isSelected)
                                            ? Colors.white
                                            : sessionTimeData.available == false
                                                ? Colors.red.withOpacity(0.6)
                                                : primaryColor,
                                        decoration: (sessionTimeData.available == false) ? TextDecoration.lineThrough : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return snapWidgetHelper(snap, loadingWidget: LoaderWidget(size: 20));
          },
        ),
      ],
    );
  }
}
