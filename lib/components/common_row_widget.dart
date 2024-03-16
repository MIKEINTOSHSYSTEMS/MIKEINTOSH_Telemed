import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonRowWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String value;
  final Color? valueColor;
  final int? valueSize;
  final int? titleSize;
  final bool isMarquee;
  final BoxFit? boxFit;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;

  CommonRowWidget({required this.title, this.valueStyle, this.boxFit, this.titleStyle, required this.value, this.isMarquee = false, this.valueColor, this.titleColor, this.valueSize, this.titleSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          fit: boxFit ?? BoxFit.scaleDown,
          child: Text(title, style: titleStyle ?? secondaryTextStyle(size: titleSize ?? 14, color: titleColor), textAlign: TextAlign.center),
        ).expand(flex: 1),
        8.width,
        (isMarquee
                ? Marquee(
                    child: Text(value, style: valueStyle ?? boldTextStyle(size: 14, color: valueColor)),
                  )
                : Text(value, style: valueStyle ?? boldTextStyle(color: valueColor, size: valueSize ?? textBoldSizeGlobal.toInt())))
            .expand(flex: 4),
      ],
    );
  }
}
