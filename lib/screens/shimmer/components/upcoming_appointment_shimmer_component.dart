import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/appointment_shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class UpcomingAppointmentShimmerComponent extends StatelessWidget {
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
              color: primaryColor.withOpacity(0.3),
              borderRadius: radius(8),
            ),
          ),
        ),
        16.height,
        AppointmentShimmerComponent(isForHomeScreen: true)
      ],
    );
  }
}
