import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final int? valueSize;
  final bool isMarquee;

  CommonRowWidget({required this.title, required this.value, this.isMarquee = false, this.valueColor, this.valueSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.antiAlias,
          fit: BoxFit.scaleDown,
          child: Text(title, style: secondaryTextStyle(size: 14)),
        ).expand(),
        (isMarquee
                ? Marquee(
                    child: Text(value, style: boldTextStyle(color: valueColor)),
                  )
                : Text(value, style: boldTextStyle(color: valueColor, size: valueSize ?? textBoldSizeGlobal.toInt())))
            .expand(flex: 4),
      ],
    );
  }
}
