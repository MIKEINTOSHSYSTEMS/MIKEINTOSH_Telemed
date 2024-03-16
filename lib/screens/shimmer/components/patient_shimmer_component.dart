import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientShimmerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerComponent(
      child: Container(
        width: context.width(),
        padding: EdgeInsets.all(16),
        decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerComponent(
              baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
              child: Container(
                padding: EdgeInsets.all(28),
                decoration: boxDecorationDefault(shape: BoxShape.circle),
              ),
            ),
            16.width,
            Column(
              children: List.generate(
                4,
                (index) => ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    width: context.width() - 150,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDecorationDefault(
                      borderRadius: radius(8),
                    ),
                  ),
                ),
              ),
            ).expand(flex: 3),
            16.width,
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                    decoration: boxDecorationDefault(borderRadius: radius()),
                  ),
                ),
                ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 36),
                    decoration: boxDecorationDefault(
                      borderRadius: radius(),
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ).expand(flex: 1)
          ],
        ),
      ),
    );
  }
}
