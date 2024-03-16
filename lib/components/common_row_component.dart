import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonRowComponent extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String value;
  final Color? valueColor;
  final int? valueSize;
  final int? titleSize;
  final bool isMarquee;
  final TextStyle? titleTextStyle;
  final TextStyle? valueTextStyle;
  final Widget? trailing;
  final Widget? leading;
  final paddingAfterLeading;
  final paddingBeforeTrailing;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? padding;
  CommonRowComponent(
      {required this.title,
      this.borderRadius,
      this.padding,
      this.paddingBeforeTrailing,
      this.paddingAfterLeading,
      this.trailing,
      this.leading,
      this.titleTextStyle,
      this.valueTextStyle,
      required this.value,
      this.isMarquee = false,
      this.valueColor,
      this.titleColor,
      this.valueSize,
      this.titleSize,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: backgroundColor ?? context.cardColor,
        borderRadius: radius(
          borderRadius ?? defaultRadius,
        ),
      ),
      padding: EdgeInsets.all(padding ?? 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading.paddingOnly(right: paddingAfterLeading ?? 4, top: 4),
          if (paddingAfterLeading != 0) 16.width,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title + " : ", style: titleTextStyle ?? secondaryTextStyle(size: valueSize ?? 14, color: titleColor), textAlign: TextAlign.left),
              8.width,
              (isMarquee
                      ? Marquee(
                          child: Text(value, style: valueTextStyle ?? boldTextStyle(size: 14, color: valueColor)),
                        )
                      : Text(
                          value,
                          style: valueTextStyle ??
                              boldTextStyle(
                                color: valueColor,
                                size: valueSize ?? textBoldSizeGlobal.toInt(),
                              ),
                          textAlign: TextAlign.start,
                        ))
                  .expand(flex: 2),
            ],
          ).expand(),
          trailing.paddingLeft(paddingBeforeTrailing ?? 4)
        ],
      ),
    );
  }
}
