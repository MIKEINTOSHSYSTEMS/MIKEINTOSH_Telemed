import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/review_shimmer_component.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailShimmerScreen extends StatelessWidget {
  const ProductDetailShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: [
        Column(
          children: [
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ),
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ),
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8),
        Column(
          children: [
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ),
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ),
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: boxDecorationDefault(),
              ),
            ).paddingRight(140)
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerComponent(
                  baseColor: shimmerLightBaseColor,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: boxDecorationDefault(shape: BoxShape.circle),
                  ),
                ),
                16.width,
                Column(
                  children: [
                    ShimmerComponent(
                      baseColor: shimmerLightBaseColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                        decoration: boxDecorationDefault(),
                      ),
                    ),
                    8.height,
                    ShimmerComponent(
                      baseColor: shimmerLightBaseColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                        decoration: boxDecorationDefault(),
                      ),
                    ),
                  ],
                )
              ],
            ),
            16.height,
            ...List.generate(
              2,
              (index) => ShimmerComponent(
                baseColor: shimmerLightBaseColor,
                child: Container(
                  width: context.width() - 32,
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationDefault(),
                ),
              ).paddingSymmetric(vertical: 6),
            )
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8)
      ],
    );
  }
}
