import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_logo.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/google_repository.dart';
import 'package:momona_healthcare/screens/auth/sign_in_screen.dart';
import 'package:momona_healthcare/screens/doctor/doctor_dashboard_screen.dart';
import 'package:momona_healthcare/screens/patient/p_dashboard_screen.dart';
import 'package:momona_healthcare/screens/receptionist/r_dashboard_screen.dart';
import 'package:momona_healthcare/screens/walkThrough/walk_through_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(appStore.isDarkModeOn ? scaffoldColorDark : scaffoldColorLight);

    afterBuildCreated(() {
      int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
      if (themeModeIndex == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
      }
    });

    await 2.seconds.delay;

    Timer.periodic(Duration(minutes: 10), (Timer t) {
      log(t.tick.validate());
      getConfiguration().catchError((e) {
        toast(e.toString());
      });
    });

    if (!getBoolAsync(IS_WALKTHROUGH_FIRST, defaultValue: false)) {
      WalkThroughScreen().launch(context, isNewTask: true); // User is for first time.
    } else if (appStore.isLoggedIn && isDoctor()) {
      DoctorDashboardScreen().launch(context, isNewTask: true); // User is Doctor
    } else if (appStore.isLoggedIn && isPatient()) {
      PatientDashBoardScreen().launch(context, isNewTask: true); // User is Patient
    } else if (appStore.isLoggedIn && isReceptionist()) {
      RDashBoardScreen().launch(context, isNewTask: true); // User is Receptionist
    } else {
      SignInScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppLogo(size: 125).center(),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('v ${packageInfo.versionName.validate()}', style: secondaryTextStyle(size: 16), textAlign: TextAlign.center),
                8.height,
                Text('© 2024. Made with love by MIKEINTOSH SYSTEMS', style: secondaryTextStyle(size: 12), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
