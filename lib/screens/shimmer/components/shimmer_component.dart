import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerComponent extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final Color? backgroundColor;
  final Color? baseColor;
  final Color? highlightColor;

  ShimmerComponent({this.height, this.width, this.child, this.backgroundColor, this.baseColor, this.highlightColor});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? primaryColor.withOpacity(0.5),
      highlightColor: highlightColor ?? Colors.transparent,
      enabled: true,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 1),
      child: child ??
          Container(
            height: height?.validate(),
            width: width.validate(),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: backgroundColor ?? Colors.white10),
          ),
    );
  }
}
