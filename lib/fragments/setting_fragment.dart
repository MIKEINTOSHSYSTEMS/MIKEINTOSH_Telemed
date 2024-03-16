import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/app_setting_component.dart';
import 'package:momona_healthcare/components/app_setting_widget.dart';
import 'package:momona_healthcare/components/common_shop_setting_component.dart';
import 'package:momona_healthcare/components/doctor_recentionist_general_setting_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/other_settings_component.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/screens/auth/components/edit_profile_component.dart';
import 'package:momona_healthcare/screens/dashboard/screens/common_settings_screen.dart';
import 'package:momona_healthcare/screens/patient/components/general_setting_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingFragment extends StatefulWidget {
  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SafeArea(
          child: AnimatedScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 60),
            listAnimationType: ListAnimationType.None,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileComponent(refreshCallback: () {
                setState(() {});
              }),
              Divider(
                height: isReceptionist() || isPatient() ? 30 : 40,
                color: context.dividerColor,
              ),
              Text(locale.lblGeneralSetting, textAlign: TextAlign.center, style: secondaryTextStyle()),
              16.height,
              if (isPatient()) GeneralSettingComponent(callBack: () => setState(() {})),
              if (isDoctor() || isReceptionist()) DoctorReceptionistGeneralSettingComponent(),
              Divider(
                height: isReceptionist() || isPatient() ? 30 : 40,
                color: context.dividerColor,
              ),
              Text(locale.lblShop, textAlign: TextAlign.center, style: secondaryTextStyle()),
              16.height,
              CommonShopSettingComponent(),
              Divider(
                height: 24,
                color: context.dividerColor,
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
          ),
        ),
        Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
      ],
    );
  }
}
