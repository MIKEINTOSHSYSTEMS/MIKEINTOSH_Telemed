import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDataShimmer extends StatelessWidget {
  const ServiceDataShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height() / 2,
      child: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        children: List.generate(6, (index) {
          return Container(
            width: context.width() / 2 - 24,
            height: context.width() / 2 - 24,
            decoration: boxDecorationDefault(
              color: primaryColor.withOpacity(0.2),
              boxShadow: [],
              borderRadius: radius(),
            ),
            child: Column(
              children: [
                Container(
                  width: context.width() / 2 - 24,
                  height: 100,
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                  ),
                ),
                16.height,
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: boxDecorationDefault(
                      color: primaryColor.withOpacity(0.4),
                      boxShadow: [],
                      borderRadius: radius(),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16),
                6.height,
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: boxDecorationDefault(
                      color: primaryColor.withOpacity(0.4),
                      boxShadow: [],
                      borderRadius: radius(),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16)
              ],
            ),
          );
        }),
      ).paddingSymmetric(horizontal: 16, vertical: 16),
    );
  }
}
