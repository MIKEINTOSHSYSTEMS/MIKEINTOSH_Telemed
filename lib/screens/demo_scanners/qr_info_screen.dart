import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
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
        "Try It! Buy It!",
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              86.height,
              Image.asset('images/appIcon.png', height: 108, width: 108).center(),
              16.height,
              RichTextWidget(
                list: [
                  TextSpan(text: APP_FIRST_NAME, style: boldTextStyle(size: 24, letterSpacing: 1)),
                  TextSpan(text: APP_SECOND_NAME, style: primaryTextStyle(size: 24, letterSpacing: 1)),
                ],
              ),
              32.height,
              Text('Try It! Buy It!', style: boldTextStyle(size: 26)),
              32.height,
              Text(
                'You are just one step away from having a hands-on backend demo.',
                style: secondaryTextStyle(),
                textAlign: TextAlign.center,
              ),
              32.height,
              Align(
                alignment: Alignment.topLeft,
                child: Text('Steps to generate the QR code', style: boldTextStyle(size: 18)),
              ),
              16.height,
              ULNew(
                symbolType: SymbolType.Numbered,
                spacing: 16,
                children: [
                  RichTextWidget(
                    list: [
                      TextSpan(text: 'Open the demo URL in Web. ', style: primaryTextStyle()),
                      TextSpan(
                        text: 'https://demo.kivicare.io/',
                        style: primaryTextStyle(color: primaryColor, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            commonLaunchUrl("https://demo.kivicare.io/");
                          },
                      ),
                    ],
                  ),
                  Text('Choose your role', style: primaryTextStyle()),
                  Text('Enter your email address as well as the temporary link', style: primaryTextStyle()),
                  Text('You will see a QR for App option on the right hand corner, click on that and scan it from the app', style: primaryTextStyle()),
                ],
              ),
              64.height,
              Text('Enjoy! the flawless Momona Healthcare system with ease', style: primaryTextStyle(size: 20, color: primaryColor)),
            ],
          ),
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
