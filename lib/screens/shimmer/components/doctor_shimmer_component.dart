import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorShimmerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerComponent(
      child: Container(
        width: context.width(),
        padding: EdgeInsets.all(16),
        decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerComponent(
              baseColor: shimmerLightBaseColor.withOpacity(0.4),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: boxDecorationDefault(shape: BoxShape.circle),
              ),
            ),
            16.width,
            Column(
              children: List.generate(
                3,
                (index) => ShimmerComponent(
                  baseColor: shimmerLightBaseColor.withOpacity(0.4),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: boxDecorationDefault(),
                  ),
                ),
              ),
            ).expand(),
            16.width,
            ShimmerComponent(
              baseColor: shimmerLightBaseColor.withOpacity(0.4),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                decoration: boxDecorationDefault(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
