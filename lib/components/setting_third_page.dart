import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_setting_widget.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/screens/about_us_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingThirdPage extends StatelessWidget {
  const SettingThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        AppSettingWidget(
          name: locale.lblTermsAndCondition,
          image: ic_termsandconition,
          subTitle: locale.lblClinicTAndC,
          onTap: () {
            launchUrlCustomTab(TERMS_AND_CONDITION_URL);
          },
        ),
        AppSettingWidget(
          name: locale.lblAboutUs,
          image: ic_aboutus,
          widget: AboutUsScreen(),
          subTitle: locale.lblAboutKiviCare,
        ),
        AppSettingWidget(
          name: locale.lblRateUs,
          image: ic_rateUs,
          subTitle: locale.lblYourReviewCounts,
          onTap: () async {
            commonLaunchUrl(playStoreBaseURL + await getPackageInfo().then((value) => value.packageName.validate()), launchMode: LaunchMode.externalApplication);
          },
        ),
        AppSettingWidget(
          name: locale.lblAppVersion,
          image: ic_app_version,
          subTitle: packageInfo.versionName,
        ),
        AppSettingWidget(
          image: ic_helpandsupport,
          name: locale.lblHelpAndSupport,
          subTitle: locale.lblSubmitYourQueriesHere,
          onTap: () {
            commonLaunchUrl(SUPPORT_URL);
          },
        ),
        AppSettingWidget(
          name: locale.lblShareKiviCare,
          image: ic_share,
          subTitle: "Reach us more",
          onTap: () async {
            Share.share('Share $APP_NAME app\n\n$playStoreBaseURL${await getPackageInfo().then((value) => value.packageName.validate())}');
          },
        ),
        AppSettingWidget(
          name: locale.lblLogout,
          subTitle: locale.lblThanksForVisiting,
          image: ic_logout,
          onTap: () async {
            showConfirmDialogCustom(
              context,
              primaryColor: primaryColor,
              negativeText: locale.lblCancel,
              positiveText: locale.lblYes,
              onAccept: (c) {
                logout(context);
              },
              title: locale.lblAreYouSureToLogout + '?',
            );
          },
        )
      ],
    );
  }
}
