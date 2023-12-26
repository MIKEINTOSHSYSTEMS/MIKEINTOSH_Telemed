import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> defaultValue() async {
  appStore.setBaseUrl(getStringAsync(SAVE_BASE_URL, defaultValue: BASE_URL));
  appStore.setDemoDoctor(getStringAsync(DEMO_DOCTOR));
  appStore.setDemoReceptionist(getStringAsync(DEMO_RECEPTIONIST));
  appStore.setDemoPatient(getStringAsync(DEMO_PATIENT));
  appStore.setCurrency(getStringAsync(CURRENCY));

  if (appStore.isLoggedIn) {
    appStore.setUserId(getIntAsync(USER_ID));
    appStore.setFirstName(getStringAsync(FIRST_NAME));
    appStore.setLastName(getStringAsync(LAST_NAME));
    appStore.setUserEmail(getStringAsync(USER_EMAIL));
    appStore.setUserDisplayName(getStringAsync(USER_DISPLAY_NAME));
    appStore.setUserProfile(getStringAsync(PROFILE_IMAGE, defaultValue: ""));
    appStore.setUserGender(getStringAsync(USER_GENDER));
    appStore.setRole(getStringAsync(USER_ROLE));
    appStore.setUserMobileNumber(getStringAsync(USER_MOBILE));
    appStore.setUserProEnabled(getBoolAsync(USER_PRO_ENABLED));
    appStore.setUserTelemedOn(getBoolAsync(USER_TELEMED_ON));
    appStore.setUserEnableGoogleCal(getStringAsync(USER_ENABLE_GOOGLE_CAL));
    appStore.setUserDoctorGoogleCal(getStringAsync(DOCTOR_ENABLE_GOOGLE_CAL));
  }
}

String getRoleWiseAppointmentName({required String name}) {
  if (isPatient() || isReceptionist()) {
    return 'Dr.$name';
  } else {
    return name;
  }
}

String getRoleWiseName({required String name}) {
  if (isDoctor()) {
    return 'Dr.$name';
  } else {
    return name;
  }
}

SystemUiOverlayStyle defaultSystemUiOverlayStyle(BuildContext context) {
  return SystemUiOverlayStyle(statusBarColor: context.primaryColor, statusBarIconBrightness: Brightness.light);
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

  return "$endPoint";
}

void getDisposeStatusBarColor({Color? colors}) {
  setStatusBarColor(colors ?? (appStore.isDarkModeOn.validate() ? scaffoldColorDark : scaffoldColorLight));
}
