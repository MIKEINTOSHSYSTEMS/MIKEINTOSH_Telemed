import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/name_initials_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/appointment_respository.dart';
import 'package:momona_healthcare/network/doctor_list_repository.dart';
import 'package:momona_healthcare/network/patient_list_repository.dart';
import 'package:momona_healthcare/screens/patient/fragments/feed_fragment.dart';
import 'package:momona_healthcare/screens/patient/fragments/patient_appointment_fragment.dart';
import 'package:momona_healthcare/screens/patient/fragments/patient_dashboard_fragment.dart';
import 'package:momona_healthcare/screens/patient/fragments/patient_setting_fragment.dart';
import 'package:momona_healthcare/screens/receptionist/screens/edit_patient_profile_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientDashBoardScreen extends StatefulWidget {
  @override
  _PatientDashBoardScreenState createState() => _PatientDashBoardScreenState();
}

class _PatientDashBoardScreenState extends State<PatientDashBoardScreen> {
  double iconSize = 24;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getDoctor();
    getPatient();
    getSpecialization();

    window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Observer(builder: (context) {
        Color disableIconColor = appStore.isDarkModeOn ? Colors.white : secondaryTxtColor;
        return Scaffold(
          appBar: patientStore.bottomNavIndex != 3
              ? appBarWidget(
                  '',
                  titleWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(ic_hi, width: 22, height: 22, fit: BoxFit.cover),
                          8.width,
                          Text(
                            locale.lblHi,
                            style: primaryTextStyle(color: appStore.isDarkModeOn ? white : secondaryTxtColor),
                          ),
                        ],
                      ),
                      2.height,
                      Text(' ${appStore.firstName.validate()} ${appStore.lastName.validate()}', style: boldTextStyle(size: 18)),
                    ],
                  ),
                  showBack: false,
                  color: context.scaffoldBackgroundColor,
                  elevation: 0,
                  systemUiOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: context.scaffoldBackgroundColor,
                    statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        EditPatientProfileScreen().launch(context);
                      },
                      child: Container(
                        decoration: boxDecorationDefault(color: context.primaryColor, border: Border.all(color: white, width: 4), shape: BoxShape.circle),
                        padding: appStore.profileImage.validate().isNotEmpty ? EdgeInsets.zero : EdgeInsets.all(12),
                        margin: EdgeInsets.only(right: 16),
                        child: appStore.profileImage.validate().isNotEmpty
                            ? CachedImageWidget(
                                url: appStore.profileImage.validate(),
                                fit: BoxFit.cover,
                                height: 46,
                                width: 46,
                                circle: true,
                                alignment: Alignment.center,
                              )
                            : NameInitialsWidget(
                                firstName: appStore.firstName.validate(value: 'K'),
                                lastName: appStore.lastName.validate(value: 'V'),
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                )
              : null,
          body: Stack(
            children: [
              Observer(builder: (context) {
                return Container(
                  child: [
                    PatientDashBoardFragment(),
                    PatientAppointmentFragment(),
                    FeedFragment(),
                    PatientSettingFragment(),
                  ][patientStore.bottomNavIndex],
                );
              }),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: patientStore.bottomNavIndex,
            onTap: (i) {
              patientStore.setBottomNavIndex(i);
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).cardColor,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 12,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(ic_dashboard, height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_dashboardFill, height: iconSize, width: iconSize),
                label: locale.lblPatientDashboard,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(ic_calendar, height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_calendarFill, height: iconSize, width: iconSize),
                label: locale.lblAppointments,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(ic_document, height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_document_fill, height: iconSize, width: iconSize),
                label: locale.lblFeedsAndArticles,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(ic_user, height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset(ic_profile_fill, height: iconSize, width: iconSize, color: primaryColor),
                label: locale.lblSettings,
              ),
            ],
          ),
        );
      }),
    );
  }
}
