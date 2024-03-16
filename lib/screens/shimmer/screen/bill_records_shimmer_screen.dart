import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class BillRecordsShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      listAnimationType: listAnimationType,
      children: List.generate(
        7,
        (index) => Container(
          width: context.width(),
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            color: primaryColor.withOpacity(0.05),
            boxShadow: [],
            borderRadius: radius(),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ShimmerComponent(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 36, horizontal: 35),
                      decoration: boxDecorationDefault(
                        color: primaryColor.withOpacity(0.3),
                        boxShadow: [],
                        borderRadius: radius(),
                      ),
                    ),
                  ),
                  16.width,
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 4,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                      3,
                      (index) => ShimmerComponent(
                        child: Container(
                          width: context.width() - 148,
                          padding: EdgeInsets.symmetric(vertical: 6),
                          decoration: boxDecorationDefault(
                            color: primaryColor.withOpacity(0.2),
                            boxShadow: [],
                            borderRadius: radius(8),
                          ),
                        ),
                      ),
                    ),
                  ).expand(),
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerComponent(
                        child: Container(
                          width: context.width() / 3 - 46,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          decoration: boxDecorationDefault(
                            color: Colors.white12,
                            boxShadow: [],
                            borderRadius: radius(8),
                          ),
                        ),
                      ),
                      6.height,
                      ShimmerComponent(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: boxDecorationDefault(
                            color: Colors.white12,
                            boxShadow: [],
                            borderRadius: radius(8),
                          ),
                        ),
                      )
                    ],
                  ).paddingOnly(right: 16),
                ),
              )
            ],
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
