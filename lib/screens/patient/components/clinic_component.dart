import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/model/clinic_list_model.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';

import 'package:kivicare_flutter/components/status_widget.dart';

class ClinicComponent extends StatelessWidget {
  final Clinic clinicData;
  final bool isCheck;
  final Function(bool)? onTap;

  ClinicComponent({required this.clinicData, this.onTap, this.isCheck = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.width() / 2 - 24,
          padding: EdgeInsets.only(top: 32, right: 16, left: 16),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              28.height,
              Marquee(
                child: Text(clinicData.name.validate(), style: boldTextStyle(size: 14)),
                animationDuration: Duration(milliseconds: 400),
                pauseDuration: Duration(milliseconds: 100),
              ),
              4.height,
              TextIcon(
                spacing: 4,
                prefix: ic_location.iconImage(size: 16).paddingAll(4),
                text: clinicData.city.validate(),
                maxLine: 1,
                expandedText: true,
                textStyle: secondaryTextStyle(),
              ),
              28.height,
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          left: 12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (clinicData.profileImage.validate().isNotEmpty)
                CachedImageWidget(
                  url: clinicData.profileImage.validate(),
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(8)
              else
                ic_clinicPlaceHolder.iconImageColored(height: 40, width: 40).cornerRadiusWithClipRRect(8),
              16.width.expand(),
              StatusWidget(
                status: clinicData.status.validate(),
                isClinicStatus: true,
                borderRadius: radius(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 8,
          right: 12,
          child: Container(
            padding: EdgeInsets.zero,
            decoration: boxDecorationDefault(shape: BoxShape.circle, color: isCheck ? Colors.green : context.cardColor, border: Border.all(width: 2, color: Colors.green)),
            child: isCheck
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : Container(padding: EdgeInsets.all(isCheck ? 0 : 8), decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor)),
          ).appOnTap(
            () {
              onTap!.call(!isCheck);
            },
          ),
        )
      ],
    ).appOnTap(
      () {
        onTap!.call(!isCheck);
      },
    );
  }
}
