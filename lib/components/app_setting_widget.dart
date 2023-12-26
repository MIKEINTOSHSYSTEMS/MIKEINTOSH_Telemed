import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AppSettingWidget extends StatelessWidget {
  final String? name;
  final String? subTitle;
  final String? image;
  final Function? onTap;
  final Widget? widget;
  final bool isLanguage;

  AppSettingWidget({this.name, this.subTitle, this.image, this.onTap, this.widget, this.isLanguage = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget == null
          ? onTap as void Function()?
          : () {
              widget.launch(context);
            },
      child: Container(
        width: context.width() / 2 - 24,
        padding: EdgeInsets.all(16),
        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLanguage ? Image.asset(image.validate(), height: 34, width: 34) : image.validate().iconImage(size: 34),
            16.height,
            Text(name.validate(), style: boldTextStyle(size: 16)),
            4.height,
            Text(subTitle.validate(), style: secondaryTextStyle(size: 12)),
          ],
        ),
      ),
    );
  }
}
