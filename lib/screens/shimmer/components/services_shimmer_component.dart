import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ServicesShimmerComponent extends StatelessWidget {
  final bool isForDoctorServicesList;
  ServicesShimmerComponent({this.isForDoctorServicesList = false});

  Widget serviceComponentForDoctorProfile(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        boxShadow: [],
        color: primaryColor.withOpacity(0.025),
      ),
      width: context.width() / 2 - 24,
      child: Column(
        children: [
          ShimmerComponent(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: boxDecorationDefault(
                boxShadow: [],
                color: primaryColor.withOpacity(0.3),
                borderRadius: radius(8),
              ),
            ),
          ).paddingLeft(70),
          16.height,
          ShimmerComponent(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 75, vertical: 8),
              decoration: boxDecorationDefault(
                boxShadow: [],
                color: primaryColor.withOpacity(0.3),
                borderRadius: radius(8),
              ),
            ),
          ),
          4.height,
          ShimmerComponent(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 75, vertical: 8),
              decoration: boxDecorationDefault(
                boxShadow: [],
                color: primaryColor.withOpacity(0.3),
                borderRadius: radius(8),
              ),
            ),
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.3)),
                ),
              ).expand(),
              16.width,
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  decoration: boxDecorationDefault(
                    boxShadow: [],
                    color: primaryColor.withOpacity(0.3),
                    borderRadius: radius(8),
                  ),
                ),
              ).expand()
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      children: List.generate(
        2,
        (index) => isForDoctorServicesList
            ? serviceComponentForDoctorProfile(context)
            : ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: context.width() / 2 - 24,
                  decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 42),
                        decoration: boxDecorationDefault(),
                      ),
                      8.height,
                      Container(
                        width: 80,
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 42),
                        decoration: boxDecorationDefault(),
                      ),
                      8.height,
                      Row(
                        children: [
                          Stack(
                            children: List.generate(
                              2,
                              (index) => ShimmerComponent(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  decoration: boxDecorationDefault(border: Border.all(color: primaryColor), shape: BoxShape.circle),
                                ),
                              ).paddingLeft(index == 0 ? 0 : (index) * 22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
