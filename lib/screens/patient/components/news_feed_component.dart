import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:kivicare_flutter/screens/patient/screens/feeds/feed_details_screen.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';

class NewsFeedComponent extends StatelessWidget {
  final NewsData data;
  const NewsFeedComponent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.image.validate().isNotEmpty)
          CachedImageWidget(
            url: data.image.validate(),
            height: 200,
            width: context.width(),
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
        Container(
          decoration: boxDecorationDefault(borderRadius: data.image.validate().isNotEmpty ? radiusOnly(bottomLeft: defaultRadius, bottomRight: defaultRadius) : radius(), color: context.cardColor),
          width: context.width(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text(data.readableDate.validate(), style: secondaryTextStyle(size: 12)),
              8.height,
              Text(data.postTitle.validate(), style: boldTextStyle(size: 18)),
              8.height,
              Text(parseHtmlString(data.postExcerpt.validate()), style: secondaryTextStyle()),
              22.height,
              Row(
                children: [
                  Text("By ${data.postAuthorName.validate().capitalizeFirstLetter()}", style: secondaryTextStyle()).expand(),
                  TextIcon(
                    onTap: () {
                      Share.share(data.shareUrl.validate());
                    },
                    textStyle: secondaryTextStyle(),
                    prefix: ic_share.iconImage(size: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).appOnTap(
      () {
        FeedDetailsScreen(newsData: data).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
      },
    );
  }
}
