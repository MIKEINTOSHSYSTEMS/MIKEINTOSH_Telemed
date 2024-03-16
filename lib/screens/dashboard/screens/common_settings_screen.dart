import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_setting_component.dart';
import 'package:momona_healthcare/components/other_settings_component.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonSettingsScreen extends StatefulWidget {
  const CommonSettingsScreen({Key? key}) : super(key: key);

  @override
  State<CommonSettingsScreen> createState() => _CommonSettingsScreenState();
}

class _CommonSettingsScreenState extends State<CommonSettingsScreen> {
  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblSettings,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: SafeArea(
        child: AnimatedScrollView(
          padding: EdgeInsets.all(16),
          children: [
            Text(locale.lblAppSettings, textAlign: TextAlign.center, style: secondaryTextStyle(size: 16)),
            16.height,
            AppSettingComponent(callSetState: () {
              setState(() {});
            }),
            24.height,
            Text(locale.lblOther, textAlign: TextAlign.center, style: secondaryTextStyle(size: 16)),
            OtherSettingsComponent(),
          ],
        ),
      ),
    );
  }
}
