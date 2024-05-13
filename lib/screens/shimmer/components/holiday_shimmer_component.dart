import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class HolidayShimmerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: context.width() / 2 - 24,
      decoration: shimmerBoxInputDecoration(color: primaryColor.withOpacity(0.050), borderRadiusValue: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  decoration: shimmerBoxInputDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
              16.width,
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: shimmerBoxInputDecoration(
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
              ).expand()
            ],
          ),
          16.height,
          ...List.generate(
            4,
            (index) => ShimmerComponent(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                margin: EdgeInsets.all(4),
                decoration: shimmerBoxInputDecoration(color: primaryColor.withOpacity(0.4), borderRadiusValue: 8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
