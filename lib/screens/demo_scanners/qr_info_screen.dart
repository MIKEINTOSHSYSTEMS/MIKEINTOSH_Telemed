import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class QrInfoScreen extends StatefulWidget {
  @override
  State<QrInfoScreen> createState() => _QrInfoScreenState();
}

class _QrInfoScreenState extends State<QrInfoScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
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
      appBar: appBarWidget(
        "${locale.lblTryIt}! ${locale.lblBuyIt}",
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            86.height,
            Image.asset(appIcon, height: 108, width: 108).center(),
            16.height,
            RichTextWidget(
              list: [
                TextSpan(text: APP_FIRST_NAME, style: boldTextStyle(size: 24, letterSpacing: 1)),
                TextSpan(text: APP_SECOND_NAME, style: primaryTextStyle(size: 24, letterSpacing: 1)),
              ],
            ),
            32.height,
            Text('${locale.lblTryIt}! ${locale.lblBuyIt}!', style: boldTextStyle(size: 26)),
            32.height,
            Text(
              locale.lblYouAreJustOneStepAwayFromHavingAHandsOnBackendDemo,
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            32.height,
            Align(
              alignment: Alignment.topLeft,
              child: Text(locale.lblStepsToGenerateQRCode, style: boldTextStyle(size: 18)),
            ),
            16.height,
            ULNew(
              symbolType: SymbolType.Numbered,
              spacing: 16,
              children: [
                RichTextWidget(
                  list: [
                    TextSpan(text: locale.lblOpenTheDemoUrlInWeb + '\n', style: primaryTextStyle()),
                    TextSpan(
                      text: 'https://momonahealthcare.com/',
                      style: primaryTextStyle(color: primaryColor, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          commonLaunchUrl("https://momonahealthcare.com/");
                        },
                    ),
                  ],
                ),
                Text(locale.lblChooseYourRole, style: primaryTextStyle()),
                Text(locale.lblEnterYourEmailAddressAsWellAsTheTemporaryLink, style: primaryTextStyle()),
                Text('${locale.lblYouWillSeeAQRForAppOptionOnTheRightHandCorner}${locale.lblClickOnThatAndScanItFromTheApp}', style: primaryTextStyle()),
              ],
            ),
            64.height,
            Text(locale.lblEnjoyTheFlawlessKivicareSystemWithEase, style: primaryTextStyle(size: 20, color: primaryColor)),
          ],
        ),
      ),
    );
  }
}

/// Add UL to its children
class ULNew extends StatelessWidget {
  final List<Widget>? children;
  final double padding;
  final double spacing;
  final SymbolType symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? edgeInsets;
  final Widget? customSymbol;
  final String? prefixText; // Used when SymbolType is Numbered

  ULNew({
    this.children,
    this.padding = 8,
    this.spacing = 8,
    this.symbolType = SymbolType.Bullet,
    this.symbolColor,
    this.textColor,
    this.customSymbol,
    this.prefixText,
    this.edgeInsets,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.validate().length, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: (index == children.validate().length - 1) ? 0 : spacing),
          padding: edgeInsets ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: symbolType == SymbolType.Numbered ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              symbolType == SymbolType.Bullet
                  ? Text(
                      '•',
                      style: boldTextStyle(color: symbolColor ?? textPrimaryColorGlobal, size: 24),
                    )
                  : SizedBox(),
              symbolType == SymbolType.Numbered ? Text('${prefixText.validate()} ${index + 1}.', style: boldTextStyle(color: symbolColor ?? textPrimaryColorGlobal)) : SizedBox(),
              (symbolType == SymbolType.Custom && customSymbol != null) ? customSymbol! : SizedBox(),
              SizedBox(width: padding),
              children![index].expand(),
            ],
          ),
        );
      }),
    );
  }
}
