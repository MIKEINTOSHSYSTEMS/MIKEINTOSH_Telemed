import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_list_model.dart';
import 'package:momona_healthcare/model/holiday_model.dart';
import 'package:momona_healthcare/network/holiday_repository.dart';
import 'package:momona_healthcare/screens/receptionist/components/doctor_drop_down.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddHolidayScreen extends StatefulWidget {
  final HolidayData? holidayData;

  AddHolidayScreen({this.holidayData});

  @override
  _AddHolidayScreenState createState() => _AddHolidayScreenState();
}

class _AddHolidayScreenState extends State<AddHolidayScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  List<String> roles = [DOCTOR, CLINIC];

  TextEditingController dateCont = TextEditingController();

  DateTimeRange? picked = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool isUpdate = false;

  int? totalLeaveInDays;

  DoctorList? doctorCont;

  String? moduleCont;

  void addHoliday() async {
    appStore.setLoading(true);
    Map request = {};

    if (moduleCont == "doctor" || moduleCont == null) {
      request = {
        "start_date": picked!.start.getFormattedDate(CONVERT_DATE),
        "end_date": picked!.end.getFormattedDate(CONVERT_DATE),
        "module_type": DOCTOR,
        "module_id": "${doctorCont == null ? getIntAsync(USER_ID) : doctorCont!.iD.validate()}",
        "description": "",
      };
    } else {
      request = {
        "start_date": picked!.start.getFormattedDate(CONVERT_DATE),
        "end_date": picked!.end.getFormattedDate(CONVERT_DATE),
        "module_type": CLINIC,
        "module_id": getIntAsync(USER_CLINIC),
        "description": "",
      };
    }

    await addHolidayData(request).then((value) {
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void updateHoliday() async {
    appStore.setLoading(true);
    Map request = {};

    if (moduleCont == "doctor" || moduleCont == null) {
      request = {
        "id": widget.holidayData!.id,
        "start_date": picked!.start.getFormattedDate(CONVERT_DATE),
        "end_date": picked!.end.getFormattedDate(CONVERT_DATE),
        "module_type": DOCTOR,
        "module_id": "${doctorCont == null ? getIntAsync(USER_ID) : doctorCont!.iD.validate()}",
        "description": "",
      };
    } else {
      request = {
        "id": widget.holidayData!.id,
        "start_date": picked!.start.getFormattedDate(CONVERT_DATE),
        "end_date": picked!.end.getFormattedDate(CONVERT_DATE),
        "module_type": CLINIC,
        "module_id": getIntAsync(USER_CLINIC),
        "description": "",
      };
    }

    await addHolidayData(request).then((value) {
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      toast(e);
    });
    appStore.setLoading(false);
  }

  void deleteHoliday() async {
    Map request = {
      "id": widget.holidayData!.id,
    };
    appStore.setLoading(true);

    await deleteHolidayData(request).then((value) {
      finish(context, true);
      toast(value.message);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = widget.holidayData != null;
    if (isUpdate) {
      listAppStore.doctorList.forEach((element) {
        if (element!.iD.toString() == widget.holidayData!.module_id) {
          doctorCont = element;
        }
      });
      if (!isDoctor()) {
        moduleCont = widget.holidayData!.module_type;
      }
      picked = DateTimeRange(
        start: DateTime.parse(widget.holidayData!.start_date.validate()),
        end: DateTime.parse(widget.holidayData!.end_date.validate()),
      );
      dateCont.text = "${widget.holidayData!.start_date!.getFormattedDate(APPOINTMENT_DATE_FORMAT)} - ${widget.holidayData!.end_date!.getFormattedDate(APPOINTMENT_DATE_FORMAT)}";
      totalLeaveInDays = DateTime.parse(widget.holidayData!.end_date!).difference(DateTime.parse(widget.holidayData!.start_date!)).inDays;
      setState(() {});
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

  void showDatePicker() async {
    picked = await showDateRangePicker(
      firstDate: DateTime.now(),
      initialDateRange: picked,
      helpText: locale.lblScheduleDate,
      context: context,
      locale: Locale(appStore.selectedLanguage),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: appStore.isDarkModeOn
              ? ThemeData.dark()
              : ThemeData.light().copyWith(
                  primaryColor: Color(0xFF4974dc),
                  colorScheme: ColorScheme.light(primary: const Color(0xFF4974dc)),
                ),
          child: child!,
        );
      },
    ).catchError((e) {
      toast(locale.lblCantEditDate);
    });
    if (picked != null) {
      dateCont.text = "${picked!.start.getFormattedDate(APPOINTMENT_DATE_FORMAT)} - ${picked!.end.getFormattedDate(APPOINTMENT_DATE_FORMAT)}";
      totalLeaveInDays = (picked!.end.difference(picked!.start)).inDays;
      setState(() {});
    }
  }

  Widget buildBodyWidget() {
    return Body(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          padding: EdgeInsets.all(16),
          children: [
            RoleWidget(
              isShowReceptionist: true,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                icon: SizedBox.shrink(),
                dropdownColor: context.cardColor,
                value: moduleCont,
                items: List.generate(
                  roles.length,
                  (index) => DropdownMenuItem<String>(child: Text(roles[index].capitalizeFirstLetter(), style: primaryTextStyle()), value: roles[index]),
                ),
                onChanged: (value) {
                  moduleCont = value;
                  setState(() {});
                },
                decoration: inputDecoration(
                  context: context,
                  labelText: locale.lblHolidayOf,
                ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                validator: (v) {
                  if (v == null) return locale.lblModuleIsRequired;
                  return null;
                },
              ),
            ),
            16.height,
            if (moduleCont == "doctor")
              RoleWidget(
                isShowReceptionist: true,
                child: DoctorDropDown(
                  doctorCont: doctorCont,
                  doctorId: doctorCont?.iD.validate(),
                  isValidate: true,
                  onSelected: (value) {
                    doctorCont = value;
                    setState(() {});
                  },
                ),
              ),
            16.height,
            AppTextField(
              onTap: showDatePicker,
              controller: dateCont,
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditHolidays : locale.lblAddHoliday,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        actions: [
          if (isUpdate)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.lblAreYouSureToDelete,
                  onAccept: (p0) {
                    deleteHoliday();
                  },
                );
              },
            )
        ],
      ),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              primaryColor: context.primaryColor,
              onAccept: (p0) {
                isUpdate ? updateHoliday() : addHoliday();
              },
            );
          }
        },
      ),
    );
  }
}
