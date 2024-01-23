import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';

//const DEMO_URL = 'https://kivicare-demo.iqonic.design/';
const DEMO_URL = 'https://sandboxdev.momonahealthcare.com/';
//const DEMO_URL = 'https://kivicare-demo.iqonic.design/';

// ignore: non_constant_identifier_names
List<String> RTLLanguage = ['ar'];

List<WeeklyAppointment> emptyGraphList = [
  WeeklyAppointment(x: "Monday", y: 0),
  WeeklyAppointment(x: "Tuesday", y: 0),
  WeeklyAppointment(x: "Wednesday", y: 0),
  WeeklyAppointment(x: "Thursday", y: 0),
  WeeklyAppointment(x: "Friday", y: 0),
  WeeklyAppointment(x: "Saturday", y: 0),
  WeeklyAppointment(x: "Sunday", y: 0),
];

List<String> appointmentStatusList = [locale.lblAll, locale.lblLatest, locale.lblCompleted, locale.lblCancelled, locale.lblPast];

List<String> themeModeList = [locale.lblLight, locale.lblDark, locale.lblSystemDefault];

// Loader Size
double loaderSize = 30;

// EmailsWakelock
const receptionistEmail = "reception@momonahealthcare";
const doctorEmail = "doctor@momonahealthcare.com";
const patientEmail = "michaelktd@gmail.com";

//Demo Password
const loginPassword = "01234567";

/* Theme Mode Type */
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;

/* DateFormats */
const FORMAT_12_HOUR = 'hh:mm a';
const TIME_WITH_SECONDS = 'hh:mm:ss';
const APPOINTMENT_DATE_FORMAT = 'dd-MMM-yyyy';
const BIRTH_DATE_FORMAT = 'dd-MM-yyyy';
const CONVERT_DATE = 'yyyy-MM-dd';
const DATE_FORMAT = 'HH:mm';

const tokenStream = 'tokenStream';

const TOTAL_PATIENT = "Total Patient";
const TOTAL_DOCTOR = "Total Doctors";

// Static DATA
const SPECIALIZATION = "SPECIALIZATION";
const SERVICE_TYPE = "service_type";

// Holidays
const DOCTOR = "doctor";
const CLINIC = "clinic";

// User Roles
const UserRoleDoctor = 'doctor';
const UserRolePatient = 'patient';
const UserRoleReceptionist = 'receptionist';

// Appointment Status
const BookedStatus = 'Booked';
const CheckOutStatus = 'Check out';
const CheckInStatus = 'Check in';
const CancelledStatus = 'Cancelled';

// Shared preferences keys
const USER_NAME = 'USER_NAME';
const USER_PASSWORD = 'USER_PASSWORD';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_REMEMBER_ME = 'IS_REMEMBER_ME';
const TOKEN = 'TOKEN';
const LANGUAGE = 'LANGUAGE';
const SELECTED_LANGUAGE = "SELECTED_LANGUAGE";
const USER_ID = "USER_ID";
const USER_DATA = "USER_DATA";
const FIRST_NAME = "FIRST_NAME";
const LAST_NAME = "LAST_NAME";
const USER_EMAIL = "USER_EMAIL";
const USER_LOGIN = "USER_LOGIN";
const USER_MOBILE = 'USER_MOBILE';
const USER_GENDER = 'USER_GENDER';
const USER_DISPLAY_NAME = "USER_DISPLAY_NAME";
const PROFILE_IMAGE = "PROFILE_IMAGE";
const DEMO_DOCTOR = "DEMO_DOCTOR";
const DEMO_RECEPTIONIST = "DEMO_RECEPTIONIST";
const DEMO_PATIENT = "DEMO_PATIENT";
const PASSWORD = "PASSWORD";
const USER_ROLE = "USER_ROLE";
const USER_CLINIC = "USER_CLINIC";
const USER_TELEMED_ON = "USER_TELEMED_ON";
const USER_PRO_ENABLED = "USER_PRO_ENABLED";
const USER_ENCOUNTER_MODULES = "USER_ENCOUNTER_MODULES";
const USER_PRESCRIPTION_MODULE = "USER_PRESCRIPTION_MODULE";
const USER_MODULE_CONFIG = "USER_MODULE_CONFIG";
const USER_ENABLE_GOOGLE_CAL = "USER_ENABLE_GOOGLE_CAL";
const DOCTOR_ENABLE_GOOGLE_CAL = "DOCTOR_ENABLE_GOOGLE_CAL";
const SET_TELEMED_TYPE = "SET_TELEMED_TYPE";
const USER_MEET_SERVICE = "USER_MEET_SERVICE";
const USER_ZOOM_SERVICE = "USER_ZOOM_SERVICE";
const RESTRICT_APPOINTMENT_POST = "RESTRICT_APPOINTMENT_POST";
const RESTRICT_APPOINTMENT_PRE = "RESTRICT_APPOINTMENT_PRE";
const CURRENCY = "CURRENCY";
const IS_WALKTHROUGH_FIRST = "IS_WALKTHROUGH_FIRST";
const ON = "on";
const OFF = "off";
const SAVE_BASE_URL = "SAVE_BASE_URL";
const GOOGLE_USER_NAME = "GOOGLE_USER_NAME";
const GOOGLE_EMAIL = "GOOGLE_EMAIL";
const GOOGLE_PHOTO_URL = "GOOGLE_PHOTO_URL";

const PROBLEM = "problem";
const OBSERVATION = "observation";
const NOTE = "note";

const UPDATE = "UPDATE";
const DELETE = "DELETE";
const APP_UPDATE = "APP_UPDATE";
const CHANGE_DATE = "CHANGE_DATE";
const DEMO_EMAILS = 'demoEmails';

int titleTextSize = 18;
