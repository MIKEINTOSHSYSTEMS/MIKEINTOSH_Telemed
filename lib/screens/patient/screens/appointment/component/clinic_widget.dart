import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/common_row_widget.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/login_response_model.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class ClinicWidget extends StatelessWidget {
  final Clinic data;
  final bool isSelected;

  ClinicWidget({required this.data, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 8, bottom: 8),
          decoration: boxDecorationDefault(color: isSelected ? selectedColor : context.cardColor, borderRadius: radius()),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedImageWidget(url: data.profile_image.validate(), height: 100, width: 95, radius: defaultRadius),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  8.height,
                  Text("${data.clinic_name.validate()}", style: boldTextStyle(size: titleTextSize)),
                  16.height,
                  CommonRowWidget(title: "${locale.lblEmail}:", value: '${data.clinic_email}', valueSize: 14),
                ],
              ).expand(),
            ],
          ),
        ),
        Positioned(
          top: 8,
          child: StatusWidget(status: getClinicStatus(data.status).toString()),
        )
      ],
    );
  }
}
