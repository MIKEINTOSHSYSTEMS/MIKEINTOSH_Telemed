import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewShimmerComponent extends StatelessWidget {
  const ReviewShimmerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: shimmerBoxInputDecoration(
        color: primaryColor.withOpacity(0.025),
        borderRadiusValue: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: shimmerBoxInputDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
              16.width,
              Column(
                children: [
                  ShimmerComponent(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                      decoration: shimmerBoxInputDecoration(borderRadiusValue: 8, color: primaryColor.withOpacity(0.6)),
                    ),
                  ),
                  4.height,
                  ShimmerComponent(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                      decoration: shimmerBoxInputDecoration(borderRadiusValue: 8, color: primaryColor.withOpacity(0.6)),
                    ),
                  ),
                ],
              )
            ],
          ),
          16.height,
          ShimmerComponent(
            child: Container(
              width: context.width() - 32,
              padding: EdgeInsets.all(8),
              decoration: shimmerBoxInputDecoration(borderRadiusValue: 8, color: primaryColor.withOpacity(0.6)),
            ),
          ),
          4.height,
          ShimmerComponent(
            child: Container(
              width: context.width() - 32,
              padding: EdgeInsets.all(8),
              decoration: shimmerBoxInputDecoration(borderRadiusValue: 8, color: primaryColor.withOpacity(0.6)),
            ),
          ),
          4.height,
          ShimmerComponent(
            child: Container(
              width: context.width() - 32,
              padding: EdgeInsets.all(8),
              decoration: shimmerBoxInputDecoration(borderRadiusValue: 8, color: primaryColor.withOpacity(0.6)),
            ),
          ),
          4.height,
          ShimmerComponent(
            child: Container(
              width: context.width() / 2 - 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: shimmerBoxInputDecoration(borderRadiusValue: 8, color: primaryColor.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
