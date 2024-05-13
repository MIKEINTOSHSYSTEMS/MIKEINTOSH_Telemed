import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/app_setting_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/coupon_list_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/edit_shop_detail_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/order_list_screen.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonShopSettingComponent extends StatelessWidget {
  const CommonShopSettingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        AppSettingWidget(
          name: locale.lblAddress,
          image: ic_address,
          subTitle: locale.lblAddressSubTitle,
          widget: EditShopDetailsScreen(),
        ),
        AppSettingWidget(
          name: locale.lblOrders,
          image: ic_orders,
          widget: OrderListScreen(),
          subTitle: locale.lblOrdersSubtitle,
        ),
        AppSettingWidget(
          name: locale.lblCoupons,
          image: ic_coupons,
          subTitle: locale.lblCouponsSubtitle,
          widget: CouponListScreen(),
        ),
      ],
    );
  }
}
