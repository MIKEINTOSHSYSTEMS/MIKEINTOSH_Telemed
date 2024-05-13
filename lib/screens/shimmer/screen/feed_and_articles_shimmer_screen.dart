import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/shimmer_component.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class FeedAndArticlesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        3,
        (index) => Container(
          width: context.width(),
          decoration: boxDecorationDefault(
            color: primaryColor.withOpacity(0.025),
            boxShadow: [],
            borderRadius: radius(),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ShimmerComponent(
                child: Container(
                  width: context.width(),
                  padding: EdgeInsets.symmetric(vertical: 120),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
                  ),
                ),
              ),
              ShimmerComponent(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radius(2),
                  ),
                ),
              ).paddingSymmetric(horizontal: 16),
              ShimmerComponent(
                child: Container(
                  width: context.width() - 32,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: boxDecorationDefault(
                    color: primaryColor.withOpacity(0.2),
                    boxShadow: [],
                    borderRadius: radius(2),
                  ),
                ),
              ).paddingSymmetric(horizontal: 16),
              Container(
                padding: EdgeInsets.all(16),
                child: Wrap(
                  runSpacing: 4,
                  children: [
                    ShimmerComponent(
                      child: Container(
                        width: context.width(),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: boxDecorationDefault(
                          color: primaryColor.withOpacity(0.2),
                          boxShadow: [],
                          borderRadius: radius(2),
                        ),
                      ),
                    ),
                    ShimmerComponent(
                      child: Container(
                        width: context.width(),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: boxDecorationDefault(
                          color: primaryColor.withOpacity(0.2),
                          boxShadow: [],
                          borderRadius: radius(2),
                        ),
                      ),
                    ),
                    ShimmerComponent(
                      child: Container(
                        width: context.width(),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: boxDecorationDefault(
                          color: primaryColor.withOpacity(0.2),
                          boxShadow: [],
                          borderRadius: radius(2),
                        ),
                      ),
                    ),
                    ShimmerComponent(
                      child: Container(
                        width: context.width() / 2,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: boxDecorationDefault(
                          color: primaryColor.withOpacity(0.2),
                          boxShadow: [],
                          borderRadius: radius(2),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
