import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/patient/components/html_widget.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

/*Future<void> commonLaunchUrl(String url, {bool forceWebView = false}) async {
  await launch(url, forceWebView: forceWebView, enableJavaScript: true, statusBarBrightness: Brightness.light).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}*/

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!, launchMode: LaunchMode.externalApplication);
    else
      commonLaunchUrl('tel:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', launchMode: LaunchMode.externalApplication);
  }
}

void checkIfLink(BuildContext context, String value, {String? title}) {
  if (value.validate().isEmpty) return;

  String temp = parseHtmlString(value.validate());
  if (temp.startsWith("https") || temp.startsWith("http")) {
    launchUrlCustomTab(temp.validate());
  } else if (temp.validateEmail()) {
    launchMail(temp);
  } else if (temp.validatePhone() || temp.startsWith('+')) {
    launchCall(temp);
  } else {
    HtmlWidget(postContent: value).launch(context);
  }
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

InputDecoration inputDecoration({required BuildContext context, String? labelText}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(),
      borderSide: BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: context.cardColor,
  );
}

bool get isRTL => RTLLanguage.contains(appStore.selectedLanguage);

DateTime getDay(DateTime date) {
  return DateTime.parse(DateFormat(CONVERT_DATE).format(date));
}

String getStatus(String num) {
  String status = "";
  if (num == '0') {
    return status = 'Cancelled';
  } else if (num == '1') {
    return status = 'Booked';
  } else if (num == '3') {
    return status = 'Checkout';
  } else if (num == '4') {
    return status = 'Checkin';
  }
  return status;
}

String? getEncounterStatus(String? num) {
  String? status;
  if (num == '0') {
    return status = 'Complete';
  } else if (num == '1') {
    return status = 'Active';
  } else if (num == '2') {
    return status = 'InActive';
  }
  return status;
}

String? getClinicStatus(String? num) {
  String? status;
  if (num == '0') {
    return status = 'Closed';
  } else if (num == '1') {
    return status = 'Open';
  }
  return status;
}

Color? getServiceStatusColor(int num) {
  Color? colors;
  if (num == 0) {
    return colors = Color(0xFFd0150f);
  } else if (num == 1) {
    return colors = Color(0xFF23a359);
  }
  return colors;
}

Color getHolidayStatusColor(bool num) {
  Color colors;
  if (num) {
    colors = Color(0xFF23a359);
  } else {
    colors = Color(0xFFd0150f);
  }
  return colors;
}

Color getEncounterStatusColor(String? num) {
  Color colors = Color(0xFFd0150f);
  if (num == '0') {
    return colors = Color(0xFFd0150f);
  } else if (num == '1') {
    return colors = Color(0xFF23a359);
  } else if (num == '2') {
    return colors = Color(0xFF23a359);
  }
  return colors;
}

List<String> monthNameList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

bool isDoctor() => appStore.userRole == UserRoleDoctor;

bool isPatient() => appStore.userRole == UserRolePatient;

bool isReceptionist() => appStore.userRole == UserRoleReceptionist;

bool isProEnabled() => getBoolAsync(USER_PRO_ENABLED);

void setDynamicStatusBarColor({Color? color}) {
  if (color != null) {
    setStatusBarColor(appStore.isDarkModeOn ? scaffoldColorDark : color);
  } else if (appStore.isDarkModeOn) {
    setStatusBarColor(scaffoldColorDark);
  } else {
    setStatusBarColor(Colors.white);
  }
}

Future setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await FirebaseRemoteConfig.instance.fetchAndActivate();

  appStore.setDemoEmails();
}

class HttpOverridesSkipCertificate extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
}
