import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/services_shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/top_doctor_shimmer_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/upcoming_appointment_shimmer_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientDashboardShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 16,
      spacing: 16,
      children: [
        ServicesShimmerComponent().paddingTop(24),
        UpcomingAppointmentShimmerComponent(),
        TopDoctorShimmerComponent(),
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            decoration: boxDecorationDefault(
              boxShadow: [],
              borderRadius: radius(8),
              color: primaryColor.withOpacity(0.3),
            ),
          ),
        ),
        16.height,
        ShimmerComponent(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 60),
            width: context.width() - 32,
            decoration: boxDecorationDefault(
              boxShadow: [],
              borderRadius: radius(8),
              color: primaryColor.withOpacity(0.3),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
