import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:kivicare_flutter/screens/patient/screens/feed_details_screen.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

class FeedFragment extends StatefulWidget {
  @override
  _FeedFragmentState createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildListWidget({required NewsData data}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            url: data.image.validate(),
            height: 200,
            width: context.width(),
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
          Container(
            decoration: boxDecorationDefault(borderRadius: radiusOnly(bottomLeft: defaultRadius, bottomRight: defaultRadius), color: context.cardColor),
            width: context.width(),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text(data.readable_date.validate(), style: secondaryTextStyle(size: 12)),
                8.height,
                Text(data.post_title.validate(), style: boldTextStyle(size: 18)),
                22.height,
                Row(
                  children: [
                    Text("By ${data.post_author_name.validate().capitalizeFirstLetter()}", style: secondaryTextStyle()).expand(),
                    TextIcon(
                      onTap: () {
                        Share.share(data.share_url.validate());
                      },
                      text: locale.lblShare,
                      textStyle: secondaryTextStyle(),
                      prefix: ic_share.iconImage(size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ).onTap(() {
        FeedDetailsScreen(newsData: data).launch(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NewsModel>(
      future: getNewsList(),
      builder: (_, snap) {
        if (snap.hasData) {
          return AnimatedListView(
            itemCount: snap.data!.newsData!.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 24, right: 16),
            onSwipeRefresh: () async {
              getNewsList();
              return await 2.seconds.delay;
            },
            itemBuilder: (BuildContext context, int index) {
              return buildListWidget(data: snap.data!.newsData![index]);
            },
          );
        }
        return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
      },
    );
  }
}
