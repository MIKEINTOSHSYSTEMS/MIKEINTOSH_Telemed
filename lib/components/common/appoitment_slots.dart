import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/appointment_slot_model.dart';
import 'package:kivicare_flutter/network/appointment_respository.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentSlots extends StatefulWidget {
  final String? appointmentTime;
  final int? doctorId;
  final String? slots;

  AppointmentSlots({this.appointmentTime, this.doctorId, this.slots});

  @override
  _AppointmentSlotsState createState() => _AppointmentSlotsState();
}

class _AppointmentSlotsState extends State<AppointmentSlots> {
  List<List<AppointmentSlotModel>> mainList = [];

  TextEditingController appointmentSlotsCont = TextEditingController();

  int selected = -1;
  int mainSelected = -1;

  String? slot = "";

  bool isFirst = true;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.appointmentTime != null) {
      appointmentSlotsCont.text = widget.appointmentTime!;
      appointmentAppStore.setSelectedTime(appointmentSlotsCont.text);
    }
    if (isFirst) {
      getData();
    }

    LiveStream().on(CHANGE_DATE, (isUpdate) {
      if (isUpdate as bool) {
        mainList.clear();
        selected = -1;
        mainSelected = -1;
        if (widget.appointmentTime == null) appointmentSlotsCont.clear();
        setState(() {});
        getData();
      }
    });
  }

  void getData() async {
    appStore.setLoading(true);

    await getAppointmentList(
      clinicId: isProEnabled()
          ? appointmentAppStore.mClinicSelected != null
              ? appointmentAppStore.mClinicSelected!.clinic_id.toInt()
              : getIntAsync(USER_CLINIC)
          : getIntAsync(USER_CLINIC),
      appointmentDate: appointmentAppStore.selectedAppointmentDate.getFormattedDate(CONVERT_DATE),
      id: appointmentAppStore.mDoctorSelected == null ? widget.doctorId.validate() : appointmentAppStore.mDoctorSelected!.iD,
    ).then((value) {
      isFirst = false;
      mainList.clear();
      mainList.addAll(value);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });

    if (!isFirst) {
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AppTextField(
              controller: appointmentSlotsCont,
              textFieldType: TextFieldType.OTHER,
              // enabled: false,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblSelectedSlots,
              ).copyWith(suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
              readOnly: true,
              validator: (s) {
                if (s!.trim().isEmpty) return locale.lblTimeSlotIsRequired;
                return null;
              },
            ).expand(),
          ],
        ),
        16.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: mainList.length,
          padding: EdgeInsets.only(bottom: 16),
          itemBuilder: (context, index) {
            var data = mainList[index];
            return Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 24),
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //16.height.visible(index != 0),
                  Row(
                    children: [
                      Image.asset(ic_morning, height: 20, color: (index + 1) == 2 ? Color(0xFFFF6433) : null),
                      5.width,
                      Text(locale.lblSession + ' ${index + 1}', style: boldTextStyle(size: 16)),
                    ],
                  ),
                  16.height,
                  Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children: List.generate(
                      data.length,
                      (i) {
                        var sessionData = data[i];
                        if (isFirstTime) {
                          if (sessionData.time == widget.appointmentTime) {
                            selected = i;
                            mainSelected = index;
                            isFirstTime = false;
                          }
                        }
                        return Container(
                          width: context.width() / 5 - 23,
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: (selected == i && mainSelected == index)
                                ? primaryColor
                                : sessionData.available == false
                                    ? errorBackGroundColor.withOpacity(0.4)
                                    : appStore.isDarkModeOn
                                        ? cardDarkColor
                                        : context.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(defaultRadius),
                          ),
                          child: FittedBox(
                            child: Text(
                              '${sessionData.time}',
                              style: boldTextStyle(
                                color: (selected == i && mainSelected == index)
                                    ? Colors.white
                                    : sessionData.available == false
                                        ? Colors.red.withOpacity(0.6)
                                        : primaryColor,
                                size: 12,
                                decoration: (sessionData.available == false && sessionData.time != widget.appointmentTime) ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ).center(),
                          ),
                        ).onTap(
                          () {
                            if (sessionData.available!) {
                              selected = i;
                              mainSelected = index;
                              slot = sessionData.time;
                              appointmentSlotsCont.text = sessionData.time.validate();
                              appointmentAppStore.setSelectedTime(sessionData.time.validate());
                            } else {
                              Fluttertoast.cancel();
                              toast(locale.lblTimeSlotIsBooked);
                            }
                            setState(() {});
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ).visible(
          !appStore.isLoading,
          defaultWidget: Text('Please wait while we load slots...', style: secondaryTextStyle()).paddingSymmetric(vertical: 32),
        ),
        NoDataFoundWidget(iconSize: 110).visible(mainList.isEmpty && !appStore.isLoading).center(),
      ],
    );
  }
}
