import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/disabled_rating_bar_widget.dart';
import 'package:momona_healthcare/components/image_border_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/woo_commerce/product_review_model.dart';
import 'package:momona_healthcare/network/shop_repository.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/double_extension.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductReviewComponent extends StatefulWidget {
  final int productId;

  final VoidCallback? callback;

  const ProductReviewComponent({required this.productId, this.callback});

  @override
  State<ProductReviewComponent> createState() => _ProductReviewComponentState();
}

class _ProductReviewComponentState extends State<ProductReviewComponent> {
  final reviewFormKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();

  double rating = 0.0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addReview() async {
    if (reviewFormKey.currentState!.validate()) {
      reviewFormKey.currentState!.save();
      hideKeyboard(context);

      if (rating > 0) {
        appStore.setLoading(true);
        Map request = {
          "product_id": widget.productId.toString(),
          "review": controller.text,
          "reviewer": '${userStore.firstName}  ${userStore.lastName}',
          "reviewer_email": userStore.userEmail,
          "rating": rating.toInt(),
        };
        await addProductReview(request: request).then((value) async {
          toast('${locale.reviewAddedSuccessfully}');
          controller.clear();
          rating = 0.0;
          setState(() {});
          widget.callback?.call();
          appStore.setLoading(false);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      } else {
        toast('${locale.pleaseAddRating}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SnapHelperWidget<List<ProductReviewModel>>(
            future: getProductReviews(productId: widget.productId),
            onSuccess: (snap) {
              if (snap.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.reviews.capitalizeFirstLetter(), style: boldTextStyle()),
                    24.height,
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snap.length,
                      itemBuilder: (ctx, index) {
                        ProductReviewModel review = snap[index];
                        return Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageBorder(
                                  src: review.reviewerAvatarUrls!.full.validate(),
                                  height: 40,
                                  width: 40,
                                ),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          review.reviewer.validate().isEmpty ? review.reviewerEmail.validate() : review.reviewer.validate(),
                                          style: boldTextStyle(size: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ).expand(),
                                        Text(convertToAgo(review.dateCreatedGmt.validate()), style: secondaryTextStyle(size: 12)),
                                      ],
                                    ),
                                    2.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DisabledRatingBarWidget(
                                          rating: review.rating.validate().toDouble(),
                                          size: 14,
                                          allowHalfRating: true,
                                        ),
                                        if (review.reviewerEmail == userStore.userEmail)
                                          Text(locale.editReview, style: primaryTextStyle(size: 12)).onTap(() {
                                            showInDialog(
                                              context,
                                              contentPadding: EdgeInsets.zero,
                                              builder: (p0) {
                                                return UpdateReviewComponent(
                                                    rating: review.rating.validate(),
                                                    review: review.review,
                                                    reviewId: review.id.validate(),
                                                    callback: () {
                                                      setState(() {});
                                                      widget.callback?.call();
                                                    });
                                              },
                                            );
                                          }),
                                      ],
                                    ),
                                    6.height,
                                    Text(parseHtmlString(review.review.validate()), style: secondaryTextStyle()),
                                  ],
                                ).expand(),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              }
              return Offstage();
            },
            errorWidget: Offstage(),
            loadingWidget: LoaderWidget(),
          ),
          Text('${locale.addAReview}', style: boldTextStyle()),
          16.height,
          RichText(
            text: TextSpan(
              style: secondaryTextStyle(),
              children: [
                TextSpan(text: '${locale.rating} '),
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontFeatures: [FontFeature.subscripts()],
                  ),
                ),
              ],
            ),
          ),
          6.height,
          RatingBarWidget(
            onRatingChanged: (rat) {
              rating = rat;
              setState(() {});
            },
            activeColor: rating.getRatingBarColor(),
            inActiveColor: ratingBarColor,
            rating: rating,
            size: 18,
          ),
          16.height,
          RichText(
            text: TextSpan(
              style: secondaryTextStyle(),
              children: [
                TextSpan(text: '${locale.writeReview} '),
                TextSpan(text: '*', style: TextStyle(color: Colors.red, fontFeatures: [FontFeature.subscripts()])),
              ],
            ),
          ),
          12.height,
          Form(
            key: reviewFormKey,
            child: AppTextField(
              enabled: !appStore.isLoading,
              controller: controller,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.MULTILINE,
              textStyle: primaryTextStyle(size: 14),
              minLines: 2,
              maxLines: 6,
              decoration: inputDecoration(context: context, hintText: locale.lblReviewHint),
              onFieldSubmitted: (text) {
                //addReview();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.pleaseAddReview;
                }
                return null;
              },
            ),
          ),
          16.height,
          Align(
            alignment: Alignment.bottomRight,
            child: AppButton(
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
              text: locale.lblSubmit,
              textStyle: boldTextStyle(color: Colors.white, size: 12),
              padding: EdgeInsets.zero,
              elevation: 0,
              color: context.primaryColor,
              onTap: () async {
                addReview();
              },
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 16),
    );
  }
}

class UpdateReviewComponent extends StatefulWidget {
  final int? rating;
  final String? review;
  final int? reviewId;

  final VoidCallback? callback;

  const UpdateReviewComponent({this.review, this.rating, this.reviewId, this.callback});

  @override
  State<UpdateReviewComponent> createState() => _UpdateReviewComponentState();
}

class _UpdateReviewComponentState extends State<UpdateReviewComponent> {
  double selectedRating = 3;

  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      reviewController.text = parseHtmlString(widget.review.validate());
      selectedRating = widget.rating.validate().toDouble();
    }
  }

  Future<void> updateReview() async {
    if (selectedRating > 0) {
      if (reviewController.text.isNotEmpty) {
        appStore.setLoading(true);
        finish(context);
        Map request = {"review": reviewController.text, "rating": selectedRating.toString()};
        await updateProductReview(request: request, reviewId: widget.reviewId.validate()).then((value) async {
          toast(locale.reviewUpdatedSuccessfully);
          widget.callback?.call();
          appStore.setLoading(false);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      } else {
        toast(locale.pleaseAddReview);
      }
    } else {
      toast(locale.pleaseAddRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(locale.rating, style: boldTextStyle(color: primaryColor, size: 18)),
                if (widget.review != null)
                  Icon(
                    Icons.delete_outline,
                    size: 20,
                  ).appOnTap(() async {
                    showConfirmDialogCustom(
                      context,
                      onAccept: (c) {
                        appStore.setLoading(true);
                        finish(context);
                        deleteProductReview(reviewId: widget.reviewId.validate()).then((value) {
                          appStore.setLoading(false);
                          toast(locale.reviewDeletedSuccessfully);
                          widget.callback?.call();
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });
                      },
                      dialogType: DialogType.CONFIRMATION,
                      title: locale.deleteReviewConfirmation,
                      positiveText: locale.lblDelete,
                    );
                  }),
              ],
            ),
            16.height,
            RatingBarWidget(
              onRatingChanged: (rating) {
                selectedRating = rating;
                setState(() {});
              },
              activeColor: Colors.amber,
              inActiveColor: Colors.amber,
              rating: selectedRating,
              size: 20,
              allowHalfRating: false,
            ),
            16.height,
            AppTextField(
              controller: reviewController,
              textFieldType: TextFieldType.OTHER,
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
              decoration: inputDecoration(
                context: context,
                contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
                labelText: locale.writeReview,
                labelStyle: secondaryTextStyle(),
                fillColor: context.scaffoldBackgroundColor,
              ),
              onFieldSubmitted: (x) {
                updateReview();
              },
            ),
            32.height,
            Row(
              children: [
                AppButton(
                  text: locale.lblCancel,
                  textColor: textPrimaryColorGlobal,
                  color: context.cardColor,
                  elevation: 0,
                  onTap: () {
                    finish(context);
                  },
                ).expand(),
                16.width,
                AppButton(
                  textColor: Colors.white,
                  text: locale.lblSubmit,
                  elevation: 0,
                  color: context.primaryColor,
                  onTap: () {
                    updateReview();
                  },
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
