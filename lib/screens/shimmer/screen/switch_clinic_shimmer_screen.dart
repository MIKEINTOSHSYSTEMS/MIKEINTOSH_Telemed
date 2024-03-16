import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/clinic_shimmer_component.dart';
import 'package:nb_utils/nb_utils.dart';

class SwitchClinicShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: AnimatedWrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: List.generate(
          8,
          (index) => ClinicShimmerComponent(),
        ),
      ).paddingSymmetric(vertical: 16, horizontal: 16),
    );
  }
}
