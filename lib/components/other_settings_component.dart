import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/app_setting_widget.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/screens/about_us_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/cached_value.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OtherSettingsComponent extends StatelessWidget {
  const OtherSettingsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        AppSettingWidget(
          name: locale.lblTermsAndCondition,
          image: ic_termsAndCondition,
          subTitle: locale.lblTermsConditionSubTitle,
          onTap: () {
            if (userStore.termsEndConditionUrl.validate().isNotEmpty)
              launchUrlCustomTab(userStore.termsEndConditionUrl.validate());
            else
              launchUrlCustomTab(TERMS_AND_CONDITION_URL);
          },
        ),
        AppSettingWidget(
          name: locale.lblAboutUs,
          image: ic_aboutUs,
          widget: AboutUsScreen(),
          subTitle: locale.lblAboutKiviCare,
        ),
        AppSettingWidget(
          name: locale.lblRateUs,
          image: ic_rateUs,
          subTitle: locale.lblRateUsSubTitle,
          onTap: () async {
            commonLaunchUrl(playStoreBaseURL + await getPackageInfo().then((value) => value.packageName.validate()), launchMode: LaunchMode.externalApplication);
          },
        ),
        AppSettingWidget(
          image: ic_helpAndSupport,
          name: locale.lblHelpAndSupport,
          subTitle: locale.lblHelpAndSupportSubTitle,
          onTap: () {
            commonLaunchUrl(SUPPORT_URL);
          },
        ),
        AppSettingWidget(
          name: locale.lblShareKiviCare,
          image: ic_share,
          subTitle: locale.lblReachUsMore,
          onTap: () async {
            Share.share('${locale.lblShare} $APP_NAME app\n\n$playStoreBaseURL${await getPackageInfo().then((value) => value.packageName.validate())}');
          },
        ),
        AppSettingWidget(
          name: locale.lblDeleteAccount,
          image: ic_delete_icon,
          subTitle: locale.lblDeleteAccountSubTitle,
          onTap: () async {
            showConfirmDialogCustom(
              context,
              customCenterWidget: Container(
                child: Stack(
                  children: [
                    defaultPlaceHolder(
                      context,
                      DialogType.DELETE,
                      136.0,
                      context.width(),
                      appSecondaryColor,
                      shape: RoundedRectangleBorder(borderRadius: radius()),
                    ),
                    Positioned(
                      left: 42,
                      bottom: 12,
                      right: 16,
                      child: Text(locale.lblDeleteAccountNote, style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                    )
                  ],
                ),
              ),
              dialogType: DialogType.DELETE,
              negativeText: locale.lblNo,
              positiveText: locale.lblYes,
              onAccept: (c) {
                ifNotTester(context, () {
                  appStore.setLoading(true);

                  deleteAccountPermanently().then((value) async {
                    toast(value.message);
                    if (isDoctor()) {
                      cachedDoctorAppointment = null;
                      cachedDoctorAppointment = [];
                      cachedDoctorPatient = [];
                    }
                    if (isReceptionist()) {
                      cachedReceptionistAppointment = null;
                      cachedDoctorList = [];
                      cachedClinicPatient = [];
                    }
                    if (isPatient()) {
                      cachedPatientAppointment = [];
                      cachedPatientAppointment = null;
                    }
                    await removeKey(IS_REMEMBER_ME);

                    logout(isTokenExpired: true);
                  }).catchError((e) {
                    appStore.setLoading(false);
                    throw e;
                  });
                });
              },
              title: locale.lblDoYouWantToDeleteAccountPermanently,
            );
          },
        ),
        AppSettingWidget(
          name: locale.lblAppVersion,
          image: ic_app_version,
          subTitle: packageInfo.versionName,
        ),
        TextButton(
          onPressed: () {
            showConfirmDialogCustom(
              context,
              primaryColor: primaryColor,
              negativeText: locale.lblCancel,
              positiveText: locale.lblYes,
              onAccept: (c) {
                appStore.setLoading(true);

                logout(isTokenExpired: true).catchError((e) {
                  appStore.setLoading(false);

                  throw e;
                });
              },
              title: locale.lblDoYouWantToLogout,
            );
          },
          child: Text(
            locale.lblLogOut,
            style: primaryTextStyle(color: primaryColor),
          ),
        ).center()
      ],
    );
  }
}
