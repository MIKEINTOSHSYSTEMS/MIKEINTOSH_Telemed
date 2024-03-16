import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/patient_shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/screen_shimmer.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientFragmentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      shimmerComponent: PatientShimmerComponent(),
    ).paddingSymmetric(horizontal: 16);
  }
}
