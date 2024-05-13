import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientSearchShimmerScreen extends StatelessWidget {
  const PatientSearchShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: 16,
      spacing: 16,
      children: List.generate(
        8,
        (index) => ShimmerComponent(
          child: Container(
            width: context.width() - 32,
            padding: EdgeInsets.all(8),
            decoration: shimmerBoxInputDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadiusValue: 16,
            ),
            child: Row(
              children: [
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.6), shape: BoxShape.circle),
                  ),
                ),
                16.width,
                ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    decoration: boxDecorationDefault(boxShadow: [], color: primaryColor.withOpacity(0.6)),
                  ),
                ).expand(),
              ],
            ),
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
