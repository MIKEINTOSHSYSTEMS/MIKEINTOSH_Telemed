import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> defaultValue() async {
  appStore.setBaseUrl(getStringAsync(SAVE_BASE_URL, defaultValue: BASE_URL));
  appStore.setDemoDoctor(getStringAsync(DEMO_DOCTOR));
  appStore.setDemoReceptionist(getStringAsync(DEMO_RECEPTIONIST));
  appStore.setDemoPatient(getStringAsync(DEMO_PATIENT));
  appStore.setCurrency(getStringAsync(CURRENCY));

  if (appStore.isLoggedIn) {
    userStore.setUserId(getIntAsync(USER_ID));
    userStore.setFirstName(getStringAsync(FIRST_NAME));
    userStore.setLastName(getStringAsync(LAST_NAME));
    userStore.setUserEmail(getStringAsync(USER_EMAIL));
    userStore.setUserDisplayName(getStringAsync(USER_DISPLAY_NAME));
    userStore.setUserProfile(getStringAsync(PROFILE_IMAGE, defaultValue: ""));
    userStore.setUserGender(getStringAsync(USER_GENDER));
    userStore.setRole(getStringAsync(USER_ROLE));
    userStore.setUserMobileNumber(getStringAsync(USER_MOBILE));
    userStore.setUserDob(getStringAsync(USER_DOB));
    //userStore.setClinicId(userStore.userClinicId.toString());
    userStore.setClinicId(getStringAsync(CLINIC_ID).toString());
    appStore.setUserProEnabled(getBoolAsync(USER_PRO_ENABLED));
    appStore.setGlobalDateFormat(getStringAsync(GLOBAL_DATE_FORMAT));
    appStore.setRestrictAppointmentPost(getIntAsync(RESTRICT_APPOINTMENT_POST));
    appStore.setRestrictAppointmentPre(getIntAsync(RESTRICT_APPOINTMENT_PRE));
  }
}

String getRoleWiseName({required String name}) {
  if (isDoctor()) {
    return '${name.prefixText(value: 'Dr. ')}';
  } else {
    return name;
  }
}

String getRoleWiseAppointmentFirstText(UpcomingAppointmentModel upcomingData) {
  if (isDoctor() || isReceptionist())
    return upcomingData.patientName.validate();
  else
    return upcomingData.doctorName.validate().prefixText(value: 'Dr. ');
}

SystemUiOverlayStyle defaultSystemUiOverlayStyle(BuildContext context, {Color? color, Brightness? statusBarIconBrightness}) {
  return SystemUiOverlayStyle(statusBarColor: color ?? context.primaryColor.withOpacity(0.02), statusBarIconBrightness: statusBarIconBrightness ?? Brightness.light);
}

String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
  String perPage = "?limit=${perPages ?? PER_PAGE}";
  String pages = "&page=$page";

  if (page != null && params.validate().isEmpty) {
    return "$endPoint$perPage$pages";
  } else if (page != null && params.validate().isNotEmpty) {
    return "$endPoint$perPage$pages&${params.validate().join('&')}";
  } else if (page == null && params != null) {
    return "$endPoint?${params.join('&')}";
  }
  log('-------------$endPoint---------------');
  return "$endPoint";
}

void getDisposeStatusBarColor({Color? colors}) {
  setStatusBarColor(colors ?? (appStore.isDarkModeOn.validate() ? scaffoldColorDark : scaffoldColorLight), statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark);
}

Future<List<File>> getMultipleImageSource({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickMultiImage();
  return pickedImage.map((e) => File(e.path)).toList();
}

Future<File> getCameraImage({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
  return File(pickedImage!.path.validate());
}

Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
  var map = <T, List<S>>{};
  for (var element in values) {
    (map[key(element)] ??= []).add(element);
  }
  return map;
}

DateTime getDateTime({required String date, String? time}) {
  DateTime? dates = DateTime.tryParse(date.validate());
  DateTime? times = DateTime.tryParse(time.validate());
  return DateTime(dates!.year, dates.month, dates.day, times!.hour, times.minute, times.second);
}

void ifNotTester(BuildContext context, VoidCallback callback) {
  if (isDoctor() && userStore.userEmail != doctorEmail) {
    callback.call();
  } else if (isPatient() && userStore.userEmail != patientEmail) {
    callback.call();
  } else if (isReceptionist() && userStore.userEmail != receptionistEmail) {
    callback.call();
  } else {
    hideKeyboard(context);
    toast(locale.lblUnAuthorized);
  }
}

void ifTester(BuildContext context, VoidCallback callback, {String? userEmail}) {
  if (isDoctor() && userStore.userEmail != doctorEmail && userEmail == patientEmail) {
    hideKeyboard(context);
    toast(locale.lblUnAuthorized);
  } else if (isReceptionist() && userStore.userEmail == receptionistEmail && (userEmail == patientEmail || userEmail == doctorEmail)) {
    hideKeyboard(context);
    toast(locale.lblUnAuthorized);
  } else {
    callback.call();
  }
}

dynamic shimmerBoxInputDecoration({double? borderRadiusValue, Color? color, BoxShape? shape}) {
  return boxDecorationDefault(
    boxShadow: [],
    shape: shape,
    color: color ?? primaryColor.withOpacity(0.2),
    borderRadius: radius(borderRadiusValue ?? 4),
  );
}

void datePickerComponent(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? helpText,
  bool isAgeVerificationRequired = false,
  Function(DateTime?)? onDateSelected,
}) async {
  hideKeyboard(context);
  await showDatePicker(
    context: context,
    locale: Locale(appStore.selectedLanguage),
    firstDate: firstDate != null
        ? firstDate
        : isAgeVerificationRequired
            ? DateTime(1900)
            : DateTime.now(),
    lastDate: lastDate != null
        ? lastDate
        : isAgeVerificationRequired
            ? DateTime.now()
            : DateTime(2101),
    initialDate: initialDate ?? DateTime.now(),
    initialDatePickerMode: DatePickerMode.day,
    helpText: helpText,
    builder: (context, child) {
      return Theme(
        data: appStore.isDarkModeOn
            ? ThemeData.dark(useMaterial3: true).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark))
            : ThemeData.light(useMaterial3: true).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light)),
        child: child.cornerRadiusWithClipRRect(24),
      );
    },
  ).then((value) {
    if (isAgeVerificationRequired && value != null && DateTime.now().year - value.year < 18) {
      Fluttertoast.cancel();
      toast(
        locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - value.year}',
        bgColor: context.cardColor,
        textColor: errorTextColor,
      );
      datePickerComponent(context, initialDate: value, firstDate: DateTime(1900), isAgeVerificationRequired: true);
    } else {
      onDateSelected?.call(value);
    }
  });
}

Future<void> dateBottomSheet(context, {DateTime? bDate, Function(DateTime?)? onBirthDateSelected}) async {
  hideKeyboard(context);
  if (bDate == null) {
    bDate = DateTime.now();
  }
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: radius()),
    builder: (BuildContext e) {
      DateTime? birthDate;
      return Container(
        height: e.height() / 2 - 180,
        color: e.cardColor,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.lblCancel, style: boldTextStyle()).appOnTap(
                    () {
                      finish(context);
                    },
                  ),
                  Text(locale.lblDone, style: boldTextStyle()).appOnTap(
                    () {
                      if (DateTime.now().year - bDate!.year < 18) {
                        toast(
                          locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - bDate!.year}',
                          bgColor: context.cardColor,
                          textColor: errorTextColor,
                        );
                      } else {
                        onBirthDateSelected?.call(bDate);
                        finish(context);
                      }
                    },
                  )
                ],
              ).paddingOnly(top: 8, left: 8, right: 8, bottom: 8),
            ),
            Container(
              height: e.height() / 2 - 240,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: primaryTextStyle(size: 20)),
                ),
                child: CupertinoDatePicker(
                  minimumDate: DateTime(1900, 1, 1),
                  minuteInterval: 1,
                  initialDateTime: bDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime selectedDate) {
                    bDate = selectedDate;
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
