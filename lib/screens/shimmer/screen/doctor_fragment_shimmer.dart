import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/doctor_shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/screen_shimmer.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorShimmerFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(shimmerComponent: DoctorShimmerComponent()).paddingSymmetric(horizontal: 16);
  }
}
