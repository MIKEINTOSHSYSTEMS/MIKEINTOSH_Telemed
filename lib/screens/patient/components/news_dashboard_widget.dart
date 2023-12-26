import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:kivicare_flutter/screens/patient/screens/feed_details_screen.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class NewsDashboardWidget extends StatelessWidget {
  final NewsData? newsData;
  final int? index;

  NewsDashboardWidget({this.newsData, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FeedDetailsScreen(newsData: newsData).launch(context);
      },
      child: Container(
        width: index == 0 ? context.width() : context.width() / 2 - 26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: newsData!.image.validate(),
              height: 200,
              radius: defaultRadius,
              width: index == 0 ? context.width() : context.width() / 2 - 20,
              fit: index == 0 ? BoxFit.cover : null,
            ),
            Text(locale.lblHealth, style: primaryTextStyle()),
            10.height,
            Text('${newsData!.post_title.validate()}', style: boldTextStyle(size: 16)),
            5.height,
            ReadMoreText(
              parseHtmlString(newsData!.post_excerpt),
              trimLines: 3,
              style: secondaryTextStyle(),
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: locale.lblReadMore,
              trimExpandedText: locale.lblReadLess,
              locale: Localizations.localeOf(context),
            ),
            5.height,
            Text(
              locale.lblBy + ' ${newsData!.post_author_name.validate().capitalizeFirstLetter()} ${newsData!.human_time_diff.validate()}',
              style: secondaryTextStyle(size: 12),
            ),
          ],
        ),
      ),
    );
  }
}
