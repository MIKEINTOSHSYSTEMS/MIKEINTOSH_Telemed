import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectServiceShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        8,
        (index) => ShimmerComponent(
          child: Container(
            width: context.width() - 32,
            padding: EdgeInsets.all(8),
            decoration: shimmerBoxInputDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadiusValue: 16,
            ),
            child: Row(
              children: [
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.6), shape: BoxShape.circle),
                  ),
                ),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerComponent(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 6),
                        decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.6)),
                      ),
                    ),
                    4.height,
                    ShimmerComponent(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 6),
                        decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ).expand(),
                16.width,
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
