import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ReportShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List.generate(
        8,
        (index) => Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            color: primaryColor.withOpacity(0.025),
            boxShadow: [],
            borderRadius: radius(),
          ),
          child: Row(
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.4),
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
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                children: List.generate(
                  2,
                  (index) => ShimmerComponent(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 60),
                      decoration: boxDecorationDefault(
                        color: primaryColor.withOpacity(0.4),
                        boxShadow: [],
                        borderRadius: radius(8),
                      ),
                    ),
                  ),
                ),
              ).expand(),
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.4),
                    boxShadow: [],
                    borderRadius: radius(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
