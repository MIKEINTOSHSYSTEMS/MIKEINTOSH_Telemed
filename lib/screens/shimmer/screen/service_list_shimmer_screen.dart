import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/services_shimmer_component.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      children: List.generate(4, (index) => ServicesShimmerComponent()),
    ).paddingSymmetric(horizontal: 16);
  }
}
