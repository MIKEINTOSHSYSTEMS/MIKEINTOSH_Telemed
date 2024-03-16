import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/holiday_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/holiday_repository.dart';
import 'package:momona_healthcare/screens/appointment/screen/step2_doctor_selection_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddHolidayScreen extends StatefulWidget {
  final HolidayData? holidayData;

  AddHolidayScreen({this.holidayData});

  @override
  _AddHolidayScreenState createState() => _AddHolidayScreenState();
}

class _AddHolidayScreenState extends State<AddHolidayScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController dateCont = TextEditingController();
  TextEditingController selectedDoctorCont = TextEditingController();

  DateTimeRange? picked = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool isUpdate = false;
  bool isFirstTime = true;
  bool showDates = false;

  int? totalLeaveInDays;

  UserModel? doctorCont;

  String? moduleCont;

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.holidayData != null;

    if (isUpdate) {
      if (!isDoctor()) {
        moduleCont = widget.holidayData!.moduleType;
      }
      selectedDoctorCont.text = 'Dr. ' + widget.holidayData!.doctorName.validate();
      if (cachedDoctorList != null && cachedDoctorList.validate().isNotEmpty) {
        cachedDoctorList.validate().forEach((element) {
          if (element.iD.toString() == widget.holidayData!.moduleId) {
            doctorCont = element;
          }
        });
      }
      selectedStartDate = DateFormat(SAVE_DATE_FORMAT).parse(widget.holidayData!.holidayStartDate.validate());
      selectedEndDate = DateFormat(SAVE_DATE_FORMAT).parse(widget.holidayData!.holidayEndDate.validate());
      dateCont.text = "${DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate)} - ${DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)}";
      totalLeaveInDays = selectedEndDate.difference(selectedStartDate).inDays + 1;
      setState(() {});
      appStore.setLoading(false);
    }
  }

  void addHoliday() async {
    appStore.setLoading(true);
    Map request = {};

    if (moduleCont == "doctor" || moduleCont == null) {
      request = {
        "start_date": selectedStartDate.getFormattedDate(SAVE_DATE_FORMAT),
        "end_date": selectedEndDate.getFormattedDate(SAVE_DATE_FORMAT),
        "module_type": DOCTOR,
        "module_id": "${doctorCont == null ? getIntAsync(USER_ID) : doctorCont!.iD.validate()}",
        "description": "",
      };
    } else {
      request = {
        "start_date": selectedStartDate.getFormattedDate(SAVE_DATE_FORMAT),
        "end_date": selectedEndDate.getFormattedDate(SAVE_DATE_FORMAT),
        "module_type": CLINIC,
        "module_id": userStore.userClinicId,
        "description": "",
      };
    }

    await addHolidayDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void updateHoliday() async {
    appStore.setLoading(true);
    Map request = {};

    if (moduleCont == "doctor" || moduleCont == null) {
      request = {
        "id": widget.holidayData!.id,
        "start_date": selectedStartDate.getFormattedDate(SAVE_DATE_FORMAT),
        "end_date": selectedEndDate.getFormattedDate(SAVE_DATE_FORMAT),
        "module_type": DOCTOR,
        "module_id": "${doctorCont == null ? getIntAsync(USER_ID) : doctorCont!.iD.validate()}",
        "description": "",
      };
    } else {
      request = {
        "id": widget.holidayData!.id,
        "start_date": selectedStartDate.getFormattedDate(SAVE_DATE_FORMAT),
        "end_date": selectedEndDate.getFormattedDate(SAVE_DATE_FORMAT),
        "module_type": CLINIC,
        "module_id": userStore.userClinicId,
        "description": "",
      };
    }

    await addHolidayDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e);
    });
    appStore.setLoading(false);
  }

  void deleteHoliday() async {
    Map request = {
      "id": widget.holidayData!.id,
    };
    appStore.setLoading(true);

    await deleteHolidayDataAPI(request).then((value) {
      appStore.setLoading(false);
      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showDatePicker() async {
    hideKeyboard(context);

    picked = await showDateRangePicker(
      firstDate: DateTime.now(),
      initialDateRange: picked,
      helpText: locale.lblScheduleDate,
      context: context,
      locale: Locale(appStore.selectedLanguage),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: appStore.isDarkModeOn
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  brightness: Brightness.dark,
                ))
              : ThemeData.light().copyWith(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: context.width() * 0.85,
                  maxHeight: context.height() * 0.60,
                ),
                child: child.cornerRadiusWithClipRRect(24),
              )
            ],
          ),
        );
      },
    ).catchError((e) {
      toast(locale.lblCantEditDate);
      throw e;
    });
    if (picked != null) {
      dateCont.text = "${picked!.start.getFormattedDate(GLOBAL_FORMAT)} - ${picked!.end.getFormattedDate(GLOBAL_FORMAT)}";
      totalLeaveInDays = (picked!.end.difference(picked!.start)).inDays;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(
          isUpdate ? locale.lblEditHolidays : locale.lblAddHoliday,
          textColor: Colors.white,
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
          actions: [
            if (isUpdate && isVisible(SharedPreferenceKey.kiviCareClinicScheduleDeleteKey))
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    title: locale.lblDoYouWantToDeleteHolidayOf,
                    onAccept: (p0) {
                      deleteHoliday();
                    },
                  );
                },
              )
          ],
        ),
        body: Body(
          visibleOn: appStore.isLoading,
          child: Form(
            key: formKey,
            autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
            child: AnimatedScrollView(
              listAnimationType: ListAnimationType.None,
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              children: [
                RoleWidget(
                  isShowReceptionist: true,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    icon: SizedBox.shrink(),
                    borderRadius: radius(),
                    dropdownColor: context.cardColor,
                    value: moduleCont,
                    items: List.generate(
                      userRoles.length,
                      (index) => DropdownMenuItem<String>(
                        child: Text(userRoles[index].capitalizeFirstLetter(), style: primaryTextStyle()),
                        value: index == 0 ? DOCTOR : CLINIC,
                      ),
                    ),
                    onChanged: (value) {
                      moduleCont = value;
                      setState(() {});
                    },
                    decoration: inputDecoration(context: context, labelText: locale.lblHolidayOf, suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                    validator: (v) {
                      if (v == null) return locale.lblModuleIsRequired;
                      return null;
                    },
                  ),
                ),
                16.height,
                if (moduleCont == locale.lblDoctor.toLowerCase())
                  RoleWidget(
                    isShowReceptionist: true,
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: selectedDoctorCont,
                      decoration: inputDecoration(context: context, labelText: isUpdate ? locale.lblDoctorName : locale.lblSelectDoctor),
                      readOnly: true,
                      onTap: () {
                        if (!isUpdate) {
                          Step2DoctorSelectionScreen(doctorId: isUpdate ? doctorCont!.iD : null).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                            if (value != null) {
                              doctorCont = value;
                              selectedDoctorCont.text = doctorCont!.displayName.validate();
                            } else {
                              toast(locale.lblPleaseSelectDoctor);
                            }
                            setState(() {});
                          }).catchError((e) {
                            toast(e.toString());
                          });
                        }
                      },
                    ),
                  ),
                if (moduleCont == locale.lblDoctor.toLowerCase()) 16.height,
                AppTextField(
                  onTap: () {
                    showDates = !showDates;
                    setState(() {});
                  },
                  controller: dateCont,
                  keyboardAppearance: appStore.isDarkModeOn ? Brightness.dark : Brightness.light,
                  selectionControls: EmptyTextSelectionControls(),
                  textFieldType: TextFieldType.NAME,
                  isValidationRequired: true,
                  suffix: Icon(Icons.date_range_outlined, color: appStore.isDarkModeOn ? context.iconColor : Colors.black),
                  decoration: inputDecoration(context: context, labelText: locale.lblScheduleDate),
                  readOnly: true,
                ),
                if (totalLeaveInDays != null) 12.height,
                if (totalLeaveInDays != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(locale.lblLeaveFor + ' $totalLeaveInDays ' + locale.lblDays, style: secondaryTextStyle(color: primaryColor)),
                  ),
                if (showDates) 16.height,
                if (showDates)
                  Theme(
                    data: appStore.isDarkModeOn
                        ? ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.fromSeed(
                            seedColor: primaryColor,
                            brightness: Brightness.dark,
                          ))
                        : ThemeData.light().copyWith(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light)),
                    child: SfDateRangePicker(
                      confirmText: locale.lblSave,
                      cancelText: locale.lblCancel,
                      showActionButtons: true,
                      selectionColor: appPrimaryColor,
                      backgroundColor: context.cardColor,
                      rangeSelectionColor: appPrimaryColor.withOpacity(0.2),
                      minDate: DateTime.now(),
                      initialSelectedDates: [
                        selectedStartDate,
                        selectedEndDate,
                      ],
                      initialSelectedRange: PickerDateRange(selectedStartDate, selectedEndDate),
                      onSubmit: (selectedRange) {
                        if (selectedRange is PickerDateRange) {
                          setState(() {
                            selectedStartDate = selectedRange.startDate!;
                            selectedEndDate = selectedRange.endDate ?? selectedRange.startDate!;
                            dateCont.text = "${DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate)} - ${DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)}";
                            totalLeaveInDays = getDateDifference(DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate), eDate: DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)) + 1;
                          });
                        } else if (selectedRange is DateTime) {
                          selectedStartDate = DateFormat(SAVE_DATE_FORMAT).parse(selectedRange.toString());
                          selectedEndDate = selectedStartDate;
                          dateCont.text = "${DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate)} - ${DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)}";
                          totalLeaveInDays = getDateDifference(DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate), eDate: DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)) + 1;
                        } else {}
                        showDates = !showDates;
                        setState(() {});
                      },
                      onCancel: () {
                        showDates = !showDates;
                        setState(() {});
                        if (!isUpdate) {
                          dateCont.clear();
                          selectedStartDate = DateTime.now();
                          selectedEndDate = DateTime.now();
                        }
                      },
                      onSelectionChanged: (selectedRange) {
                        if (selectedRange.value is PickerDateRange) {
                          setState(() {
                            selectedStartDate = selectedRange.value.startDate;
                            selectedEndDate = selectedRange.value.endDate ?? selectedRange.value.startDate;
                            dateCont.text = "${DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate)} - ${DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)}";
                            totalLeaveInDays = getDateDifference(DateFormat(SAVE_DATE_FORMAT).format(selectedStartDate), eDate: DateFormat(SAVE_DATE_FORMAT).format(selectedEndDate)) + 1;
                          });
                        } else if (selectedRange.value is DateTime) {
                          setState(() {
                            selectedStartDate = DateFormat(SAVE_DATE_FORMAT).parse(selectedRange.value.toString());
                            selectedEndDate = selectedStartDate;
                          });
                        } else {}
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                    ).cornerRadiusWithClipRRect(16),
                  )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done, color: Colors.white),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              showConfirmDialogCustom(
                context,
                dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
                primaryColor: context.primaryColor,
                title: locale.lblAllTheAppointmentOnSelectedDateWillBeCancelled,
                onAccept: (p0) {
                  isUpdate ? updateHoliday() : addHoliday();
                },
              );
            } else {
              isFirstTime = !isFirstTime;
              setState(() {});
            }
          },
        ),
      );
    });
  }
}
