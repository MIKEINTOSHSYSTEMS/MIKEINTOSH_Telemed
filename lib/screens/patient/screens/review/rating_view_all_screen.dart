import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/internet_connectivity_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/rating_model.dart';
import 'package:kivicare_flutter/network/review_repository.dart';
import 'package:kivicare_flutter/screens/patient/screens/review/component/review_widget.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/review_rating_shimmer_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class RatingViewAllScreen extends StatefulWidget {
  final int doctorId;

  RatingViewAllScreen({required this.doctorId});

  @override
  State<RatingViewAllScreen> createState() => _RatingViewAllScreenState();
}

class _RatingViewAllScreenState extends State<RatingViewAllScreen> {
  Future<List<RatingData>>? future;

  int page = 1;
  bool isLastPage = false;

  List<RatingData> ratingList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader) appStore.setLoading(true);
    future = doctorReviewsListAPI(
      ratingList: ratingList,
      doctorId: widget.doctorId.validate(),
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblRatingsAndReviews,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: InternetConnectivityWidget(
        retryCallback: () {
          init();
        },
        child: Stack(
          children: [
            SnapHelperWidget<List<RatingData>>(
              future: future,
              loadingWidget: ReviewRatingShimmerScreen(),
              onSuccess: (data) {
                if (data.isNotEmpty) {
                  return AnimatedListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    itemCount: data.length,
                    itemBuilder: (context, index) => ReviewWidget(
                      data: data[index],
                      callDelete: () async {
                        appStore.setLoading(true);
                        await deleteReviewAPI(id: data[index].id.validate().toInt()).then((value) {
                          toast(value.message);
                          init();
                          appStore.setLoading(false);
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });
                      },
                    ),
                  );
                } else {
                  return NoDataFoundWidget(
                    text: locale.lblNoReviewsFound,
                  ).center();
                }
              },
            ).paddingTop(20),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Text(
                locale.lblSwipeRightNote,
                style: secondaryTextStyle(color: appSecondaryColor, size: 12),
              ),
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
