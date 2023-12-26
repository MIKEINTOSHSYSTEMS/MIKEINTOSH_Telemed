import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/demo_login_model.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 0, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flags/ic_us.png'),
    LanguageDataModel(id: 1, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'images/flags/ic_ar.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'images/flags/ic_india.png'),
    LanguageDataModel(id: 3, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'images/flags/ic_germany.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'images/flags/ic_french.png'),
  ];
}

List<DemoLoginModel> demoLoginList() {
  List<DemoLoginModel> demoLoginListData = [];
  demoLoginListData.add(DemoLoginModel(loginTypeImage: "images/icons/user.png"));
  demoLoginListData.add(DemoLoginModel(loginTypeImage: "images/icons/receptionistIcon.png"));
  demoLoginListData.add(DemoLoginModel(loginTypeImage: "images/icons/doctorIcon.png"));

  return demoLoginListData;
}

List<String> getServicesImages() {
  List<String> images = [];

  for (int i = 1; i < 6; i++) {
    images.add("images/services_icon/services$i.png");
  }
  return images;
}


Widget googleCalendar(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    width: 260,
    alignment: Alignment.center,
    decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(ic_google_calendar, height: 32, width: 32, fit: BoxFit.cover),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStore.userDoctorGoogleCal == ON ? '${locale.lblConnectedWith} ${appStore.googleEmail}' : "${locale.lblConnectWithGoogle}",
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            8.height,
            Text("${locale.lblGoogleCalendarConfiguration}", style: boldTextStyle(size: 16)),
          ],
        ).expand(),
      ],
    ),
  );
}
