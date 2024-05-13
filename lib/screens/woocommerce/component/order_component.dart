import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/order_model.dart';
import 'package:kivicare_flutter/screens/woocommerce/component/order_status_component.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/order_detail_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderComponent extends StatelessWidget {
  final OrderModel orderData;
  double subTotal;
  final VoidCallback? callback;

  OrderComponent({required this.orderData, this.subTotal = 0.0, this.callback});

  @override
  Widget build(BuildContext context) {
    double subTotal = orderData.lineItems.validate().map((e) => e).toList().sumByDouble((p) => double.parse(p.subtotal.validate()));

    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor, boxShadow: []),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#${orderData.id}', style: secondaryTextStyle(color: appPrimaryColor)),
              OrderStatusComponent(status: orderData.status.validate()),
            ],
          ),
          8.height,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orderData.lineItems.validate().length,
            itemBuilder: (ctx, i) {
              LineItem orderItem = orderData.lineItems.validate()[i];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CachedImageWidget(
                    url: orderItem.image!.src.validate().isNotEmpty ? orderItem.image!.src.validate() : ic_noProduct,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    radius: defaultRadius,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${orderItem.name.validate()} * ${orderItem.quantity.validate()}', style: primaryTextStyle()),
                      PriceWidget(
                        price: orderItem.subtotal.validate(),
                        textStyle: secondaryTextStyle(),
                      ),
                    ],
                  ).expand(),
                ],
              ).paddingSymmetric(vertical: 4);
            },
          ),
          Divider(height: 16, color: context.dividerColor),
          Row(
            children: [
              Text('${locale.lblSubTotal} - ', style: secondaryTextStyle()).expand(),
              PriceWidget(
                textStyle: secondaryTextStyle(),
                price: subTotal.toStringAsFixed(2),
              ),
            ],
          ),
          if (double.parse(orderData.discountTotal.validate()).toInt() != 0)
            Row(
              children: [
                Text(
                  locale.lblCouponDiscount,
                  style: secondaryTextStyle(size: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).expand(),
                Wrap(
                  children: [
                    Text(' - ', style: secondaryTextStyle(color: ratingBarLightGreenColor)),
                    PriceWidget(
                      price: orderData.discountTotal.validate(),
                      textStyle: secondaryTextStyle(color: ratingBarLightGreenColor),
                    )
                  ],
                ),
              ],
            ),
          if (double.parse(orderData.totalTax.validate()).toInt() > 0)
            Row(
              children: [
                Text('${locale.lblTotalTax} - ', style: secondaryTextStyle()).expand(),
                PriceWidget(
                  textStyle: secondaryTextStyle(),
                  price: getPrice(orderData.totalTax.validate()).toDouble().toStringAsFixed(2),
                ),
              ],
            ),
          if (double.parse(orderData.shippingTotal.validate()).toInt() > 0)
            Row(
              children: [
                Text(locale.lblShippingCost, style: secondaryTextStyle()).expand(),
                PriceWidget(
                  textStyle: secondaryTextStyle(),
                  price: getPrice(orderData.shippingTotal.validate()),
                ),
              ],
            ),
          Divider(
            height: 16,
            color: context.dividerColor,
          ),
          Row(
            children: [
              Text('${locale.lblTotal} - ', style: primaryTextStyle()).expand(),
              PriceWidget(price: orderData.total.validate()),
            ],
          ),
        ],
      ),
    ).appOnTap(() {
      OrderDetailScreen(
        orderDetails: orderData,
        orderId: orderData.id.validate(),
        callback: () => callback?.call(),
      ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
    });
  }
}
