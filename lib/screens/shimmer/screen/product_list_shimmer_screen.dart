import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/shimmer/components/screen_shimmer.dart';
import 'package:kivicare_flutter/screens/shimmer/components/woocommerce/product_shimmer_component.dart';

class ProductListScreenShimmer extends StatelessWidget {
  const ProductListScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(shimmerComponent: ProductShimmerComponent());
  }
}
