import 'package:flutter/material.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAboutUs, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(APP_NAME, style: primaryTextStyle(size: 30)),
          16.height,
          Container(decoration: boxDecorationDefault(color: primaryColor, borderRadius: radius(4)), height: 4, width: 100),
          16.height,
          Text(locale.lblVersion, style: secondaryTextStyle()),
          Text('${packageInfo.versionName}', style: primaryTextStyle()),
          16.height,
          Text(locale.lblAboutUsDes, style: primaryTextStyle(size: 14), textAlign: TextAlign.justify),
          16.height,
          AppButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ic_contact.iconImage(size: 24, color: Colors.white),
                8.width,
                Text(locale.lblContactUs, style: primaryTextStyle(color: Colors.white)),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            onTap: () {
              launchMail(MAIL_TO);
            },
          ),
          AppButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ic_purchase.iconImage(color: Colors.white, size: 24),
                8.width,
                Text(locale.lblPurchase, style: primaryTextStyle(color: Colors.white)),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            onTap: () {
              launchUrlCustomTab(CODE_CANYON_URL);
            },
          ),
        ],
      ),
    );
  }
}
