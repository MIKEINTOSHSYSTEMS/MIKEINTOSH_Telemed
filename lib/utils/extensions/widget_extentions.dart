import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

extension WidgetExtension on Widget? {
  Widget appOnTap(
    Function? function, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
  }) {
    return InkWell(
      onTap: function as void Function()?,
      borderRadius: borderRadius ?? radius(),
      child: this,
      splashColor: splashColor ?? Colors.transparent,
      hoverColor: hoverColor ?? Colors.transparent,
      highlightColor: highlightColor ?? Colors.transparent,
    );
  }
}
