import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/cart_item_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/cart_model.dart';
import 'package:kivicare_flutter/network/shop_repository.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/cart_shimmer_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/component/coupon_component.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/checkout_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/coupon_list_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/product_detail_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CartScreen extends StatefulWidget {
  final bool isFromHome;

  CartScreen({this.isFromHome = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

List<CartItemModel> cartItemList = [];

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItemModel>> future;
  CartModel? cart;

  double total = 0;
  double subTotal = 0;
  TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init(showLoader: false);
  }

  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    cartItemList.clear();
    future = getCartDetails().then((value) {
      cart = value;
      cartItemList.addAll(value.items.validate());
      shopStore.setCartCount(value.items.validate().length);

      setTotal();
      setState(() {});
      appStore.setLoading(false);
      return cartItemList;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> applyCouponToCart() async {
    if (couponController.text.isNotEmpty) {
      appStore.setLoading(true);
      await Future.forEach<CartItemModel>(cart!.items.validate(), (element) async {
        if (element.isQuantityChanged.validate()) {
          appStore.setLoading(true);
          await updateCartItem(productKey: element.key.validate(), quantity: element.quantity.validate()).then((value) async {
            toast(locale.cartUpdated);
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString(), print: true);
          });
        }
      }).whenComplete(() async {
        appStore.setLoading(true);

        await applyCoupon(code: couponController.text).then((value) {
          cart = value;
          setTotal();
          couponController.clear();

          setState(() {});
          appStore.setLoading(false);
        }).catchError((e) {
          couponController.clear();
          appStore.setLoading(false);
          toast(e.toString());
        });
      });
    } else {
      toast(locale.enterValidCouponCode);
    }
  }

  void onAcceptRemoveItem(CartItemModel cartItem) {
    cartItem.isQuantityChanged = true;

    cartProduct.isAddedCart = false;

    total = total - (double.parse(cartItem.prices!.price.validate()) * cartItem.quantity!.toInt());

    cartItemList.remove(cartItem);
    setState(() {});

    toast(locale.itemRemovedSuccessfully);

    removeCartItem(productKey: cartItem.key.validate()).then((value) {
      init();
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  Future<void> onRefresh() async {
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);

    super.dispose();
  }

  setTotal() {
    subTotal = cartItemList.map((e) => e).toList().sumByDouble((p) => (double.parse(getPrice(p.prices!.price.validate())) * p.quantity.validate().toInt()));

    total = subTotal;
    if (cart!.totals != null && cart!.totals!.totalDiscount.validate().isNotEmpty) {
      total -= double.parse(getPrice(cart!.totals!.totalDiscount.validate()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      color: context.primaryColor,
      child: Scaffold(
        appBar: appBarWidget(
          'Cart',
          textColor: Colors.white,
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SnapHelperWidget<List<CartItemModel>>(
              future: future,
              loadingWidget: CartShimmerScreen(),
              onSuccess: (data) {
                if (data.isEmpty)
                  return NoDataFoundWidget(
                    text: locale.yourCartIsCurrentlyEmpty.capitalizeEachWord(),
                    retryText: locale.lblViewProducts,
                    onRetry: () {
                      finish(context);
                    },
                  ).center();
                return AnimatedScrollView(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  padding: EdgeInsets.only(bottom: 60),
                  children: [
                    AnimatedListView(
                      shrinkWrap: true,
                      listAnimationType: ListAnimationType.None,
                      slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cartItemList.length,
                      itemBuilder: (context, index) {
                        CartItemModel cartItem = cartItemList[index];

                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedImageWidget(
                                    url: cartItem.images.validate().isNotEmpty ? cartItem.images!.first.src.validate() : ic_noProduct,
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(defaultAppButtonRadius).appOnTap(
                                    () {
                                      ProductDetailScreen(productId: cartItem.id.validate()).launch(context);
                                    },
                                  ),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cartItem.name.validate().capitalizeFirstLetter(),
                                            style: boldTextStyle(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ).appOnTap(
                                            () {
                                              ProductDetailScreen(productId: cartItem.id.validate()).launch(context);
                                            },
                                          ).expand(),
                                          Image.asset(
                                            ic_clear,
                                            color: context.primaryColor,
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                          ).onTap(
                                            () {
                                              showConfirmDialogCustom(
                                                context,
                                                onAccept: (c) {
                                                  onAcceptRemoveItem(cartItem);
                                                },
                                                dialogType: DialogType.CONFIRMATION,
                                                //To do add language.lblRemoveFromCartConfirmation,
                                                title: locale.removeFromCartConfirmation,
                                              );
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                        ],
                                      ),
                                      4.height,
                                      PriceWidget(
                                        price: getPrice(cartItem.prices!.price.validate()),
                                        salePrice: getPrice(cartItem.prices!.salePrice.validate()),
                                        regularPrice: getPrice(cartItem.prices!.regularPrice.validate()),
                                        prefix: cartItem.prices!.currencyPrefix,
                                        postFix: cartItem.prices!.currencySuffix,
                                      ).appOnTap(
                                        () {
                                          ProductDetailScreen(productId: cartItem.id.validate()).launch(context);
                                        },
                                      ),
                                      8.height,
                                      Row(
                                        children: [
                                          Text(locale.lblQuantity, style: primaryTextStyle(size: 12)),
                                          Icon(
                                            Icons.remove,
                                            color: context.iconColor,
                                            size: 18,
                                          ).paddingOnly(left: 8, right: 6, top: 8, bottom: 8).onTap(() async {
                                            if (cartItem.quantity.validate() > 1) {
                                              cartItem.quantity = cartItem.quantity.validate() - 1;
                                              cartItem.isQuantityChanged = true;

                                              setState(() {});
                                              setTotal();
                                            }
                                          }),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                            margin: EdgeInsets.only(top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                              borderRadius: radius(4),
                                              border: Border.all(
                                                color: appStore.isDarkModeOn ? Colors.white10 : Colors.black,
                                              ),
                                            ),
                                            child: Text(cartItem.quantity.toString(), style: primaryTextStyle(size: 12)),
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: context.iconColor,
                                            size: 18,
                                          ).paddingOnly(left: 6, right: 12, top: 8, bottom: 8).onTap(() async {
                                            cartItem.quantity = cartItem.quantity.validate() + 1;
                                            cartItem.isQuantityChanged = true;
                                            setState(() {});

                                            setTotal();
                                          }),
                                        ],
                                      ),
                                    ],
                                  ).expand(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ).paddingTop(16),
                    16.height,
                    if (cart!.coupons.validate().isNotEmpty)
                      Divider(
                        height: 36,
                        indent: 16,
                        endIndent: 16,
                        color: context.dividerColor,
                      ),
                    if (cart!.coupons.validate().isNotEmpty)
                      CartCouponsComponent(
                        couponsList: cart!.coupons.validate(),
                        onCouponRemoved: (value) {
                          cart = value;
                          setTotal();
                          couponController.clear();
                          setState(() {});
                        },
                      ),
                    Divider(
                      height: 16,
                      indent: 16,
                      endIndent: 16,
                      color: context.dividerColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: context.width() / 2 - 32,
                          child: TextField(
                            enabled: !appStore.isLoading,
                            controller: couponController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            decoration: inputDecoration(
                              context: context,
                              labelText: locale.couponCode,
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                              fillColor: context.cardColor,
                            ),
                            onSubmitted: (text) async {
                              await applyCouponToCart();
                            },
                          ),
                        ),
                        Text(
                          couponController.text.isEmpty ? locale.applyCoupon : locale.appliedCoupons,
                          style: primaryTextStyle(color: context.primaryColor),
                          textAlign: TextAlign.end,
                        ).appOnTap(() async {
                          await applyCouponToCart();
                        }).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 8),
                    Divider(
                      height: 16,
                      indent: 16,
                      endIndent: 16,
                      color: context.dividerColor,
                    ),
                    Align(
                      child: Text(locale.lblViewCoupons, style: primaryTextStyle(color: appSecondaryColor)).paddingSymmetric(horizontal: 16).appOnTap(() {
                        CouponListScreen(
                          isCartScreen: true,
                          cartAmount: total,
                        ).launch(context, duration: pageAnimationDuration, pageRouteAnimation: pageAnimation);
                      }),
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(locale.lblSubTotal, style: secondaryTextStyle(size: 16)).expand(),
                                  PriceWidget(
                                    price: subTotal.toStringAsFixed(2),
                                    size: 16,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              8.height,
                              if (double.parse(cart!.totals!.totalDiscount.validate()).toInt() > 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      locale.lblCouponDiscount,
                                      style: secondaryTextStyle(size: 16),
                                    ).expand(),
                                    Wrap(
                                      children: [
                                        Text('- ', style: primaryTextStyle(color: ratingBarLightGreenColor)),
                                        PriceWidget(
                                          price: getPrice(cart!.totals!.totalDiscount.validate()),
                                          textAlign: TextAlign.start,
                                          textStyle: primaryTextStyle(color: ratingBarLightGreenColor),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              8.height,
                              if (double.parse(cart!.totals!.totalShipping.validate()).toInt() > 0)
                                Row(
                                  children: [
                                    Text(locale.lblShippingCost, style: secondaryTextStyle(size: 16)).expand(),
                                    PriceWidget(
                                      price: cart!.totals!.totalShipping.validate(),
                                      size: 16,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(locale.lblTotal, style: secondaryTextStyle(size: 16)).expand(),
                                  PriceWidget(
                                    price: total.toString(),
                                    size: 16,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ).paddingAll(16),
                  ],
                ).visible(data.isNotEmpty);
              },
            ),
            if (cart != null && cart!.items.validate().isNotEmpty)
              Positioned(
                child: AppButton(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                  text: locale.lblContinue,
                  textStyle: boldTextStyle(color: Colors.white),
                  elevation: 0,
                  color: context.primaryColor,
                  width: context.width() - 32,
                  onTap: () async {
                    if (!appStore.isLoading)
                      await Future.forEach<CartItemModel>(cart!.items.validate(), (element) async {
                        if (element.isQuantityChanged.validate()) {
                          appStore.setLoading(true);
                          try {
                            await updateCartItem(productKey: element.key.validate(), quantity: element.quantity.validate());
                            toast(locale.cartUpdated);
                            init();
                          } catch (e) {
                            appStore.setLoading(false);
                            setState(() {
                              element.isQuantityChanged = false;
                            });
                            init();
                            toast(e.toString());
                            return;
                          }
                        }
                      }).then((value) {
                        CheckoutScreen(cartDetails: cart!, itermRemoved: () => init(showLoader: false)).launch(context).then((value) async {
                          if (value ?? false) {
                            init();
                          }
                        });
                      }).catchError((e) {
                        appStore.setLoading(false);
                        init(showLoader: true);
                        toast(e.toString());
                        return;
                      });
                  },
                ),
                bottom: 16,
                left: 16,
                right: 16,
              ),
            Observer(
              builder: (context) => LoaderWidget().center().visible(appStore.isLoading),
            )
          ],
        ),
      ),
    );
  }
}
