import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/review_shimmer_component.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewRatingShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      children: List.generate(
        4,
        (index) => ReviewShimmerComponent(),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
