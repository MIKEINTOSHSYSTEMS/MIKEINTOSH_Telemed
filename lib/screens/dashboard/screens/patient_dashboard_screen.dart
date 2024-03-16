import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/app_bar_title_widget.dart';
import 'package:momona_healthcare/components/dashboard_profile_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/patient/fragments/patient_appointment_fragment.dart';
import 'package:momona_healthcare/screens/patient/fragments/patient_dashboard_fragment.dart';
import 'package:momona_healthcare/screens/patient/screens/feeds/feed_fragment.dart';
import 'package:momona_healthcare/fragments/setting_fragment.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/product_list_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
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

  void init() async {
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
      if (showDashboard) PatientDashBoardFragment(),
      if (showAppointment) PatientAppointmentFragment(),
      FeedFragment(),
      SettingFragment(),
    ];
  }

  bool get showAppointment {
    return isVisible(SharedPreferenceKey.kiviCareAppointmentListKey);
  }

  bool get showDashboard {
    return isVisible(SharedPreferenceKey.kiviCareDashboardKey);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Observer(
        builder: (context) {
          if (patientStore.bottomNavIndex >= getScreens().length) patientStore.setBottomNavIndex(getScreens().length - 1);
          Color disableIconColor = appStore.isDarkModeOn ? Colors.white : secondaryTxtColor;
          return Scaffold(
            appBar: patientStore.bottomNavIndex != getScreens().length - 1
                ? appBarWidget(
                    '',
                    titleWidget: AppBarTitleWidget(),
                    showBack: false,
                    color: context.scaffoldBackgroundColor,
                    elevation: 0,
                    systemUiOverlayStyle: defaultSystemUiOverlayStyle(context,
                        color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : appPrimaryColor.withOpacity(0.02),
                        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark),
                    actions: [
                      ic_shop.iconImageColored(size: 28).paddingAll(14).appOnTap(() {
                        ProductListScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                      }),
                      DashboardTopProfileWidget(
                        refreshCallback: () => setState(() {}),
                      )
                    ],
                  )
                : null,
            body: getScreens()[patientStore.bottomNavIndex],
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
                  selectedIndex: patientStore.bottomNavIndex,
                  backgroundColor: context.cardColor,
                  animationDuration: 1000.milliseconds,
                  destinations: [
                    if (showDashboard)
                      NavigationDestination(
                        icon: Image.asset(ic_dashboard, height: iconSize, width: iconSize, color: disableIconColor),
                        label: locale.lblPatientDashboard,
                        selectedIcon: Image.asset(ic_dashboard, height: iconSize, width: iconSize, color: primaryColor),
                      ),
                    if (showAppointment)
                      NavigationDestination(
                        icon: Image.asset(ic_calendar, height: iconSize, width: iconSize, color: disableIconColor),
                        label: locale.lblAppointments,
                        selectedIcon: Image.asset(ic_calendar, height: iconSize, width: iconSize, color: primaryColor),
                      ),
                    NavigationDestination(
                      icon: Image.asset(ic_document, height: iconSize, width: iconSize, color: disableIconColor),
                      label: locale.lblFeedsAndArticles,
                      selectedIcon: Image.asset(ic_document, height: iconSize, width: iconSize, color: primaryColor),
                    ),
                    NavigationDestination(
                      icon: Image.asset(ic_more_item, height: iconSize, width: iconSize, color: disableIconColor),
                      label: locale.lblSettings,
                      selectedIcon: Image.asset(ic_more_item, height: iconSize, width: iconSize, color: primaryColor),
                    ),
                  ],
                  onDestinationSelected: (index) {
                    patientStore.setBottomNavIndex(index);
                    setState(() {});
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
