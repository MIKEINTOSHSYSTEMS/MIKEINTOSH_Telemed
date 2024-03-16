import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/patient/models/news_model.dart';
import 'package:momona_healthcare/screens/patient/screens/feeds/feed_details_screen.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class NewsDashboardWidget extends StatelessWidget {
  final NewsData? newsData;

  NewsDashboardWidget({this.newsData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FeedDetailsScreen(newsData: newsData).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
      },
      child: Container(
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newsData!.image.validate().isNotEmpty)
              CachedImageWidget(
                url: newsData!.image.validate(),
                height: 200,
                width: context.width(),
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
            Container(
              decoration: boxDecorationDefault(color: context.cardColor, borderRadius: newsData!.image.validate().isNotEmpty ? radiusOnly(bottomLeft: 8, bottomRight: 8) : radius()),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.lblHealth, style: primaryTextStyle()),
                  10.height,
                  Text('${newsData!.postTitle.validate()}', style: boldTextStyle(size: 16)),
                  5.height,
                  ReadMoreText(
                    parseHtmlString(newsData!.postExcerpt),
                    trimLines: 3,
                    style: secondaryTextStyle(),
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: locale.lblReadMore,
                    trimExpandedText: locale.lblReadLess,
                    locale: Localizations.localeOf(context),
                  ),
                  8.height,
                  Text(
                    locale.lblBy + ' ${newsData!.postAuthorName.validate().capitalizeFirstLetter()} ${newsData!.humanTimeDiff.validate()}',
                    style: secondaryTextStyle(size: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
