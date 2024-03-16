import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/disabled_rating_bar_widget.dart';
import 'package:momona_healthcare/components/price_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/woo_commerce/product_detail_model.dart';
import 'package:momona_healthcare/model/woo_commerce/product_list_model.dart';
import 'package:momona_healthcare/network/shop_repository.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/product_detail_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductComponent extends StatelessWidget {
  final ProductListModel product;

  const ProductComponent({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
      width: context.width() / 2 - 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CachedImageWidget(
                url: product.images.validate().isNotEmpty ? product.images.validate().first.src.validate() : ic_noProduct,
                height: 120,
                width: context.width() / 2 - 24,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(
                topRight: defaultRadius.toInt(),
                topLeft: defaultRadius.toInt(),
              ),
              Positioned(
                left: 0,
                top: -1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    borderRadius: radiusOnly(
                      bottomRight: defaultRadius,
                      topLeft: defaultRadius,
                    ),
                  ),
                  child: Text(locale.lblSale, style: secondaryTextStyle(size: 10, color: Colors.white)),
                ),
              ).visible(product.onSale.validate()),
              Positioned(
                top: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: boxDecorationDefault(
                    borderRadius: BorderRadius.only(
                      bottomLeft: radiusCircular(),
                      topRight: radiusCircular(),
                    ),
                  ),
                  child: DisabledRatingBarWidget(
                    rating: product.averageRating.validate().toDouble(),
                    size: 14,
                    showRatingText: true,
                    itemCount: 1,
                  ).paddingSymmetric(horizontal: 4, vertical: 3),
                ),
              ).visible(product.ratingCount.validate() > 0)
            ],
          ),
          14.height,
          Marquee(
            child: Text(product.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 14)).paddingSymmetric(horizontal: 10),
          ),
          PriceWidget(
            price: product.price.validate(value: '0'),
            salePrice: product.salePrice,
            regularPrice: product.regularPrice,
            showDiscountPercentage: false,
            textSize: 14,
          ).paddingSymmetric(horizontal: 10, vertical: 8),
          if (product.type != ProductTypes.variable && product.type != ProductTypes.grouped && product.type != ProductTypes.external)
            Text(
              locale.addToCart,
              style: secondaryTextStyle(color: primaryColor),
            ).appOnTap(() {
              appStore.setLoading(true);
              addItemToCart(productId: product.id.validate(), quantity: 1).then((value) {
                toast(locale.successfullyAddedToCart);
                appStore.setLoading(false);
              }).catchError((e) {
                toast(e.toString());
                appStore.setLoading(false);
              });
            })
          else
            Text(
              '',
              style: secondaryTextStyle(color: primaryColor),
            ),
          8.height,
        ],
      ),
    ).appOnTap(
      () {
        appStore.setLoading(false);
        ProductDetailScreen(productId: product.id.validate()).launch(
          context,
          duration: pageAnimationDuration,
          pageRouteAnimation: pageAnimation,
        );
      },
      splashColor: appPrimaryColor,
    );
  }
}

class RelatedProductCardComponent extends StatefulWidget {
  final RelatedProductModel product;

  const RelatedProductCardComponent({required this.product});

  @override
  State<RelatedProductCardComponent> createState() => _RelatedProductCardComponentState();
}

class _RelatedProductCardComponentState extends State<RelatedProductCardComponent> {
  late RelatedProductModel product;

  @override
  void initState() {
    product = widget.product;

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        appStore.setLoading(false);
        ProductDetailScreen(productId: product.id.validate()).launch(context, duration: pageAnimationDuration, pageRouteAnimation: pageAnimation);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
        width: context.width() / 2 - 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImageWidget(
                  url: product.images!.first.src.validate().isNotEmpty ? product.images!.first.src.validate() : ic_noProduct,
                  height: 150,
                  width: context.width() / 2 - 24,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRectOnly(topRight: defaultAppButtonRadius.toInt(), topLeft: defaultAppButtonRadius.toInt()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: radiusOnly(topLeft: defaultAppButtonRadius, bottomRight: defaultAppButtonRadius)),
                  child: Text(locale.lblSale, style: secondaryTextStyle(size: 10, color: Colors.white)),
                ).visible(double.parse(product.regularPrice.validate()) > double.parse(product.salePrice.validate())),
              ],
            ),
            14.height,
            Text(product.name.validate().capitalizeFirstLetter(), style: boldTextStyle(size: 14)).paddingSymmetric(horizontal: 10),
            4.height,
            PriceWidget(
              price: product.price.validate(),
              salePrice: product.salePrice,
              regularPrice: product.regularPrice,
              showDiscountPercentage: false,
            ).paddingSymmetric(horizontal: 10),
            14.height,
          ],
        ),
      ),
    );
  }
}
