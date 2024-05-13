import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/empty_error_state_component.dart';
import 'package:kivicare_flutter/components/internet_connectivity_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/patient/components/news_feed_component.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/feed_and_articles_shimmer_screen.dart';
import 'package:kivicare_flutter/utils/cached_value.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:kivicare_flutter/network/patient_list_repository.dart';

class FeedFragment extends StatefulWidget {
  @override
  _FeedFragmentState createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  Future<NewsModel>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getNewsListAPI().whenComplete(() {
      appStore.setLoading(false);
      setState(() {});
    });
    future = getNewsListAPI().whenComplete(() {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectivityWidget(
      retryCallback: () {
        setState(() {});
      },
      child: SnapHelperWidget<NewsModel>(
        future: future,
        initialData: cachedNewsFeed,
        loadingWidget: FeedAndArticlesShimmer(),
        errorBuilder: (error) {
          return NoDataWidget(
            imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
            title: error.toString(),
          );
        },
        errorWidget: ErrorStateWidget(),
        onSuccess: (snap) {
          return AnimatedListView(
            itemCount: snap.newsData.validate().length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 24, right: 16),
            onSwipeRefresh: () async {
              init();
              return await 2.seconds.delay;
            },
            itemBuilder: (BuildContext context, int index) {
              NewsData data = snap.newsData![index];
              return NewsFeedComponent(data: data).paddingSymmetric(vertical: 8);
            },
          ).visible(snap.newsData.validate().isNotEmpty, defaultWidget: NoDataFoundWidget(text: locale.lblNoArticlesFound).center());
        },
      ),
    );
  }
}
