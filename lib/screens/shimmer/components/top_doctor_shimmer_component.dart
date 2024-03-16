import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/doctor_shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class TopDoctorShimmerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            decoration: boxDecorationDefault(
              boxShadow: [],
              borderRadius: radius(8),
              color: primaryColor.withOpacity(0.3),
            ),
          ),
        ),
        16.height,
        DoctorShimmerComponent()
      ],
    );
  }
}
