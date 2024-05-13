import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/screen_shimmer.dart';
import 'package:kivicare_flutter/screens/shimmer/components/woocommerce/coupon_shimmer_component.dart';
import 'package:nb_utils/nb_utils.dart';

class CouponListShimmerScreen extends StatelessWidget {
  const CouponListShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(shimmerComponent: CouponShimmerComponent()).paddingTop(16);
  }
}
