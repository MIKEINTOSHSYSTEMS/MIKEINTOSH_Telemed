import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductShimmerComponent extends StatelessWidget {
  const ProductShimmerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerComponent(
      child: Container(
        width: context.width() / 2 - 24,
        decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
        child: Column(
          children: [
            ShimmerComponent(
              baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 70),
                decoration: boxDecorationDefault(
                  borderRadius: radiusOnly(
                    topLeft: defaultRadius,
                    topRight: defaultRadius,
                  ),
                ),
              ),
            ),
            ShimmerComponent(
              baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
              child: Container(
                width: context.width() - 32,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(),
              ),
            ).paddingSymmetric(horizontal: 32, vertical: 8),
            4.height,
            ShimmerComponent(
              baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ).paddingSymmetric(horizontal: 64).paddingBottom(8)
          ],
        ),
      ),
    );
  }
}
