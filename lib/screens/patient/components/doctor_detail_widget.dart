import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorDetailWidget extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subTitle;
  final Color? bgColor;
  final double? width;

  DoctorDetailWidget({Key? key, this.image, this.title, this.subTitle, this.bgColor, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingItemWidget(
      title: title.validate(),
      decoration: boxDecorationDefault(color: context.cardColor),
      leading: image.validate().iconImage(size: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      subTitle: subTitle.validate(),
      titleTextStyle: secondaryTextStyle(size: 13),
      subTitleTextStyle: boldTextStyle(),
    ).withWidth(width ?? context.width() / 2 - 22);
  }
}
