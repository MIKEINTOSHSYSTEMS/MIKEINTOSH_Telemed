import 'package:flutter/material.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:kivicare_flutter/utils/images.dart';

class AppLogo extends StatelessWidget {
  final double? size;

  AppLogo({this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(appIcon, height: size ?? 100, width: size ?? 100).center(),
        26.height,
        RichTextWidget(
          list: [
            TextSpan(text: APP_FIRST_NAME, style: boldTextStyle(size: 32, letterSpacing: 2)),
            TextSpan(text: APP_SECOND_NAME, style: primaryTextStyle(size: 32, letterSpacing: 2)),
          ],
        ).center(),
        8.height,
      ],
    );
  }
}
