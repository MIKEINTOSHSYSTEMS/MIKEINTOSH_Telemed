import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ClinicListComponent extends StatelessWidget {
  final Clinic data;
  final bool isSelected;

  ClinicListComponent({required this.data, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          margin: EdgeInsets.only(top: 8, bottom: 8),
          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(), border: Border.all(color: isSelected ? context.primaryColor : context.cardColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedImageWidget(
                url: data.profileImage.validate(),
                height: 80,
                width: 80,
                radius: defaultRadius,
                fit: BoxFit.cover,
              ),
              12.width,
              AnimatedWrap(
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.start,
                listAnimationType: ListAnimationType.None,
                children: [
                  Text("${data.name.validate()}", style: boldTextStyle(size: titleTextSize)),
                  SettingItemWidget(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    paddingAfterLeading: 4,
                    title: data.email.validate(),
                    titleTextStyle: secondaryTextStyle(),
                    leading: ic_user.iconImage(size: 16),
                  ),
                  TextIcon(
                    prefix: ic_location.iconImage(size: 16),
                    edgeInsets: EdgeInsets.zero,
                    text: data.city.validate() + ", " + data.country.validate(),
                    textStyle: secondaryTextStyle(size: 12),
                  ),
                ],
              ).expand(),
            ],
          ).paddingTop(10),
        ),
        Positioned(
          top: 16,
          right: 8,
          child: StatusWidget(
            status: data.status.validate(),
            isClinicStatus: true,
          ),
        )
      ],
    );
  }
}
