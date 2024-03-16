import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/appointment_shimmer_component.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentFragmentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        AppointmentShimmerComponent().paddingSymmetric(vertical: 8),
        AppointmentShimmerComponent().paddingSymmetric(vertical: 8),
        AppointmentShimmerComponent().paddingSymmetric(vertical: 8),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
