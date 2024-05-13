import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/shimmer/components/appointment_shimmer_component.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorDashboardShimmerFragment extends StatelessWidget {
  const DoctorDashboardShimmerFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 24,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          direction: Axis.horizontal,
          children: List.generate(
            3,
            (index) => Container(
              width: context.width() / 3 - 22,
              height: context.width() / 3 - 12,
              child: Stack(
                children: [
                  ShimmerComponent(
                    child: Container(
                      decoration: boxDecorationDefault(
                        color: primaryColor.withOpacity(0.080),
                        boxShadow: [],
                        borderRadius: radius(),
                      ),
                      child: Column(
                        children: [
                          ShimmerComponent(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                              decoration: boxDecorationDefault(
                                color: primaryColor.withOpacity(0.7),
                                boxShadow: [],
                                borderRadius: radius(8),
                              ),
                            ),
                          ).paddingTop(16),
                          8.height,
                          ShimmerComponent(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                              decoration: boxDecorationDefault(
                                color: primaryColor.withOpacity(0.7),
                                boxShadow: [],
                                borderRadius: radius(8),
                              ),
                            ),
                          )
                        ],
                      ).paddingSymmetric(vertical: 24, horizontal: 8),
                    ),
                  ).paddingTop(20),
                  Positioned(
                    top: 0,
                    right: 16,
                    left: 16,
                    child: ShimmerComponent(
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: boxDecorationDefault(color: primaryColor.withOpacity(0.3), boxShadow: [], shape: BoxShape.circle),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        24.height,
        ShimmerComponent(
          child: Container(
            width: context.width() / 2,
            padding: EdgeInsets.all(12),
            decoration: boxDecorationDefault(
              color: primaryColor.withOpacity(0.2),
              boxShadow: [],
              borderRadius: radius(8),
            ),
          ),
        ),
        24.height,
        Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            color: primaryColor.withOpacity(0.030),
            boxShadow: [],
            borderRadius: radius(),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: List.generate(
                      5,
                      (index) => ShimmerComponent(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationDefault(
                            color: primaryColor.withOpacity(0.25),
                            boxShadow: [],
                            borderRadius: radius(2),
                          ),
                        ),
                      ).paddingSymmetric(vertical: 10),
                    ),
                  ),
                  32.width,
                  Wrap(
                    spacing: 32,
                    runSpacing: 16,
                    direction: Axis.horizontal,
                    children: List.generate(
                      6,
                      (index) => ShimmerComponent(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 80),
                          decoration: boxDecorationDefault(
                            color: primaryColor.withOpacity(0.25),
                            boxShadow: [],
                            borderRadius: radius(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.height,
              Row(
                children: List.generate(
                  6,
                  (index) => ShimmerComponent(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationDefault(
                        color: primaryColor.withOpacity(0.25),
                        boxShadow: [],
                        borderRadius: radius(2),
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 10),
                ),
              ).paddingLeft(40)
            ],
          ),
        ),
        24.height,
        ShimmerComponent(
          child: Container(
            width: context.width() / 2,
            padding: EdgeInsets.all(12),
            decoration: boxDecorationDefault(
              color: primaryColor.withOpacity(0.2),
              boxShadow: [],
              borderRadius: radius(8),
            ),
          ),
        ),
        24.height,
        AnimatedWrap(
          runSpacing: 16,
          listAnimationType: listAnimationType,
          children: List.generate(4, (index) => AppointmentShimmerComponent()),
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
