import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
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
              widget.launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                setStatusBarColor(
                  appStore.isDarkModeOn ? context.scaffoldBackgroundColor : appPrimaryColor.withOpacity(0.02),
                  statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
                );
              });
            },
      child: SettingItemWidget(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          title: name.validate(),
          titleTextStyle: primaryTextStyle(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          subTitle: subTitle.validate(),
          leading: isLanguage ? Image.asset(image.validate(), height: 24, width: 24) : image.validate().iconImage(size: 24),
          trailing: widget != null || onTap != null
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor.withOpacity(0.5),
                  size: 16,
                ).paddingOnly(left: 16, right: 4, top: 8, bottom: 8).appOnTap(
                    widget == null
                        ? onTap as void Function()?
                        : () {
                            widget.launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                          },
                  )
              : Offstage()),
    );
  }
}
