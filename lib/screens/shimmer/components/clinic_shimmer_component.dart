import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ClinicShimmerComponent extends StatelessWidget {
  const ClinicShimmerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: context.width() / 2 - 24,
      decoration: boxDecorationDefault(
        color: primaryColor.withOpacity(0.050),
        boxShadow: [],
        borderRadius: radius(),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radius(),
                  ),
                ),
              ),
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radius(),
                  ),
                ),
              )
            ],
          ),
          16.height,
          ShimmerComponent(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              decoration: boxDecorationDefault(
                color: primaryColor.withOpacity(0.2),
                boxShadow: [],
                borderRadius: radius(8),
              ),
            ),
          ),
          8.height,
          ShimmerComponent(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              decoration: boxDecorationDefault(
                color: primaryColor.withOpacity(0.2),
                boxShadow: [],
                borderRadius: radius(8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
