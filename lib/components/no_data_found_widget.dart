import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String? text;
  final double? iconSize;

  NoDataFoundWidget({this.text, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          appStore.isDarkModeOn ? darkModeNoImage : noDataFound,
          height: iconSize ?? 180,
          fit: BoxFit.fitHeight,
        ),
        Text(text ?? locale.lblNoMatch, style: boldTextStyle(size: 18)),
        8.height.visible(false),
        Text(
          locale.lblNoDataSubTitle,
          textAlign: TextAlign.center,
          style: secondaryTextStyle(),
        ).visible(false),
      ],
    ).paddingAll(16);
  }
}
