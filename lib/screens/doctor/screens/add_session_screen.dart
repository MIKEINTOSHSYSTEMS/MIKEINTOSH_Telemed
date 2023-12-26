import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/common/clinic_drop_down.dart';
import 'package:kivicare_flutter/components/role_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/model/doctor_schedule_model.dart';
import 'package:kivicare_flutter/model/login_response_model.dart';
import 'package:kivicare_flutter/model/week_days_model.dart';
import 'package:kivicare_flutter/network/doctor_sessions_repository.dart';
import 'package:kivicare_flutter/screens/receptionist/components/doctor_drop_down.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/int_extesnions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddSessionsScreen extends StatefulWidget {
  final SessionData? sessionData;

  AddSessionsScreen({this.sessionData});

  @override
  _AddSessionsScreenState createState() => _AddSessionsScreenState();
}

class _AddSessionsScreenState extends State<AddSessionsScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController morningStartTimeCont = TextEditingController();
  TextEditingController morningEndTimeCont = TextEditingController();
  TextEditingController eveningStartTimeCont = TextEditingController();
  TextEditingController eveningEndTimeCont = TextEditingController();

  SessionData? sessionData;

  int? timeSlotCont;

  bool isUpdate = false;

  late DoctorList doctorCont;
  late Clinic selectedClinic;

  List<WeekDaysModel> weekDays = [];
  List<int> timeSlots = [];

  DateTime? morningStartDateTime = DateTime.now();
  DateTime? morningEndDateTime = DateTime.now();
  DateTime? eveningStartDateTime = DateTime.now();
  DateTime? eveningEndDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    for (int i = 1; i <= 60; i++) {
      if (i % 5 == 0) {
        timeSlots.add(i);
      }
    }
    setState(() {});

    for (int i = 1; i <= 7; i++) {
      weekDays.add(WeekDaysModel(name: i.getWeekDay(), value: i.getWeekDay().toLowerCase(), isSelected: false));
      setState(() {});
    }

    isUpdate = widget.sessionData != null;
    if (isUpdate) {
      sessionData = widget.sessionData;

      morningStartDateTime = DateFormat(DATE_FORMAT).parse(sessionData!.morningStart.validate());
      morningEndDateTime = DateFormat(DATE_FORMAT).parse(sessionData!.morningEnd.validate());
      eveningStartDateTime = DateFormat(DATE_FORMAT).parse(sessionData!.eveningStart.validate());
      eveningEndDateTime = DateFormat(DATE_FORMAT).parse(sessionData!.eveningEnd.validate());

      timeSlotCont = sessionData!.time_slot.toInt();

      morningStartTimeCont.text = morningStartDateTime!.getFormattedDate(DATE_FORMAT);
      morningEndTimeCont.text = morningEndDateTime!.getFormattedDate(DATE_FORMAT);
      eveningStartTimeCont.text = eveningStartDateTime!.getFormattedDate(DATE_FORMAT);
      eveningEndTimeCont.text = eveningEndDateTime!.getFormattedDate(DATE_FORMAT);

      weekDays.forEach((weekDays) {
        sessionData!.days!.forEach((element) {
          if (element == weekDays.name!.toLowerCase()) {
            weekDays.isSelected = true;
          }
        });
      });

      setState(() {});
    }
  }

  void addDetails() async {
    appStore.setLoading(true);

    Map<String, dynamic> request = {
      "time_slot": timeSlotCont.validate(),
      "day": weekDays.where((element) => element.isSelected == true).map((e) => e.name.validate().toLowerCase()).toList(),
    };

    if (morningStartTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_one_start_time", () => {"HH": "${morningStartDateTime!.hour}", "mm": "${morningStartDateTime!.minute}"});
    }
    if (morningEndTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_one_end_time", () => {"HH": "${morningEndDateTime!.hour}", "mm": "${morningEndDateTime!.minute}"});
    }
    if (eveningStartTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_two_start_time", () => {"HH": "${eveningStartDateTime!.hour}", "mm": "${eveningStartDateTime!.minute}"});
    }
    if (eveningEndTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_two_end_time", () => {"HH": "${eveningEndDateTime!.hour}", "mm": "${eveningEndDateTime!.minute}"});
    }
    if (isDoctor()) {
      if (isProEnabled()) {
        request.putIfAbsent("clinic_id", () => selectedClinic.clinic_id);
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      } else {
        request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      }
    }
    if (isReceptionist()) {
      request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
      request.putIfAbsent("doctor_id", () => doctorCont.iD);
    }

    log("request $request");

    await addDoctorSessionData(request).then((value) {
      toast(locale.lblSessionAddedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void updateDetails() async {
    List<String> temp = [];
    weekDays.forEach((element) {
      if (element.isSelected == true) {
        temp.add(element.name!.toLowerCase());
      }
    });

    appStore.setLoading(true);

    Map request = {
      "id": sessionData!.id,
      "clinic_id": getIntAsync(USER_CLINIC),
      "doctor_id": getStringAsync(USER_ROLE) == UserRoleDoctor ? getIntAsync(USER_ID) : doctorCont.iD,
      "time_slot": timeSlotCont.validate(),
      "day": temp,
    };

    if (morningStartTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_one_start_time", () => {"HH": "${morningStartDateTime!.hour}", "mm": "${morningStartDateTime!.minute}"});
    }
    if (morningEndTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_one_end_time", () => {"HH": "${morningEndDateTime!.hour}", "mm": "${morningEndDateTime!.minute}"});
    }
    if (eveningStartTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_two_start_time", () => {"HH": "${eveningStartDateTime!.hour}", "mm": "${eveningStartDateTime!.minute}"});
    }
    if (eveningEndTimeCont.text.isNotEmpty) {
      request.putIfAbsent("s_two_end_time", () => {"HH": "${eveningEndDateTime!.hour}", "mm": "${eveningEndDateTime!.minute}"});
    }

    if (isDoctor()) {
      if (isProEnabled()) {
        request.putIfAbsent("clinic_id", () => selectedClinic.clinic_id);
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      } else {
        request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      }
    }
    if (isReceptionist()) {
      request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
      request.putIfAbsent("doctor_id", () => doctorCont.iD);
    }

    await addDoctorSessionData(request).then((value) {
      toast(locale.lblSessionUpdatedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void deleteSession() async {
    appStore.setLoading(true);

    Map request = {"id": "${sessionData!.id}"};
    await deleteDoctorSessionData(request).then((value) {
      toast(locale.lblSessionDeleted);
      finish(context, true);
    }).catchError((s) {
      toast(locale.lblSessionDeleted);
    });
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<DateTime?> timeBottomSheet(context, {DateTime? initial, bool? aIsMorning, bool? aIsEvening}) async {
    DateTime? picked = initial;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 250,
          color: e.cardColor,
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.lblCancel, style: primaryTextStyle(size: 18)).onTap(() {
                      finish(e);
                      toast(locale.lblPleaseSelectTime);
                    }),
                    Text(locale.lblDone, style: primaryTextStyle(size: 18)).onTap(() {
                      if ((picked!.minute % 5) == 0) {
                        if (aIsMorning ?? false) {
                          if (picked!.getFormattedDate(DATE_FORMAT) == morningStartDateTime!.getFormattedDate(DATE_FORMAT)) {
                            toast(locale.lblStartAndEndTimeNotSame);
                          } else {
                            bool check = morningStartDateTime!.isBefore(picked!);
                            if (check) {
                              finish(e, picked);
                            } else {
                              toast(locale.lblTimeNotBeforeMorningStartTime);
                            }
                          }
                        } else if (aIsEvening ?? false) {
                          if (picked!.getFormattedDate(DATE_FORMAT) == eveningStartDateTime!.getFormattedDate(DATE_FORMAT)) {
                            toast(locale.lblStartAndEndTimeNotSame);
                          } else {
                            bool check = eveningStartDateTime!.isBefore(picked!);
                            if (check) {
                              finish(e, picked);
                            } else {
                              toast(locale.lblTimeNotBeforeEveningStartTime);
                            }
                          }
                        } else {
                          finish(e, picked);
                        }
                      } else {
                        toast(locale.lblTimeShouldBeInMultiplyOf5);
                      }
                    })
                  ],
                ).paddingAll(8.0),
              ),
              SizedBox(
                height: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: primaryTextStyle(size: 20)),
                  ),
                  child: CupertinoDatePicker(
                    backgroundColor: e.cardColor,
                    minuteInterval: 1,
                    initialDateTime: picked,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime dateTime) {
                      picked = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return picked;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Body(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          padding: EdgeInsets.all(16),
          children: [
            if (isDoctor() && isProEnabled())
              ClinicDropDown(
                clinicId: sessionData?.clinic_id?.toInt(),
                isValidate: true,
                onSelected: (Clinic? clinic) {
                  selectedClinic = clinic!;
                },
              ),
            if (!isDoctor() && !isProEnabled()) 0.height,
            RoleWidget(
              isShowReceptionist: true,
              child: DoctorDropDown(
                clinicId: getIntAsync(USER_CLINIC),
                isValidate: true,
                doctorId: sessionData?.doctor_id?.toInt(),
                onSelected: (value) {
                  doctorCont = value!;
                  setState(() {});
                },
              ),
            ),
            16.height,
            DropdownButtonFormField(
              value: timeSlotCont,
              icon: SizedBox.shrink(),
              isExpanded: true,
              dropdownColor: context.cardColor,
              items: List.generate(
                timeSlots.length,
                (index) => DropdownMenuItem(child: Text("${timeSlots[index]}", style: primaryTextStyle()), value: timeSlots[index]),
              ),
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblTimeSlotInMinute,
              ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
              onChanged: (dynamic e) {
                timeSlotCont = e;
                setState(() {});
              },
              validator: (dynamic v) {
                if (v == null) return locale.lblTimeSlotRequired;
                return null;
              },
            ),
            16.height,
            Text(locale.lblWeekDays, style: boldTextStyle()),
            8.height,
            Wrap(
              spacing: 8,
              children: List.generate(weekDays.length, (index) {
                WeekDaysModel data = weekDays[index];
                return FilterChip(
                  backgroundColor: context.cardColor,
                  label: Text(data.name.validate()),
                  labelStyle: primaryTextStyle(size: 14, color: data.isSelected.validate() ? Colors.white : textPrimaryColorGlobal),
                  selected: data.isSelected!,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  selectedColor: context.primaryColor,
                  checkmarkColor: Colors.white,
                  onSelected: (bool selected) {
                    data.isSelected = !data.isSelected!;
                    setState(() {});
                  },
                );
              }),
            ),
            16.height,
            Text(locale.lblMorningSession, style: boldTextStyle()),
            16.height,
            Row(
              children: [
                AppTextField(
                  onTap: () async {
                    DateTime? result = await timeBottomSheet(context, initial: morningStartDateTime);
                    morningStartDateTime = result;
                    setState(() {});
                    morningStartTimeCont.text = morningStartDateTime!.getFormattedDate('HH:mm');
                  },
                  controller: morningStartTimeCont,
                  textFieldType: TextFieldType.OTHER,
                  readOnly: true,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblStartTime,
                  ).copyWith(suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                ).expand(),
                8.width,
                AppTextField(
                  controller: morningEndTimeCont,
                  textFieldType: TextFieldType.OTHER,
                  readOnly: true,
                  onTap: () async {
                    if (morningStartTimeCont.text.isNotEmpty) {
                      DateTime? result = await timeBottomSheet(context, initial: morningEndDateTime, aIsMorning: true);

                      morningEndDateTime = result;
                      setState(() {});
                      morningEndTimeCont.text = morningEndDateTime!.getFormattedDate('HH:mm');
                    } else {
                      toast(locale.lblSelectStartTimeFirst);
                    }
                  },
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblEndTime,
                  ).copyWith(suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                ).expand()
              ],
            ),
            16.height,
            Text(locale.lblEveningSession, style: boldTextStyle()),
            16.height,
            Row(
              children: [
                AppTextField(
                  onTap: () async {
                    DateTime? result = await timeBottomSheet(context, initial: eveningStartDateTime);
                    eveningStartDateTime = result;
                    setState(() {});
                    eveningStartTimeCont.text = eveningStartDateTime!.getFormattedDate('HH:mm');
                  },
                  controller: eveningStartTimeCont,
                  readOnly: true,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblStartTime,
                  ).copyWith(suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                ).expand(),
                8.width,
                AppTextField(
                  controller: eveningEndTimeCont,
                  textFieldType: TextFieldType.OTHER,
                  readOnly: true,
                  onTap: () async {
                    if (eveningStartTimeCont.text.isNotEmpty) {
                      DateTime? result = await timeBottomSheet(context, initial: eveningEndDateTime, aIsEvening: true);
                      eveningEndDateTime = result;
                      setState(() {});
                      eveningEndTimeCont.text = eveningEndDateTime!.getFormattedDate('HH:mm');
                    } else {
                      toast(locale.lblSelectStartTimeFirst);
                    }
                  },
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblEndTime,
                  ).copyWith(suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                ).expand()
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditSession : locale.lblAddSession,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        actions: [
          if (isUpdate)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                showConfirmDialogCustom(
                  context,
                  title: locale.lblAreYouSureToDelete,
                  dialogType: DialogType.DELETE,
                  onAccept: (p0) {
                    deleteSession();
                  },
                );
              },
            ),
        ],
      ),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            if (weekDays.where((element) => element.isSelected == true).map((e) => e.name.validate().toLowerCase()).isEmpty) {
              return toast(locale.lblSelectWeekdays);
            }
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              primaryColor: context.primaryColor,
              title: "Are you sure you want to submit the session form?",
              onAccept: (p0) {
                isUpdate ? updateDetails() : addDetails();
              },
            );
          }
        },
      ),
    );
  }
}
