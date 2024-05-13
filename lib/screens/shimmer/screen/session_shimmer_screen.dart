import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class SessionShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      itemCount: 4,
      listAnimationType: listAnimationType,
      children: List.generate(
        4,
        (index) => ShimmerComponent(
          child: Container(
            padding: EdgeInsets.all(16),
            width: context.width() - 32,
            decoration: shimmerBoxInputDecoration(borderRadiusValue: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    ShimmerComponent(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 35),
                        decoration: shimmerBoxInputDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                    16.width,
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: List.generate(
                        3,
                        (index) => ShimmerComponent(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: shimmerBoxInputDecoration(
                              color: primaryColor.withOpacity(0.8),
                              borderRadiusValue: 8,
                            ),
                          ),
                        ),
                      ),
                    ).expand()
                  ],
                ),
                16.height,
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: context.width() - 64,
                    decoration: shimmerBoxInputDecoration(
                      color: primaryColor.withOpacity(0.8),
                      borderRadiusValue: 8,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
