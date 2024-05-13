import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderDetailShimmerScreen extends StatelessWidget {
  const OrderDetailShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      children: [
        ShimmerComponent(
          baseColor: shimmerLightBaseColor,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: boxDecorationDefault(),
          ),
        ).paddingRight(180).paddingLeft(16).paddingTop(16),
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
            child: Column(
              children: List.generate(
                4,
                (index) => ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationDefault(),
                  ),
                ),
              ),
            ),
          ),
        ).paddingSymmetric(horizontal: 16),
        ShimmerComponent(
          baseColor: shimmerLightBaseColor,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: boxDecorationDefault(),
          ),
        ).paddingRight(180).paddingLeft(16),
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
            child: Column(
              children: [
                Row(
                  children: [
                    ShimmerComponent(
                      baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
                Row(
                  children: [
                    ShimmerComponent(
                      baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
                ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Divider(height: 8),
                ),
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
                )
              ],
            ),
          ),
        ).paddingSymmetric(horizontal: 16),
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
            child: Column(
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
            ),
          ),
        ).paddingSymmetric(horizontal: 16),
        ShimmerComponent(
          baseColor: shimmerLightBaseColor,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: boxDecorationDefault(),
          ),
        ).paddingRight(180).paddingLeft(16),
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: shimmerBoxInputDecoration(borderRadiusValue: defaultRadius),
            child: Column(
              children: [
                ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationDefault(),
                  ),
                ),
                ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationDefault(),
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
                ),
                4.height,
                ShimmerComponent(
                  baseColor: shimmerPrimaryBaseColor.withOpacity(0.4),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: boxDecorationDefault(),
                  ),
                ).paddingRight(180)
              ],
            ),
          ),
        ).paddingSymmetric(horizontal: 16, vertical: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                width: context.width() - 32,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(),
              ),
            ),
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                width: context.width() - 32,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(),
              ),
            ),
            4.height,
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                width: context.width() - 32,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(),
              ),
            ),
            4.height,
            ShimmerComponent(
              baseColor: shimmerLightBaseColor,
              child: Container(
                width: context.width() / 2 - 24,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: boxDecorationDefault(),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 8)
      ],
    );
  }
}
