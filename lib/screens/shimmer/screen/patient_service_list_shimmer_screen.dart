import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/services_shimmer_component.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientServiceListShimmerScreen extends StatelessWidget {
  const PatientServiceListShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height(),
      child: AnimatedListView(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, int) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerComponent(
                child: Container(
                  width: context.width() / 2,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: boxDecorationDefault(
                    boxShadow: [],
                    color: primaryColor.withOpacity(0.3),
                    borderRadius: radius(8),
                  ),
                ),
              ),
              16.height,
              ServicesShimmerComponent(),
              16.height,
              ServicesShimmerComponent(),
            ],
          ).paddingSymmetric(vertical: 8, horizontal: 16);
        },
      ),
    );
  }
}
