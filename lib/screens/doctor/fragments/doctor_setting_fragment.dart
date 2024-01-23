import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_common_dialog.dart';
import 'package:momona_healthcare/components/app_setting_widget.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/components/setting_third_page.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/response_model.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/network/google_repository.dart';
import 'package:momona_healthcare/screens/about_us_screen.dart';
import 'package:momona_healthcare/screens/auth/change_password_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/doctor_session_list_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/edit_profile_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/holiday_list_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/service_list_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/telemed/telemed_screen.dart';
import 'package:momona_healthcare/screens/language_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/app_widgets.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

class DoctorSettingFragment extends StatefulWidget {
  @override
  _DoctorSettingFragmentState createState() => _DoctorSettingFragmentState();
}

class _DoctorSettingFragmentState extends State<DoctorSettingFragment> with SingleTickerProviderStateMixin {
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

  Widget buildDoctorEditProfileWidget() {
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
                onTap: () => EditProfileScreen().launch(context),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: boxDecorationDefault(border: Border.all(color: white, width: 3), shape: BoxShape.circle, color: appPrimaryColor),
                  child: ic_edit.iconImage(size: 20, color: Colors.white, fit: BoxFit.contain),
                ),
              ),
            ),
          ],
        ),
        20.height,
        Text(
          getRoleWiseName(name: "${appStore.firstName.validate()} ${appStore.lastName.validate()}"),
          style: boldTextStyle(size: 20),
        ),
        RoleWidget(
          isShowDoctor: appStore.userEnableGoogleCal == ON && isProEnabled(),
          child: Column(
            children: [
              20.height,
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
                      onAccept: (c) {
                        disconnectGoogleCalendar().then((value) {
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
          ),
        ),
      ],
    );
  }

  Widget buildDoctorFirstWidget() {
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
        if (appStore.userTelemedOn.validate() || appStore.userMeetService.validate())
          AppSettingWidget(
            name: locale.lblTelemed,
            image: ic_telemed,
            widget: TelemedScreen(),
            subTitle: locale.lblVideoConsulting,
          ),
      ],
    );
  }

  Widget buildDoctorSecondWidget() {
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
              builder: (p0) => AppCommonDialog(
                title: locale.lblSelectTheme,
                child: buildSelectThemeWidget(),
              ),
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
                  20.height,
                  buildDoctorEditProfileWidget(),
                  30.height,
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
                        buildDoctorFirstWidget().paddingAll(16),
                        buildDoctorSecondWidget().paddingAll(16),
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
