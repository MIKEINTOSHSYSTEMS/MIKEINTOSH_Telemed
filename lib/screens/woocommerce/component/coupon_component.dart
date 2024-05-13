import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/cart_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/coupon_model.dart';
import 'package:kivicare_flutter/network/shop_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CouponComponent extends StatelessWidget {
  final CouponModel coupon;

  final bool isCartScreen;
  final double? amount;
  const CouponComponent({Key? key, required this.coupon, this.isCartScreen = false, this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (coupon.discountType == DiscountType.fixedCart || coupon.discountType == DiscountType.fixedProduct)
                Text(
                  '${appStore.currencyPrefix.validate()} ${coupon.amount.toDouble().toStringAsFixed(2)} ${appStore.currencyPostfix.validate(value: '${appStore.currency.validate()}')} off',
                  style: boldTextStyle(size: 18, color: context.primaryColor),
                )
              else
                Text(
                  '${coupon.amount.validate().suffixText(value: '%')} off',
                  style: boldTextStyle(size: 18, color: context.primaryColor),
                ),
              InkWell(
                child: DottedBorderWidget(
                  child: Container(
                    decoration: BoxDecoration(color: context.primaryColor.withAlpha(30), borderRadius: radius()),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(coupon.code.validate(), style: boldTextStyle(color: context.primaryColor)),
                  ),
                  radius: defaultRadius,
                  color: context.primaryColor,
                ),
                onTap: () {
                  //Todo add languagekey
                  toast("Copied To Clipboard");
                  Clipboard.setData(new ClipboardData(text: coupon.code.validate()));
                },
              ).visible(coupon.code.validate().isNotEmpty),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          if (coupon.description.validate().isNotEmpty) Text(coupon.description.validate(), style: primaryTextStyle()),
          14.height,
          Row(
            children: [
              if (coupon.minimumAmount.validate().isNotEmpty)
                Text(
                  'Minimum Spend - ${coupon.minimumAmount.toDouble().toStringAsFixed(2).prefixText(value: appStore.currencyPrefix.validate()).suffixText(value: appStore.currencyPostfix.validate())}',
                  style: secondaryTextStyle(),
                ).expand(),
              if (coupon.maximumAmount.validate().isNotEmpty)
                Text(
                  'Maximum Spend - ${coupon.maximumAmount.toDouble().toStringAsFixed(2).prefixText(value: appStore.currencyPrefix.validate()).suffixText(value: appStore.currencyPostfix.validate())}',
                  style: secondaryTextStyle(),
                ).expand(),
            ],
          ),
          12.height,
          if (coupon.dateExpires.validate().isNotEmpty) Text('${"Expires On -"} ${coupon.dateExpires.validate().getFormattedDate(DISPLAY_DATE_FORMAT)}', style: secondaryTextStyle()),
          8.height,
          if (amount != null)
            Text('Your cart value is less than minimum spend.', style: secondaryTextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
                .visible(amount.validate() < coupon.minimumAmount.toDouble() && amount.validate() < coupon.maximumAmount.toDouble()),
          if (amount != null)
            Text('Coupon Applicable', style: primaryTextStyle(color: ratingBarLightGreenColor, fontStyle: FontStyle.italic))
                .visible(amount.validate() > coupon.minimumAmount.toDouble() && amount.validate() < coupon.maximumAmount.toDouble()),
        ],
      ),
    );
  }
}

class CartCouponsComponent extends StatefulWidget {
  final List<CartCouponModel>? couponsList;
  final Function(CartModel)? onCouponRemoved;

  final bool isForCheckout;

  CartCouponsComponent({this.couponsList, this.onCouponRemoved, this.isForCheckout = false});

  @override
  State<CartCouponsComponent> createState() => _CartCouponsComponentState();
}

class _CartCouponsComponentState extends State<CartCouponsComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    widget.couponsList.validate().forEach((element) {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Applied coupon', style: boldTextStyle()).paddingSymmetric(horizontal: 16),
        16.height,
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.couponsList!.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, couponIndex) {
            CartCouponModel coupon = widget.couponsList.validate()[couponIndex];
            return DecoratedBox(
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Code - ',
                          style: secondaryTextStyle(),
                          children: <TextSpan>[
                            TextSpan(text: coupon.code.validate(), style: primaryTextStyle()),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '${locale.lblDiscount} - ',
                          style: secondaryTextStyle(),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${getPrice(coupon.totals!.totalDiscount.validate()).toDouble().toStringAsFixed(2).prefixText(value: appStore.currencyPrefix.validate()).suffixText(value: appStore.currencyPostfix.validate())}',
                              style: primaryTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  if (!widget.isForCheckout)
                    IconButton(
                      onPressed: () {
                        showConfirmDialogCustom(
                          context,
                          onAccept: (c) {
                            appStore.setLoading(true);
                            removeCoupon(code: coupon.code.validate()).then((value) {
                              widget.onCouponRemoved?.call(value);
                              appStore.setLoading(false);

                              log('Coupon removed');
                            }).catchError((e) {
                              log('error remove coupon: ${e.toString()}');
                              appStore.setLoading(false);
                            });
                          },
                          dialogType: DialogType.DELETE,
                          title: 'Do you want to remove coupon?',
                        );
                      },
                      icon: CachedImageWidget(url: ic_delete_icon, height: 20, width: 20, color: Colors.red),
                    ),
                ],
              ).paddingOnly(left: widget.isForCheckout ? 0 : 16).paddingSymmetric(vertical: widget.isForCheckout ? 0 : 8),
            );
          },
        ),
      ],
    );
  }
}
