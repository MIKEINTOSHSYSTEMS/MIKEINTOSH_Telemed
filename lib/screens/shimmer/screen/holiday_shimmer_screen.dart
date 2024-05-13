import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/holiday_shimmer_component.dart';
import 'package:nb_utils/nb_utils.dart';

class HolidayShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      children: List.generate(
        8,
        (index) => HolidayShimmerComponent(),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
