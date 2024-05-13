import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/common_models.dart';
import 'package:kivicare_flutter/model/woo_commerce/order_model.dart';
import 'package:kivicare_flutter/network/shop_repository.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/order_list_shimmer_screen.dart';
import 'package:kivicare_flutter/screens/woocommerce/component/order_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderListScreen extends StatefulWidget {
  final bool isFromProduct;
  OrderListScreen({Key? key, this.isFromProduct = false}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  Future<List<OrderModel>>? future;
  List<OrderModel> orderList = [];
  List<FilterModel> filterOptions = getOrderStatus();
  FilterModel? dropDownValue;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false, String? status}) async {
    if (showLoader) appStore.setLoading(true);
    getOrderList(
      orderList: orderList,
      status: status ?? OrderStatus.any,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    );
    future = getOrderList(
      orderList: orderList,
      status: status ?? OrderStatus.any,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      setState(() {});

      appStore.setLoading(false);
      return value;
    }) /*.catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    })*/
        ;
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
    if (!widget.isFromProduct) getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Your Orders',
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        textColor: Colors.white,
      ),
      body: Stack(
        children: [
          AnimatedScrollView(
            crossAxisAlignment: CrossAxisAlignment.end,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
            onNextPage: onNextPage,
            listAnimationType: ListAnimationType.None,
            onSwipeRefresh: onRefresh,
            children: [
              Container(
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<FilterModel>(
                      borderRadius: radius(),
                      icon: Icon(Icons.arrow_drop_down),
                      elevation: 8,
                      style: primaryTextStyle(),
                      dropdownColor: context.cardColor,
                      onChanged: (FilterModel? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                          page = 1;
                        });
                        init(status: dropDownValue?.value, showLoader: true);
                      },
                      hint: Text('Order Status', style: primaryTextStyle()),
                      items: filterOptions.map<DropdownMenuItem<FilterModel>>((FilterModel value) {
                        return DropdownMenuItem<FilterModel>(
                          value: value,
                          child: Text(value.title.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      value: dropDownValue,
                    ),
                  ),
                ),
              ),
              SnapHelperWidget(
                future: future,
                loadingWidget: OrderListShimmerScreen(),
                onSuccess: (List<OrderModel> data) {
                  if (dropDownValue != null && dropDownValue!.value.validate().isNotEmpty) {
                    if (data.isEmpty) dropDownValue = null;
                  }
                  if (data.isNotEmpty)
                    return AnimatedWrap(
                        runSpacing: 16,
                        spacing: 16,
                        listAnimationType: ListAnimationType.None,
                        children: data.map((orderData) {
                          return OrderComponent(
                            orderData: orderData,
                            callback: () => init(showLoader: true),
                          );
                        }).toList());
                  else
                    return SizedBox(
                      height: context.height() * 0.65,
                      child: NoDataFoundWidget(
                        text: locale.lblNoDataFound.capitalizeEachWord(),
                        retryText: locale.clickToRefresh,
                        onRetry: () => onRefresh(showLoader: true),
                      ).center(),
                    );
                },
              ).paddingTop(16),
            ],
          ),
          Observer(
            builder: (context) => LoaderWidget().center().visible(appStore.isLoading),
          )
        ],
      ),
    );
  }
}
