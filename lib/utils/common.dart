import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView, bool showToast = true}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    if (showToast) toast('${locale.lblInvalidURL}');
    throw e;
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!, showToast: false, launchMode: LaunchMode.externalApplication).catchError((e) {
        toast("Contact number does not exist");
        throw e.toString();
      });
    else
      commonLaunchUrl('tel:' + url!, launchMode: LaunchMode.externalApplication).catchError((e) {
        toast("Contact number does not exist");
        throw e.toString();
      });
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', showToast: false, launchMode: LaunchMode.externalApplication).catchError((e) {
      toast("Email does not exist");
      throw e.toString();
    });
  }
}

bool isVisible(String key) {
  return getBoolAsync(key, defaultValue: true);
}

Future<void> meetLaunch(String url) async {
  await commonLaunchUrl(url, showToast: false, launchMode: LaunchMode.externalApplication).catchError((e) {
    toast('Invalid URL: $url');
  });
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    custom_tabs.launch(
      url!,
      customTabsOption: custom_tabs.CustomTabsOption(
        enableDefaultShare: true,
        enableInstantApps: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        toolbarColor: primaryColor,
      ),
      safariVCOption: custom_tabs.SafariViewControllerOption(
        preferredBarTintColor: primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}

List<DateTime> getDatesBetweenTwoDates(DateTime startDate, DateTime endDate) {
  List<DateTime> dates = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    dates.add(startDate.add(Duration(days: i)));
  }
  return dates;
}

int getDateDifference(String sDate, {String? eDate, bool isForHolidays = false}) {
  DateTime startDate = new DateFormat(SAVE_DATE_FORMAT).parse(sDate);

  DateTime endDate = new DateFormat(SAVE_DATE_FORMAT).parse(eDate ?? DateTime.now().toString());
  Duration diff = endDate.difference(startDate);

  return diff.inDays;
}

InputDecoration inputDecoration({
  required BuildContext context,
  Widget? prefixIcon,
  Color? fillColor,
  String? labelText,
  EdgeInsets? contentPadding,
  String? hintText,
  Widget? suffixIcon,
  TextStyle? labelStyle,
  InputBorder? border,
}) {
  return InputDecoration(
    contentPadding: contentPadding ?? EdgeInsets.all(10),
    labelText: labelText,
    labelStyle: labelStyle ?? secondaryTextStyle(),
    alignLabelWithHint: false,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    fillColor: fillColor ?? context.cardColor,
    disabledBorder: OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
    border: border ?? OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
    enabledBorder: border ?? OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: Colors.red, width: 0.0)),
    errorBorder: OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: Colors.red, width: 1.0)),
    focusedBorder: OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: primaryColor, width: 0.0)),
  );
}

bool get isRTL => RTLLanguage.contains(appStore.selectedLanguageCode);

DateTime getDay(DateTime date) {
  return DateTime.parse(DateFormat(SAVE_DATE_FORMAT).format(date));
}

String getStatus(String num) {
  String status = "";
  if (num == '0') {
    return status = locale.lblCancelled;
  } else if (num == '1') {
    return status = locale.lblBooked;
  } else if (num == '2') {
    return status = locale.lblPending;
  } else if (num == '3') {
    return status = locale.lblCheckOut;
  } else if (num == '4') {
    return status = locale.lblCheckIn;
  }
  return status;
}

Color commonStatusColor(String num) {
  if (num == '1') {
    return activeStatusGreenColor;
  } else if (num == '0') {
    return inactiveStatusRedColor;
  }
  return Colors.transparent;
}

Color getAppointStatusColor(String? num) {
  if (num == '0') {
    return inactiveStatusRedColor;
  } else if (num == '1') {
    return activeStatusGreenColor;
  } else if (num == '2') {
    return activeStatusGreenColor;
  } else if (num == '3') {
    return activeStatusGreenColor;
  } else if (num == '4') {
    return activeStatusGreenColor;
  }
  return Colors.transparent;
}

String getEncounterStatus(String? num) {
  String status = "";
  if (num == '0') {
    return status = locale.lblClosed;
  } else if (num == '1') {
    return status = locale.lblActive;
  } else if (num == '2') {
    return status = locale.lblInActive;
  }
  return status;
}

String getUserActivityStatus(String? num) {
  String status = "";
  if (num == '0') {
    return status = locale.lblInActive;
  } else if (num == '1') {
    return status = locale.lblActive;
  }
  return status;
}

String getServiceActivityStatus(String? num) {
  String status = "";
  if (num == '1') {
    return status = locale.lblActive;
  } else if (num == '0') {
    return status = locale.lblInActive;
  }
  return status;
}

Color getServiceActivityStatusColor(String? num) {
  if (num == '1') {
    return activeStatusGreenColor;
  } else if (num == '0') {
    return inactiveStatusRedColor;
  }
  return Colors.transparent;
}

Color getUserActivityStatusColor(String? num) {
  if (num == '1') {
    return activeStatusGreenColor;
  } else if (num == '0') {
    return inactiveStatusRedColor;
  }
  return Colors.transparent;
}

Color getEncounterStatusColor(String? num) {
  if (num == '1') {
    return activeStatusGreenColor;
  } else if (num == '0') {
    return inactiveStatusRedColor;
  }
  return Colors.transparent;
}

String getPaymentStatus(String? num) {
  String status = "";
  if (num == '0') {
    return status = locale.lblUnPaid;
  } else if (num == '1') {
    return status = locale.lblPaid;
  }
  return status;
}

String getClinicStatus(String? num) {
  String? status;
  if (num == '0') {
    return status = locale.lblClose;
  } else if (num == '1') {
    return status = locale.lblOpen;
  }
  return status.validate(value: '');
}

Color getHolidayStatusColor(bool num, bool isOnLeave) {
  Color colors;
  if (isOnLeave)
    colors = appPrimaryColor;
  else {
    if (num) {
      colors = activeStatusGreenColor;
    } else {
      colors = inactiveStatusRedColor;
    }
  }
  return colors;
}

String getPrice(String price) {
  return (double.parse(price) / 100).toString();
}

bool isDoctor() => userStore.userRole == UserRoleDoctor;

bool isPatient() => userStore.userRole == UserRolePatient;

bool isReceptionist() => userStore.userRole == UserRoleReceptionist;

bool isProEnabled() => getBoolAsync(USER_PRO_ENABLED);

Future setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await FirebaseRemoteConfig.instance.fetchAndActivate().catchError((e) {
    log("Firebase Remote Failed");
    return false;
  });

  appStore.setDemoEmails();
}

String convertToAgo(String dateTime) {
  if (dateTime.isNotEmpty) {
    DateTime input = DateFormat(dateTime.contains('T') ? DATE_FORMAT_2 : DATE_FORMAT_1).parse(dateTime, true);

    return formatTime(input.millisecondsSinceEpoch);
  } else {
    return '';
  }
}

String formatTime(int timestamp) {
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference);
  } else if (difference < 3600000) {
    result = countMinutes(difference);
  } else if (difference < 86400000) {
    result = countHours(difference);
  } else if (difference < 604800000) {
    result = countDays(difference);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference);
  } else
    result = countYears(difference);

  return result != locale.justNow.capitalizeFirstLetter() ? result + ' ${locale.ago.toLowerCase()}' : result;
}

class HttpOverridesSkipCertificate extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}

Future<File?> getSignatureInFile(BuildContext context, {required SignatureController controller, int? height, int? width, required String fileName}) async {
  if (controller.isEmpty) return null;
  Uint8List? unit = await controller.toPngBytes(height: height ?? 150, width: width ?? context.width().toInt());

  Directory? directory = await getExternalStorageDirectory();

  await Directory('${directory!.path}/signature').create(recursive: true);
  File('${directory.path}/signature/$fileName.png').writeAsBytesSync(unit!.buffer.asInt8List());
  return File(Directory('${directory.path}/signature/$fileName.png').path);
}

//region Image DECODE AND ENCODE
dynamic convertImageToBase64(File file) {
  List<int> imageBytes = file.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);

  return 'data:image/png;base64,$base64Image';
}

Uint8List? getImageFromBase64(String value) {
  UriData? data = Uri.parse(value.validate()).data;

  return data?.contentAsBytes();
}
//endregion

String get getAppointmentDate => appointmentAppStore.selectedAppointmentDate.getFormattedDate(SAVE_DATE_FORMAT);
