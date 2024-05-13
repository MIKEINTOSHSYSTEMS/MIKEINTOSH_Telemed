import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/app_bar_title_widget.dart';
import 'package:kivicare_flutter/components/dashboard_profile_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/dashboard_model.dart';
import 'package:kivicare_flutter/network/dashboard_repository.dart';
import 'package:kivicare_flutter/screens/dashboard/fragments/doctor_list_fragment.dart';
import 'package:kivicare_flutter/screens/dashboard/fragments/patient_list_fragment.dart';
import 'package:kivicare_flutter/fragments/setting_fragment.dart';
import 'package:kivicare_flutter/screens/receptionist/fragments/r_appointment_fragment.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/product_list_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class RDashBoardScreen extends StatefulWidget {
  @override
  _RDashBoardScreenState createState() => _RDashBoardScreenState();
}

class _RDashBoardScreenState extends State<RDashBoardScreen> {
  Future<DashboardModel>? future;
  double iconSize = 24;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getUserDashBoardAPI().whenComplete(() {});
    afterBuildCreated(() {
      View.of(context).platformDispatcher.onPlatformBrightnessChanged = () {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
        }
      };
    });
  }

  List<Widget> getScreens() {
    return [
      // if (showDashboard) RDashboardFragment(),
      if (showAppointment) RAppointmentFragment(),
      if (showPatientList) PatientListFragment(),
      if (showDoctorList) DoctorListFragment(),
      SettingFragment(),
    ];
  }

  bool get showAppointment {
    return isVisible(SharedPreferenceKey.kiviCareAppointmentListKey);
  }

  bool get showDashboard {
    return isVisible(SharedPreferenceKey.kiviCareDashboardKey);
  }

  bool get showPatientList {
    return isVisible(SharedPreferenceKey.kiviCarePatientListKey);
  }

  bool get showDoctorList {
    return isVisible(SharedPreferenceKey.kiviCareDoctorListKey);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Observer(builder: (context) {
        if (receptionistAppStore.bottomNavIndex >= getScreens().length) receptionistAppStore.setBottomNavIndex(getScreens().length - 1);
        Color disableIconColor = appStore.isDarkModeOn ? Colors.white : secondaryTxtColor;
        return Scaffold(
          appBar: receptionistAppStore.bottomNavIndex != getScreens().length - 1
              ? appBarWidget(
                  '',
                  titleWidget: AppBarTitleWidget(),
                  showBack: false,
                  color: context.scaffoldBackgroundColor,
                  elevation: 0,
                  systemUiOverlayStyle: defaultSystemUiOverlayStyle(
                    context,
                    color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : appPrimaryColor.withOpacity(0.02),
                    statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
                  ),
                  actions: [
                    ic_shop.iconImageColored(size: 28).paddingAll(14).appOnTap(() {
                      ProductListScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                    }),
                    DashboardTopProfileWidget(refreshCallback: () => setState(() {})),
                  ],
                )
              : null,
          body: getScreens()[receptionistAppStore.bottomNavIndex],
          bottomNavigationBar: Blur(
            blur: 30,
            borderRadius: radius(0),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: context.primaryColor.withOpacity(0.02),
                indicatorColor: context.primaryColor.withOpacity(0.1),
                labelTextStyle: MaterialStateProperty.all(primaryTextStyle(size: 10)),
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: NavigationBar(
                height: 66,
                surfaceTintColor: context.scaffoldBackgroundColor,
                selectedIndex: receptionistAppStore.bottomNavIndex,
                backgroundColor: context.cardColor,
                animationDuration: 1000.milliseconds,
                destinations: [
                  if (showAppointment)
                    NavigationDestination(
                      icon: Image.asset(ic_calendar, height: iconSize, width: iconSize, color: disableIconColor),
                      label: locale.lblAppointments,
                      selectedIcon: Image.asset(ic_calendar, height: iconSize, width: iconSize, color: primaryColor),
                    ),
                  if (showPatientList)
                    NavigationDestination(
                      icon: Image.asset(ic_patient, height: iconSize, width: iconSize, color: disableIconColor),
                      label: locale.lblPatients,
                      selectedIcon: Image.asset(ic_patient, height: iconSize, width: iconSize, color: primaryColor),
                    ),
                  if (showDoctorList)
                    NavigationDestination(
                      icon: Image.asset(ic_doctorIcon, height: iconSize, width: iconSize, color: disableIconColor),
                      label: locale.lblDoctor.getApostropheString(apostrophe: false, count: 2),
                      selectedIcon: Image.asset(ic_doctorIcon, height: iconSize, width: iconSize, color: primaryColor),
                    ),
                  NavigationDestination(
                    icon: Image.asset(ic_more_item, height: iconSize, width: iconSize, color: disableIconColor),
                    label: locale.lblSettings,
                    selectedIcon: Image.asset(ic_more_item, height: iconSize, width: iconSize, color: primaryColor),
                  ),
                ],
                onDestinationSelected: (index) {
                  receptionistAppStore.setBottomNavIndex(index);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
