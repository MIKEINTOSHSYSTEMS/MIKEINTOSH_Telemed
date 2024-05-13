import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.start,
      listAnimationType: listAnimationType,
      children: List.generate(
        8,
        (index) => Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            color: primaryColor.withOpacity(0.05),
            boxShadow: [],
            borderRadius: radius(),
          ),
          child: Row(
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 42, horizontal: 35),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radius(),
                  ),
                ),
              ),
              16.width,
              Wrap(
                direction: Axis.vertical,
                spacing: 6,
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
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
