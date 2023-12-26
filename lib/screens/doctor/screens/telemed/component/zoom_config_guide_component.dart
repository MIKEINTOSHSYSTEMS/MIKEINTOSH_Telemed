import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ZoomConfigGuideComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: viewLineColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lbl1, style: boldTextStyle()),
              6.width,
              RichTextWidget(
                list: [
                  TextSpan(text: locale.lblSignUpOrSignIn, style: primaryTextStyle()),
                  TextSpan(
                    text: locale.lblZoomMarketPlacePortal,
                    style: boldTextStyle(color: primaryColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://marketplace.zoom.us/');
                      },
                  ),
                ],
              ).expand(),
            ],
          ).paddingAll(8),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lbl2, style: boldTextStyle()),
              6.width,
              RichTextWidget(list: [
                TextSpan(text: locale.lblClickOnDevelopButton, style: primaryTextStyle()),
                TextSpan(
                  text: locale.lblCreateApp,
                  style: boldTextStyle(color: primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch("https://marketplace.zoom.us/develop/create");
                    },
                ),
              ], maxLines: 5)
                  .expand(),
            ],
          ).paddingAll(8),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lb13, style: boldTextStyle()),
              6.width,
              Text(locale.lblChooseAppTypeToJWT, style: primaryTextStyle()).expand(),
            ],
          ).paddingAll(8),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lbl4, style: boldTextStyle()),
              6.width,
              Text(locale.lblMandatoryMessage, style: primaryTextStyle()).expand(),
            ],
          ).paddingAll(8),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lbl5, style: boldTextStyle()),
              6.width,
              Text(locale.lblCopyAndPasteAPIKey, style: primaryTextStyle()).expand(),
            ],
          ).paddingAll(8),
        ],
      ),
    );
  }
}
