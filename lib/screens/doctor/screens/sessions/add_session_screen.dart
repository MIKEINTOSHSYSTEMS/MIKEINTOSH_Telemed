import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';
import 'package:momona_healthcare/model/doctor_session_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/model/week_days_model.dart';
import 'package:momona_healthcare/network/doctor_sessions_repository.dart';
import 'package:momona_healthcare/screens/appointment/screen/step1_clinic_selection_screen.dart';
import 'package:momona_healthcare/screens/appointment/screen/step2_doctor_selection_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/int_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';

class AddSessionsScreen extends StatefulWidget {
  final SessionData? sessionData;

  AddSessionsScreen({this.sessionData});

  @override
  _AddSessionsScreenState createState() => _AddSessionsScreenState();
}

class _AddSessionsScreenState extends State<AddSessionsScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController selectedDoctorCon = TextEditingController();
  TextEditingController selectedClinicNameCont = TextEditingController();
  TextEditingController morningStartTimeCont = TextEditingController();
  TextEditingController morningEndTimeCont = TextEditingController();
  TextEditingController eveningStartTimeCont = TextEditingController();
  TextEditingController eveningEndTimeCont = TextEditingController();

  SessionData? sessionData;

  int? timeSlotCont;

  bool isUpdate = false;
  bool isFirstTime = true;

  UserModel? doctorCont;
  Clinic? selectedClinic;

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
      doctorCont = UserModel(iD: sessionData!.doctorId.toInt(), displayName: sessionData!.doctors);
      selectedClinic = Clinic(id: sessionData!.clinicId, name: sessionData!.clinicName);

      selectedClinicNameCont.text = widget.sessionData!.clinicName.validate();
      selectedDoctorCon.text = 'Dr. ' + widget.sessionData!.doctors.validate();
      morningStartDateTime = DateFormat(ONLY_HOUR_MINUTE).parse(sessionData!.morningStart.validate());
      morningEndDateTime = DateFormat(ONLY_HOUR_MINUTE).parse(sessionData!.morningEnd.validate());
      eveningStartDateTime = DateFormat(ONLY_HOUR_MINUTE).parse(sessionData!.eveningStart.validate());
      eveningEndDateTime = DateFormat(ONLY_HOUR_MINUTE).parse(sessionData!.eveningEnd.validate());

      timeSlotCont = sessionData!.timeSlot.toInt();

      morningStartTimeCont.text = morningStartDateTime!.getFormattedDate(ONLY_HOUR_MINUTE);
      morningEndTimeCont.text = morningEndDateTime!.getFormattedDate(ONLY_HOUR_MINUTE);
      eveningStartTimeCont.text = eveningStartDateTime!.getFormattedDate(ONLY_HOUR_MINUTE);
      eveningEndTimeCont.text = eveningEndDateTime!.getFormattedDate(ONLY_HOUR_MINUTE);

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
    if (appStore.isLoading) return;

    Map<String, dynamic> request = {
      "time_slot": timeSlotCont.validate(),
      "day": weekDays.where((element) => element.isSelected == true).map((e) => e.name.validate().toLowerCase()).toList(),
    };
    appStore.setLoading(true);
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
        request.putIfAbsent("clinic_id", () => selectedClinic?.id);
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      } else {
        request.putIfAbsent("clinic_id", () => userStore.userClinicId);
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      }
    }
    if (isReceptionist()) {
      request.putIfAbsent("clinic_id", () => userStore.userClinicId);
      request.putIfAbsent("doctor_id", () => doctorCont?.iD);
    }

    await addDoctorSessionDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblSessionAddedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void updateDetails() async {
    if (appStore.isLoading) return;
    List<String> temp = [];
    weekDays.forEach((element) {
      if (element.isSelected == true) {
        temp.add(element.name!.toLowerCase());
      }
    });

    appStore.setLoading(true);

    Map request = {
      "id": sessionData!.id,
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
        request.putIfAbsent("clinic_id", () => selectedClinic?.id);
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      } else {
        request.putIfAbsent("clinic_id", () => userStore.userClinicId);
        request.putIfAbsent("doctor_id", () => getIntAsync(USER_ID));
      }
    }
    if (isReceptionist()) {
      request.putIfAbsent("clinic_id", () => userStore.userClinicId);
      request.putIfAbsent("doctor_id", () => doctorCont?.iD);
    }

    log('===============$request=====================');

    await addDoctorSessionDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblSessionUpdatedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
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
                    Text(locale.lblCancel, style: primaryTextStyle(size: 18)).appOnTap(
                      () {
                        finish(e);
                        toast(locale.lblPleaseSelectTime);
                      },
                    ),
                    Text(locale.lblDone, style: primaryTextStyle(size: 18)).appOnTap(
                      () {
                        if ((picked!.minute % 5) == 0) {
                          if (aIsMorning ?? false) {
                            if (picked!.getFormattedDate(ONLY_HOUR_MINUTE) == morningStartDateTime!.getFormattedDate(ONLY_HOUR_MINUTE)) {
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
                            if (picked!.getFormattedDate(ONLY_HOUR_MINUTE) == eveningStartDateTime!.getFormattedDate(ONLY_HOUR_MINUTE)) {
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
                      },
                    )
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
    return Stack(
      children: [
        Form(
          key: formKey,
          autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
          child: AnimatedScrollView(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            children: [
              if (isDoctor() && isProEnabled())
                AppTextField(
                  controller: selectedClinicNameCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  decoration: inputDecoration(context: context, labelText: isUpdate ? locale.lblClinicName : locale.lblSelectClinic),
                  onTap: () async {
                    await Step1ClinicSelectionScreen(
                      sessionOrEncounter: true,
                      clinicId: isUpdate ? widget.sessionData!.clinicId.toInt() : null,
                    ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                      if (value != null)
                        selectedClinic = value!;
                      else {
                        if (!isUpdate) toast('${locale.lblPlease} ${locale.lblSelectClinic}');
                      }

                      selectedClinicNameCont.text = selectedClinic!.name.validate();
                      setState(() {});
                    });
                  },
                ),
              if (!isDoctor() && !isProEnabled()) 0.height,
              RoleWidget(
                isShowReceptionist: true,
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: selectedDoctorCon,
                  decoration: inputDecoration(context: context, labelText: isUpdate ? locale.lblDoctorName : locale.lblSelectDoctor),
                  readOnly: true,
                  onTap: () {
                    if (!isUpdate) {
                      Step2DoctorSelectionScreen(doctorId: doctorCont?.iD).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                        if (value != null) {
                          doctorCont = value;
                          selectedDoctorCon.text = doctorCont!.displayName.validate();
                        } else {
                          toast('${locale.lblPlease} ${locale.lblSelectDoctor}');
                        }
                        setState(() {});
                      }).catchError((e) {
                        toast(e.toString());
                      });
                    }
                  },
                ),
              ),
              16.height,
              DropdownButtonFormField(
                value: timeSlotCont,
                icon: SizedBox.shrink(),
                isExpanded: true,
                borderRadius: radius(),
                dropdownColor: context.cardColor,
                items: List.generate(
                  timeSlots.length,
                  (index) => DropdownMenuItem(child: Text("${timeSlots[index]}", style: primaryTextStyle()), value: timeSlots[index]),
                ),
                decoration: inputDecoration(context: context, labelText: locale.lblTimeSlotInMinute, suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
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
                runSpacing: 8,
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
                    decoration: inputDecoration(context: context, labelText: locale.lblStartTime, suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
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
                    decoration: inputDecoration(context: context, labelText: locale.lblEndTime, suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
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
                    decoration: inputDecoration(context: context, labelText: locale.lblStartTime, suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
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
                    decoration: inputDecoration(context: context, labelText: locale.lblEndTime, suffixIcon: ic_timer.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                  ).expand()
                ],
              ),
            ],
          ),
        ),
        Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditSession : locale.lblAddSession,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        actions: [],
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
              title: isUpdate ? locale.lblDoYouWantToUpdateSession : locale.lblDoYouWantToAddSession,
              onAccept: (p0) {
                isUpdate ? updateDetails() : addDetails();
              },
            );
          } else {
            isFirstTime = !isFirstTime;
            setState(() {});
          }
        },
      ),
    );
  }
}
