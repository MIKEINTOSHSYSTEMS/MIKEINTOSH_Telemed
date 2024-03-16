import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/woo_commerce/coupon_model.dart';
import 'package:momona_healthcare/network/shop_repository.dart';
import 'package:momona_healthcare/screens/shimmer/screen/coupon_list_shimmer_screen.dart';
import 'package:momona_healthcare/screens/woocommerce/component/coupon_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

class CouponListScreen extends StatefulWidget {
  final bool isCartScreen;

  final double? cartAmount;
  const CouponListScreen({this.isCartScreen = false, this.cartAmount});

  @override
  _CouponListScreenState createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  List<CouponModel> couponsList = [];
  Future<List<CouponModel>>? future;

  int page = 1;
  bool isLastPage = false;
  @override
  void initState() {
    super.initState();
    init(showLoader: false);
  }

  void init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    getCouponsList(
      couponList: couponsList,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    );
    future = getCouponsList(
      couponList: couponsList,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      setState(() {});

      appStore.setLoading(false);
      return value;
    }) /*.catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    })*/
        ;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (!widget.isCartScreen) getDisposeStatusBarColor();
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Coupons',
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: [
          SnapHelperWidget(
            future: future,
            loadingWidget: CouponListShimmerScreen(),
            onSuccess: (data) {
              if (data.isEmpty)
                return NoDataFoundWidget(text: 'No Coupons Available');
              else
                return AnimatedScrollView(
                  padding: EdgeInsets.only(top: 16, bottom: 60),
                  onSwipeRefresh: () async {
                    setState(() {
                      page = 1;
                    });
                    init(showLoader: true);
                    return await 1.seconds.delay;
                  },
                  onNextPage: () {
                    if (!isLastPage)
                      setState(() {
                        page++;
                      });
                    init(showLoader: true);
                  },
                  children: data.map((e) {
                    return CouponComponent(
                      coupon: e,
                      isCartScreen: widget.isCartScreen,
                      amount: widget.cartAmount,
                    );
                  }).toList(),
                );
            },
          ),
          Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading).center(),
          )
        ],
      ),
    );
  }
}
