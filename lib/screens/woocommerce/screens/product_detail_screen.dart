import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/disabled_rating_bar_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/price_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/woo_commerce/common_models.dart';
import 'package:momona_healthcare/model/woo_commerce/product_detail_model.dart';
import 'package:momona_healthcare/model/woo_commerce/product_list_model.dart';
import 'package:momona_healthcare/network/shop_repository.dart';
import 'package:momona_healthcare/screens/patient/screens/web_view_payment_screen.dart';
import 'package:momona_healthcare/screens/shimmer/screen/product_detail_shimmer_screen.dart';
import 'package:momona_healthcare/screens/woocommerce/component/product_component.dart';
import 'package:momona_healthcare/screens/woocommerce/component/product_review_component.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/cart_screen.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/product_list_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  final ProductListModel? productData;

  const ProductDetailScreen({Key? key, required this.productId, this.productData}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

ProductDetailModel mainProduct = ProductDetailModel();

ProductDetailModel cartProduct = ProductDetailModel();

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Future<ProductDetailModel>? future;
  ProductDetailModel productData = ProductDetailModel();
  bool isFetched = false;
  bool isLoading = false;

  bool isWishListed = false;

  PageController pageController = PageController();
  List<GroupProductModel> groupProductList = [];

  int selectedIndex = -1;

  int count = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader) appStore.setLoading(true);
    if (isFetched) {
      setState(() {
        isFetched = false;
      });
    }

    future = getProductDetail(productId: widget.productId.validate()).then((value) {
      productData = value;
      isFetched = true;

      if (value.type == ProductTypes.grouped) {
        appStore.setLoading(true);
        value.groupedProducts.validate().forEach((e) {
          groupProductList.add(GroupProductModel(id: e.id.validate(), product: e));
          if (value.id == widget.productId) {
            productData = value;
          }
        });
        setState(() {});
      }

      if (value.type == ProductTypes.variable) {
        mainProduct = value;
        value.attributes.validate().forEach((attribute) {
          attribute.options!.insert(0, '${locale.chooseAnOption}');
        });
        value.variations.validate().forEach((e) {
          groupProductList.add(GroupProductModel(id: e.id.validate(), product: e));
          if (e.id == widget.productId) {
            productData = e;
          }
        });
      }

      setState(() {});
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  Future<void> addToCart() async {
    if (count == 0) {
      toast(locale.lblPleaseAddQuantity);
    } else {
      if (productData.isAddedCart.validate()) {
        CartScreen().launch(context).then((_) => init(showLoader: true));
      } else {
        if (productData.stockStatus == 'instock') {
          if (productData.type == ProductTypes.external) {
            WebViewPaymentScreen(
              isProductDetail: true,
              checkoutUrl: productData.externalUrl.validate(),
            ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
          } else {
            appStore.setLoading(true);
            addItemToCart(productId: productData.id.validate(), quantity: count).then((value) {
              toast(locale.successfullyAddedToCart);
              appStore.setLoading(false);
              productData.isAddedCart = true;
              setState(() {});
            }).catchError((e) {
              appStore.setLoading(false);
              toast(e.toString(), print: true);
            });
          }
        }
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: ((BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: context.height() * 0.5,
              systemOverlayStyle: defaultSystemUiOverlayStyle(
                context,
                statusBarIconBrightness: Brightness.dark,
              ),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: SizedBox(
                  height: context.height() * 0.5,
                  width: context.width(),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (productData.images.validate().isNotEmpty)
                        PageView.builder(
                          controller: pageController,
                          itemCount: productData.images.validate().length,
                          itemBuilder: (BuildContext context, int index) {
                            return CachedImageWidget(
                              url: productData.images.validate()[index].src.validate(),
                              height: context.height() * 0.5,
                              width: context.width(),
                              fit: BoxFit.cover,
                            );
                          },
                          onPageChanged: (value) {
                            if (productData.type == ProductTypes.grouped) {}
                          },
                        )
                      else
                        CachedImageWidget(
                          url: ic_noProduct,
                          height: context.height() * 0.5,
                          width: context.width(),
                          fit: BoxFit.cover,
                        ),
                      Positioned(
                        top: 42,
                        left: isRTL ? 16 : null,
                        right: isRTL ? null : 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                          child: Text(locale.lblSale, style: secondaryTextStyle(size: 10, color: Colors.white)),
                        ).visible(productData.onSale.validate()),
                      ),
                      Positioned(
                        bottom: 8,
                        child: DotIndicator(
                          indicatorColor: primaryColor,
                          pageController: pageController,
                          pages: productData.images.validate(),
                        ),
                      ).visible(productData.images.validate().length > 1),
                    ],
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
              backgroundColor: context.scaffoldBackgroundColor,
              title: Text(productData.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 22)).visible(innerBoxIsScrolled),
              actions: [
                Stack(
                  children: [
                    ic_cart.iconImageColored(size: 22, color: shimmerPrimaryBaseColor).paddingSymmetric(horizontal: 16).appOnTap(() {
                      CartScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                    }).paddingTop(shopStore.itemsInCartCount.validate() > 0 ? 8 : 0),
                    Positioned(
                      top: -4,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: boxDecorationDefault(
                          color: appSecondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(shopStore.itemsInCartCount.validate().toString(), style: secondaryTextStyle(color: Colors.white, size: 12)),
                      ),
                    ).visible(shopStore.itemsInCartCount.validate() > 0)
                  ],
                ).visible(innerBoxIsScrolled),
              ],
            ),
          ];
        }),
        body: Stack(
          children: [
            SnapHelperWidget(
              future: future,
              loadingWidget: ProductDetailShimmerScreen(),
              onSuccess: (data) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productData.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16, vertical: 8),
                      PriceWidget(
                        price: productData.price.validate(),
                        priceHtml: productData.priceHtml,
                        salePrice: productData.salePrice,
                        regularPrice: productData.regularPrice,
                        showDiscountPercentage: true,
                        size: 16,
                      ).paddingSymmetric(horizontal: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DisabledRatingBarWidget(
                            rating: productData.averageRating.validate().toDouble(),
                            size: 18,
                          ),
                          16.width,
                          Text('(${productData.ratingCount} ${locale.lblReview})', style: secondaryTextStyle(color: context.primaryColor)),
                        ],
                      ).paddingOnly(left: 16, right: 16, top: 8).visible(productData.averageRating.validate().toDouble() != 0.0),
                      16.height,
                      if (productData.type.validate() != ProductTypes.grouped && productData.type.validate() != ProductTypes.variable)
                        Row(
                          children: [
                            Text(locale.lblQuantity, style: primaryTextStyle()),
                            Icon(
                              Icons.remove,
                              size: 18,
                            ).paddingOnly(left: 8, right: 6, top: 8, bottom: 8).onTap(() {
                              if (count > 0) {
                                count = count - 1;
                                setState(() {});
                              }
                            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                              margin: EdgeInsets.only(top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: radius(4),
                                border: Border.all(),
                                color: context.cardColor,
                              ),
                              child: Text(count.toString(), style: primaryTextStyle(size: 12)),
                            ),
                            Icon(
                              Icons.add,
                              size: 18,
                            ).paddingOnly(left: 6, right: 12, top: 8, bottom: 8).onTap(() {
                              count = count + 1;
                              setState(() {});
                            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      if (productData.sku.validate().isNotEmpty)
                        RichText(
                          text: TextSpan(
                            text: locale.sku.suffixText(value: ' - '),
                            style: boldTextStyle(size: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: productData.sku.validate(),
                                style: primaryTextStyle(),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ).paddingOnly(top: 16, left: 16, right: 16),
                      if (productData.categories.validate().isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.lblCategory.suffixText(value: ' : '), style: boldTextStyle(size: 14)),
                            Wrap(
                              children: productData.categories!.map(
                                (e) {
                                  return Text(e.name.validate(), style: primaryTextStyle(color: context.primaryColor, size: 14)).onTap(() {
                                    ProductListScreen(categoryName: e.name, categoryId: e.id).launch(context);
                                  });
                                },
                              ).toList(),
                            ).expand(),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      if ((groupProductList.validate().isNotEmpty && productData.type == ProductTypes.grouped) || (groupProductList.validate().isNotEmpty && productData.type == ProductTypes.variable))
                        16.height,
                      if ((groupProductList.validate().isNotEmpty && productData.type == ProductTypes.grouped) || (groupProductList.validate().isNotEmpty && productData.type == ProductTypes.variable))
                        Text(locale.lblChooseFromCollection, style: primaryTextStyle()).paddingSymmetric(horizontal: 16),
                      if ((groupProductList.validate().isNotEmpty && productData.type == ProductTypes.grouped) || (groupProductList.validate().isNotEmpty && productData.type == ProductTypes.variable))
                        Divider(
                          indent: 16,
                          endIndent: 16,
                          height: 16,
                        ),
                      if ((groupProductList.validate().isNotEmpty && productData.type == ProductTypes.grouped) || (groupProductList.validate().isNotEmpty && productData.type == ProductTypes.variable))
                        Column(
                          children: groupProductList.map((e) {
                            return DecoratedBox(
                              decoration: boxDecorationDefault(
                                color: context.cardColor,
                                border: Border.all(
                                  color: selectedIndex == groupProductList.indexOf(e) ? appSecondaryColor : context.cardColor,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CachedImageWidget(
                                    url: e.product.productImage.validate(),
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(defaultRadius),
                                  16.width,
                                  Text(e.product.name.validate(), style: primaryTextStyle(size: 14), overflow: TextOverflow.ellipsis, maxLines: 1).expand(),
                                  PriceWidget(
                                    price: e.product.price.validate(),
                                    priceHtml: e.product.priceHtml,
                                    salePrice: e.product.salePrice,
                                    regularPrice: e.product.regularPrice,
                                    showDiscountPercentage: false,
                                  ),
                                  16.width,
                                  Icon(
                                    Icons.info_outline,
                                    color: primaryColor,
                                    size: 18,
                                  ).appOnTap(() {
                                    ProductDetailScreen(productId: e.id).launch(context);
                                  })
                                ],
                              ).paddingSymmetric(horizontal: 12, vertical: 12).onTap(() {
                                selectedIndex = groupProductList.indexOf(e);

                                setState(() {});
                                ProductDetailScreen(productId: e.id).launch(context);
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                            ).paddingSymmetric(horizontal: 16, vertical: 8);
                          }).toList(),
                        ),
                      if (!getBoolAsync(SharedPreferenceKey.hasInReviewKey) && productData.description.validate().isNotEmpty) 16.height,
                      if (!getBoolAsync(SharedPreferenceKey.hasInReviewKey) && productData.description.validate().isNotEmpty)
                        Text(locale.lblDescription, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                      if (!getBoolAsync(SharedPreferenceKey.hasInReviewKey) && productData.description.validate().isNotEmpty) 8.height,
                      if (!getBoolAsync(SharedPreferenceKey.hasInReviewKey) && productData.description.validate().isNotEmpty)
                        ReadMoreText(
                          parseHtmlString(productData.description.validate()),
                          trimLines: 4,
                          textAlign: TextAlign.justify,
                          trimMode: TrimMode.Line,
                          style: secondaryTextStyle(),
                        ).paddingSymmetric(horizontal: 16),
                      if (!getBoolAsync(SharedPreferenceKey.hasInReviewKey) && productData.description.validate().isNotEmpty) 24.height,
                      if (productData.attributes.validate().isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.additionalInformation, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                            Table(
                              columnWidths: {
                                0: FractionColumnWidth(0.25),
                                1: FractionColumnWidth(0.7),
                              },
                              border: TableBorder.all(
                                style: BorderStyle.solid,
                                width: 0.5,
                                color: secondaryTxtColor,
                                borderRadius: radius(4),
                              ),
                              children: productData.attributes.validate().map((e) {
                                return TableRow(
                                  decoration: boxDecorationDefault(color: context.cardColor),
                                  children: [
                                    Text(
                                      e.name.validate(),
                                      style: primaryTextStyle(),
                                      textAlign: TextAlign.start,
                                    ).paddingSymmetric(vertical: 8, horizontal: 16),
                                    productData.type == ProductTypes.variation
                                        ? Text(
                                            e.optionString.validate(),
                                            style: primaryTextStyle(),
                                            textAlign: TextAlign.start,
                                          ).paddingSymmetric(horizontal: 16)
                                        : Wrap(
                                            children: e.options.validate().map((option) {
                                              if (option != 'Choose an option') {
                                                return Text(
                                                  option.validate(),
                                                  style: primaryTextStyle(),
                                                  textAlign: TextAlign.start,
                                                ).paddingSymmetric(horizontal: 16, vertical: 8);
                                              } else {
                                                return Offstage();
                                              }
                                            }).toList(),
                                          ),
                                  ],
                                );
                              }).toList(),
                            ).paddingAll(16),
                            8.height,
                          ],
                        ),
                      ProductReviewComponent(
                        productId: productData.id.validate(),
                        callback: () {
                          init(showLoader: true);
                        },
                      ),
                      if (productData.relatedProductList.validate().isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.height,
                            Text(locale.relatedProducts, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 18),
                            HorizontalList(
                              padding: EdgeInsets.all(16),
                              spacing: 16,
                              itemCount: productData.relatedProductList.validate().length,
                              itemBuilder: (ctx, index) {
                                return RelatedProductCardComponent(product: productData.relatedProductList.validate()[index]);
                              },
                            ),
                          ],
                        )
                    ],
                  ),
                );
              },
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
      bottomNavigationBar: productData.type != ProductTypes.variable
          ? Container(
              color: context.cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(0)),
                    child: TextIcon(
                      text: productData.type == ProductTypes.external
                          ? locale.lblBuyThisOnWordpressStore
                          : productData.isAddedCart.validate()
                              ? locale.goToCart
                              : productData.stockStatus == 'instock'
                                  ? locale.addToCart
                                  : locale.outOfStock,
                      textStyle: boldTextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    onTap: () async {
                      addToCart();
                    },
                    elevation: 0,
                    color: productData.isAddedCart.validate()
                        ? appSecondaryColor
                        : productData.stockStatus == 'instock'
                            ? context.primaryColor
                            : Colors.grey.withOpacity(0.5),
                  ).expand().visible(isFetched && productData.type != ProductTypes.grouped),
                ],
              ),
            )
          : Offstage(),
    );
  }
}
