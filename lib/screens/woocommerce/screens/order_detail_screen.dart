import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/order_model.dart';
import 'package:kivicare_flutter/network/shop_repository.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/order_detail_shimmer_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/component/cancel_order_form_component.dart';
import 'package:kivicare_flutter/screens/woocommerce/component/order_status_component.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/product_detail_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel orderDetails;
  final int orderId;
  final VoidCallback? callback;

  const OrderDetailScreen({required this.orderDetails, required this.orderId, this.callback});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Future<OrderModel>? future;
  late OrderModel orderDetails;

  bool isSameAddress = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader = false) {
      appStore.setLoading(true);
    }
    orderDetails = widget.orderDetails;
    setState(() {});

    future = getOrder(orderId: widget.orderId.validate()).then((value) {
      orderDetails = value;
      isSameAddress =
          orderDetails.shipping!.postcode.validate() == orderDetails.billing!.postcode.validate() && orderDetails.shipping!.firstName.validate() == orderDetails.billing!.firstName.validate();

      appStore.setLoading(false);
      setState(() {});
      return value;
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onDeleteOrder() async {
    showConfirmDialogCustom(
      context,
      onAccept: (c) {
        appStore.setLoading(true);
        deleteOrder(orderId: widget.orderId.validate()).then((value) {
          toast(locale.lblOrderDeleted);
          appStore.setLoading(false);
          widget.callback?.call();
          finish(context, true);
        }).catchError((e) {
          appStore.setLoading(false);

          toast(e.toString(), print: true);
        });
      },
      dialogType: DialogType.CONFIRMATION,
      title: 'Do you want to Delete Order?',
    );
  }

  Future<void> onCancelOrder() async {
    await showInDialog(
      context,
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      builder: (context) {
        return CancelOrderFormComponent(
          orderId: widget.orderId.validate(),
          callback: (text) {
            showConfirmDialogCustom(
              context,
              onAccept: (c) {
                appStore.setLoading(true);
                cancelOrder(orderId: widget.orderId.validate(), note: text).then((value) {
                  toast(locale.lblOrderCancelledSuccessfully);
                  orderDetails.status = OrderStatus.cancelled;

                  init();
                  widget.callback?.call();

                  //finish(context, true);
                }).catchError((e) {
                  appStore.setLoading(false);
                  toast(e.toString(), print: true);
                });
              },
              dialogType: DialogType.CONFIRMATION,
              title: locale.cancelOrderConfirmation,
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.orderDetails,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        actions: [
          PopupMenuButton(
            enabled: !appStore.isLoading,
            iconColor: Colors.white,
            surfaceTintColor: context.cardColor,
            shape: RoundedRectangleBorder(borderRadius: radius()),
            onSelected: (val) async {
              if (val == 1) {
                onDeleteOrder();
              } else {
                onCancelOrder();
              }
            },
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Image.asset(ic_delete_icon, width: 20, height: 20, color: Colors.red, fit: BoxFit.cover),
                    8.width,
                    Text(locale.lblDelete, style: primaryTextStyle()),
                  ],
                ),
              ),
              if (orderDetails.status.validate() != OrderStatus.cancelled &&
                  orderDetails.status.validate() != OrderStatus.refunded &&
                  orderDetails.status.validate() != OrderStatus.completed &&
                  orderDetails.status.validate() != OrderStatus.trash &&
                  orderDetails.status.validate() != OrderStatus.failed)
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Image.asset(ic_clear, width: 20, height: 20, color: Colors.red, fit: BoxFit.cover),
                      8.width,
                      Text(locale.lblCancel, style: primaryTextStyle()),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          SnapHelperWidget(
            future: future,
            loadingWidget: OrderDetailShimmerScreen(),
            onSuccess: (orderData) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 70, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.orderStatus, style: boldTextStyle()),
                        OrderStatusComponent(status: orderDetails.status.validate()),
                      ],
                    ),
                    16.height,
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('#${orderDetails.id.validate().toString()}', style: secondaryTextStyle(color: primaryColor)),
                          8.height,
                          Row(
                            children: [
                              Text('${locale.lblDate}:', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.dateCreated.validate().getFormattedDate(DISPLAY_DATE_FORMAT), style: primaryTextStyle()).expand(),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              Text('${locale.lblEmail}:', style: primaryTextStyle()),
                              8.width,
                              Text(userStore.userEmail.validate(), style: primaryTextStyle()).expand(),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              Text('${locale.lblPaymentMethod}:', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.paymentMethodTitle.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Text('${locale.products}', style: boldTextStyle()),
                    16.height,
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: orderDetails.lineItems!.length,
                            itemBuilder: (ctx, index) {
                              return Row(
                                children: [
                                  CachedImageWidget(
                                    url: orderDetails.lineItems![index].image!.src.validate().isNotEmpty ? orderDetails.lineItems![index].image!.src.validate() : ic_noProduct,
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(defaultRadius),
                                  8.width,
                                  Text(
                                    '${orderDetails.lineItems.validate()[index].name.validate()} * ${orderDetails.lineItems![index].quantity.validate()}',
                                    style: primaryTextStyle(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ).expand(),
                                  PriceWidget(
                                    price: orderDetails.lineItems![index].total.validate(),
                                    textStyle: secondaryTextStyle(),
                                  ),
                                ],
                              ).paddingSymmetric(vertical: 6).onTap(() {
                                ProductDetailScreen(productId: orderDetails.lineItems![index].productId.validate()).launch(context);
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                            },
                          ),
                          10.height,
                          if (double.parse(orderDetails.discountTotal.validate()).toInt() > 0) Divider(height: 16),
                          if (double.parse(orderDetails.discountTotal.validate()).toInt() > 0) 2.height,
                          if (double.parse(orderDetails.discountTotal.validate()).toInt() > 0)
                            Row(
                              children: [
                                Text(
                                  locale.lblCouponDiscount.suffixText(value: ' - '),
                                  style: primaryTextStyle(size: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                Wrap(
                                  children: [
                                    Text(' - ', style: secondaryTextStyle(color: ratingBarLightGreenColor)),
                                    PriceWidget(
                                      price: orderDetails.discountTotal.validate(),
                                      textStyle: secondaryTextStyle(color: ratingBarLightGreenColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          2.height,
                          if (orderDetails.taxLines != null && orderDetails.taxLines.validate().isNotEmpty)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(locale.lblTax, style: boldTextStyle(size: 12)).expand(),
                                    16.width,
                                    Text(
                                      'Slug',
                                      style: boldTextStyle(size: 12),
                                      textAlign: TextAlign.center,
                                    ).expand(flex: 2),
                                    16.width,
                                    Text(
                                      locale.lblCharges,
                                      style: boldTextStyle(size: 12),
                                      textAlign: TextAlign.end,
                                    ).expand(),
                                  ],
                                ),
                                Divider(
                                  color: context.dividerColor,
                                ),
                                ...orderDetails.taxLines.validate().map<Widget>((data) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(data.taxName.validate(), maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 14)).expand(),
                                      Text(data.slug.validate(), maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 14)).expand(flex: 2),
                                      PriceWidget(
                                        price: double.parse(data.rate.validate()).toStringAsFixed(2),
                                        textStyle: secondaryTextStyle(),
                                        textAlign: TextAlign.center,
                                      ).paddingLeft(4).expand(flex: 2),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          if (double.parse(orderDetails.totalTax.validate()).toInt() > 0)
                            Row(
                              children: [
                                Text(
                                  locale.lblTotalTax,
                                  style: secondaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                PriceWidget(
                                  price: getPrice(orderDetails.totalTax.validate()),
                                  textStyle: secondaryTextStyle(),
                                ),
                              ],
                            ),
                          if (double.parse(orderDetails.shippingTotal.validate()).toInt() > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  locale.lblShippingCost.suffixText(value: ' - '),
                                  style: secondaryTextStyle(),
                                ),
                                Wrap(
                                  children: orderDetails.shippingLines.validate().map((e) {
                                    return PriceWidget(
                                      price: getPrice(e.total.validate()),
                                      textStyle: secondaryTextStyle(),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          Divider(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${locale.lblTotal}', style: boldTextStyle()),
                              PriceWidget(price: orderDetails.total.validate()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    if (!isSameAddress) Text('${locale.billingAddress}', style: boldTextStyle()),
                    if (!isSameAddress) 16.height,
                    if (!isSameAddress)
                      Container(
                        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.lblName} - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.firstName.validate() + ' ${orderDetails.billing!.lastName.validate()}', style: primaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Company - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.company.validate().toString(), style: primaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.lblAddress} - ', style: primaryTextStyle()),
                                8.width,
                                Text('${orderDetails.billing!.address_1.validate().toString()}, ${orderDetails.billing!.address_2.validate().toString()}', style: primaryTextStyle()).expand(),
                              ],
                            ),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.lblCity} - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.city.validate().toString().capitalizeFirstLetter(), style: primaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.state} - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.state.validate().toString(), style: primaryTextStyle()),
                              ],
                            ).visible(orderDetails.billing!.state.validate().isNotEmpty),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.lblCountry} - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.country.validate().toString(), style: primaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.lblPostalCode} - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.postcode.validate(), style: primaryTextStyle()).expand(),
                              ],
                            ).visible(orderDetails.billing!.postcode.validate().isNotEmpty),
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${locale.lblContactNumber} - ', style: primaryTextStyle()),
                                8.width,
                                Text(orderDetails.billing!.phone.validate().toString(), style: primaryTextStyle()).expand(),
                              ],
                            ).visible(orderDetails.billing!.phone.validate().isNotEmpty),
                          ],
                        ),
                      ),
                    24.height,
                    Text('${locale.shippingAddress}', style: boldTextStyle()),
                    16.height,
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.lblName} - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.firstName.validate() + ' ${orderDetails.shipping!.lastName.validate()}', style: primaryTextStyle()),
                            ],
                          ),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Company - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.company.validate(), style: primaryTextStyle()),
                            ],
                          ).visible(orderDetails.shipping!.company.validate().isNotEmpty),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.lblAddress} - ', style: primaryTextStyle()),
                              8.width,
                              Text('${orderDetails.shipping!.address_1.validate()} ${orderDetails.billing!.address_2.validate().prefixText(value: ',')}', style: primaryTextStyle()).expand(),
                            ],
                          ).visible(orderDetails.shipping!.address_1.validate().isNotEmpty || orderDetails.billing!.address_2.validate().isNotEmpty),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.lblCity} - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.city.validate().capitalizeFirstLetter(), style: primaryTextStyle()),
                            ],
                          ).visible(orderDetails.shipping!.city.validate().isNotEmpty),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.state} - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.state.validate(), style: primaryTextStyle()),
                            ],
                          ).visible(orderDetails.shipping!.state.validate().isNotEmpty),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.lblCountry} - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.country.validate(), style: primaryTextStyle()),
                            ],
                          ).visible(orderDetails.shipping!.country.validate().isNotEmpty),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.lblPostalCode} - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.postcode.validate(), style: primaryTextStyle()),
                            ],
                          ).visible(orderDetails.shipping!.postcode.validate().isNotEmpty),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${locale.lblContactNumber} - ', style: primaryTextStyle()),
                              8.width,
                              Text(orderDetails.shipping!.phone.validate(), style: primaryTextStyle()).expand(),
                            ],
                          ).visible(orderDetails.shipping!.phone.validate().isNotEmpty),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Observer(builder: (ctx) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
