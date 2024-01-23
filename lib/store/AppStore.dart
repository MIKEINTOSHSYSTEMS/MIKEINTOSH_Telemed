import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/locale/app_localizations.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool isDarkModeOn = false;

  @observable
  bool isLoading = false;

  @observable
  bool isLoggedIn = false;

  @observable
  bool isBookedFromDashboard = false;

  @observable
  String mStatus = "all";

  @observable
  String? userEmail;

  @observable
  int? restrictAppointmentPost;

  @observable
  int? restrictAppointmentPre;

  @observable
  String? profileImage;

  @observable
  int? userId;

  @observable
  String? firstName;

  @observable
  String? lastName;

  @observable
  String? userRole;

  @observable
  String? userDisplayName;

  @observable
  String? userMobileNumber;

  @observable
  String? userGender;

  @observable
  String? currency;

  @observable
  String? tempBaseUrl;

  @observable
  bool? userTelemedOn;

  @observable
  bool? userProEnabled;

  @observable
  String? userEnableGoogleCal;

  @observable
  String? userDoctorGoogleCal;
  @observable
  String? googleUsername;

  @observable
  String? googleEmail;
  @observable
  String? googlePhotoURL;

  @observable
  String? telemedType;

  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE;

  @observable
  String? demoDoctor;

  @observable
  String? demoReceptionist;

  @observable
  String? demoPatient;

  @observable
  bool? userMeetService;

  @observable
  bool? zoomService;

  @observable
  String selectedLanguage = DEFAULT_LANGUAGE;

  @observable
  List<dynamic> demoEmails = [];

  @action
  void setDemoEmails() {
    String temp = FirebaseRemoteConfig.instance.getString(DEMO_EMAILS);
    log(temp);

    if (temp.isNotEmpty && temp.isJson()) {
      demoEmails = jsonDecode(temp) as List<dynamic>;
    } else {
      log('');
    }
  }

  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkModeOn = aIsDarkMode;

    if (isDarkModeOn) {
      textPrimaryColorGlobal = textPrimaryDarkColor;
      textSecondaryColorGlobal = textSecondaryWhiteColor;
      defaultLoaderBgColorGlobal = cardSelectedColor;
      selectedColor = Color(0xF4B4A4A);
    } else {
      textPrimaryColorGlobal = textPrimaryLightColor;
      textSecondaryColorGlobal = textSecondaryLightColor;
      defaultLoaderBgColorGlobal = Colors.white;
      selectedColor = getColorFromHex('#e6ecfa');
    }
  }

  @action
  Future<void> setLoggedIn(bool value) async {
    setValue(IS_LOGGED_IN, value);
    isLoggedIn = value;
  }

  @action
  Future<void> setBookedFromDashboard(bool value) async => isBookedFromDashboard = value;

  @action
  Future<void> setUserEmail(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_EMAIL, value);

    userEmail = value;
  }

  @action
  Future<void> setUserProfile(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(PROFILE_IMAGE, value);
    profileImage = value;
  }

  @action
  Future<void> setDemoDoctor(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(DEMO_DOCTOR, value);
    demoDoctor = value;
  }

  @action
  Future<void> setDemoReceptionist(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(DEMO_RECEPTIONIST, value);
    demoReceptionist = value;
  }

  @action
  Future<void> setDemoPatient(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(DEMO_PATIENT, value);
    demoPatient = value;
  }

  @action
  Future<void> setGoogleUsername(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(GOOGLE_USER_NAME, value);
    googleUsername = value;
  }

  @action
  Future<void> setGoogleEmail(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(GOOGLE_EMAIL, value);
    googleEmail = value;
  }

  @action
  Future<void> setGooglePhotoURL(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(GOOGLE_PHOTO_URL, value);
    googlePhotoURL = value;
  }

  @action
  Future<void> setRestrictAppointmentPost(int value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(RESTRICT_APPOINTMENT_POST, value);
    restrictAppointmentPost = value;
  }

  @action
  Future<void> setRestrictAppointmentPre(int value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(RESTRICT_APPOINTMENT_PRE, value);
    restrictAppointmentPre = value;
  }

  @action
  Future<void> setUserId(int value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_ID, value);
    userId = value;
  }

  @action
  Future<void> setFirstName(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(FIRST_NAME, value);
    firstName = value;
  }

  @action
  Future<void> setLastName(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(LAST_NAME, value);

    lastName = value;
  }

  @action
  Future<void> setLoading(bool value) async => isLoading = value;

  @action
  Future<void> setRole(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_ROLE, value);

    userRole = value;
  }

  @action
  Future<void> setUserDisplayName(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_DISPLAY_NAME, value);

    userDisplayName = value;
  }

  @action
  Future<void> setUserMobileNumber(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_MOBILE, value);

    userMobileNumber = value;
  }

  @action
  Future<void> setUserGender(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_GENDER, value);

    userGender = value;
  }

  @action
  Future<void> setCurrency(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(CURRENCY, value);

    currency = value;
  }

  @action
  Future<void> setBaseUrl(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(SAVE_BASE_URL, value);
    log("Current Base Url :  $value");
    tempBaseUrl = value;
  }

  @action
  Future<void> setUserTelemedOn(bool value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_TELEMED_ON, value);

    userTelemedOn = value;
  }

  @action
  Future<void> setUserProEnabled(bool value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_PRO_ENABLED, value);

    userProEnabled = value;
  }

  Future<void> setUserEnableGoogleCal(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_ENABLE_GOOGLE_CAL, value);

    userEnableGoogleCal = value;
  }

  Future<void> setUserDoctorGoogleCal(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(DOCTOR_ENABLE_GOOGLE_CAL, value);

    userDoctorGoogleCal = value;
  }

  Future<void> setTelemedType(String value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(SET_TELEMED_TYPE, value);

    telemedType = value;
  }

  Future<void> setUserMeetService(bool value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_MEET_SERVICE, value);

    userMeetService = value;
  }

  Future<void> setUserZoomService(bool value, {bool initiliaze = false}) async {
    if (initiliaze) setValue(USER_ZOOM_SERVICE, value);

    zoomService = value;
  }

  @action
  Future<void> setLanguage(String val, {BuildContext? context}) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    locale = await AppLocalizations().load(Locale(selectedLanguageCode));
  }

  @action
  void setStatus(String aStatus) => mStatus = aStatus;
}
