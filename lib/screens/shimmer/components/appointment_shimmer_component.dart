import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/shimmer_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentShimmerComponent extends StatelessWidget {
  final bool isForHomeScreen;
  AppointmentShimmerComponent({this.isForHomeScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        boxShadow: [],
        color: primaryColor.withOpacity(0.050),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 28, horizontal: 28),
                  decoration: boxDecorationDefault(
                    boxShadow: [],
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
              16.width,
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: boxDecorationDefault(
                    boxShadow: [],
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
              ).expand(),
              16.width,
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  decoration: boxDecorationDefault(
                    boxShadow: [],
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
              )
            ],
          ),
          16.height,
          ShimmerComponent(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18),
              width: context.width(),
              decoration: boxDecorationDefault(
                boxShadow: [],
                color: primaryColor.withOpacity(0.3),
              ),
            ),
          ),
          if (!isForHomeScreen) 16.height,
          if (!isForHomeScreen)
            Row(
              children: List.generate(
                3,
                (index) => ShimmerComponent(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                    decoration: boxDecorationDefault(
                      color: primaryColor.withOpacity(0.2),
                      boxShadow: [],
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                      borderRadius: index == 1
                          ? radius(0)
                          : BorderRadiusDirectional.only(
                              bottomStart: radiusCircular(index == 0 ? defaultRadius : 0),
                              topStart: radiusCircular(index == 0 ? defaultRadius : 0),
                              topEnd: radiusCircular(index == 2 ? defaultRadius : 0),
                              bottomEnd: radiusCircular(index == 2 ? defaultRadius : 0),
                            ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
