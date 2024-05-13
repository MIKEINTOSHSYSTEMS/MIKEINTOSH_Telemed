import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/billing_address_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/cart_item_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/cart_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/payment_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/network/shop_repository.dart';
import 'package:kivicare_flutter/screens/woocommerce/component/coupon_component.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/edit_shop_detail_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/order_detail_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CheckoutScreen extends StatefulWidget {
  final CartModel cartDetails;

  final VoidCallback? itermRemoved;

  CheckoutScreen({required this.cartDetails, this.itermRemoved});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late CartModel cart;

  bool isPaymentGatewayLoading = true;

  PaymentModel? selectedPaymentMethod;

  List<PaymentModel> paymentGateways = [];
  BillingAddressModel billingAddress = BillingAddressModel();
  BillingAddressModel? shippingAddress;

  TextEditingController orderNotesController = TextEditingController();

  @override
  void initState() {
    cart = widget.cartDetails;
    billingAddress = widget.cartDetails.billingAddress!;
    super.initState();
    init();
  }

  Future<void> init() async {
    isPaymentGatewayLoading = true;
    setState(() {});

    await getPaymentMethods().then((value) {
      paymentGateways.addAll(value);
      selectedPaymentMethod = value.firstWhere((element) => element.id == 'cod');
      isPaymentGatewayLoading = false;
      setState(() {});
    }).catchError((e) {
      isPaymentGatewayLoading = false;
      toast(e.toString(), print: true);
      setState(() {});
    });
  }

  Future<void> getCart({String? orderBy}) async {
    appStore.setLoading(true);

    await getCartDetails().then((value) {
      cart = value;
      billingAddress = value.billingAddress!;
      shippingAddress = value.shippingAddress!;
      setState(() {});
      if (cart.items.validate().isEmpty) {
        finish(context);
        finish(context);
      }

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> placeOrder() async {
    Map request = {
      "payment_method": selectedPaymentMethod!.id,
      "payment_method_title": selectedPaymentMethod!.title,
      "set_paid": false,
      'customer_id': userStore.userId,
      'status': "pending",
      "billing": cart.billingAddress!.toJson(),
      "shipping": cart.shippingAddress!.toJson(),
      "line_items": cart.items!.map((e) {
        return {"product_id": e.id, "quantity": e.quantity};
      }).toList(),
      "shipping_lines": [],
      "coupon_lines": cart.coupons.validate().map((e) => {"code": e.code}).toList()
    };

    appStore.setLoading(true);

    log(jsonEncode(request));

    await createOrder(request: request).then((value) async {
      if (orderNotesController.text.isNotEmpty) {
        Map noteRequest = {"note": orderNotesController.text.trim(), "customer_note": true};
        await createOrderNotes(request: noteRequest, orderId: value.id.validate()).then((value) {}).catchError((e) {
          log('Order Note Error: ${e.toString()}');
        });
      }

      appStore.setLoading(false);
      shopStore.setCartCount(0);
      for (int i = 0; i < 3; i++) {
        finish(context);
      }
      OrderDetailScreen(
        orderDetails: value,
        orderId: value.id.validate(),
      ).launch(context);
    }).whenComplete(() {
      cart.items!.forEach((element) {
        removeCartItem(productKey: element.key.validate()).then((value) {
          log('removed');
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      });

      cart.coupons!.forEach((coupon) {
        removeCoupon(code: coupon.code.validate()).then((value) {
          toast(locale.lblCouponRemoved);
        }).catchError((e) {
          log('error remove coupon: ${e.toString()}');
        });
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    widget.itermRemoved?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.checkout,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.only(top: 16, bottom: 120),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.products, style: boldTextStyle()),
              16.height.visible(cart.items.validate().isNotEmpty),
              if (cart.items.validate().isNotEmpty)
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cart.items!.length,
                  itemBuilder: (ctx, index) {
                    CartItemModel cartItem = cart.items![index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedImageWidget(
                          url: cartItem.images.validate().isNotEmpty ? cartItem.images!.first.src.validate() : ic_noProduct,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(8),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cartItem.name.validate(), style: primaryTextStyle()),
                            if (double.parse(cartItem.totals!.lineSubtotal.validate()).toInt() > 0)
                              PriceWidget(
                                price: getPrice(cartItem.prices!.price.validate()),
                                salePrice: getPrice(cartItem.prices!.salePrice.validate()),
                                regularPrice: getPrice(cartItem.prices!.regularPrice.validate()),
                                prefix: cartItem.prices!.currencyPrefix,
                                postFix: cartItem.prices!.currencySuffix,
                              ),
                            Text(
                              '${cartItem.quantity.validate()} * ${getPrice(cartItem.prices!.price.validate()).prefixText(value: cartItem.prices!.currencyPrefix.validate()).suffixText(value: cartItem.prices!.currencySuffix.validate())}',
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ).expand(),
                        PriceWidget(
                          price: getPrice(cartItem.totals!.lineTotal.validate()).toString(),
                          prefix: cartItem.prices!.currencyPrefix,
                          postFix: cartItem.prices!.currencySuffix,
                        ),
                        16.width,
                        Image.asset(
                          ic_delete_icon,
                          color: Colors.red,
                          height: 18,
                          width: 18,
                          fit: BoxFit.cover,
                        ).appOnTap(() {
                          showConfirmDialogCustom(
                            context,
                            onAccept: (c) {
                              appStore.setLoading(true);
                              removeCartItem(productKey: cartItem.key.validate()).then((value) {
                                toast(locale.itemRemovedSuccessfully);
                                getCart();
                                widget.itermRemoved?.call();
                              }).catchError((e) {
                                appStore.setLoading(false);

                                toast(e.toString(), print: true);
                              });
                            },
                            dialogType: DialogType.CONFIRMATION,
                            title: locale.removeFromCartConfirmation,
                          );
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent).paddingSymmetric(vertical: 4),
                      ],
                    ).paddingSymmetric(vertical: 8);
                  },
                )
              else
                Text(locale.yourCartIsCurrentlyEmpty, style: secondaryTextStyle()),
              16.height,
              Container(
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
                child: Column(
                  children: [
                    8.height,
                    if (cart.coupons.validate().isNotEmpty)
                      CartCouponsComponent(
                        couponsList: cart.coupons.validate(),
                        isForCheckout: true,
                        onCouponRemoved: (value) {
                          cart = value;
                          setState(() {});
                        },
                      ),
                    if (cart.totals!.totalDiscount.validate().toInt() > 0) 8.height,
                    if (cart.totals!.totalDiscount.validate().toInt() > 0)
                      Divider(
                        height: 8,
                        color: context.dividerColor,
                      ),
                    if (cart.totals!.totalDiscount.validate().toInt() > 0) 8.height,
                    if (cart.totals!.totalDiscount.validate().toInt() > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.lblCouponDiscount.suffixText(value: ' - '), style: primaryTextStyle(size: 14)),
                          Wrap(
                            children: [
                              Text('- ', style: primaryTextStyle(color: ratingBarLightGreenColor)),
                              PriceWidget(
                                price: getPrice(cart.totals!.totalDiscount.validate()),
                                textStyle: primaryTextStyle(size: 14, color: ratingBarLightGreenColor),
                                prefix: cart.totals!.currencyPrefix,
                                postFix: cart.totals!.currencySuffix,
                              )
                            ],
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    if (double.parse(cart.totals!.totalShipping.validate()).toInt() > 0)
                      Row(
                        children: [
                          Text(locale.lblShippingCost, style: secondaryTextStyle(size: 16)).expand(),
                          PriceWidget(
                            price: cart.totals!.totalShipping.validate(),
                            size: 16,
                            textAlign: TextAlign.start,
                            textStyle: secondaryTextStyle(),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${locale.lblTotal} - ', style: boldTextStyle()),
                        PriceWidget(
                          price: getPrice(cart.totals!.totalPrice.validate()),
                          prefix: cart.totals!.currencyPrefix,
                          postFix: cart.totals!.currencySuffix,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 8),
                  ],
                ),
              ),
              24.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.shippingAddress, style: boldTextStyle()),
                  Image.asset(ic_edit, width: 22, height: 22, fit: BoxFit.cover, color: context.primaryColor).onTap(() async {
                    EditShopDetailsScreen().launch(context).then((value) {
                      if (value ?? false) getCart();
                    });
                  }),
                ],
              ).visible(shippingAddress != null),
              10.height,
              if (shippingAddress != null)
                Wrap(
                  children: [
                    Text('${shippingAddress?.company}, ', style: secondaryTextStyle()).visible(shippingAddress!.company.validate().isNotEmpty),
                    Text('${shippingAddress?.address_1}, ', style: secondaryTextStyle()).visible(shippingAddress!.address_1.validate().isNotEmpty),
                    Text('${shippingAddress?.address_2}, ', style: secondaryTextStyle()).visible(shippingAddress!.address_2.validate().isNotEmpty),
                    Text('${shippingAddress?.city}, ', style: secondaryTextStyle()).visible(shippingAddress!.city.validate().isNotEmpty),
                    Text('${shippingAddress?.state}, ', style: secondaryTextStyle()).visible(shippingAddress!.state.validate().isNotEmpty),
                    Text('${shippingAddress?.country}', style: secondaryTextStyle()).visible(shippingAddress!.country.validate().isNotEmpty),
                  ],
                ),
              if (shippingAddress != null) Text('${locale.lblPostalCode}: ${shippingAddress?.postcode}', style: secondaryTextStyle()).visible(shippingAddress!.postcode.validate().isNotEmpty),
              if (shippingAddress != null) Text('${locale.lblContactNumber}: ${shippingAddress?.phone}', style: secondaryTextStyle()).visible(shippingAddress!.phone.validate().isNotEmpty),
              if (shippingAddress != null) Text('${locale.lblEmail}: ${shippingAddress?.email}', style: secondaryTextStyle()).visible(shippingAddress!.email.validate().isNotEmpty),
              if (!isSameAddress || shippingAddress == null) 16.height,
              if (!isSameAddress || shippingAddress == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.billingAddress, style: boldTextStyle()),
                    Image.asset(ic_edit, width: 22, height: 22, fit: BoxFit.cover, color: context.primaryColor).onTap(() async {
                      EditShopDetailsScreen().launch(context).then((value) {
                        if (value ?? false) getCart();
                      });
                    }),
                  ],
                ),
              if (!isSameAddress || shippingAddress == null) 10.height,
              if (!isSameAddress || shippingAddress == null)
                Wrap(
                  children: [
                    Text('${billingAddress.company}, ', style: secondaryTextStyle()).visible(billingAddress.company.validate().isNotEmpty),
                    Text('${billingAddress.address_1}, ', style: secondaryTextStyle()).visible(billingAddress.address_1.validate().isNotEmpty),
                    Text('${billingAddress.address_2}, ', style: secondaryTextStyle()).visible(billingAddress.address_2.validate().isNotEmpty),
                    Text('${billingAddress.city}, ', style: secondaryTextStyle()).visible(billingAddress.city.validate().isNotEmpty),
                    Text('${billingAddress.state}, ', style: secondaryTextStyle()).visible(billingAddress.state.validate().isNotEmpty),
                    Text('${billingAddress.country}', style: secondaryTextStyle()).visible(billingAddress.country.validate().isNotEmpty),
                  ],
                ),
              if (!isSameAddress || shippingAddress == null)
                Text('${locale.lblPostalCode}: ${billingAddress.postcode}', style: secondaryTextStyle()).visible(billingAddress.postcode.validate().isNotEmpty),
              if (!isSameAddress || shippingAddress == null)
                Text('${locale.lblContactNumber}: ${billingAddress.phone}', style: secondaryTextStyle()).visible(billingAddress.phone.validate().isNotEmpty),
              if (!isSameAddress || shippingAddress == null) Text('${locale.lblEmail}: ${billingAddress.email}', style: secondaryTextStyle()).visible(billingAddress.email.validate().isNotEmpty),
              16.height,
              Text(locale.lblSelectPaymentMethod, style: boldTextStyle()),
              !isPaymentGatewayLoading
                  ? paymentGateways.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                          margin: EdgeInsets.symmetric(vertical: 16),
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: paymentGateways.length,
                            itemBuilder: (ctx, index) {
                              if (paymentGateways[index].id.validate() == 'cod') {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(selectedPaymentMethod == paymentGateways[index] ? Icons.radio_button_checked : Icons.radio_button_off, color: context.primaryColor, size: 20),
                                        8.width,
                                        Text(paymentGateways[index].title.toString().validate(), style: primaryTextStyle()),
                                      ],
                                    ),
                                    8.height,
                                    Container(
                                      child: Text(paymentGateways[index].description.validate(), style: secondaryTextStyle(size: 12)),
                                      decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius()),
                                      padding: EdgeInsets.all(8),
                                    ).visible(selectedPaymentMethod == paymentGateways[index])
                                  ],
                                ).onTap(() {
                                  selectedPaymentMethod = paymentGateways[index];
                                  setState(() {});
                                }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                              } else {
                                return Offstage();
                              }
                            },
                          ),
                        )
                      : Text(locale.lblNoPaymentMethods, style: secondaryTextStyle())
                  : LoaderWidget(),
              16.height,
              RichText(
                text: TextSpan(
                  text: locale.lblAddOrderNotes,
                  style: boldTextStyle(),
                  children: <TextSpan>[
                    TextSpan(text: '(${locale.lblOptional})', style: secondaryTextStyle(size: 12)),
                  ],
                ),
              ),
              10.height,
              Text(locale.lblNotesAboutOrder, style: secondaryTextStyle()),
              8.height,
              AppTextField(
                controller: orderNotesController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                textFieldType: TextFieldType.MULTILINE,
                textStyle: boldTextStyle(),
                minLines: 3,
                maxLines: 3,
                decoration: inputDecoration(context: context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              16.height,
            ],
          ).paddingSymmetric(horizontal: 16),
          Positioned(
            child: AppButton(
              text: 'Place Order',
              width: context.width() - 32,
              onTap: () async {
                if (cart.items.validate().isNotEmpty) {
                  if (cart.billingAddress!.address_1.validate().isNotEmpty || cart.billingAddress!.address_2.validate().isNotEmpty || cart.billingAddress!.city.validate().isNotEmpty) {
                    placeOrder();
                  } else {
                    toast(locale.lblEnterValidBllling);
                  }
                } else {
                  toast(locale.lblYourCarIsEmpty);
                }
              },
            ),
            bottom: 16,
            left: 16,
            right: 15,
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
