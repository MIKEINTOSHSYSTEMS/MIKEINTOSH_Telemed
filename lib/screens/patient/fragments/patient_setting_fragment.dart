import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_common_dialog.dart';
import 'package:momona_healthcare/components/app_setting_widget.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/setting_third_page.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/screens/about_us_screen.dart';
import 'package:momona_healthcare/screens/auth/change_password_screen.dart';
import 'package:momona_healthcare/screens/language_screen.dart';
import 'package:momona_healthcare/screens/patient/screens/patient_encounter_screen.dart';
import 'package:momona_healthcare/screens/receptionist/screens/edit_patient_profile_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

class PatientSettingFragment extends StatefulWidget {
  @override
  _PatientSettingFragmentState createState() => _PatientSettingFragmentState();
}

class _PatientSettingFragmentState extends State<PatientSettingFragment> with SingleTickerProviderStateMixin {
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

  //region Widgets

  Widget buildEditProfileWidget() {
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
                onTap: () {
                  EditPatientProfileScreen().launch(context);
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: appPrimaryColor,
                    boxShape: BoxShape.circle,
                    border: Border.all(color: white, width: 3),
                  ),
                  child: Image.asset(ic_edit, height: 20, width: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        22.height,
        Text(
          getRoleWiseName(name: "${appStore.firstName.validate()} ${appStore.lastName.validate()}"),
          style: boldTextStyle(),
        ),
        Text(
          appStore.userEmail.validate(),
          style: primaryTextStyle(),
        ),
      ],
    );
  }

  Widget buildFirstWidget() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16,
      runSpacing: 16,
      children: [
        AppSettingWidget(
          name: locale.lblEncounters,
          image: ic_services,
          widget: PatientEncounterScreen(),
          subTitle: locale.lblYourEncounters,
        ),
      ],
    );
  }

  Widget buildSecondWidget() {
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
                  child: ListView.builder(
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
                  ),
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
                children: <Widget>[
                  50.height,
                  buildEditProfileWidget(),
                  20.height,
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
                        buildFirstWidget().paddingAll(16),
                        buildSecondWidget().paddingAll(16),
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
