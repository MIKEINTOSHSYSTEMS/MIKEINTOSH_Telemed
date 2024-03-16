import 'package:flutter/material.dart';
import 'package:momona_healthcare/screens/shimmer/components/screen_shimmer.dart';
import 'package:momona_healthcare/screens/shimmer/components/woocommerce/order_shimmer_component.dart';

class OrderListShimmerScreen extends StatelessWidget {
  const OrderListShimmerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(shimmerComponent: OrderShimmerComponent());
  }
}
