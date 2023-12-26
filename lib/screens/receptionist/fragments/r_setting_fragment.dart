import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/app_common_dialog.dart';
import 'package:kivicare_flutter/components/app_setting_widget.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/setting_third_page.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/response_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/network/google_repository.dart';
import 'package:kivicare_flutter/screens/about_us_screen.dart';
import 'package:kivicare_flutter/screens/auth/change_password_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/doctor_session_list_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/holiday_list_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/service_list_screen.dart';
import 'package:kivicare_flutter/screens/language_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/patient_encounter_screen.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/edit_patient_profile_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/app_widgets.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

class RSettingFragment extends StatefulWidget {
  @override
  _RSettingFragmentState createState() => _RSettingFragmentState();
}

class _RSettingFragmentState extends State<RSettingFragment> with SingleTickerProviderStateMixin {
  TabController? tabController;

  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    tabController = new TabController(initialIndex: 0, length: 3, vsync: this);
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // region widget

  Widget buildSelectThemeWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: themeModeList.length,
      padding: EdgeInsets.only(bottom: 16),
      itemBuilder: (BuildContext context, int index) {
        return Theme(
          data: ThemeData(
            unselectedWidgetColor: context.dividerColor,
          ),
          child: RadioListTile(
            value: index,
            dense: true,
            groupValue: currentIndex,
            title: Text(themeModeList[index], style: primaryTextStyle()),
            onChanged: (dynamic val) {
              setState(() {
                currentIndex = val;

                if (val == THEME_MODE_SYSTEM) {
                  appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                } else if (val == THEME_MODE_LIGHT) {
                  appStore.setDarkMode(false);
                } else {
                  if (val == THEME_MODE_DARK) {
                    appStore.setDarkMode(true);
                  }
                }

                setValue(THEME_MODE_INDEX, val);
              });

              finish(context);
            },
          ),
        );
      },
    );
  }

  Widget buildREditProfileWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: [
            CachedImageWidget(url: appStore.profileImage.validate(), height: 90, circle: true, fit: BoxFit.cover),
            Positioned(
              bottom: -8,
              left: 0,
              right: -60,
              child: GestureDetector(
                onTap: () async {
                  await EditPatientProfileScreen().launch(context).then((value) {
                    if (value ?? false) {
                      setState(() {});
                      buildREditProfileWidget();
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: boxDecorationDefault(border: Border.all(color: white, width: 3), shape: BoxShape.circle, color: appPrimaryColor),
                  child: ic_edit.iconImage(size: 20, color: Colors.white, fit: BoxFit.contain),
                ),
              ),
            ),
          ],
        ),
        22.height,
        Text(getRoleWiseName(name: "${appStore.firstName.validate()} ${appStore.lastName.validate()}"), style: boldTextStyle()),
        Text(appStore.userEmail.validate(), style: primaryTextStyle()),
        28.height,
        if (isReceptionist() && appStore.userEnableGoogleCal == ON && isProEnabled())
          googleCalendar(context).onTap(
            () async {
              if (appStore.userDoctorGoogleCal != ON) {
                await authService.signInWithGoogle().then((user) async {
                  if (user != null) {
                    appStore.setLoading(true);

                    Map<String, dynamic> request = {
                      'code': await user.getIdToken().then((value) => value),
                    };

                    await connectGoogleCalendar(request: request).then((value) async {
                      ResponseModel data = value;

                      appStore.setUserDoctorGoogleCal(ON);

                      appStore.setGoogleUsername(user.displayName.validate(), initiliaze: true);
                      appStore.setGoogleEmail(user.email.validate(), initiliaze: true);
                      appStore.setGooglePhotoURL(user.photoURL.validate(), initiliaze: true);

                      toast(data.message);
                      appStore.setLoading(false);
                      setState(() {});
                    }).catchError((e) {
                      toast(e.toString());
                      appStore.setLoading(false);
                    });
                  }
                }).catchError((e) {
                  appStore.setLoading(false);
                  toast(e.toString());
                });
              } else {
                appStore.setLoading(true);
                showConfirmDialogCustom(
                  context,
                  onAccept: (c) async {
                    await disconnectGoogleCalendar().then((value) {
                      appStore.setUserDoctorGoogleCal(OFF);

                      appStore.setGoogleUsername("", initiliaze: true);
                      appStore.setGoogleEmail("", initiliaze: true);
                      appStore.setGooglePhotoURL("", initiliaze: true);
                      appStore.setLoading(false);
                      toast(value.message.validate());
                    }).catchError((e) {
                      appStore.setLoading(false);
                      toast(e.toString());
                    });
                  },
                  title: locale.lblAreYouSureYouWantToDisconnect,
                  dialogType: DialogType.CONFIRMATION,
                  positiveText: locale.lblYes,
                );
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
      ],
    );
  }

  Widget buildRFirstWidget() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16,
      runSpacing: 16,
      children: [
        AppSettingWidget(
          name: locale.lblServices,
          image: ic_services,
          widget: ServiceListScreen(),
          subTitle: locale.lblClinicServices,
        ),
        AppSettingWidget(
          name: locale.lblHoliday,
          image: ic_holiday,
          widget: HolidayScreen(),
          subTitle: locale.lblClinicHoliday,
        ),
        AppSettingWidget(
          name: locale.lblSessions,
          image: ic_calendar,
          widget: DoctorSessionListScreen(),
          subTitle: locale.lblClinicSessions,
        ),
        AppSettingWidget(
          name: locale.lblEncounters,
          image: ic_services,
          widget: PatientEncounterScreen(),
          subTitle: locale.lblYourEncounters,
        ),
      ],
    );
  }

  Widget buildRSecondWidget() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        AppSettingWidget(
          name: locale.lblSelectTheme,
          image: ic_darkmode,
          subTitle: locale.lblChooseYourAppTheme,
          onTap: () {
            showInDialog(
              context,
              contentPadding: EdgeInsets.zero,
              shape: dialogShape(),
              builder: (context) {
                return AppCommonDialog(
                  title: locale.lblSelectTheme,
                  child: buildSelectThemeWidget(),
                );
              },
            );
          },
        ),
        AppSettingWidget(
          name: locale.lblChangePassword,
          image: ic_unlock,
          widget: ChangePasswordScreen(),
        ),
        AppSettingWidget(
          name: locale.lblLanguage,
          isLanguage: true,
          subTitle: selectedLanguageDataModel!.name.validate(),
          image: selectedLanguageDataModel!.flag.validate(),
          onTap: () async {
            await LanguageScreen().launch(context).then((value) {
              setState(() {});
            });
          },
        ),
      ],
    );
  }


  //endregion

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  50.height,
                  buildREditProfileWidget(),
                  TabBar(
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: appStore.isDarkModeOn ? Colors.white : primaryColor,
                    isScrollable: false,
                    labelStyle: boldTextStyle(),
                    unselectedLabelStyle: primaryTextStyle(),
                    unselectedLabelColor: appStore.isDarkModeOn ? gray : textSecondaryColorGlobal,
                    indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: radius()), color: context.cardColor),
                    tabs: [
                      Tab(icon: Text(locale.lblGeneralSetting, textAlign: TextAlign.center)),
                      Tab(icon: Text(locale.lblAppSettings, textAlign: TextAlign.center)),
                      Tab(icon: Text(locale.lblOther, textAlign: TextAlign.center)),
                    ],
                  ).paddingAll(16).center(),
                  Container(
                    height: constraint.maxHeight,
                    child: TabBarView(
                      controller: tabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        buildRFirstWidget().paddingAll(16),
                        buildRSecondWidget().paddingAll(16),
                        SettingThirdPage().paddingAll(16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
