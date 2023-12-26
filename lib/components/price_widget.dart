import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceWidget extends StatelessWidget {
  final String price;
  final TextStyle? textStyle;
  final int? textSize;
  final Color? textColor;

  PriceWidget({required this.price, this.textStyle, this.textSize, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${appStore.currency.validate()}$price',
      style: textStyle ?? boldTextStyle(size: textSize ?? textBoldSizeGlobal.toInt(), color: textColor ?? textPrimaryColorGlobal),
    );
  }
}
