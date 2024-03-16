import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CartShimmerScreen extends StatelessWidget {
  const CartShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        8.height,
        ...List.generate(
            4,
            (index) => ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
                    child: Row(
                      children: [
                        ShimmerComponent(
                          baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                            decoration: boxDecorationDefault(),
                          ),
                        ),
                        16.width,
                        Column(
                          children: List.generate(
                            2,
                            (index) => ShimmerComponent(
                              baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                decoration: boxDecorationDefault(),
                              ),
                            ),
                          ),
                        ).expand()
                      ],
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16)),
        Row(
          children: [
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ).expand(),
            16.width,
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ).expand()
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 16),
        ShimmerComponent(
          baseColor: shimmerLightBaseColor,
          child: Divider(
            height: 8,
            indent: 16,
            endIndent: 16,
          ),
        ),
        Column(
          children: List.generate(
            3,
            (index) => ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ),
          ),
        ).paddingSymmetric(horizontal: 16, vertical: 16)
      ],
    );
  }
}
