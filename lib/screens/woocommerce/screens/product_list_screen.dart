import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/links.dart';
import 'package:momona_healthcare/model/woo_commerce/cart_item_model.dart';
import 'package:momona_healthcare/model/woo_commerce/category_model.dart';
import 'package:momona_healthcare/model/woo_commerce/common_models.dart';
import 'package:momona_healthcare/model/woo_commerce/product_list_model.dart';
import 'package:momona_healthcare/network/shop_repository.dart';
import 'package:momona_healthcare/screens/shimmer/screen/product_list_shimmer_screen.dart';
import 'package:momona_healthcare/screens/woocommerce/component/product_component.dart';
import 'package:momona_healthcare/screens/woocommerce/component/sort_filter_bottom_sheet_component.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/cart_screen.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/order_list_screen.dart';
import 'package:momona_healthcare/screens/woocommerce/screens/product_detail_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductListScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  const ProductListScreen({this.categoryId, this.categoryName});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  Future<List<ProductListModel>>? future;
  ScrollController _scrollController = ScrollController();

  TextEditingController searchCont = TextEditingController();

  List<ProductListModel> productList = [];
  List<CategoryModel> categoryList = [];

  CategoryModel? selectedCategory;

  int page = 1;

  bool isLastPage = false;
  bool showClear = false;

  String? orderBy;

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) {
      appStore.setLoading(false);
    }

    init(showLoader: false);
    getCategories();
  }

  Future<void> init({bool showLoader = true, int? categoryId}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getProductsList(
      page: page,
      productList: productList,
      searchString: searchCont.text,
      categoryId: categoryId ?? widget.categoryId,
      orderBy: orderBy,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  Future<void> selectedFilterSort({bool isOrderBy = false, FilterModel? filterValue}) async {
    setState(() {
      orderBy = filterValue?.value;
      page = 1;
    });

    finish(context);

    init(showLoader: true);
  }

  Future<void> getCategories() async {
    await getCategoryList().then((value) {
      categoryList.add(CategoryModel(name: 'All', id: -1));

      categoryList.addAll(value);
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  Future<void> _onClearSearch() async {
    hideKeyboard(context);
    searchCont.clear();
    setState(() {
      page = 1;
    });

    init(showLoader: true);
  }

  Future<void> onNextPage() async {
    setState(() {
      page++;
    });
    init(showLoader: true);
  }

  Future<void> onRefresh({bool showLoader = false}) async {
    setState(() {
      page = 1;
    });
    init(showLoader: showLoader);
    return 1.seconds.delay;
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
      appBar:
          appBarWidget(widget.categoryName != null ? widget.categoryName.validate() : locale.products, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context), actions: [
        ic_checkList.iconImageColored(color: Colors.white, isRoundedCorner: true).appOnTap(() {
          OrderListScreen(isFromProduct: true).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
        }).paddingTop(shopStore.itemsInCartCount.validate() > 0 ? 8 : 0),
        Stack(
          children: [
            ic_cart.iconImageColored(size: 22, color: Colors.white).paddingSymmetric(horizontal: 16).appOnTap(() {
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
        )
      ]),
      body: Observer(builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                AppTextField(
                  controller: searchCont,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context: context,
                    hintText: "Search Products",
                    prefixIcon: ic_search.iconImage().paddingAll(16),
                    suffixIcon: !showClear
                        ? Offstage()
                        : ic_clear.iconImage().paddingAll(16).appOnTap(
                            () {
                              _onClearSearch();
                            },
                          ),
                  ),
                  onChanged: (newValue) {
                    if (newValue.isEmpty) {
                      showClear = false;
                      _onClearSearch();
                    } else {
                      Timer(pageAnimationDuration, () {
                        setState(() {
                          page = 1;
                        });
                        init(showLoader: true);
                      });
                      showClear = true;
                    }
                    setState(() {});
                  },
                  onFieldSubmitted: (searchString) async {
                    hideKeyboard(context);
                    init(showLoader: true);
                  },
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextIcon(
                      prefix: ic_sort.iconImage(size: 16),
                      text: locale.sortBy,
                      textStyle: primaryTextStyle(color: appSecondaryColor),
                      spacing: 8,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: context.cardColor,
                          constraints: BoxConstraints(minHeight: context.height() * 0.25, minWidth: context.width()),
                          builder: (context) {
                            return SortFilterBottomSheet(
                              onTapCall: (filter) {
                                selectedFilterSort(
                                  filterValue: filter,
                                  isOrderBy: true,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ).paddingOnly(left: 16, right: 16, top: 24, bottom: 60),
            SnapHelperWidget<List<ProductListModel>>(
              future: future,
              loadingWidget: ProductListScreenShimmer().paddingTop(16),
              errorBuilder: (error) {
                return NoDataWidget(
                  imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
                  title: error.toString(),
                ).center();
              },
              onSuccess: (snap) {
                return AnimatedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  disposeScrollController: true,
                  controller: _scrollController,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                  listAnimationType: ListAnimationType.None,
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  onSwipeRefresh: onRefresh,
                  onNextPage: onNextPage,
                  children: [
                    HorizontalList(
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        CategoryModel item = categoryList[index];

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: item.isSelected.validate() ? context.primaryColor : context.cardColor,
                            borderRadius: BorderRadius.all(radiusCircular()),
                          ),
                          child: Row(
                            children: [
                              if (item.image != null)
                                CachedImageWidget(
                                  url: item.image!.src.validate(),
                                  fit: BoxFit.cover,
                                  width: 16,
                                  height: 16,
                                  circle: true,
                                ).paddingOnly(right: 4),
                              Text(item.name.validate(), style: boldTextStyle(size: 14, color: item.isSelected.validate() ? context.cardColor : context.primaryColor), maxLines: 1),
                            ],
                          ),
                        ).appOnTap(
                          () {
                            categoryList.forEach((element) {
                              element.isSelected = false;
                            });
                            item.isSelected = true;
                            page = 1;
                            selectedCategory = item;

                            if (item.id == -1) {
                              init(showLoader: true);
                            } else {
                              init(categoryId: selectedCategory!.id.validate(), showLoader: true);
                            }

                            setState(() {});
                          },
                        );
                      },
                    ),
                    16.height,
                    Wrap(
                      runSpacing: 16,
                      spacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: snap.map((product) => ProductComponent(product: product)).toList(),
                    )
                  ],
                ).visible(snap.isNotEmpty,
                    defaultWidget: SingleChildScrollView(
                      child: NoDataFoundWidget(
                        text: searchCont.text.isEmpty ? locale.lblNoProductsFound : locale.lblCantFindProductYouSearchedFor,
                        onRetry: () {
                          onRefresh(showLoader: true);
                        },
                      ),
                    ).center().visible(snap.isEmpty && !appStore.isLoading));
              },
            ).paddingTop(128),
            Observer(
              builder: (context) => LoaderWidget().center().visible(appStore.isLoading),
            )
          ],
        );
      }),
    );
  }
}
